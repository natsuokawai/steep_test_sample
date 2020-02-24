import * as ts from "typescript";
import * as fs from "fs";
import * as path from "path";
import * as fetch from "isomorphic-fetch";

const lspVersion = "c0c516735fb9eea08ac0151333b5380d70525961";
const rootDir = path.normalize(path.join(__dirname, ".."));
const tempDir = path.join(rootDir, "tmp");
const protocolMdPath = path.join(tempDir, lspVersion, "protocol.md");

const createFile = (filePath, content) => {
  const dir = path.dirname(path.normalize(filePath));

  dir.split(/(?!^)\//).forEach((_, index, all) => {
    const dir = all.slice(0, index + 1).join("/");

    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir);
    }
  });

  fs.writeFileSync(filePath, content);
};

const extractTypeScriptSource = content => {
  const regEx = /^```typescript\r\n([^]*?)^```\r\n/gm;
  let match;
  let result = "";

  while ((match = regEx.exec(content)) !== null) {
    result = result.concat(match[1]);
  }

  return result;
};

const extractDefinitions = content => {
  const fileName = path.join(tempDir, "protocol.ts");
  createFile(fileName, content);
  const program = ts.createProgram([fileName], {});
  const checker = program.getTypeChecker();

  const output = [];

  const serialize = member => {
    const symbol = checker.getSymbolAtLocation(member.name);
    const type = checker.getTypeOfSymbolAtLocation(
      symbol,
      symbol.valueDeclaration
    );
    const types =
      member.kind == ts.SyntaxKind.UnionType
        ? (<ts.UnionTypeNode>(<ts.PropertySignature>member).type).types
        : [];

    return {
      name: symbol.getName(),
      documentation: ts.displayPartsToString(symbol.getDocumentationComment()),
      type: checker.typeToString(type),
      optional: !!member.questionToken,
      nullable: (<ts.NodeArray<ts.TypeNode>>types).some(
        t => t.kind == ts.SyntaxKind.NullKeyword
      ),
      value: symbol.valueDeclaration
        ? symbol.valueDeclaration
            .getChildAt(symbol.valueDeclaration.getChildCount() - 1)
            .getText()
        : null
    };
  };

  const handleInterface = (node: ts.InterfaceDeclaration) => {
    const members = node.members
      .filter(member => member.name)
      .map(member => serialize(member));
    const parentName =
      node.heritageClauses && node.heritageClauses[0].getLastToken().getText();
    const parent = output.find(
      i => i.interface && i.interface.name === parentName
    );

    output.push({
      interface: serialize(node),
      parent: parent,
      allMembers: ((parent && parent.allMembers) || []).concat(members),
      members
    });
  };

  const handleModule = (node: ts.ModuleDeclaration) => {
    const members = [];

    ts.forEachChild(node.body, node => {
      members.push(
        serialize((<ts.VariableStatement>node).declarationList.declarations[0])
      );
    });

    output.push({
      module: serialize(node),
      members
    });
  };

  const visit = node => {
    switch (node.kind) {
      case ts.SyntaxKind.InterfaceDeclaration:
        handleInterface(node);
        break;

      case ts.SyntaxKind.ModuleDeclaration:
        handleModule(node);
        break;
    }
  };

  ts.forEachChild(program.getSourceFile(fileName), visit);

  return output;
};

import Handlebars from "handlebars";
const snake = s =>
  s
    .replace(/^[A-Z]/, s => s.toLowerCase())
    .replace(/[A-Z]/g, s => `_${s.toLowerCase()}`);

Handlebars.registerHelper("params", members => {
  return members
    .map(
      member =>
        `${snake(member.name)}:${
          member.optional || member.nullable ? " nil" : ""
        }`
    )
    .join(", ");
});
Handlebars.registerHelper("snake", snake);
Handlebars.registerHelper("comment", (s, options) => {
  const indent = Array(options.hash.indent + 1).join(" ");
  return s
    .split("\n")
    .map(s => s.trim())
    .map(s => `${indent}#${s.length == 0 ? "" : ` ${s}`}`)
    .join("\n");
});
Handlebars.registerHelper("local_var", s => {
  const rubyKeywords = ["end", "retry"];
  const snaked = snake(s);

  if (rubyKeywords.some(k => k == s)) {
    return `binding.local_variable_get(:${snaked})`;
  } else {
    return snake(s);
  }
});
Handlebars.registerHelper("const", s => {
  return snake(s).toUpperCase();
});

(async () => {
  if (!fs.existsSync(protocolMdPath)) {
    const res = await fetch(
      `https://github.com/Microsoft/language-server-protocol/raw/${lspVersion}/specification.md`
    );
    createFile(protocolMdPath, await res.text());
  }

  const md = fs.readFileSync(protocolMdPath).toString();
  const typeScriptSource = extractTypeScriptSource(md);

  const definitions = extractDefinitions(typeScriptSource);
  const interfaces = definitions.filter(d => d.interface);
  const modules = definitions.filter(d => d.module);

  interfaces.forEach(definition => {
    createFile(
      path.join(
        rootDir,
        "lib",
        "language_server",
        "protocol",
        "interface",
        `${snake(definition.interface.name)}.rb`
      ),
      Handlebars.compile(
        `
module LanguageServer
  module Protocol
    module Interface
      {{#if definition.interface.documentation}}
      #
{{comment definition.interface.documentation indent=6}}
      #
      {{/if}}
      class {{definition.interface.name}}{{#if definition.parent}} < {{definition.parent.interface.name}}{{/if}}
        def initialize({{params definition.allMembers}})
          @attributes = {}

          {{#each definition.members}}
          @attributes[:{{name}}] = {{local_var name}}{{#if optional}} if {{local_var name}}{{/if}}
          {{/each}}

          @attributes.freeze
        end
        {{#each definition.members}}

        {{#if documentation}}
        #
{{comment documentation indent=8}}
        #
        {{/if}}
        # @return [{{type}}{{#if nullable}}, nil{{/if}}]
        def {{snake name}}
          attributes.fetch(:{{name}})
        end
        {{/each}}

        attr_reader :attributes

        def to_hash
          attributes
        end

        def to_json(*args)
          to_hash.to_json(*args)
        end
      end
    end
  end
end
`.slice(1),
        { noEscape: true }
      )({ definition })
    );
  });

  modules.forEach(definition => {
    createFile(
      path.join(
        rootDir,
        "lib",
        "language_server",
        "protocol",
        "constant",
        `${snake(definition.module.name)}.rb`
      ),
      Handlebars.compile(
        `
module LanguageServer
  module Protocol
    module Constant
      {{#if definition.module.documentation}}
      #
{{comment definition.module.documentation indent=6}}
      #
      {{/if}}
      module {{definition.module.name}}
        {{#each definition.members}}
        {{#if documentation}}
        #
{{comment documentation indent=8}}
        #
        {{/if}}
        {{const name}} = {{value}}
        {{/each}}
      end
    end
  end
end
`.slice(1),
        { noEscape: true }
      )({ definition })
    );
  });

  createFile(
    path.join(rootDir, "lib", "language_server", "protocol", "interface.rb"),
    Handlebars.compile(
      `
module LanguageServer
  module Protocol
    module Interface
{{#each names}}
      autoload :{{this}}, "language_server/protocol/interface/{{snake this}}"
{{/each}}

{{#each names}}
      require "language_server/protocol/interface/{{snake this}}"
{{/each}}
    end
  end
end
`.slice(1),
      { noEscape: true }
    )({ names: interfaces.map(i => i.interface.name).sort() })
  );

  createFile(
    path.join(rootDir, "lib", "language_server", "protocol", "constant.rb"),
    Handlebars.compile(
      `
module LanguageServer
  module Protocol
    module Constant
{{#each names}}
      autoload :{{this}}, "language_server/protocol/constant/{{snake this}}"
{{/each}}

{{#each names}}
      require "language_server/protocol/constant/{{snake this}}"
{{/each}}
    end
  end
end
`.slice(1),
      { noEscape: true }
    )({ names: modules.map(i => i.module.name).sort() })
  );
})();

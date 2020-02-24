module LanguageServer
  module Protocol
    module Interface
      #
      # Execute command registration options.
      #
      class ExecuteCommandRegistrationOptions
        def initialize(commands:)
          @attributes = {}

          @attributes[:commands] = commands

          @attributes.freeze
        end

        #
        # The commands to be executed on the server
        #
        # @return [string[]]
        def commands
          attributes.fetch(:commands)
        end

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

module LanguageServer
  module Protocol
    module Interface
      #
      # Workspace specific client capabilities.
      #
      class WorkspaceClientCapabilities
        def initialize(apply_edit: nil, workspace_edit: nil, did_change_configuration: nil, did_change_watched_files: nil, symbol: nil, execute_command: nil, workspace_folders: nil, configuration: nil)
          @attributes = {}

          @attributes[:applyEdit] = apply_edit if apply_edit
          @attributes[:workspaceEdit] = workspace_edit if workspace_edit
          @attributes[:didChangeConfiguration] = did_change_configuration if did_change_configuration
          @attributes[:didChangeWatchedFiles] = did_change_watched_files if did_change_watched_files
          @attributes[:symbol] = symbol if symbol
          @attributes[:executeCommand] = execute_command if execute_command
          @attributes[:workspaceFolders] = workspace_folders if workspace_folders
          @attributes[:configuration] = configuration if configuration

          @attributes.freeze
        end

        #
        # The client supports applying batch edits to the workspace by supporting
        # the request 'workspace/applyEdit'
        #
        # @return [boolean]
        def apply_edit
          attributes.fetch(:applyEdit)
        end

        #
        # Capabilities specific to `WorkspaceEdit`s
        #
        # @return [{ documentChanges?: boolean; resourceOperations?: ResourceOperationKind[]; failureHandling?: Fail...]
        def workspace_edit
          attributes.fetch(:workspaceEdit)
        end

        #
        # Capabilities specific to the `workspace/didChangeConfiguration` notification.
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def did_change_configuration
          attributes.fetch(:didChangeConfiguration)
        end

        #
        # Capabilities specific to the `workspace/didChangeWatchedFiles` notification.
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def did_change_watched_files
          attributes.fetch(:didChangeWatchedFiles)
        end

        #
        # Capabilities specific to the `workspace/symbol` request.
        #
        # @return [{ dynamicRegistration?: boolean; symbolKind?: { valueSet?: any[]; }; }]
        def symbol
          attributes.fetch(:symbol)
        end

        #
        # Capabilities specific to the `workspace/executeCommand` request.
        #
        # @return [{ dynamicRegistration?: boolean; }]
        def execute_command
          attributes.fetch(:executeCommand)
        end

        #
        # The client has support for workspace folders.
        #
        # Since 3.6.0
        #
        # @return [boolean]
        def workspace_folders
          attributes.fetch(:workspaceFolders)
        end

        #
        # The client supports `workspace/configuration` requests.
        #
        # Since 3.6.0
        #
        # @return [boolean]
        def configuration
          attributes.fetch(:configuration)
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

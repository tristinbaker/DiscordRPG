require_relative "../lib/constants"

module Util
  class MessageHelper
    def self.unknown_command_opts
      opts = {}
      opts[:color] = Constants::FAILURE_COLOR
      opts[:title] = "Unknown Command!"
      opts[:description] = "Try running ;;aq help for a list of commands"
      return opts
    end

    def self.quest_help_opts
      opts = {}
      opts[:color] = Constants::NOTIFY_COLOR
      return opts
    end

    def self.show_help_opts
      opts = {}
      opts[:color] = Constants::NOTIFY_COLOR
      opts[:title] = "ApeQuest 'Show' Help"
      opts[:description] = "**#{Constants::COMMAND_START} show player** -- Displays your current stats\n"
      opts[:description] += "**#{Constants::COMMAND_START} show enemy {enemy name}** -- Displays listed enemy's stats\n"
      opts[:description] += "**#{Constants::COMMAND_START} show enemy list** -- Displays list of available enemies to fight\n"
      return opts
    end

    def self.update_help_opts
      opts = {}
      opts[:color] = Constants::NOTIFY_COLOR
      return opts
    end

    def self.general_help_opts
      opts = {}
      opts[:color] = Constants::NOTIFY_COLOR
      opts[:title] = "ApeQuest Help"
      opts[:description] = "**#{Constants::COMMAND_START} help quest** -- Displays list of commands under the 'quest' option\n"
      opts[:description] += "**#{Constants::COMMAND_START} help show** -- Displays list of commands under the 'show' option\n"
      opts[:description] += "**#{Constants::COMMAND_START} help update** -- Displays list of commands under the 'update' option\n"
      return opts
    end
  end
end

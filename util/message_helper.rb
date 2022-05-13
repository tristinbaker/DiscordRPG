require_relative "../lib/constants"
require_relative "./image_handler"

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

    def self.print_player_opts(player)
      opts = {}
      opts[:title] = "#{player.player_name} Stats"
      opts[:description] = "*Status: #{player.action}*\n"
      opts[:description] += "Level #{player.level} (#{player.experience}/#{player.experience_level} EXP)\n"
      opts[:description] += "**HP:** #{player.hp}/#{player.max_hp}\n**MP:** #{player.mp}/#{player.max_mp}\n"
      opts[:description] += "**STR:** #{player.strength}\n**AGL:** #{player.agility}\n**INT:** #{player.intelligence}\n"
      opts[:opts] = Hash.new("")
      return opts
    end

    def self.new_battle_opts
      opts = {}
      opts[:color] = Constants::NOTIFY_COLOR
      opts[:title] = "ApeQuest Battle"
      opts[:description] = "You have not started a battle! Please start a battle by running the following:\n"
      opts[:description] += "**#{Constants::COMMAND_START} battle start {enemy_name}**\n\n"
      opts[:description] += "If you need a list of enemies, you can run the following:\n"
      opts[:description] += "**#{Constants::COMMAND_START} show enemy list**\n"
      return opts
    end

    def self.unknown_enemy_opts(enemy)
      opts[:color] = Constants::FAILURE_COLOR
      opts[:title] = "ApeQuest Battle"
      opts[:description] = "**Unknown Enemy:** *#{enemy}*"
      return opts
    end

    def self.battle_already_started_opts
      opts = {}
      opts[:color] = Constants::FAILURE_COLOR
      opts[:title] = "ApeQuest Battle"
      opts[:description] = "You are already in a battle! You can view your battle by running the following:\n"
      opts[:description] += "**#{Constants::COMMAND_START} battle show**\n"
      return opts
    end

    def self.show_battle_opts(battle)
      player = battle.player
      enemy = battle.enemy
      opts = {}
      opts[:color] = Constants::NOTIFY_COLOR
      opts[:title] = "ApeQuest Battle"
      opts[:description] = "*Turn #{battle.turn_number}*\n\n"
      opts[:description] += "**#{player.player_name}:**\n"
      opts[:description] += "*HP:* #{player.hp}/#{player.max_hp}\n"
      opts[:description] += "*MP:* #{player.mp}/#{player.max_mp}\n"
      opts[:description] += "*STR:* #{player.strength} *AGL:* #{player.agility} *INT:* #{player.intelligence}\n\n"
      opts[:description] += "**#{enemy.name}:**\n"
      opts[:description] += "*HP:* #{enemy.hp}/#{enemy.max_hp}\n"
      opts[:description] += "*MP:* #{enemy.mp}/#{enemy.max_mp}\n"
      opts[:description] += "*STR:* #{enemy.strength} *AGL:* #{enemy.agility} *INT:* #{enemy.intelligence}\n\n"
      opts[:image] = Util::ImageHandler.new(enemy.sprite_location).create_embed_image()
      return opts
    end
  end
end

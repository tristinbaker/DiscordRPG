require_relative "../lib/constants"
require_relative "./message_helper"

require "discordrb"

include Constants

module Util
  class ApeQuestBot
    attr_accessor :bot, :gsm

    def initialize(gsm)
      @bot = Discordrb::Bot.new token: Constants::TEST_BOT_TOKEN
      @gsm = gsm
      set_commands
    end

    def set_commands
      @bot.message(starts_with: Constants::COMMAND_START) do |event|
        next unless event.message.content.start_with?(Constants::COMMAND_START)
        opts = ""
        arguments = get_arguments(event)
        player = get_player(event)
        command = decipher_command(arguments)
        case command
        when "show_player"
          opts = player.print_player
        when "quest_status"
          opts = gsm.quest_manager.print_quest_status(arguments, player)
        when "quest_log"
          opts = gsm.quest_manager.print_quest_log(player)
        when "show_enemy"
          enemy = gsm.enemies.select { |e| e.name.downcase == arguments[2..arguments.length].join(" ").downcase }&.first
          opts = enemy.print_enemy(enemy) unless enemy.nil?
        when "show_enemy_list"
          opts = gsm.print_enemy_list
        when "update_name"
          opts = player.update_name(arguments, gsm.db, player)
        when "quest_help"
          opts = MessageHelper.quest_help_opts
        when "show_help"
          opts = MessageHelper.show_help_opts
        when "update_help"
          opts = MessageHelper.update_help_opts
        when "general_help"
          opts = MessageHelper.general_help_opts
        else
          opts = MessageHelper.unknown_command_opts
          opts = "Unknown command!"
        end
        message = format_output(opts)
        event.channel.send_embed("", message)
      end
    end

    def get_arguments(event)
      argument_raw = event.message.content.split(" ")
      arguments = argument_raw[1..argument_raw.length]
      return arguments
    end

    def decipher_command(arguments)
      case arguments[0]
      when "quest"
        case arguments[1]
        when "status"
          command = "quest_status"
        when "log"
          command = "quest_log"
        end
      when "show"
        case arguments[1]
        when "enemy"
          case arguments[2]
          when "list"
            command = "show_enemy_list"
          else
            command = "show_enemy"
          end
        when "player"
          command = "show_player"
        end
      when "update"
        case arguments[1]
        when "name"
          command = "update_name"
        end
      when "help"
        case arguments[1]
        when "quest"
          command = "quest_help"
        when "show"
          command = "show_help"
        when "update"
          command = "update_help"
        else
          command = "general_help"
        end
      end
      return command
    end

    def format_output(opts)
      message = Discordrb::Webhooks::Embed.new
      message.color = opts[:color] || Constants::SUCCESS_COLOR
      message.timestamp = Time.now
      message.title = opts[:title]
      message.description = opts[:description]
      message.image = opts[:image] if opts[:image]
      return message
    end

    def get_player(event)
      player = @gsm.players.select { |player| player.player_id == event.user.id }&.first
      return player.nil? ? false : player
    end

    def run
      @bot.run
    end
  end
end

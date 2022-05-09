require_relative "../lib/constants"

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
        opts = ""
        arguments = get_arguments(event)
        player = get_player(event)
        command = decipher_command(arguments)
        case command
        when "show_player"
          opts = player.print_player
        else
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
      if arguments[0] == "player"
        command = "show_player"
      end
    end

    def format_output(opts)
      message = Discordrb::Webhooks::Embed.new
      message.color = Constants::SUCCESS_COLOR
      message.timestamp = Time.now
      if opts == "Unknown command!"
        opts = get_unknown_command_opts
      end
      message.title = opts[:title]
      message.description = opts[:description]
      opts[:opts].each do |k, v|
        #require "pry" && binding.pry
        message.add_field(name: k, value: v.to_s)
      end
      return message
    end

    def get_unknown_command_opts
      opts = {}
      opts[:color] = Constants::FAILURE_COLOR
      opts[:title] = "Unknown Command!"
      opts[:description] = "Try running ;;aq help for a list of commands"
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

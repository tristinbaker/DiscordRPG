require_relative "util/game_state_manager"
require_relative "util/ape_quest_bot"

require "pry"

gsm = Util::GameStateManager.new
bot = Util::ApeQuestBot.new(gsm)

running = true

bot.run

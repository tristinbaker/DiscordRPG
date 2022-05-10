require_relative "util/game_state_manager"
require_relative "util/ape_quest_bot"

gsm = Util::GameStateManager.new
bot = Util::ApeQuestBot.new(gsm)

require "pry"
#binding.pry

bot.run

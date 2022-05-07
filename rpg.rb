require_relative "util/game_state_manager"
require_relative "lib/constants"
require_relative "entities/enemy"

require "pry"

include Constants

def set_players(gsm)
  players = []
  rows = gsm.db.query("SELECT * FROM players")
  rows.each do |row|
    players << Entities::Player.new(row)
  end
  return players
end

gsm = Util::GameStateManager.new

enemy = Entities::Enemy.new(3, gsm.db)

binding.pry

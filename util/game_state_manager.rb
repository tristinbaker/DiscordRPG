require_relative "./database"
require_relative "../entities/player"
require_relative "../events/quest"

module Util
  class GameStateManager
    attr_accessor :db, :players, :quests

    def initialize()
      @db = Util::Database.new(Constants::DB_FILE_NAME)
      @quests = init_quests
      @players = init_players
    end

    def init_quests
      quests = []
      rows = @db.query("SELECT * FROM quests")
      rows.each do |row|
        quests << Events::Quest.new(row, @db)
      end
      return quests
    end

    def init_players
      players = []
      rows = @db.query("SELECT * FROM players")
      rows.each do |row|
        player = Entities::Player.new(row, @db)
        player.player_quest_log.set_quest_details(@db, @quests)
        players << player
      end
      return players
    end

    def handle_quest_stage(player, quest, action, amount = 0)
    end
  end
end

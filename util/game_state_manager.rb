require_relative "./database"
require_relative "../entities/player"
require_relative "../events/quest"

module Util
  class GameStateManager
    attr_accessor :db, :players, :quests

    def initialize()
      @db = Util::Database.new(Constants::DB_FILE_NAME)
      @players = init_players
      @quests = init_quests
    end

    def init_players
      players = []
      rows = @db.query("SELECT * FROM players")
      rows.each do |row|
        players << Entities::Player.new(row, @db)
      end
      return players
    end

    def init_quests
      quests = []
      rows = @db.query("SELECT * FROM quests")
      rows.each do |row|
        quests << Events::Quest.new(row, @db)
      end
      return quests
    end
  end
end

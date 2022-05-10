require_relative "./database"
require_relative "./quest_manager"
require_relative "../entities/player"
require_relative "../events/quest"

module Util
  class GameStateManager
    attr_accessor :db, :players, :quests, :enemies, :quest_manager

    def initialize()
      @db = Util::Database.new(Constants::DB_FILE_NAME)
      @quests = init_quests
      @players = init_players
      @enemies = init_enemies
      @quest_manager = init_quest_manager
    end

    def init_quests
      quests = []
      rows = @db.query("SELECT * FROM quests")
      rows.each do |row|
        quests << Events::Quest.new(row, @db)
      end
      return quests
    end

    def init_enemies
      enemies = []
      rows = @db.query("SELECT * FROM enemies")
      rows.each do |row|
        enemies << Entities::Enemy.new(row["id"], @db)
      end
      return enemies
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

    def init_quest_manager
      @quest_master = Util::QuestManager.new(@quests)
    end

    def print_enemy_list
      opts = {}
      opts[:title] = "ApeQuest Enemy List"
      opts[:description] = ""
      @enemies.each_with_index do |enemy, i|
        next if enemy.is_boss
        opts[:description] += "**#{i + 1})** #{enemy.name} (*Lvl #{enemy.level}*)\n"
      end
      return opts
    end
  end
end

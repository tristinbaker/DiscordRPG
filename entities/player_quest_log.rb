module Entities
  class PlayerQuestLog
    attr_accessor :player_quets_log_id, :quests, :total_completed, :total_open

    def initialize(player_id, db)
      @player_quest_log = set_player_quest_log(player_id, db)
      @total_completed = @player_quest_log["total_completed"]
      @total_open = @player_quest_log["total_open"]
    end

    def set_player_quest_log(player_id, db)
      player_quest_log = db.query("SELECT * FROM player_quest_logs WHERE player_id = #{player_id}").first
      return player_quest_log
    end

    def set_quest_details(db, quests)
      @quests = []
      player_quests = db.query("SELECT * FROM player_quest_log_details WHERE player_quest_log_id = #{@player_quest_log["id"]}")
      return false if player_quests.empty?
      player_quests.each do |player_quest|
        quest = quests.select { |q| q.quest_id == player_quest["quest_id"] }&.first
        next if quest.nil?
        @quests << quest
      end
      return @quests
    end
  end
end

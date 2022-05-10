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
      @quests = Hash.new({})
      player_quests = db.query("SELECT * FROM player_quest_log_details WHERE player_quest_log_id = #{@player_quest_log["id"]}")
      return false if player_quests.empty?
      player_quests.each do |player_quest|
        quest = quests.select { |q| q.quest_id == player_quest["quest_id"] }&.first
        next if quest.nil?
        @quests[quest.quest_id] = { quest_name: quest.quest_name, quest_description: quest.quest_description,
                                    quest_enemy: quest.quest_enemy.name, quest_enemy_required: quest.quest_enemy_amount,
                                    quest_enemies_killed: player_quest["quest_enemies_killed"],
                                    quest_items_gained: player_quest["quest_items_gained"],
                                    completed: player_quest["completed"], reward_paid_out: player_quest["reward_paid_out"] }
      end
      return @quests
    end
  end
end

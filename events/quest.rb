require_relative "../entities/enemy"
require_relative "../entities/item"

module Events
  class Quest
    attr_accessor :quest_id, :quest_name, :quest_description, :quest_enemy, :quest_enemy_amount, :quest_reward,
                  :quest_reward_amount, :quest_secondary_reward, :quest_secondary_reward_amount,
                  :quest_money_amount

    def initialize(quest, db)
      set_quest_details(quest, db)
    end

    def set_quest_details(quest, db)
      @quest_id = quest["id"]
      @quest_name = quest["quest_name"]
      @quest_description = quest["quest_description"]
      @quest_enemy = Entities::Enemy.new(quest["quest_requirement_enemy_id"], db)
      @quest_enemy_amount = quest["quest_requirement_enemy_amount"]
      @quest_reward = Entities::Item.new(quest["quest_reward_item_id"], db)
      @quest_reward_amount = quest["quest_reward_item_amount"]
      @quest_secondary_reward = quest["quest_reward_secondary_item"] == 0 ? nil : Entities::Item.new(quest["quest_reward_secondary_item_id"], db)
      @quest_secondary_reward_amount = quest["quest_secondary_reward_item_amount"]
      @quest_money_amount = quest["quest_reward_money_amount"]
    end
  end
end

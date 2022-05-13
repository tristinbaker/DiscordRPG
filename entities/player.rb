require_relative "./inventory.rb"
require_relative "./player_quest_log.rb"
require_relative "../lib/experience_levels"

include ExperienceLevels

module Entities
  class Player
    attr_accessor :player_id, :player_name, :inventory, :level, :strength, :agility, :intelligence, :experience, :hp, :max_hp, :mp, :max_mp, :player_quest_log, :action, :equipped_weapon, :experience_level

    def initialize(player, db)
      @player_id = player["player_id"]
      @player_name = player["player_name"]
      @inventory = set_inventory(db)
      set_player_details(db)
      @player_quest_log = set_player_quest_log(db)
      @action = actions[:idle]
    end

    #####################
    #      Getters      #
    #####################

    def get_player_damage(enemy)
      player_damage_multiplier = 1
      player_damage = 0
      str = @strength
      agl = @agility
      int = @intelligence
      item_str = @equipped_weapon.item_strength
      enemy_lvl = enemy.level
      enemy_def = enemy.defense
      if @level < enemy_lvl
        if @level + 1 < enemy_lvl && @level + 3 >= enemy_lvl
          player_damage_multiplier *= 0.95
        elsif @level + 3 < enemy_lvl && @level + 5 >= enemy_lvl
          player_damage_multiplier *= 0.9
        elsif @level + 5 < enemy_lvl && @level + 10 >= enemy_lvl
          player_damage_multiplier *= 0.85
        else
          player_damage_multiplier *= 0.75
        end
      end
      player_damage += ((str + (0.5 * item_str if @equipped_weapon.is_str_weapon || 0)) +
                        (agl + (0.5 * item_str if @equipped_weapon.is_agl_weapon || 0)) +
                        (int + (0.5 * item_str if @equipped_weapon.is_int_weapon || 0)))
      player_damage = (player_damage * player_damage_multiplier).ceil
      player_damage = ((player_damage - (enemy_def / 2)) / 2).ceil
      return player_damage
    end

    #####################
    #      Setters      #
    #####################

    def set_action(action)
      @action = actions[action]
    end

    def increase_level(player, db)
      @level += 1
      db.query("UPDATE players SET level = #{@level} WHERE player_id = #{player.player_id}")
    end

    def set_name(arguments, db, player)
      name = arguments[2..arguments.length].join(" ")
      db.query("UPDATE players SET player_name = '#{name}' WHERE player_id = #{player.player_id}")
      @player_name = name
      opts = {}
      opts[:title] = "Player Name Updated!"
      opts[:description] = "Player name updated to #{@player_name}."
      return opts
    end

    def set_inventory(db)
      begin
        inventory_id = db.query("SELECT id FROM inventories WHERE player_id = #{@player_id} LIMIT 1").first["id"]
      rescue NoMethodError
        gsm.db.query("INSERT INTO inventories (player_id) VALUES (#{@player_id})")
        inventory_id = db.query("SELECT id FROM inventories WHERE player_id = #{@player_id} LIMIT 1").first["id"]
      end
      inventory = Entities::Inventory.new(inventory_id, db)
      return inventory
    end

    def set_player_details(db)
      details = db.query("SELECT * FROM player_details WHERE player_id = #{@player_id}").first
      if details.nil?
        db.query("INSERT INTO player_details (player_id, inventory_id) VALUES (#{@player_id}, #{@inventory.inventory_id})")
        details = db.query("SELECT * FROM player_details WHERE player_id = #{@player_id}").first
      end
      @hp = details["hp"].to_i
      @max_hp = details["max_hp"].to_i
      @mp = details["mp"].to_i
      @max_mp = details["max_mp"].to_i
      @strength = details["strength"]
      @defense = details["defense"]
      @agility = details["agility"]
      @intelligence = details["intelligence"]
      @level = details["level"]
      @experience = details["experience"]
      @experience_level = @level == 30 ? 99999999 : ExperienceLevels::LEVELS[(@level + 1).to_s]
      @equipped_weapon = Entities::Item.new(details["equipped_weapon_item_id"], db)
      return details
    end

    def set_player_quest_log(db)
      player_quest_log = Entities::PlayerQuestLog.new(player_id, db)
      return player_quest_log
    end

    #####################
    #       Others      #
    #####################

    def actions
      { idle: "Idle", questing: "Questing", battle: "Battle" }
    end
  end
end

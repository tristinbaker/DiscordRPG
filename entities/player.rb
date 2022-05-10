require_relative "./inventory.rb"
require_relative "./player_quest_log.rb"

module Entities
  class Player
    attr_accessor :player_id, :player_name, :inventory, :player_details, :player_quest_log, :action

    def initialize(player, db)
      @player_id = player["player_id"]
      @player_name = player["player_name"]
      @inventory = set_inventory(db)
      @player_details = set_player_details(db)
      @player_quest_log = set_player_quest_log(db)
      @action = actions[:idle]
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
      return details
    end

    def set_player_quest_log(db)
      player_quest_log = Entities::PlayerQuestLog.new(player_id, db)
      return player_quest_log
    end

    def print_player
      opts = {}
      opts[:title] = "#{@player_name} Stats"
      opts[:description] = "*Status: #{@action}*\n"
      opts[:description] += "Level #{@player_details["level"]} (#{player_details["experience"]} EXP)\n"
      opts[:description] += "**HP:** #{@player_details["hp"].to_i}/#{@player_details["max_hp"].to_i}\n**MP:** #{@player_details["mp"].to_i}/#{@player_details["max_mp"].to_i}\n"
      opts[:description] += "**STR:** #{@player_details["strength"]}\n**AGL:** #{@player_details["agility"]}\n**INT:** #{@player_details["intelligence"]}\n"
      opts[:opts] = Hash.new("")
      return opts
    end

    def update_name(arguments, db, player)
      name = arguments[2..arguments.length].join(" ")
      db.query("UPDATE players SET player_name = '#{name}' WHERE player_id = #{player.player_id}")
      @player_name = name
      opts = {}
      opts[:title] = "Player Name Updated!"
      opts[:description] = "Player name updated to #{@player_name}."
      return opts
    end

    def actions
      { idle: "Idle", questing: "Questing", battle: "Battle" }
    end
  end
end

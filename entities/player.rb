require_relative "./inventory.rb"

module Entities
  class Player
    attr_accessor :player_id, :player_name, :inventory, :player_details

    def initialize(player, db)
      @player_id = player["player_id"]
      @player_name = player["player_name"]
      @inventory = set_inventory(db)
      @player_details = set_player_details(db)
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
  end
end

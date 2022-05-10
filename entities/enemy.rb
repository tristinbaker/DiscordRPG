require_relative "./item.rb"
require_relative "../util/image_handler"

module Entities
  class Enemy
    attr_accessor :name, :strength, :agility, :intelligence, :weapon, :weapon_str, :experience_drop, :max_hp, :max_mp, :sprite_location, :is_boss, :level

    def initialize(enemy_id, db)
      @enemy_id = enemy_id
      set_enemy_details(db)
    end

    def set_enemy_details(db)
      details = db.query("SELECT * FROM enemies where id = #{@enemy_id}").first
      @name = details["enemy_name"]
      @max_hp = details["max_hp"]
      @max_mp = details["max_mp"]
      @strength = details["strength"]
      @agility = details["agility"]
      @intelligence = details["intelligence"]
      @weapon = Entities::Item.new(details["item_id"], db)
      @weapon_str = @weapon.item_strength
      @experience_drop = details["experience_drop"]
      @sprite_location = details["sprite_location"]
      @is_boss = details["is_boss"] == 0 ? false : true
      @level = details["level"]
    end

    def print_enemy(enemy)
      opts = {}
      opts[:title] = "#{@name}"
      opts[:description] = "**HP:** #{enemy.max_hp.to_i}/#{enemy.max_hp.to_i}\n**MP:** #{enemy.max_mp.to_i}/#{enemy.max_mp.to_i}\n"
      opts[:description] += "**STR:** #{enemy.strength}\n**AGL:** #{enemy.agility}\n**INT:** #{enemy.intelligence}\n"
      opts[:image] = Util::ImageHandler.new(enemy.sprite_location).create_embed_image
      return opts
    end
  end
end

require_relative "./item.rb"
require_relative "../util/image_handler"

module Entities
  class Enemy
    attr_accessor :enemy_id, :name, :strength, :agility, :intelligence, :weapon, :weapon_str, :experience_drop, :hp, :mp, :max_hp, :max_mp, :sprite_location, :is_boss, :level, :defense, :equipped_weapon

    def initialize(enemy_id, db)
      @enemy_id = enemy_id
      set_enemy_details(db)
    end

    #####################
    #      Getters      #
    #####################

    def get_enemy_damage(player)
      enemy_damage = 0
      str = @strength
      agl = @agility
      int = @intelligence
      item_str = @weapon.item_strength
      player_def = player.defense
      enemy_damage += ((str + (0.5 * item_str if @weapon.is_str_weapon)) +
                       (agl + (0.5 * item_str if @weapon.is_agl_weapon)) +
                       (int + (0.5 * item_str if @weapon.is_int_weapon)))
      enemy_damage = ((enemy_damage - (player_def / 2)) / 2).ceil
      return enemy_damage
    end

    #####################
    #      Setters      #
    #####################

    def set_enemy_details(db)
      details = db.query("SELECT * FROM enemies where id = #{@enemy_id}").first
      @name = details["enemy_name"]
      @hp = details["max_hp"]
      @mp = details["max_mp"]
      @max_hp = details["max_hp"]
      @max_mp = details["max_mp"]
      @strength = details["strength"]
      @defense = details["defense"]
      @agility = details["agility"]
      @intelligence = details["intelligence"]
      @weapon = Entities::Item.new(details["item_id"], db)
      @weapon_str = @weapon.item_strength
      @experience_drop = details["experience_drop"]
      @sprite_location = details["sprite_location"]
      @is_boss = details["is_boss"] == 0 ? false : true
      @level = details["level"]
    end

    #####################
    #       Others      #
    #####################

    def print_enemy
      opts = {}
      opts[:title] = "#{@name}"
      opts[:description] = "**HP:** #{@max_hp.to_i}/#{@max_hp.to_i}\n**MP:** #{@max_mp.to_i}/#{@max_mp.to_i}\n"
      opts[:description] += "**STR:** #{@strength}\n**AGL:** #{@agility}\n**INT:** #{@intelligence}\n**DEF:** #{@defense}\n"
      opts[:image] = Util::ImageHandler.new(@sprite_location).create_embed_image
      return opts
    end
  end
end

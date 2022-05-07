require_relative "./item.rb"

module Entities
  class Enemy
    attr_accessor :name, :strength, :agility, :intelligence, :weapon, :weapon_str, :experience_drop

    def initialize(enemy_id, db)
      @enemy_id = enemy_id
      #require "pry" && binding.pry
      set_enemy_details(db)
    end

    def set_enemy_details(db)
      details = db.query("SELECT * FROM enemies where id = #{@enemy_id}").first
      @name = details["enemy_name"]
      @strength = details["strength"]
      @agility = details["agility"]
      @intelligence = details["intelligence"]
      @weapon = Entities::Item.new(details["item_id"], db)
      @weapon_str = @weapon.item_strength
      @experience_drop = details["experience_drop"]
    end
  end
end

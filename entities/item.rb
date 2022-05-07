require_relative "./item_type.rb"

module Entities
  class Item
    attr_accessor :item_id, :item_name, :item_type, :item_strength, :max_item_quantity, :is_healing_item

    def initialize(item_id, db)
      @item_id = item_id
      set_item_details(db)
    end

    def set_item_details(db)
      details = db.query("SELECT * FROM items WHERE id = #{@item_id}").first
      unless details.nil? || details.empty?
        @item_name = details["item_name"]
        @item_strength = details["item_strength"]
        @is_healing_item = details["is_heal_item"] == 0 ? false : true
        @max_item_quantity = details["max_item_quantity"]
        @item_type = Entities::ItemType.get_item_type(details["item_type_id"], db)
      else
        @item_name = ""
        @item_type = ""
        @item_strength = 0
        @is_healing_item = false
        @max_item_quantity = -99
      end
    end
  end
end

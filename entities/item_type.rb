module Entities
  class ItemType
    attr_accessor :item_type

    def initialize(item_type)
      @item_type = item_type
    end

    def self.get_item_type(item_type_id, db)
      item_type = db.query("SELECT * FROM item_types WHERE id = #{item_type_id}").first
      unless item_type.empty?
        item_type = item_type["item_type"]
      end
      return item_type
    end
  end
end

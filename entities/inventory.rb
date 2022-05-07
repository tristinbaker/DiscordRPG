require_relative "./item.rb"

module Entities
  class Inventory
    attr_accessor :inventory_id, :items

    def initialize(inventory_id, db)
      @inventory_id = inventory_id
      @items = set_items(db)
    end

    def set_items(db)
      items = []
      rows = db.query("SELECT * FROM inventory_details WHERE inventory_id = #{@inventory_id}")
      rows.each do |item|
        items << Entities::Item.new(item["id"], db)
      end
      return items
    end
  end
end

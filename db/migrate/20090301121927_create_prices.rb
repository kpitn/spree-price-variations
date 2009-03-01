class CreatePriceVariations < ActiveRecord::Migration
  def self.up
    create_table :price_variations  do |t|
      t.references :product
      t.float :value
      t.string :change_date, :limit=>7
      t.timestamp 
    end
    add_index :price_variations, :product_id
  end

  def self.down
    drop_table :price_variations
  end
end

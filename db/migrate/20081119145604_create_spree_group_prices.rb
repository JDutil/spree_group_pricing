class CreateSpreeGroupPrices < ActiveRecord::Migration
  def self.up
    create_table :spree_group_prices do |t|
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :discount_type
      t.string :name
      t.string :range
      t.integer :position
      t.references :variant
      t.timestamps
    end
  end

  def self.down
    drop_table :spree_group_prices
  end
end

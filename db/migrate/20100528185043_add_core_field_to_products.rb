class AddCoreFieldToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :core_amount, :decimal, :null => true, :default => nil, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :products, :core_amount
  end
end

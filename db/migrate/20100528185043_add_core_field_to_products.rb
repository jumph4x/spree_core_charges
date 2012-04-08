class AddCoreFieldToProducts < ActiveRecord::Migration
  def self.up
    add_column products_table_name, :core_amount, :decimal, :null => true, :default => nil, :precision => 8, :scale => 2
  end

  def self.down
    remove_column products_table_name, :core_amount
  end
  
  private
  
  def self.products_table_name
    table_exists?('products') ? :products : :spree_products
  end
end

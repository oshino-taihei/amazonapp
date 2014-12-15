class AddIndexAsinToBook < ActiveRecord::Migration
  def change
    add_index :books, :asin, :unique => true
  end
end

class AddIndexFromAsinAndToAsinToLink < ActiveRecord::Migration
  def change
    add_index :links, [:from_asin, :to_asin], :unique => true
  end
end

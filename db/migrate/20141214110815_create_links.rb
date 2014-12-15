class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :from_asin, limit:13
      t.string :from_title
      t.string :to_asin, limit:13
      t.string :to_title

      t.timestamps
    end
  end
end

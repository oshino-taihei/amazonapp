class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :from_id
      t.string :from_title
      t.string :to_id
      t.string :to_title

      t.timestamps
    end
  end
end

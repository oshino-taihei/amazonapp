class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :asin, :limit => 13
      t.string :title
      t.string :url
      t.string :image

      t.timestamps
    end
  end
end

class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :asin
      t.string :title
      t.references :book, index: true

      t.timestamps
    end
  end
end

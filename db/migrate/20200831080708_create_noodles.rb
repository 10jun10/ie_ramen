class CreateNoodles < ActiveRecord::Migration[5.2]
  def change
    create_table :noodles do |t|
      t.string :name
      t.string :maker
      t.string :place
      t.text :eat
      t.string :image
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

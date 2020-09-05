class AddTasteToNoodles < ActiveRecord::Migration[5.2]
  def change
    add_column :noodles, :taste, :string
  end
end

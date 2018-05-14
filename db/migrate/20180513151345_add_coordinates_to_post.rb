class AddCoordinatesToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :coordinates, :string
  end
end

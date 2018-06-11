class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :posts, :media_link, :content
  end
end

class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :media_type
      t.text :media_link
      t.text :description
      t.timestamps
    end
  end
end

class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title, index: true, unique: true
      t.string :content

      t.timestamps null: false
    end

    add_index :posts, [:user_id, :title], unique: true
  end
end

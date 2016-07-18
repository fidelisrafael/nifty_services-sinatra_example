class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :post, index: true, foreign_key: true
      t.string :content

      # very simple report system
      t.datetime :reported_at

      t.timestamps null: false
    end
  end
end

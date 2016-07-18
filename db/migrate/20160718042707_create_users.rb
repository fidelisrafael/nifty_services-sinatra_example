class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :role
      t.string :auth_token # very simple implementation

      t.string :activation_token
      t.datetime :activated_at
      t.datetime :activation_sent_at

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :password_reseted_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :activation_token, unique: true
  end
end

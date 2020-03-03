class CreatePlaylists < ActiveRecord::Migration[5.2]
  def change
    create_table :playlists do |t|
      t.string :name
      t.integer :user_id
      t.integer :followers_user_id
    end
  end
end

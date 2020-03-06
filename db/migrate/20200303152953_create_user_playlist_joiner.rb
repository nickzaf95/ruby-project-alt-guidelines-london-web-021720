class CreateUserPlaylistJoiner < ActiveRecord::Migration[5.2]
  def change
    create_table :followings do |t|
      t.integer :user_id
      t.integer :playlist_id
    end
  end
end

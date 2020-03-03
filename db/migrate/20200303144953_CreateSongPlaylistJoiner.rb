class CreateSongPlaylistJoiner < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_joiners do |t|
      # Each joiner belongs to a song 
      # Each joiner belongs to a playlist 
      # songs have many joiners
      # playlists have many joiners 
      t.integer :song_id
      t.integer :playlist_id
    end
  end
end


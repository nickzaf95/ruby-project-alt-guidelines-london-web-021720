class PlaylistJoiner < ActiveRecord::Base
    belongs_to :song
    belongs_to :playlist 

    def self.add(song, playlist)
        # Adds a joiner between a song and a playlist
        PlaylistJoiner.create(song_id: song.id, playlist_id: playlist.id)
    end
end
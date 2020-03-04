class Artist < ActiveRecord::Base
    has_many :songs
    has_many :genres, through: :songs 
    has_many :playlists, through: :playlist_joiners

    def songs
        # Returns an array with all the artist's songs
        Song.all.select{ |s| s.artist_id == self.id }
    end

end
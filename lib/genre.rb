class Genre < ActiveRecord::Base
    has_many :songs
    has_many :artists, through: :songs 
    has_many :playlists, through: :songs

    def songs
        # Returns an array with all the genre's songs
        Song.all.select{ |s| s.genre_id == self.id }
    end

end
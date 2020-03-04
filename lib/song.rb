class Song < ActiveRecord::Base
    belongs_to :artist
    belongs_to :genre
    has_many :playlists, through: :playlist_joiners

    def self.new_song(title, a, g)
        # After prompting users for data, initialises a new song
        art = Artist.create(name: a)
        gen = Genre.create(name: g)
        Song.create(name: title, artist: a, genre: g)
    end


end
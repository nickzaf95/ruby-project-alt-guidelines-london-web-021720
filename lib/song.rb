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

    def add_to_playlist(title)
        if Playlist.all.find{ |p| p.name == title }
            Playlist.all.find{ |p| p.name == title }.add_song(self.name)
        else
            nil
        end
    end

    def self.find_song(title)
        Song.all.find{ |s| s.name == title }
    end


end
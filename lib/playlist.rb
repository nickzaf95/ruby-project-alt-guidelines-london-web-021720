class Playlist < ActiveRecord::Base
    has_many :songs, through: :playlist_joiners
    has_many :artists, through: :songs
    has_many :genres, through: :songs 
    has_many :users, through: :followings

    def add_song(name)
        song = (Song.all.select{ |s| s.name == name }).first
        PlaylistJoiner.create(playlist_id: self.id, song_id: song.id)
        song
    end

    def pj_finder
        # Find all the instances in playlist joiner where this playlist shows up
        PlaylistJoiner.all.select{ |pj| pj.playlist_id == self.id }
    end


    def songs
        # First finds all the instances where this playlist
        # shows up in the joiner table
        # Maps it to find all the song instances in this specific playlist
        # where the ids match
        pj_finder.map{ |s| Song.all.select{ |x| x.id == s.song_id }[0] }
    end

    def add_songs_from_artist(name)
        # Adds all the songs from a specific artist to a playlist
        # Does not add duplicates (separate method?)
        artist = Artist.all.select{ |a| a.name == name }[0]
        artist.songs.each{ |s| PlaylistJoiner.add(s, self)}
    end

end
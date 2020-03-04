class Playlist < ActiveRecord::Base
    has_many :songs, through: :playlist_joiners
    has_many :artists, through: :songs
    has_many :genres, through: :songs 
    has_many :users, through: :followings

    def add_song(title)
        song = Song.find_song(title)
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

    def artists
        songs = self.songs
        arr = songs.map{ |s| s.artist }
        arr.uniq
    end

    def genres
        songs = self.songs
        arr = songs.map{ |s| s.genre }
        arr.uniq
    end

    def add_songs_from_artist(name)
        # Adds all the songs from a specific artist to a playlist
        # Does not add duplicates (separate method?)
        artist = Artist.all.select{ |a| a.name == name }[0]
        artist.songs.each{ |s| PlaylistJoiner.add(s, self) }
    end

    def add_songs_from_genre(name)
        # Adds all the songs from a specific genre to a playlist
        # Does not add duplicates (separate method?)
        genre = Genre.all.select{ |g| g.name == name }[0]
        genre.songs.each{ |s| PlaylistJoiner.add(s, self) }
    end

    def creator
        # Finds the instance of who created this playlist
        User.all.find{ |u| u.id == self.user_id }
    end

    def creator_name
        # Returns the name of who created this playlist
        self.creator.name
    end

    def self.is_there_song(title)
        # Returns a list of all the playlists that include this song
        song = Song.find_song(title)
        arr = []
        Playlist.all.each do |p|
            if p.songs.include?(song)
                arr << p 
            end
        end
        arr
    end

    def self.is_there_artist(title)
        artist = Artist.find_artist(title)
        arr = []
        Playlist.all.each do |p|
            if p.artists.include?(artist)
                arr << p 
            end
        end
        arr
    end

    def self.is_there_genre(title)
        genre = Genre.find_genre(title)
        arr = []
        Playlist.all.each do |p|
            if p.genres.include?(genre)
                arr << p 
            end
        end
        arr
    end



end
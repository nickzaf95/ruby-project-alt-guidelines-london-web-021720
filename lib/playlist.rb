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

    def add_songs_from_playlist(title)
        # Adds all the songs from a specific genre to a playlist
        # Does not add duplicates (separate method?)
        play = Playlist.find_by(name: title)
        play.songs.each{ |s| PlaylistJoiner.add(s, self) }
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
        # Returns a list of all the playlists that include this artist
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
        # Returns a list of all the playlists that include this genre
        genre = Genre.find_genre(title)
        arr = []
        Playlist.all.each do |p|
            if p.genres.include?(genre)
                arr << p 
            end
        end
        arr
    end

    def followings
        # Returns an array with all the following pairs
        Followings.all.select{ |f| f.playlist_id == self.id }
    end

    def follow_count 
        # Counts how many users follow this playlist
        self.followings.size
    end

    def song_count
        # Counts how many songs are in this playlist
        self.songs.size
    end

    def artist_count(title)
        # Counts how many songs by this artist are in the playlist
        art = Artist.all.find{ |a| a.name == title }
        self.songs.select{ |s| s.artist = art }.size
    end

    def genre_count(title)
        # Counts how many songs with this genre are in the playlist
        gen = Genre.all.find{ |g| g.name == title }
        self.songs.select{ |s| s.genre = gen }.size
    end

    def who_follows
        # Array of each user that follows this playlist
        self.followings.map{ |f| User.all.find{ |u| u.id == f.user_id } }
    end

    def check_for_follow(username)
        # Returns false if user already follows
        person = User.all.find{ |u| u.name == username }
        if self.who_follows.include?(person)
            false
        else
            true
        end
    end

    def self.create_favourites(hash)
        # Takes a hash of the top songs
        # Creates a playlist with these songs
        top = Playlist.create(name: "Billboard Top 5")
        hash.each do |k, v|
            top.add_song(k)
        end
    end

    def self.top_two_playlist
        # Returns the top 2 followed playlists
        arr = {}
        Playlist.all.each do |p|
            arr[p.name] = p.follow_count
        end
        arr.sort_by{|k, v| -v}.to_h.first(2).to_h
    end

    def delete_from_playlist(title)
        # Deletes song from this playlist
        song = Song.find_by(name: title)
        join = PlaylistJoiner.find_by(song_id: song.id, playlist_id: self.id)
        PlaylistJoiner.delete(join)
    end

end
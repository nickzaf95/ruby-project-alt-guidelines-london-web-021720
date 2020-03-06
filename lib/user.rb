class User < ActiveRecord::Base
    has_many :playlists, through: :followings
    has_many :songs, through: :playlists
    has_many :artists, through: :songs 
    has_many :genres, through: :songs 

    def follows_all
        # Returns the list of followings this user has
        Followings.all.select{ |f| f.user_id == self.id }
    end

    def does_not_follow
        # Returns list of playlists you don't follow
        arr = []
        users_playlists = my_playlists
        Playlist.all.each do |p|
            if users_playlists.include?(p) == false 
                arr << p 
            end
        end
        arr
    end

    def has_not_created
        # Returns list of playlists you did not create
        arr = []
        users_playlists = my_created_playlists
        Playlist.all.each do |p|
            if users_playlists.include?(p) == false 
                arr << p 
            end
        end
        arr
    end

    def follow(title)
        # Makes user follow this title playlist
        play = Playlist.all.find{ |p| p.name == title }
        Followings.add(self, play)
    end

    def follows_playlists_id
        # Returns a list of all the ids of all the playlist this user follows
        follows_all.map{ |f| f.playlist_id } 
    end

    def my_playlists  
        # Takes all the followings and maps them to
        # all the playlists that have the same playlist id
        # Basically returns the playlists this user follows
        follows_all.map{ |f| Playlist.all.select{ |x| x.id == f.playlist_id }[0] }
    end

    def my_created_playlists
        # Returns playlists that 'I' created
        Playlist.all.select{ |p| p.user_id == self.id }
    end

    def playlist_songs(title)
        # Takes in a playlist name, returns the songs for that playlist
        play = Playlist.all.find{ |p| p.name == title }
        play.songs
    end

end
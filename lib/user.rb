class User < ActiveRecord::Base
    has_many :playlists, through: :followings
    has_many :songs, through: :playlists
    has_many :artists, through: :songs 
    has_many :genres, through: :songs 

    def follows_all
        # Returns the list of followings this user has
        Followings.all.select{ |f| f.user_id == self.id }
    end

    def follow(title)
        play = Playlist.all.find{ |p| p.name == title }
        Followings.add(self, play)
    end

    def follows_playlists_id
        # Returns a list of all the ids of all the playlist this user follows
        follows_all.map{ |f| f.playlist_id } 
    end

    def follows 
        # Takes all the followings and maps them to
        # all the playlists that have the same playlist id
        follows_all.map{ |f| Playlist.all.select{ |x| x.id == f.playlist_id }[0] }
    end

end
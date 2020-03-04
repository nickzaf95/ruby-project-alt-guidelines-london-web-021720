class Playlist < ActiveRecord::Base
    has_many :songs, through: :playlist_joiners
    has_many :artists, through: :songs
    has_many :genres, through: :songs 
    has_many :users, through: :followings

    def add_song(name)
        PlaylistJoiner.create(playlist_id: self.id, song_id: (Song.all.select{ |s| s.name == name }).first.id)
    end



    def songs
        # First finds all the instances where this playlist
        # shows up in the joiner table
        # Maps it to find all the song instances in this specific playlist
        # where the ids match
        PlaylistJoiner.all.select{ |pj| pj.playlist_id == self.id }.map{ |s| Song.all.select{ |x| x.id == s.song_id }[0] }
    end
end
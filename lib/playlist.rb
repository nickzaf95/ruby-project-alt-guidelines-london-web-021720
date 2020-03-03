class Playlist < ActiveRecord::Base
    has_many :songs, through: :playlist_joiners
    has_many :artists, through: :songs
    has_many :genres, through: :songs 
    has_many :users, through: :followings
end
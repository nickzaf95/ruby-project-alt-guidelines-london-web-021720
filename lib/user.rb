class User < ActiveRecord::Base
    has_many :playlists, through: :followings
    has_many :songs, through: :playlists
    has_many :artists, through: :songs 
    has_many :genres, through: :songs 
end
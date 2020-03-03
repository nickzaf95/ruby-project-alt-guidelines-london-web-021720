class Song < ActiveRecord::Base
    belongs_to :artist
    belongs_to :genre
    has_many :playlists, through: :playlist_joiners

end
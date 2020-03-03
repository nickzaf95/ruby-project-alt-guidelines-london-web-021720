class PlaylistJoiner < ActiveRecord::Base
    belongs_to :song
    belongs_to :playlist 
end
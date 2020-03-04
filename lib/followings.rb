class Followings < ActiveRecord::Base
    belongs_to :user
    belongs_to :playlist

    def self.add(user, playlist)
        Followings.create(user_id: user.id, playlist_id: playlist.id)
    end
end
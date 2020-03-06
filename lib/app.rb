class App

    def greet
        puts "Welcome to Nick's music app! Here you can check out songs and add them to your own playlists"
    end

    def ask_for_name
        puts "Hi there! What is your first name?"
    end

    def welcome_back(name)
        puts "Welcome back #{name}! Enjoy your time using this app."
    end

    def lets_create_you(title)
        User.create(name: title)
    end

    def down_it_and_titleize(x)
        x.downcase.titleize 
    end

    def do_you_want_to(title)
        puts "Would you like to create a user profile for yourself? [y/n]"
        ans = gets.chomp
        if ans.downcase == "n" || ans.downcase == "no"
            puts "Thank you for your time with us."
            return "This was fun!"
        elsif ans.downcase == "y" || ans.downcase == "yes"
            puts "Your user profile has been created #{title}!"
            self.lets_create_you(title)
        else
            puts "Sorry, we did not understand your input, please try again."
            do_you_want_to(title)
        end
    end

    def goodbye
        puts "Goodbye!"
    end

    def provide_options
        puts "What would you like to do?"
        puts ""
        puts "Please respond with the integer in the square brackets only."
        puts "If you would like to leave the app, please type 'exit'."
        puts ""
        puts "See the Playlists you currently follow.          [1]"
        puts "See the Playlists you created                    [2]"
        puts "Modify a Playlists                               [3]"
        puts "Check the information of a particular song       [4]"
        puts "Check the information of a particular artist     [5]"
        puts "Check the songs or artists of a particular genre [6]"
        puts "Follow a playlist you do not already follow      [7]"
        puts "Add a song, artist or genre to the database      [8]"
        puts "See the Billboard Top 5 Songs of right now!      [9]"
        answer = gets.chomp
        answer
    end

    def billboard
        puts "Have you altered how many songs go into each playlist? [y/n]"
        response = gets.chomp
        if response.downcase == "n" || response.downcase == "no"
            topsongs = {"Tropic"=>6, "Perth"=>5, "Raw"=>4, "The Illout"=>4, "Bela"=>3}
            original_top_songs_playlist = Playlist.create_favourites(topsongs)
            return original_top_songs_playlist
        elsif response == "y" || response == "yes"
            bill = Playlist.create_favourites(Song.top_songs)
            return bill
        else
            puts "Sorry, I do not understand."
            self.billboard
        end
    end

    def artist_adder
        puts "Please type in the correct name of the artist."
        art = gets.chomp
        art = down_it_and_titleize(art)
        if Artist.find_by(name: art) == nil
            art = Artist.create(name: art)
        else
            puts "The Artist #{art} exists!"
            art = Artist.find_artist(art)
        end
        art
    end

    def genre_adder
        puts "Please type in the correct name of the genre."
        gen = gets.chomp
        gen = down_it_and_titleize(gen)
        if Genre.find_by(name: gen)
            puts "The Genre #{gen} exists!"
            gen = Genre.find_genre(gen)
        else
            gen = Genre.create(name: gen)
        end
        gen
    end

    def artist_checker
        puts "Please type in the correct name of the artist."
        art = gets.chomp
        art = down_it_and_titleize(art)
        check = Artist.find_by(name: art)
        if check == nil
            puts "Sorry, please try again."
        else
            puts "#{check.name}"
            puts "The artist has #{check.songs.size} songs"
            puts "The artist's songs are:"
            x = check.songs.map{ |s| s.name }
            puts "#{x}"
        end
        check
    end

    def genre_checker
        puts "Please type in the correct name of the genre."
        gen = gets.chomp
        gen = down_it_and_titleize(gen)
        check = Genre.find_by(name: gen)
        if check == nil
            puts "Sorry, please try again."
        else
            puts "#{check.name}"
            puts "The genre has #{check.songs.size} songs"
            puts "The genre's songs are:"
            x = check.songs.map{ |s| s.name }
            puts "#{x}"
            puts "The genre's artists are:"
            x = check.artists.uniq
            x.each{ |a| puts a.name }
            puts "The genre has #{x.size} artists"
        end
        check
    end

    def song_adder(response)
        # Ask if they want to add the song to the database
        puts "Would you like to add this song to the database? [y/n]"
        answer = gets.chomp
        if answer.downcase == "n" || answer.downcase == "no"
            puts "Ok not to worry!"
            return
        elsif answer.downcase == "y" || answer.downcase == "yes"
            art = self.artist_adder
            gen = self.genre_adder
            song = Song.create(name: response, artist: art, genre: gen)
        else
            puts "Sorry we did not understand. Please try again."
        end
        song
    end

    def song_checker
        puts "Please type in the name of the song."
        response = gets.chomp
        response = down_it_and_titleize(response)
        isit = Song.find_by(name: response)
        if isit == nil
            song = self.song_adder(response)
        else
            puts "This song exists!!!"
            puts "The name of the song is: #{isit.name}"
            puts "The name of the artist is: #{isit.artist.name}"
            puts "The name of the genre is: #{isit.genre.name}"
            puts "This song is in #{isit.how_many_playlists} playlists"
            song = isit
        end
        song
    end

    def song_artist_genre
        puts "What would you like to add? [S]ong, [A]rtist or [G]enre."
        response = gets.chomp
        if response.downcase == "s" || response.downcase == "a" || response.downcase == "g" 
            return response.downcase
        else
            "Sorry, we did not understand. Please try again."
            self.song_artist_genre
        end
    end

    def playlist_starter(user)
        # Checks which playlist you want to modify
        puts "Out of these playlists, which would you like to modify?"
        puts ""
        Playlist.all.each do |p|
            puts "#{p.name} is option #{p.id}"
        end
        response = gets.chomp.to_i
        if response < 1 || response > Playlist.all.size
            "Sorry, Please try again."
        else
            # First check to see if you created it
            # Then either create a new one or modify your own
            playlist = Playlist.find(response)
            if playlist.user_id == user.id
                puts "You created this playlist! So we will modify the original."
                return playlist
            else
                puts "Someone else created this playlist."
                puts "So we will create a new playlist for you with the modifications."
                puts ""
                new_name = "#{playlist.name} - modified by #{user.name}"
                new_playlist = Playlist.create(name: new_name, user_id: user.id)
                new_playlist.add_songs_from_playlist(playlist.name)
                return new_playlist
            end
        end
    end

    def modify(playlist)
        puts "How would you like to modify this Playlist?"
        puts ""
        puts "Add a song to this playlist                   [1]"
        puts "Add all songs from an artist to this playlist [2]"
        puts "Add all songs from a genre to this playlist   [3]"
        response = gets.chomp.to_i
        if response < 1 || response > 3
            puts "Sorry, please try again!"
        elsif response == 1
            song = self.song_checker
            playlist.add_song(song.name)
        elsif response == 2
            artist = artist_checker
            playlist.add_songs_from_artist(artist.name)
        elsif response == 3
            genre = genre_checker
            playlist.add_songs_from_genre(genre.name)
        end
        puts "Are you finished modifying this playlist?"
        answer = gets.chomp
        if answer.downcase == "n" || answer.downcase == "no"
            self.modify(playlist)
        elsif answer.downcase == "y" || answer.downcase == "yes"
            puts "Thank you very much!"
            return
        else
            "Sorry, please start again."
        end
    end

    def follow_unfollowed(username)
        username.does_not_follow.uniq.each{ |p| puts p.name }
        puts "Please type in the exact name of the playlist you would like to follow."
        puts ""
        response = gets.chomp
        play = Playlist.find_by(name: response)
        if play
            already = username.follows_playlists_id
            if already.include?(play.id)
                puts "Sorry, you already follow this playlist! Have a nice day."
            else
                username.follow(response)
            end
        else
            puts "Sorry, your playlist does not exist. Please try again."
        end
    end

    def run
        self.greet
        self.ask_for_name
        title = gets.chomp
        title = down_it_and_titleize(title)
        username = User.find_by(name: title)
        if username
            puts ""
            self.welcome_back(username.name)
        elsif title.downcase == "exit"
            return
        else
            puts ""
            username = do_you_want_to(title)
            if username.class == String
                self.goodbye
                return
            end
        end
        # Initialisation is over, now let's get to functionality of the app
        desire = 0
        while desire do
            puts ""
            desire = self.provide_options
            puts ""
            if desire.downcase == "exit"
                self.goodbye
                desire = nil
                break
            end
            desire = desire.to_i 

            if desire < 1 || desire > 10
                puts ""
                puts "Sorry we don't understand your response. Please try again."
            elsif desire == 1
                # See playlists you follow
                username.my_playlists.each{ |p| puts p.name }
            elsif desire == 2
                puts ""
                # See playlists you created
                username.my_created_playlists.each{ |p| puts p.name }            
            elsif desire == 3
                # Modify a playlist
                puts ""
                play = self.playlist_starter(username)
                self.modify(play)
            elsif desire == 4
                # Check info of song
                puts ""
                self.song_checker
            elsif desire == 5
                # Check info of artist
                puts ""
                self.artist_checker
            elsif desire == 6
                # Check info of genre
                puts ""
                self.genre_checker
            elsif desire == 7
                # Follow a playlist you don't already follow
                # Shows playlist you don't follow, you choose
                # And Boom! you follow it
                puts ""
                self.follow_unfollowed(username)
            elsif desire == 8
                # Add a song, artist or genre to the database
                puts ""
                ans = song_artist_genre
                if ans == "s"
                    self.song_checker
                elsif ans == "a"
                    self.artist_adder
                else
                    self.genre_adder
                end
            elsif desire == 9
                # Check out the billboard top 5
                puts ""
                bill = self.billboard
                puts "This will print out the songs with how many playlist each song is in."
                puts ""
                puts bill
            end
        end
    end
end
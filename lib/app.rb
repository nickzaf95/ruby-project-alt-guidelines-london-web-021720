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
        puts "Please respond with the integer in the square brackets only."
        puts "If you would like to leave the app, please type 'exit'."
        puts ""
        puts "See your current Playlists [1]"
        puts "See the Playlists you created [2]"
        puts "Modify one of your Playlists [3]"
        puts "Check the information of a particular song [4]"
        puts "Check the information of a particular artist [5]"
        puts "Check the songs or artists of a particular genre [6]"
        puts "Modify a playlist that you have not created [7]"
        puts "Follow a playlist you do not already follow [8]"
        puts "Add a song, artist or genre to the database [9]"
        puts "See the Billboard Top 5 Songs of right now! [10]"
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

    def song_checker
        puts "Please type in the name of the song you would like to check."
        response = gets.chomp
        isit = Song.find_by(name: response)
        if isit == nil
            # Ask if they want to add the song to the database
            puts "Would you like to add this song to the database? [y/n]"
            answer = gets.chomp
            if answer.downcase == "n" || answer.downcase == "no"
                puts "Ok not to worry!"
                return
            elsif answer.downcase == "y" || answer.downcase == "yes"
                answer = down_it_and_titleize(answer)
                puts "Please type in the correct name of the artist."
                art = gets.chomp
                if Artist.find_artist(down_it_and_titleize(art)) == nil
                    art = Artist.create(name: art)
                else
                    art = Artist.find_artist(art)
                end
                puts "Please type in the correct name of the genre."
                gen = gets.chomp
                if Genre.find_genre(down_it_and_titleize(gen))
                    gen = Genre.find_genre(gen)
                else
                    gen = Genre.create(name: gen)
                end
                Song.create(name: answer, artist: art, genre: gen)
            else
                puts "Sorry we did not understand. Please try again."
            end
        else
            puts "The name of the song is: #{isit.name}"
            puts "The name of the artist is: #{isit.artist}"
            puts "The name of the genre is: #{isit.genre}"
            puts "This song is in #{isit.how_many_playlists} playlists"
        end
    end



    def run
        self.greet
        self.ask_for_name
        title = gets.chomp
        title = down_it_and_titleize(title)
        username = User.find_by(name: title)
        if username
            self.welcome_back(username.name)
        else
            username = do_you_want_to(title)
            if username.class == String
                self.goodbye
                return
            end
        end
        # Initialisation is over, now let's get to functionality of the app
        desire = 0
        while desire do
            desire = self.provide_options
            if desire.downcase == "exit"
                self.goodbye
                desire = nil
                break
            end
            desire = desire.to_i 

            if desire.class != Integer || desire < 1 || desire > 10
                puts "Sorry we don't understand your response. Please try again."
            elsif desire == 1
                username.my_playlists.each{ |p| puts p.name }
            elsif desire == 2
                username.my_created_playlists.each{ |p| puts p.name }            
            elsif desire == 3
                # Modify a playlist
            elsif desire == 4
                # Check info of song
            elsif desire == 5
                # Check info of artist
            elsif desire == 6
                # Check info of genre
            elsif desire == 7
                # Modify playlist that you did not create
                # Creates a new playlist with your user id
            elsif desire == 8
                # Follow a playlist you don't already follow
                # Shows playlist you don't follow, you choose
                # And Boom! you follow it
            elsif desire == 9
                # Add a song, artist or genre to the database
            elsif desire == 10
                # Check out the billboard top 5
                bill = self.billboard
                puts "This will print out the songs with how many playlist each song is in."
                puts bill
            end

        end


    end

end
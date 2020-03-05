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

    def provide_options
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


    def run
        self.greet
        self.ask_for_name
        title = gets.chomp
        title = down_it_and_titleize(title)
        username = User.find_by(name: title)
        if username
            self.welcome_back(username.name)
        else
            user = do_you_want_to(title)
            if user.class == String
                puts "Goodbye!"
                return "Goodbye!"
            end
        end
        # Initialisation is over, now let's get to functionality of the app


    end

end
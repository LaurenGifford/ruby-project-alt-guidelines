class PantryApp
    attr_reader :prompt
    attr_accessor :user
    # include CliControls

    def initialize
        @prompt = TTY::Prompt.new
    end

    def run
        greet
        login_or_signup
        main_screen
        exit
    end

    def greet
        puts "Welcome to Pantry App. Find food resources near you!"
        sleep(2.0)
    end

    def login_or_signup
        username = prompt.ask("Enter your username to log in or sign up!")
        neighborhood = prompt.ask("What neighborhood do you live in?")
        self.user = User.find_or_create_by(username: username, neighborhood: neighborhood)
        puts "Thanks for signing in, #{user.username}!"
        sleep(1.7)
 #       main_screen
    end

    def main_screen
        system 'clear'
        user.reload
        prompt.select("Do you want to manage your resources?") do |menu|
            menu.choice "Add a resource to my resources", -> {add_helper}
            menu.choice "View all of my resources", -> {view_helper}
            menu.choice "Update a resource", -> {update_helper}
            menu.choice "Delete a resource", -> {delete_helper}
            menu.choice "Exit", -> {exit}
          end
    end

    def add_helper
        resources = Resource.all_names
        selected_resource_id = prompt.select("Which resource do you wish to add?", resources)
        new_resource = FavResource.create(user_id: user.id, resource_id: selected_resource_id)
        puts "Congratulations! You added #{new_resource.resource.name} to your resources."
        sleep(2.0)
        main_screen
    end

    def view_helper
         my_resources = user.show_resources
         puts "Here are your resources:"
         my_resources.each do |res|
            puts res
         end
         sleep(1.0)
         main_screen
    end

    def update_helper
        #display favresources
        #ask what to update
        #what about resource to update
        #do update
        binding.pry
        my_resources = user.resources
        selected_resource = prompt.select("What resource do you want to change?", my_resources)
        # prompt.select("Which aspect of this resource do you want to update?")    

        # result = prompt.collect do
        #     key(:name).ask("Name?")
        #     key(:neighborhood).ask("Neighborhood?")
        #     key(:description).ask("Description?")
        #     key(:fresh).ask("Fresh?", convert: :boolean)
        #   end
    end

    def delete_helper
    binding.pry
        my_resources = user.my_resources
        selected_resource = prompt.select("Which resource would you like to delete?", my_resources.name)
        selected_resource.destroy
        # deleted_resource = favresource.destroy(user_id: user.id, resource_id: selected_resource_id)
        # puts "#{deleted_resource.resource.name} has been deleted from your fav resources."
        # sleep(2.0)
        # main_screen
        # a list of all of the resources
        #select a resource
        #when the user clicks enter, that resource gets deleted from fav_resource
    end

    def exit
        puts "See you later!"
    end

end
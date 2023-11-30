require_relative 'app'

class MainMenu
  def initialize(app)
    @app = app
    @menu_options = {
      1 => :list_all_books,
      2 => :list_all_people,
      3 => :create_person,
      4 => :create_book,
      5 => :create_rental,
      6 => :list_rentals_for_person,
      7 => :quit
    }
  end

  def display
    puts 'Welcome to School Library!'
    puts '=================================='
    puts 'Please select an option:'
    @menu_options.each { |key, value| puts "#{key}. #{value.to_s.tr('_', ' ').capitalize}" }
    puts '=================================='
  end

  def handle_choice(choice)
    option = @menu_options[choice]
    option ? @app.send(option) : invalid_choice
  end

  private

  def quit
    puts 'Thank you for using School Library. Goodbye!'
    exit
  end

  def invalid_choice
    puts 'Invalid choice. Please try again.'
  end
end

class Main
  def initialize
    @app = App.new
    @main_menu = MainMenu.new(@app)
  end

  def run
    loop do
      @main_menu.display
      choice = gets.chomp.to_i
      @main_menu.handle_choice(choice)
    end
  end
end

Main.new.run

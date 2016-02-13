class ClosestWeightliftingGem::CLI
  def call
    load_gyms

    address_input

    menu
  end

  def load_gyms
    puts <<-DOC
      Welcome to the Closest Weightlifting Gem!
      Give me a second while I fetch fresh data widget doohicky from the cloud nebula...
    DOC
    ClosestWeightliftingGem::Scraper.new.scrape_main
  end

  def address_input
    puts <<-DOC
      Please enter your address below and I'll find
      the closest weightlifting gym. (ex. 123 Main St. New York, NY)
    DOC
    address = gets.chomp
  end

  def menu
    puts <<-DOC
      1. More info about the gym
      2. Search again?
      3. Exit
    DOC

    process_option
  end

  def process_option
    input = nil
    while input != "exit"
      input = gets.strip.downcase
      case input
        when "1"
          puts "#1"
        when "2"
          puts "#2"
        when "3"
          puts "#3"
        when "exit"
          puts good_bye
        else
          puts "I didn't understand that, please try again."
      end
    end
  end

  def good_bye
    "Adios friend.  Hope you come back to lift weights again!"
  end

  def show_gym

  end
end
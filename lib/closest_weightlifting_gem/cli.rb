class ClosestWeightliftingGem::CLI
  def call
    load_gyms

    menu

    address_input
  end

  def load_gyms
    puts <<-DOC.gsub /^\s*/, ''
      Welcome to the Closest Weightlifting Gem!
      Give me a few minutes to fetch a fresh data widget doohicky from the cloud nebula...
    DOC
    ClosestWeightliftingGem::Scraper.scrape_main
  end

  def address_input
    puts <<-DOC.gsub /^\s*/, ''
      Please enter your address below and I'll find
      the closest weightlifting gym. (ex. 123 Main St. New York, NY)
    DOC
    address = gets.chomp
  end

  def menu
    puts <<-DOC.gsub /^\s*/, ''
      1. Search 
      2. List By State
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
          show_gym
        when "2"
          puts "Enter"
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
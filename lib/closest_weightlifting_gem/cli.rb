class ClosestWeightliftingGem::CLI
  def call
    load_gyms

    main_menu
  end

  def load_gyms
    puts <<-DOC.gsub /^\s*/, ''
      Welcome to the Closest Weightlifting Gem!
      Give me a few minutes to fetch a fresh data widget doohicky from the cloud nebula...
    DOC

    ClosestWeightliftingGem::Scraper.scrape_main
  end

  def main_menu
    puts "What do you want to do now?"

    options(__method__)
  end

  def options(menu, data=nil)
    menu = menu.to_s

    case menu
      when "main_menu"
        puts line
        puts <<-DOC.gsub(/^\s*/,'')
          1. List By State Abbreviation (ex. AL, AK, CA, FL, IL, NY, etc.)
          2. Search Club Names
          3. Exit
        DOC

        process_main
      when "show_gyms"
        puts line
        puts <<-DOC.gsub(/^\s*/,'')
          1. Select Gym By Number
          2. Replay List
          3. Main menu
          4. Exit
        DOC

        process_gyms(data)
      when "show_gym"
        puts line
        puts <<-DOC.gsub(/^\s*/,'')
          1. Open in Google Maps
          2. Back to Previous Search
          2. Main menu
          3. Exit
        DOC

        process_gym(data)
      else
        puts "What was that??"
    end
  end

  # Not implemented currently, but plan to introduce when I figure out geocoder
  #
  # def address_input
  #   puts <<-DOC.gsub /^\s*/, ''
  #     Please enter your address below and I'll find
  #     the closest weightlifting gym. (ex. 123 Main St. New York, NY)
  #   DOC

  #   address = gets.chomp
  # end

  def show_gyms(gyms)
    width = 80
    puts "="*width
    puts "OK, your search yielded #{gyms.size} gyms!\n"
    puts "Here's the list: "
    puts "="*width
    puts "     Gym Name".ljust(width/2)+"       City"

    gyms.each_with_index do |gym, i|
      puts "#{(i+1).to_s.rjust(3)}. #{gym.name.ljust(width/2)}  #{gym.city}, #{gym.state}"
    end

    options(__method__, gyms)
  end

  def show_gym(gym)
    puts "Name: #{gym.name}"
    puts "Address: #{gym.full_address}"
    puts "Director: #{gym.director}"
    puts "Coach: #{gym.coach}"
    puts "Phone: #{gym.phone}"

    options(__method__, gym)
  end

  def open_in_google_maps(gym)
    if gym.full_address
      system("open", "http://maps.google.com/?q=#{gym.full_address}")
    else
      puts "Sorry, that gym doesn't have an address listed.\n\n\n\n"
      show_gym(gym)
    end
  end

  def open_in_browser(gym)
    if gym.website == "none"
      puts "Sorry, that gym doesn't have a website. :(\n\n\n"
    elsif !gym.website.include?("http")
      system("open", "http://#{gym.website}")
    else
      system("open", "#{gym.website}")
    end
  end

  def process_main
    input = nil

    while input != "exit"
      input = gets.strip.downcase

      case input
        when "1"
          puts "Which state?"
          state = gets.chomp.upcase
          show_gyms(ClosestWeightliftingGem::Gym.find_by_state(state))
        when "2"
          puts "What do you want to search for?"
          search_term = gets.chomp.upcase
          show_gyms(ClosestWeightliftingGem::Gym.find_by_name(search_term))
        when "3"
          good_bye
        when "exit"
          good_bye
        else
          puts "I didn't understand that, please try again."
      end
    end
  end

  def process_gyms(gyms)
    input = nil

    until input == "exit"
      input = gets.strip.downcase

      case input
        when "1"
          puts "Select a gym by the number:"
          gym_num = gets.chomp.to_i - 1

          show_gym(gyms[gym_num])
        when "2"
          show_gyms(gyms)
        when "3"
          main_menu
        when "4"
          good_bye
        when "exit"
          good_bye
        else
          puts "I didn't understand that, please try again."
      end
    end
  end

  def process_gym(gym)
    input = nil

    until input == "exit"
      input = gets.strip.downcase

      case input
        when "1"
          open_in_google_maps(gym)
          process_gym(gym)
        when "2"
          show_gyms(ClosestWeightliftingGem::Gym.find_by_last_search)
        when "3"
          main_menu
        when "4"
         good_bye
        when "exit"
          good_bye
        else
          puts "I didn't understand that, please try again."
      end
    end

  end

  def line
    "="*80
  end

  def good_bye
    puts "Adios friend.  Hope you come back to lift weights again!"

    exit
  end
end

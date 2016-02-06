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
    ClosestWeightliftingGem::Scraper.new.call
  end

  def address_input
    puts <<-DOC
      Please enter your address below and I'll find"
      puts "the closest weightlifting gym. (ex. 123 Main St. New York, NY)
    DOC
    address = gets.chomp
  end

  def menu
    puts <<-DOC
      Please enter your address below and I'll find"
      puts "the closest weightlifting gym. (ex. 123 Main St. New York, NY)
    DOC

    process_option
  end

  def process_option
    case 0
    case 1
    case 2
  end
end
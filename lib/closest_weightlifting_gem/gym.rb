class ClosestWeightliftingGem::Gym
  attr_accessor :name, :full_address, :street, :city, :state, :zipcode, :phone, :director, :coach, :website

  @@all = []

  def initialize(gym_attributes)
    gym_attributes.each { |k,v| self.send(("#{k}="), v)}

    @street = full_address.split(",")[0].split(" ")[0..-2].join(" ")
    @city = full_address.split(",")[0].split(" ").last
    @state = full_address.split(/\W/)[-3].upcase
    @zipcode = full_address.split(/\W/).last

    @@all << self
  end

  def self.all
    @@all
  end

  def self.reset!
    @@all.clear
  end

  def self.find_by_state(state)
    self.all.find_all { |gym| gym.state == state.upcase }
  end
end

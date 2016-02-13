class ClosestWeightliftingGem::Gym
  attr_accessor :name, :full_address, :city, :state, :zipcode, :phone, :director, :coach, :website

  @@all = []

  def initialize(gym_attributes)
    gym_attributes.each { |k,v| self.send(("#{k}="), v)}

    @@all << self
  end

  def self.all
    @@all
  end

  def self.reset!
    @@all.clear
  end
end

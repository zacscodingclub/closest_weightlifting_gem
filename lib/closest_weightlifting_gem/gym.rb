require 'pry'

class ClosestWeightliftingGem::Gym
  attr_accessor :name,
                :full_address,
                :street,
                :city,
                :state,
                :zipcode,
                :phone,
                :director,
                :website

  @@all = []
  @@searches = []

  def initialize(gym_attributes)
    gym_attributes.each { |k,v| self.send(("#{k}="), v)}

    @@all << self
  end

  def add_attributes(gym_attributes)
    gym_attributes.each { |k,v| self.send(("#{k}="), v)}
  end

  def full_address
    if street.nil?
      nil
    else
      "#{street}, #{city}, #{state} #{zipcode}"
    end
  end

  def self.all
    @@all
  end

  def self.last_search
    @@searches.last
  end

  def self.searches
    @@searches
  end

  def self.reset!
    self.all.clear
  end

  def self.weird_gyms
    self.all.find_all do |g|
      g.phone.nil? || g.street.nil? || g.name.nil? || g.city.nil?
    end
  end

  def self.find_by_name(input)
    self.searches << { method: __method__, value: input }

    self.all.find_all { |gym| gym.name.upcase.include?(input.upcase) }
  end

  def self.find_by_state(state)
    self.searches << { method: __method__, value: state }

    self.all.find_all { |gym| gym.state == state.upcase }
  end

  def self.find_by_last_search
    last_search = @@searches.last
    self.send(last_search[:method], last_search[:value])
  end

  def self.count_by_state
    self.all.inject(Hash.new(0)) { |total, gym| total[gym.state] += 1 ; total }
  end
end

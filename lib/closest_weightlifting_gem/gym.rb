class ClosestWeightliftingGem::Gym
  attr_accessor :name,
                :full_address,
                :street,
                :city,
                :state,
                :zipcode,
                :phone,
                :director,
                :coach,
                :usaw_url,
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
    "#{street} #{city}, #{state} #{zipcode}"
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
      g.phone == nil || g.street == nil || g.name == nil 
    end
  end

  def self.find_by_name(input)
    self.searches << { method: __method__, value: input }

    select_few = self.all.select do |gym|
      gym.name.upcase.include?(input.upcase)
    end
  end

  def self.find_by_state(state)
    self.searches << { method: __method__, value: state }
    
    self.all.find_all { |gym| gym.state == state.upcase }
  end

  def self.count_by_state
    self.all.inject(Hash.new(0)) { |total, gym| total[gym.state] += 1 ; total }
  end
end
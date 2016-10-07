class ClosestWeightliftingGem::Scraper

  BASE_URL = "https://webpoint.usaweightlifting.org/wp15/Companies/"

  def self.scrape_main
    puts "Fetching index..."
    # !!HTTP Request!!
    # !!HTTP Request!!
    index = Nokogiri::HTML(open("#{BASE_URL}/Clubs.wp?frm=t"))

    get_state_abbreviations(index).each { |state| scrape_state_page(state) }

    puts "\n\nSorry that took so long."
  end

  def self.scrape_state_page(state)
    puts "Fetching gym data in #{state}..."
    # !!HTTP Request!!
    # !!HTTP Request!!
    state_doc = Nokogiri::HTML(open("#{BASE_URL}/Clubs.wp?frm=t&CompanyState=#{state}"))

    # I want it to scrape each state page
    # I want it to insantiate and save gym objects for each gym on the page
    # This will just be basic info and I can set other data in the gym class

    state_doc.search("li").each do |gym_row|
      # binding.pry
      # if gym_row.search(".right+ .left").text.split(" ").size < 5
      #   scrape_gym_page(gym_row)
      # else
        ClosestWeightliftingGem::Gym.new({
             :name => gym_row.search("h3").text,
           :street => gym_row.search("p").children[0].to_s,
             :city => gym_row.search("p").children[2].to_s.split(/\W+/)[0],
            :state => state,
          :zipcode => gym_row.search("p").children[2].to_s.split(/\W+/)[-1],
            :phone => gym_row.search("p").children[4].to_s,
          :website => gym_row.search("a")[0].attr('href'),
         :director => gym_row.search("p").children[10].to_s
        })
      # end
    end
  end

  def self.scrape_gym_page(gym_row)
    gym_doc = Nokogiri::HTML(open("#{BASE_URL + gym_row.search("a").first.attr("onclick").match(/\/V.+true/)[0]}"))

    ClosestWeightliftingGem::Gym.new({
      :name => gym_doc.search("h3").text,
      :street => gym_doc.search("p").children[0].to_s,
      :city => gym_row.search("p").children[2].to_s.split(/\W+/)[0],
      :state => gym_row.search("p").children[2].to_s.split(/\W+/)[1],
      :zipcode => gym_row.search("p").children[2].to_s.split(/\W+/)[-1],
      :phone => gym_row.search("p").children[4].to_s,
      :director => gym_doc.search(".fe_big_row:nth-child(2) td+ td").text,
      :coach => gym_doc.search(".fe_big_row+ .fe_big_row td+ td").text,
      :website => gym_doc.text.split("site:")[1].split("\r").first[1..-1],
      :usaw_url => gym_row.search("a").first.attr("onclick").match(/\/V.+true/)[0]
    })

  end

  def self.scrape_attributes(gym)
    gym_doc = Nokogiri::HTML(open("#{BASE_URL + gym.usaw_url}"))

    gym.add_attributes({
      :phone => gym_doc.search(".fe_big_row:nth-child(4) td").children.last.to_s[1..-1],
      :director => gym_doc.search(".fe_big_row:nth-child(2) td+ td").text,
      :coach => gym_doc.search(".fe_big_row+ .fe_big_row td+ td").text,
      :website => gym_doc.text.split("site:")[1].split("\r").first[1..-1]
    })
  end

  def self.get_state_abbreviations(index)
    index.search("select").children.collect { |child| child.attr("value") }[2..-1]
  end

end

class ClosestWeightliftingGem::Scraper
  BASE_URL = "https://webpoint.usaweightlifting.org/wp15/Companies"

  def self.scrape_main
    puts "Fetching index..."
    index = Nokogiri::HTML(open("#{BASE_URL}/Clubs.wp?frm=t"))

    get_state_abbreviations(index).each { |state| scrape_state_page(state) }
  end

  def self.scrape_state_page(state)
    puts "Fetching gym data in #{state}..."
    state_doc = Nokogiri::HTML(open("#{BASE_URL}/Clubs.wp?frm=t&CompanyState=#{state}"))

    gym_urls = state_doc.search(".datarow").collect do |g|
      g.search("a").first.attr("onclick").match(/\/V.+true/)
    end

    scrape_gym_page(gym_urls)
  end

  def self.scrape_gym_page(gym_urls)
    gym_urls.each do |gym_url|
      gym_doc = Nokogiri::HTML(open("#{BASE_URL + gym_url.to_s}"))
      
      ClosestWeightliftingGem::Gym.new({
                 :name => gym_doc.search(".pagetitlerow td").text.split(/[\r]+/)[0],
         :full_address => gym_doc.search(".fe_vbig_row+.fe_big_row td").to_s.split(/<.{2}>/).join(" ")[1..-6],
                :phone => gym_doc.search(".fe_big_row:nth-child(4) td").children.last.to_s[1..-1],
             :director => gym_doc.search(".fe_big_row:nth-child(2) td+ td").text,
                :coach => gym_doc.search(".fe_big_row+ .fe_big_row td+ td").text,
              :website => gym_doc.search(".fe_big_row~ .fe_big_row b").text.split("e:").last[1..-1]
      })
    end
  end

  def self.get_state_abbreviations(index)
    index.search("select").children.collect { |child| child.attr("value") }[2..-1]
  end
end
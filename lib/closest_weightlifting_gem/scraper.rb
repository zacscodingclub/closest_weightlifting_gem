require 'pry'

class ClosestWeightliftingGem::Scraper

  BASE_URL = "https://webpoint.usaweightlifting.org/wp15/Companies/"

  def self.get_state_abbreviations(index)
    index.search("select").children.collect { |child| child.attr("value") }[2..-1]
  end

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

<<<<<<< HEAD
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
=======
    # binding.pry

    state_doc.search("li").each do |gym_row|
      # Count the gym rows, then process them according to size
      size = gym_row.search("p").children.size

      # count[size] +=1

      case size
        when 1
          scrape_from_one(gym_row)
        when 5
          scrape_from_five(gym_row)
        when 7
          scrape_from_seven(gym_row)
        when 9
          scrape_from_nine_or_eleven(gym_row)
        when 11
          scrape_from_nine_or_eleven(gym_row)
        when 13
          scrape_from_thirteen(gym_row)
        else
          puts "Please NOOOOOO!!!"
          return
      end
    end
  end

  def self.scrape_from_one(gym_row)
    ClosestWeightliftingGem::Gym.new({
      :name => gym_row.search("h3").text.strip,
      :phone => gym_row.search("p").first.text
>>>>>>> 38644a21ce53bc788a4d5601d566b41987113b26
    })
  end

  def self.scrape_from_five(gym_row)
    is_region = gym_row.search("h3").text.include?("5")

    if is_region
      scrape_from_seven(gym_row)
    else
      ClosestWeightliftingGem::Gym.new({
          :name => gym_row.search("h3").text.strip,
        :street => gym_row.search("p").children.first.text,
          :city => gym_row.search("p").children[2].text.split(",").first,
         :state => gym_row.search("p").children[2].text.split(/[\,\d]/).last[1..2],
       :zipcode => gym_row.search("p").children[2].text.split(",")[1][-5..-1],
         :phone => gym_row.search("p").children[4].text
      })
    end
  end

  def self.scrape_from_seven(gym_row)
    ClosestWeightliftingGem::Gym.new({
         :name => gym_row.search("h3").text.strip,
        :phone => gym_row.search("p").children.first.text,
     :director => gym_row.search("p").children[4].text
    })
  end

  def self.scrape_from_nine_or_eleven(gym_row)
    two_level_address = gym_row.search("p").children[2].text.include?(",")
    is_jugg = gym_row.search("h3").text.downcase.include?("jugg")
    is_shady = gym_row.search("h3").text.downcase.include?("shadyside barbell")

    if two_level_address
      ClosestWeightliftingGem::Gym.new({
           :name => gym_row.search("h3").text.split("\t").last,
         :street => gym_row.search("p").children.first.text,
           :city => gym_row.search("p").children[2].text.split(",").first,
          :state => gym_row.search("p").children[2].text.split(/[\,\d]/).last[1..2],
        :zipcode => gym_row.search("p").children[2].text.split(",")[1][-5..-1],
          :phone => gym_row.search("p").children[4].text,
       :director => gym_row.search("p").children[8].text
      })
    elsif is_jugg || is_shady
      ClosestWeightliftingGem::Gym.new({
          :name => gym_row.search("h3").text.strip,
        :street => gym_row.search("p").children.first.text.split(",").first.titleize,
         :state => gym_row.search("p").children.first.text.split(/[\,\d]/).last[1..2],
       :zipcode => gym_row.search("p").children.first.text[-5..-1],
         :phone => gym_row.search("p").children[2].text,
      :director => gym_row.search("p").children[6].text
        })
    else
      scrape_from_thirteen(gym_row)
    end
  end

<<<<<<< HEAD
=======
  def self.scrape_from_thirteen(gym_row)
    street_address = gym_row.search("p").children.first.text
    suite = gym_row.search("p").children[2].text

    ClosestWeightliftingGem::Gym.new({
        :name => gym_row.search("h3").text.split("\t").last,
      :street => "#{street_address}  #{suite}",
        :city => gym_row.search("p").children[4].text.split(",").first,
       :state => gym_row.search("p").children[4].text.split(/[\,\d]/).last[1..2],
     :zipcode => gym_row.search("p").children[4].text.split(",")[1][-5..-1],
       :phone => gym_row.search("p").children[6].text,
    :director => gym_row.search("p").children[10].text
    })
  end

#
#
#
# Legacy code from previous version of website
      #
      # if gym_row.search(".right+ .left").text.split(" ").size < 5
      #   scrape_gym_page(gym_row)
      # else
      #   ClosestWeightliftingGem::Gym.new({
      #        :name => gym_row.search("a").first.children.text.titleize,
      #      :street => gym_row.children[5].children[0].text,
      #        :city => gym_row.children[5].children[2].text.split(",").first,
      #       :state => state,
      #     :zipcode => gym_row.children[5].children[2].text.split(/\W+/).last,
      #       :phone => gym_row.children[5].children[4].text,
      #    :usaw_url => gym_row.search("a").first.attr("onclick").match(/\/V.+true/)[0]
      #   })
      # end

  # def self.scrape_gym_page(gym_row)
  #   gym_doc = Nokogiri::HTML(open("#{BASE_URL + gym_row.search("a").first.attr("onclick").match(/\/V.+true/)[0]}"))
  #
  #   ClosestWeightliftingGem::Gym.new({
  #     :name => gym_doc.search(".fe_vbig_row td").text.titleize,
  #     :street => gym_doc.search(".fe_vbig_row+ .fe_big_row td").children.to_s.split("<br>")[0],
  #     :city => gym_doc.search(".fe_vbig_row+ .fe_big_row td").children.to_s.split("<br>")[1].split(",")[0],
  #     :state => gym_doc.search(".fe_vbig_row+ .fe_big_row td").children.to_s.split(",").last.split(/\W+/)[1],
  #     :zipcode => gym_doc.search(".fe_vbig_row+ .fe_big_row td").children.to_s.split(/\W/).last,
  #     :phone => gym_doc.search(".fe_big_row:nth-child(4) td").children.last.to_s[1..-1],
  #     :director => gym_doc.search(".fe_big_row:nth-child(2) td+ td").text,
  #     :coach => gym_doc.search(".fe_big_row+ .fe_big_row td+ td").text
  #     #:website => gym_doc.text.split("site:")[1].split("\r").first[1..-1],
  #     #:usaw_url => gym_row.search("a").first.attr("onclick").match(/\/V.+true/)[0]
  #   })
  # end
  #
  # def self.scrape_attributes(gym)
  #   gym_doc = Nokogiri::HTML(open("#{BASE_URL + gym.usaw_url}"))
  #
  #   gym.add_attributes({
  #     :phone => gym_doc.search(".fe_big_row:nth-child(4) td").children.last.to_s[1..-1],
  #     :director => gym_doc.search(".fe_big_row:nth-child(2) td+ td").text,
  #     :coach => gym_doc.search(".fe_big_row+ .fe_big_row td+ td").text,
  #     :website => gym_doc.text.split("site:")[1].split("\r").first[1..-1]
  #   })
  # end
>>>>>>> 38644a21ce53bc788a4d5601d566b41987113b26
end

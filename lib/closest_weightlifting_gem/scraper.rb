require 'pry'
require 'net/http'
require 'json'
require 'uri'

class ClosestWeightliftingGem::Scraper
  BASE_URL = "https://webpoint.usaweightlifting.org/wp15/Companies/"

  def self.get_state_abbreviations(index)
    index.search("select#CompanyState").children[2..-1].collect { |child| child.attr("value") }
  end

  def self.scrape_main
    puts "Fetching index..."
    index = Nokogiri::HTML(open("#{BASE_URL}/Clubs.wp?frm=t&RF=Zp%2CST"))

    get_state_abbreviations(index).each { |state| scrape_state_page(state) }

    puts "\n\nSorry that took so long."
  end

  # Form Data
  # do I need cookies, etc now?
  def self.scrape_state_page(state)
    puts "Fetching gym data in #{state}..."
    data = {
      'wp_ClientOrgID' => '',
      'CompanyParentID' => '',
      'CompanyName' => '',
      'CompanyState' => state,
      'geo_Zip' => '',
      'geo_Miles' => 25,
      'submit' => 'Go'
    }

    url = URI("#{BASE_URL}/Clubs.wp?frm=t&RF=Zp%2CST")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/x-www-form-urlencoded'
    request["cache-control"] = 'no-cache'
    request.body = "wp_ClientOrgID=&CompanyParentID=&CompanyName=&CompanyState=#{state}&geo_Zip=&geo_Miles=25&submit=Go"
    response = http.request(request)
    state_doc = Nokogiri::HTML(response.read_body)

    state_doc.search("#wp_Clubs li").each do |gym_row|
      details = extract_details(gym_row.search("p")[0])

      ClosestWeightliftingGem::Gym.new({
           :name => gym_row.search("h3").text.strip,
         :street => details[:street], #gym_row.search("p").children[0].to_s,
           :city => details[:city], #gym_row.search("p").children[2].to_s.split(/\W+/)[0],
          :state => state,
        :zipcode => details[:zipcode], #gym_row.search("p").children[2].to_s.split(/\W+/)[-1],
          :phone => details[:phone], #gym_row.search("p").children[4].to_s,
        :website => details[:website],
       :director => details[:director]
      })
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

  def self.extract_details(info_div)
    details = {
      "street": "",
      "city": "",
      "state": "",
      "zipcode": "",
      "phone": "",
      "website": "",
      "director": ""
    }

    begin
      aa = info_div.children.select { |el| !["br", "b"].include?(el.name) }
      case aa.length
      when 1
        details[:phone] = aa[0].text
      when 3
        details[:phone] = aa[0].text
        details[:director] = aa[1].text
      when 4
        details[:phone] = aa[0].text
        details[:website] = aa[1].text
        details[:director] = aa[2].text
      else
        if aa[1].text.include?(", ")
          city, state_zip = aa[1].text.split(", ")
        else
          city, state_zip = aa[2].text.split(", ")
        end

        state, empty, zip = state_zip.split(/[[:space:]]/)
        details[:street] = aa[0].text
        details[:city] = city
        details[:state] = state
        details[:zipcode] = zip
        details[:phone] = aa[2].text
        details[:website] = aa[3]["href"]
        details[:director] = aa[4].text
      end
    rescue StandardError => e
      puts "[ERROR] extracting details from: #{aa}"
      puts "[ERROR] #{e}"
    end

    details.each { |k, v| details[k] = "" if v.nil? }
    details
  end
end

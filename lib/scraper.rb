require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  
  # :name doc.css(".student-card").last.css("h4").text
  # :location doc.css(".student-card").last.css(".student-location").text
  # :profile-page doc.css(".student-card").first.css("a").first["href"]
  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |student|
      students << {
      :name => student.css("h4").text,
      :location => student.css(".student-location").text,
      :profile_url => student.css("a").first["href"]
    }
    end
    students
  end

  # :twitter => doc.css(".social-icon-container").css("a").first["href"]
  # :linkedin =>
  # :github =>
  # :blog =>
  # :profile_quote => doc.css(".profile-quote").text
  # :bio =>
  def self.scrape_profile_page(profile_url)
    profile = {}
    doc = Nokogiri::HTML(open(profile_url))
    links = doc.css(".social-icon-container").css("a").map{ |item| item.attribute("href").value}
    # binding.pry
    links.each do |link|
      # binding.pry
      if link.include?("twitter") 
        profile[:twitter] = link
      elsif link.include?("linkedin") 
        profile[:linkedin] = link
      elsif link.include?("github") 
        profile[:github] = link
      else 
        profile[:blog] = link
      end
    end
    profile[:profile_quote] = doc.css(".profile-quote").text
    profile[:bio] = doc.css(".description-holder").css("p").text
    # binding.pry
    profile
  end

end


require 'watir-webdriver'

Given(/^I navigate to google$/) do
  @browser = Watir::Browser.new :ff
  @browser.goto "http://www.google.co.uk"
end

When(/^I enter wado into the search field$/) do
  searchField = @browser.text_field(:id, 'lst-ib')
  searchButton = @browser.button(:name, 'btnG')
  searchField.set 'Wado ryu'
  searchButton.click
end

Then(/^text ohtsuka should be present$/) do
  @browser.div(:id => 'rcnt').wait_until_present
  (@browser.text.include? 'Ohtsuka').should == true
  @browser.close
end
	

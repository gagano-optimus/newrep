Given(/^I am on auto-discovery page$/) do
  visit AutodiscoveryPage
end

Given(/^I enter filter name as "(.*?)", filter pattern as "(.*?)" and choose type as "(.*?)"$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

When(/^I add the filter$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^perform auto-discovery with control type as auto\-commit$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^"(.*?)" host should be shown on the status viewer\.$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^perform auto-discovery$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^error should be shown in the event during discovery stage of  auto-discovery$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I enter filter name "(.+?)", filter pattern "(.+?)" and choose type "(.+?)"$/) do |filName, range, filType|
  on AutodiscoveryPage do |page|
        page.add_filter(filName,range,filType)
  end
end

When(/^I add filter$/) do
  filter_click = @browser.frame(:id => "myframe").button(:name => "add_filter")
       if filter_click.exists?
            filter_click.when_present.click 
       end  
end


Then(/^the filter "(.+?)" should be added in the list of added filters$/) do |filName|
  filter = @browser.frame(:id => "myframe").button(:name => "delete_filter_#{filName}")
           filter.exists?.should == true
end

Given(/^I delete a filter of name "(.+?)"$/) do |filName|
  
  on AutodiscoveryPage do |page|
        page.delete_filter(filName)
sleep(10)
  end
end

When(/^I click 'Yes' on the subsequent page asking for confirming the deletion$/) do
  on AutodiscoveryPage do |page|
        page.delete_confirm_filter
  end
end

Then(/^the filter "(.+?)" should be removed from the list of added filters$/) do |fil|
  on AutodiscoveryPage do |page|
        page.delete_confirm(fil)
  end
end


Given /^I create a duplicate range-filter with name "(.+?)", type "(.+?)" and range "(.+?)"$/ do |filterName, type, range|
  on AutodiscoveryPage do |page|
    page.add_filter(filterName,range,type) 
  end
end

When /^I try to add the Range\/Filter$/ do
    
       filter_click = @browser.frame(:id => "myframe").button(:name => "add_filter")
       if filter_click.exists?
            filter_click.when_present.click 
       end 
    
end

Then /^I should see the duplicate message error for "(.+?)"$/ do |filterName|
    @browser.frame(:id => "myframe").td(:class => "row1").text.include?("A filter named \""+ filterName + "\" already exists").should == true
	
end

Given(/^I create a discovery definition "(.+?)" and create "(.+?)" filter of type "(.+?)" and range "(.+?)"$/) do | defName, filName, type, range |
   on AutodiscoveryPage do |page|
        page.add_filter(filName,range,type)

       filter_click = @browser.frame(:id => "myframe").button(:name => "add_filter")
       if filter_click.exists?
            filter_click.when_present.click 
       end 
        
       page.add_schema(defName)

    end
end

When /^I Uncheck definition methods$/ do
    on AutodiscoveryPage do |page|
        page.uncheck_NmapTCP
        page.uncheck_SNMP
        
    end
end

When /^save the definition$/ do
    @browser.frame(:id => "myframe").button(:name => "save_group").when_present.click
end

When /^I launch go$/ do
    @browser.frame(:id => "myframe").button(:name => "go").when_present.click
end

Then /^I should see no method assign message error for "(.+?)"$/ do |name|
puts @browser.frame(:id => "myframe").td(:class => "row1").text
    @browser.frame(:id => "myframe").td(:class => "row1").text.include?("There are no methods assigned to #{name}. You must assign at least one discovery method").should == true
    
end

When(/^I add a new discovery definition "(.+?)" filling all the required details$/) do |defName|
  on AutodiscoveryPage do |page|
     page.add_schema(defName)
     @browser.frame(:id => "myframe").checkbox(:value => "Nmap TCP").when_present.set
     @browser.frame(:id => "myframe").checkbox(:value => "SNMP").when_present.set
     @browser.frame(:id => "myframe").button(:name => "save_group").when_present.click
  end
end

Then(/^the added discovery definition "(.+?)" should be shown in the list of discovery definitions$/) do |defName|
  @browser.frame(:id => "myframe").td(:class => "row1").td(:text => defName).exists?.should == true
end

Given(/^I add a new discovery definition$/) do
  @browser.frame(:id => "myframe").button(:name => "new_group").when_present.click
end

When(/^I click 'create' leaving discovery name and import schema blank$/) do
  on AutodiscoveryPage do |page|
    page.discovery_definition_name = "new_sch"
    page.discovery_definition_description= "new_sch"
    @browser.frame(:id => "myframe").button(:name => "create_group").when_present.click
  end
end

Then(/^discovery name and import schema required error message should be shown$/) do
  @browser.frame(:id => "myframe").td(:class => "row1").text.include?("A discovery name and one of import schema or template is required.").should == true
end

Given(/^I add a filter with type 'include' with range '(\d+)\.(\d+)\.(\d+)\.(\d+)\-(\d+)'$/) do |arg1, arg2, arg3, arg4, arg5|
  pending # express the regexp above with the code you wish you had
end

Given(/^I add a filter with type 'exclude' with range '(\d+)\.(\d+)\.(\d+)\.(\d+)'$/) do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

When(/^I perform auto-discovery with control type 'auto\-commit'$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^hosts '(\d+)\.(\d+)\.(\d+)\.(\d+)' and '(\d+)\.(\d+)\.(\d+)\.(\d+)' should be shown in status viewer but not '(\d+)\.(\d+)\.(\d+)\.(\d+)'\.$/) do |arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12|
  pending # express the regexp above with the code you wish you had
end

Given(/^I uncheck all the filters$/) do
  @browser.frame(:id => "myframe").checkbox(:name => "set_filter").when_present.clear
end

When(/^I perform auto discovery$/) do
  @browser.frame(:id => "myframe").button(:name => "go").when_present.click
end

Then(/^no ranges assigned error message is shown$/) do
  @browser.frame(:id => "myframe").td(:class => "row1").text.include?("There are no ranges assigned to GroundWork-Discovery-Pro or any of its methods. You must assign or select at least one range to discover.").should == true
end

Given(/^control type of discovery definition is 'interactive'$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I add a filter with range '(\d+)\.(\d+)\.(\d+)\.(\d+)'$/) do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

When(/^I process the records after the discovery$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I commit the results$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^the host should be shown in status viewer$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^control type of discovery definition is 'auto'$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^control type of discovery definition is 'auto commit'$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I edit the discovery definition$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I check 'Nmap TCP', uncheck 'SNMP' and then save\.$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^results shown should be of Nmap only$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I check 'SNMP', uncheck 'Nmap TCP' and then save\.$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^results shown should be of SNMP only$/) do
  pending # express the regexp above with the code you wish you had
end


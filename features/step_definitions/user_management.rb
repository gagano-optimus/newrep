#!/usr/bin/env ruby
# encoding: utf-8
require 'net/http'

Given /^I am on the Administration page$/ do
  visit AdministrationViewPage
end

Given /^I am on the New Staff page under Group$/ do
    on AdministrationViewPage do |page|
		sleep(5)
		page.group_element.fire_event 'mouseover'
        sleep(2)
		page.organization_element.fire_event 'mouseover'
		sleep(2)
		page.new_staff_element.when_present.click
    end
end

Given /^I create a new user account with username "(.*?)" and password "(.*?)" and firstname "(.*?)" and lastname "(.*?)" and email "(.*?)"$/ do |name, password, firstname, lastname, email|
    on AdministrationViewPage do |page|
        page.create_new_user(name, password, firstname, lastname, email)
			on PreferencePage do |page|
				page.ok
				sleep(5)
			end
	end
	
end

Given /^I login with "(.*?)" and "(.*?)"$/ do |name, password|
    on DashboardPage do |page|
        page.logout
    end
    on LoginPage do |page|
        page.login_user(name, password)
    end
    
end

Then /^I should see the dashboard page$/ do
    on DashboardPage do |page|
        page.show_install_info_element.when_present.click
        page.logout
    end
    on LoginPage do |page|
        page.login_user("admin","admin")
    end
end

Given /^I navigate to Site Editor to edit the current dashboard page$/ do
	on AdministrationViewPage do |page|
		sleep(3)
		page.site_editor_element.fire_event 'mouseover'
		sleep(2)
		page.edit_page_element.when_present.click
	end
end

When /^I add a portlet$/ do
	on AdministrationViewPage do |page|
		page.gw_portlets_element.when_present.click
		sleep(2)
		#@browser.div(:title => "Event Console").simulateDragSortable({ move: 10, -10 });
		#@browser.div(:title => "Event Console").drag_and_drop_by(100, -200)
		
		@browser.div(:title => "Custom Groups").fire_event "onmousedown"
		sleep(2)
		@browser.driver.action.click_and_hold(page.customgroup_element.wd).perform
		sleep(2)
		@browser.driver.action.move_to(page.droppable_area_element.wd).click.perform
		sleep(2)
		@browser.div(:title => "Custom Groups" ).fire_event "onmouseup"
		
		#a = @browser.div(:title => "Event Console")
		#b = @browser.div(:class => "UIRowContainer")
		#a.drag_and_drop_on b
		#sleep(2)

		#@browser.driver.action.drag_and_drop(a, b).perform
		
	end	
end

And /^I edit the portlet configuration$/ do
sleep(10)
	3.times do
		@browser.div(:id => /UIPortlet/).fire_event 'mouseover'
	end
	sleep(2)
	on AdministrationViewPage do |page|
		page.edit_portlet_element.when_present.click
	end
	@browser.text_field(:id => 'title').when_present.set 'Custom Group'
	@browser.checkbox(:name => 'showInfoBar').when_present.set
	@browser.link(:text => 'Save And Close').when_present.click
	
	sleep(10)
end

And /^I add another portlet and edit its configuration$/ do
	on AdministrationViewPage do |page|
		page.gw_portlets_element.when_present.click
		sleep(2)		
		@browser.div(:title => "Event Portlet").fire_event "onmousedown"
		sleep(2)
		@browser.driver.action.click_and_hold(page.event_portlet_element.wd).perform
		sleep(2)
		@browser.driver.action.move_to(page.droppable_area_element.wd).click.perform
		sleep(2)
		@browser.div(:title => "Event Portlet" ).fire_event "onmouseup"

	3.times do
		@browser.div(:id => /UIPortlet/, :index => 1).fire_event 'mouseover'
	end
	sleep(2)
		#page.edit_portlet_element.when_present.click
		@browser.link(:title => /Edit Portlet/, :index => 1).when_present.click
		@browser.radio(:id => 'radioEntireNetwork_ELP').when_present.set
		@browser.text_field(:name => 'customPortletTitle').when_present.set 'All Events'
		@browser.button(:value => 'Save Preferences').when_present.click
		@browser.link(:text => 'Close').when_present.click
		#page.finish_element.when_present(30).click
		page.gw_portlets_element.when_present.click
		sleep(5)
		@browser.link(:class => /EdittedSaveButton/).when_present.click
		sleep(10)
	end
end
	
Then /^I should see the added portlets$/ do
	@browser.button(:value => 'Select All').when_present.click
	sleep(10)
	@browser.button(:value => 'Deselect All').when_present.click
	sleep(5)
	@browser.div(:class => 'customgroupframe').span(:text => /No CustomGroups Available!/).exists?.should == true
	@browser.div(:class => 'customgroupframe').button(:value => 'Create New CustomGroup').when_present.click
	sleep(5)
	#on CustomGroupPage do |page|
	#    page.form_button_element.when_present.click
	#	sleep(5)
	#end
	visit DashboardPage
end

When /^I delete the added portlets$/ do
	on AdministrationViewPage do |page|
	#@browser.div(:class)div(:class => /UIComponentBlock/).div(:class => /EDITION-BLOCK EDITION-PORTLET/ ).div(:class => /NewLayer/).when_present.hover
		2.times do
			page.gw_portlets_element.when_present.click
			sleep(2)
			@browser.div(:id => /UIPortlet/).fire_event 'mouseover'
			@browser.div(:id => /UIPortlet/).fire_event 'mouseover'
			@browser.div(:id => /UIPortlet/).fire_event 'mouseover'
			#@browser.div(:id => /UIPortlet/).when_present.click
			sleep(2)
			page.delete_portlet_element.when_present.click
			sleep(3)
			@browser.alert.ok
			sleep(3)			
			#page.finish_element.when_present(30).click
			sleep(5)
		end
		@browser.link(:class => /EdittedSaveButton/).when_present.click
	end
end

Then /^I should not see the portlets$/ do
	@browser.div(:class => 'customgroupframe').span(:text => /No CustomGroups Available!/).exists?.should == false
	@browser.button(:value => 'Select All').exists?.should == false
	sleep(5)
	
end


Given /^I navigate to Site Editor to add a new page$/ do
	on AdministrationViewPage do |page|
		sleep(5)
		page.site_editor_element.when_present.hover
		sleep(4)
		page.add_page_element.when_present.click
	end
end

Given /^I go to User Management under Groups$/ do
    on AdministrationViewPage do |page|
	 sleep(5)
     page.group_element.fire_event 'mouseover'
	 sleep(2)
	 page.organization_element.fire_event 'mouseover'
     sleep(2)
	 page.user_management_element.when_present.click
    end
end


Given /^I select Search users$/ do
    on AdministrationViewPage do |page|
		page.search_textbox_element.when_present.set 'optimus'
        #page.search_icon_element.when_present.click
		@browser.send_keys :enter
		sleep(3)
    end
end


When /^I delete the user with name "(.*?)"$/ do |name|
    #on AdministrationViewPage do |page|
     #   page.delete_new_user_element.when_present.click
	@browser.image(:class => /DeleteUserIcon/).when_present.click
	@browser.alert.ok
    end

Then /^the user should be deleted$/ do
 on AdministrationViewPage do |page|
 
    page.search_textbox_element.when_present.set 'optimus'
    #page.search_icon_element.when_present.click
	@browser.send_keys :enter
    page.no_results_message_element.when_present.exists?.should == true
		on PreferencePage do |page|
			page.ok
			sleep(5)
		end
end
end
	

#OptimusComment: Added to display build version in results

Given /^Build and version$/ do
on DashboardPage do |page|
        page.show_install_info_element.when_present.click
		info_text = @browser.span(:id => "last_checked").p(:text => /PostgreSQL/).text.split("\n")
        name = info_text.grep(/^name/)[0].split("= ")[1]
        version = info_text.grep(/^version/)[0].split("= ")[1]
		gw_build = info_text.grep(/^gw_build/)[0].split("= ")[1]
		bitrock_build = info_text.grep(/^bitrock_build/)[0].split("= ")[1]
		puts "Name:" + name + " ---- Version:" + version + " ---- GW_build:" + gw_build + " ---- bitrock_build:" + bitrock_build
    end
end

#Added on 18 Feb 2015

Given /^I am on the User Management page$/ do
    on AdministrationViewPage do |page|
	 sleep(5)
     page.group_element.fire_event 'mouseover'
	 sleep(2)
	 page.organization_element.fire_event 'mouseover'
     sleep(2)
	 page.user_management_element.when_present.click
	sleep(5)
    end
end

And /^I navigate to membership management$/ do
	on UserManagementPage do |page|
		page.membership_management_element.click
		sleep(5)
	end
end


And /^I navigate to group management$/ do
	on UserManagementPage do |page|
		page.group_management_element.when_present.click
		sleep(5)
	end
end


And /^I logout and login with "(.+)"$/ do |user|
	on DashboardPage do |page|
        	page.logout
    	end
    	on LoginPage do |page|
        	page.login_user(user,user)
   	end
end




And /^I "(.*?)" portal user "(.*?)" to access modules "(.*?)" and "(.*?)"$/ do |permission,user,module1,module2|
	on UserManagementPage do |page|
		page.access_restriction(user,permission,module1,module2)
	end
end


Then /^accessing "(.+)" and "(.+)" should display access error$/ do |module1,module2|
		
	on UserManagementPage do |page|
		page.access_error(module1)
		page.access_error(module2)
	end
end

Then /^"(.+)" and "(.+)" should be accessible and should not display any errors$/ do |module1,module2|
	on UserManagementPage do |page|
		page.access_granted(module1)
		page.access_granted(module2)
	end
end

And /^I "(.+)" user - "(.+)" in group - "(.+)"$/ do |add,user,group|
			
	on UserManagementPage do |page|
		page.add_group(add,user,group)
	end
end

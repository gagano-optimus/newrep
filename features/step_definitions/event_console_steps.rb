When /^I apply the filter "(.+)" under Applications$/ do |apptype|
    on EventconsolePage do |page|
        @browser.div(:class => "iceTreeRow", :index => 1).link(:index => 0).when_present.click
		sleep(10)
		@browser.link(:text => "#{apptype}").when_present.click
		sleep(5)
        page.wait_until(20) do
            page.events_application_types_element.when_present.text == "Events by ApplicationTypes="+apptype 
        end
    end
end

When /^I apply the filter "(.+)"$/ do |filter|
    on EventconsolePage do |page|
        #page.criticals_element.when_present.click
		@browser.link(:text => "#{filter}").when_present.click
        page.wait_until(20) do
			if filter == "All Events"
			page.events_application_types_element.when_dom_changed.text == "All Events"
			else
           	 	page.events_application_types_element.when_dom_changed.text == "Events by=" + filter
			end
        end
    end
end

When /^I select (\d+) event$/ do |arg1|
    on EventconsolePage do |page|
        page.number_showing_events_element.when_present.text.to_i.should >= 1
        #cell = @browser.tr(:class => "iceDatTblRow  portlet-section-body Row textRow odd iceRowSel")
        cell = @browser.tr(:id => /contentPanel:icepnltabset:0:eventTableID:0/)
        span_message = cell.span(:id => /txt_textMessage/)
        $message = span_message.text
        $message = $message[0...-5]
        span_message.when_present.click
	sleep(4)

    end
end



When /^I perform the action open log message$/ do
    on EventconsolePage do |page|
	sleep(3)
	page.open_log_message_element.when_present.click
	 @browser.text_field(:name => /popupform:j_id208/).when_present.set "Comment"
        @browser.button(:name => /popupform:closeInputModal/).click
	sleep(5)
    end
end

When /^I navigate to operation status open filter$/ do
    on EventconsolePage do |page|
        puts "Message #{$message}"
        page.operation_status_events_open_element.when_present.click
        page.open_filter_element.when_present.click
        page.message_search = $message
        page.search_element.when_present.click
        sleep(10)
    end
end


When /^I perform the action close log message$/ do
    #visit EventconsolePage
    on EventconsolePage do |page|
	sleep(3)
        page.close_log_message_element.when_present.click
         @browser.text_field(:name => /popupform:j_id208/).when_present.set "Comment"
        @browser.button(:name => /popupform:closeInputModal/).click
	sleep(5)
    end
end


When /^I navigate to operation status close filter$/ do
    on EventconsolePage do |page|
	puts "Message #{$message}"
        page.operation_status_events_open_element.when_present.click
        page.close_filter_element.when_present.click
        page.message_search = $message
        page.search_element.when_present.click
        sleep(10)
    end
end

Then /^the events selected must be display$/ do
    on EventconsolePage do |page|
        page.number_showing_events_element.when_present.text.to_i.should >= 1
        $message_new = @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_textMessage/).text
        $message_new = $message_new[0...-5]
        $message_new.should == "#{$message}"
    end
end

Given /^I select all open events$/ do
    on EventconsolePage do |page|
        page.all_open_events_element.when_present.click
    end
end

Given /^I search for the events with the message "(.*?)"$/ do |message|
    on EventconsolePage do |page|
        sleep(5)
        page.message_search = message
    end
end

And /^I click the Search button$/ do
    on EventconsolePage do |page|
        page.search_link_element.when_dom_changed.click
        sleep(5)
    end
end

Then /^I should only see events with the message "(.+)"$/ do |message|
    on EventconsolePage do |page|
        page.check_events_message(message, 0)
    end
end

And /^I click on the new tab button$/ do
    on EventconsolePage do |page|
        page.new_tab_element.click
		sleep(5)
    end
end

Then /^I see the window for new tab$/ do
=begin
    on EventconsolePage do |page|
        page.wait_until do
            sleep(5)
            @browser.span(:class => "iceOutTxt", :text => "All Open Events", :index => 1).exists?
        end
    end
=end	

	@browser.span(:class => "iceOutTxt", :text => "All Events").when_dom_changed.exists?

end

And /^I search for the events with the message "(.*?)" on the new tab$/ do |message|
    on EventconsolePage do |page|
        page.message_search = message
    end
end


Then /^I should only see events with the message "(.+)" on the new tab$/ do |message|
    on EventconsolePage do |page|
        page.check_events_message(message, 1)
    end
end

Given /^I am on Services Configuration page$/ do
    visit ServiceConfigurationPage
end

Given /^I modify max check attempts and disable active checks in generic services$/ do
    on ServiceConfigurationPage do |page|
        page.open_generic_service
        page.set_max_check_attempts
    end
end

Given /^I am on Host Configuration page$/ do
    visit HostsConfigurationPage
end

Given /^I modify max check attempts and disable active checks in generic hosts$/ do
    on HostsConfigurationPage do |page|
        page.open_generic_host
		on ServiceConfigurationPage do |page|
			page.set_max_check_attempts
		end
    end
end

Given /^I revert max check attempts and disable active checks in generic hosts$/ do
    on HostsConfigurationPage do |page|
        page.open_generic_host
		on ServiceConfigurationPage do |page|
			page.reset_max_check_attempts
		end
    end
end


Given /^I select a host and a service$/ do
    on StatusviewerPage do |page|
        #page.services_link
        #page.open_servicegroup_element.when_present.click
        #$hostname = page.get_host(0)
        #page.hosts_link
        #page.select_host("HG1", $hostname, "Linux Servers")
        #sleep(1)
        @browser.span(:class => "iceOutTxt", :text => /Linux Servers/).when_dom_changed.click
	@browser.span(:class => "iceOutTxt", :text => /localhost/).when_dom_changed.click
	sleep(1)
        page.local_cpu_httpd_element.when_dom_changed.click
    end
end

Given /^I select submit passive Check Result with "(.*?)"$/ do |state|
    on StatusviewerPage do |page|
        sleep(5)
        page.submit_check_results_service(state)
		sleep(15)
    end
end

When /^I submit and navigate to Event Console$/ do
    on StatusviewerPage do |page|
        page.submit_button_service_element.when_dom_changed.click
    end
    sleep(15)
    visit EventconsolePage
end

Then /^I see an event gets displayed with status as "(.+)"$/ do |status|
    on EventconsolePage do |page|
        page.check_event_status($hostname, status)
    end
end


Given /^I select submit host passive Check Result with "(.*?)"$/ do |state|
    on StatusviewerPage do |page|
      sleep(10)
      page.submit_check_results_host(state)
          end
	  end



#@new TCs

#Verify updation of tab label 

And /^I enter a new tab name "(.+)"$/ do |tab_name|
    on EventconsolePage do |page|
       page.update_label = tab_name
	   page.update_button_element.click
    end
end

Then /^the tab name gets updated as "(.+)"$/ do |tab_name|
    on EventconsolePage do |page|
       #page.wait_until(20) do
            #page.events_application_types_element.when_present.text == "Test Tab"
			#@browser.span(:text => tab_name).exists?.should == true
		#end
		@browser.span(:text => tab_name).when_present(10).exists?.should == true
		
    end
end

And /^I revert the change to the tab made above$/ do
    on EventconsolePage do |page|
        page.all_events_element.when_present.click
    end
end

#verify running blank search

And /^I run a blank search$/ do
    on EventconsolePage do |page|
       page.search_element.when_dom_changed.click
	   sleep(2)
    end
end


Then /^an error message for running blank search is generated$/ do
    on EventconsolePage do |page|
	   page.error_message_element.when_dom_changed.exists?
	   page.error_ok_element.click
    end
end


#updation of tab label with an invalid name
Then /^I enter an invalid tab name$/ do
    on EventconsolePage do |page|
       page.update_label = '!@#$^&*()'
	   page.update_button_element.click
    end
end


Then /^an error message gets generated$/ do
    on EventconsolePage do |page|
       
	   #error message validation
	   
    end
end


Then /^the tab name does not get updated$/ do
    on EventconsolePage do |page|
       
	   #tab name validation
	   
    end
end

#verify acknowledging an Nagios event

And /^I select the Actions button$/ do
    on EventconsolePage do |page|
	   page.actions_element.click
    end
end


And /^I select the Nagios Acknowledge option and fill in the acknowledge comment as "(.+)"$/ do |comment|
    on EventconsolePage do |page|
	   #selecting the Nagios Acknowledge option
	   page.actions_element.click
	   page.nagios_ack_element.click
	   sleep(5)
	   #filling in the comment and submitting
	   #page.nagios_ack_comment_element = "Nagios Event Acknowledged by QA"
	   #@browser.div(:class => /icePnlPop/).td(:class => "icePnlGrdCol1 Col1 popupModalBodyCol1").textarea(:id => /iceInpTxtArea portlet-form-input-field popupText/).set "Nagios Event Acknowledged by QA"
	   #@browser.div(:class => /icePnlPop/).textarea(:id => /iceInpTxtArea portlet-form-input-field popupText/, :name => /:popupform:j_id/).set "Nagios Event Acknowledged by QA"
	   
	   #@browser.textarea(:id=> 'G005c7bb8_2d847a_2d4467_2d9dc5_2d4d3aebb5f4ad:popupform:j_id199').set "Nagios Event Acknowledged by QA"
	   #@browser.textarea(:name => /popupform:j_id199/).set "Nagios Event Acknowledged by QA"
	   #@browser.textarea(:name => /popupform:j_id199/, :class => /iceInpTxtArea portlet-form-input-field popupText/).set comment
	   @browser.textarea(:name => /popupform:j_id/, :class => /iceInpTxtArea portlet-form-input-field popupText/).set comment
	   page.nagios_ack_comment_button_element.click
	   sleep(5)
    end
end


Then /^I see acknowledgement comment "(.+)" gets updated in the comment column of event$/ do |comment|
	@browser.refresh
	sleep(6)
    @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_acknowledgeComment/).text == comment
	puts "Comment on Console: "+@browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_acknowledgeComment/).text
end


When /^I apply the filter All Events$/ do
    on EventconsolePage do |page|
        page.all_events_element.when_present.click
		sleep(5)
    end
end


And /^I search a device "(.+)"$/ do |device|
    on EventconsolePage do |page|
        page.device = device
		page.search_link_element.click
		sleep(3)
    end
end


Then /^I see all the events of device "(.+)" only are displayed$/ do |device|
    text11 = @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:j_id/).text.include?(device)
	#on EventconsolePage do |page|
	#thetext = page.hosts_displayed_element.when_present.text.include?('bsm-host')
	#end
	puts text11
end

#accepting log messages on event console
When /^I perform the action accept log message$/ do
    on EventconsolePage do |page|
	sleep(3)
        page.accept_log_message_element.when_present.click
         @browser.text_field(:name => /popupform:j_id208/).when_present.set "Comment"
         @browser.button(:name => /popupform:closeInputModal/).click
	sleep(5)
    end
end


When /^I navigate to operation status "(.+)" filter$/ do |filter|
    on EventconsolePage do |page|
        puts "Message #{$message}"
		if $message.include? "...."
			puts $message.slice "...."
			$message["...."]= ""
		end
	if filter == "accepted"
        page.operation_status_events_open_element.when_present.click
        page.operation_status_events_accepted_element.when_present.click
	elsif filter == "notified"
		page.operation_status_events_open_element.when_present.click
        page.operation_status_events_notified_element.when_present.click
	end
		sleep(2)
        page.message_search = $message
        page.search_element.when_present.click
        sleep(10)
    end
end


When /^I revert the changes$/ do
    on EventconsolePage do |page|
		page.applications_events_element.when_present.click
		page.operation_status_events_open_element.when_present.click
		sleep(2)
    end
end


#notifying log messages on event console
When /^I perform the action notify log message$/ do
    on EventconsolePage do |page|
	sleep(3)
        page.notify_log_message_element.when_present.click
        @browser.text_field(:name => /popupform:j_id208/).when_present.set "Comment"
        @browser.button(:name => /popupform:closeInputModal/).click
	sleep(5)
    end
end


#Verify functionality of Reset button
When /^I fill in some values in textboxes and dropdowns$/ do
    on EventconsolePage do |page|
	
        page.device = "bsm-host"
		page.message_search = "CRITICAL"
		page.severity_search = "UNREACHABLE"
		page.opstatus_search = "OPEN"
		page.monstatus_search = "UNKNOWN"
	
    end
end


When /^I select the Reset button$/ do
    on EventconsolePage do |page|
        page.reset_element.when_present.click
		sleep(5)
    end
end


Then /^all fields should get cleared$/ do
    on EventconsolePage do |page|
	
       # dev_val = String.new
	   # dev_val = page.device_element.attribute_value("value")
	   # puts dev_val
	   
	   page.device_element.attribute_value("value") == ""
	   page.message_search_element.attribute_value("value") == ""
	   page.severity_search_element.attribute_value("value") == /Any/
	   page.opstatus_search_element.attribute_value("value") == /Any/
	   page.monstatus_search_element.attribute_value("value") == /Any/
	   
    end
end


#For Scenario: Generating event from Nagios and verifying on Event Console

#below given step navigates user to the "Service Status Details For All Hosts" page under Nagios.
Given /^I am on Nagios Service Status Details page$/ do
    visit NagiosServiceStatusDetailsPage       
end


When /^I select the service "(.+)" of host "(.+)"$/ do |service,host|
	service_href = "extinfo.cgi?type=2&host="+host+"&service="+service
    on NagiosServiceStatusDetailsPage do |page|
        #page.localhost_local_cpu_httpd_element.when_present.click
		#@browser.link(:href => service_href).when_present.click
		#@browser.link(:href => service_href, :text => service).when_present.click
		#@browser.table(:class => /status/).link(:href => service_href).when_present.click 
		@browser.table(:class => /status/).link(:href => service_href, :text => service).when_present.click 
    end
end
                   
					
And /^I submit passive check result for "(.+)" "(.+)" with "(.+)"$/ do |host,service,status|
    on NagiosServiceStatusDetailsPage do |page|
		#if
			#@browser.link(:text => /Submit passive check result/).exists?.should == true
			#@browser.table(:class => 'command').td(:class => 'command').link(:text => /Submit passive check/).exists?.should == true
			#@browser.td(:class => 'command').link(:text => /Submit passive check/).exists?.should == true
        #page.passive_check_result_element.when_present.click
			#@browser.table(:class => 'command').td(:class => 'command').link(:text => /Submit passive check/).when_present.click
			#@browser.td(:class => 'command').link(:text => /Submit passive check/).when_present.click
			
			#@browser.goto 'http://qa-rhel-6-64.groundwork.groundworkopensource.com/nagios-app/cmd.cgi?cmd_typ=30&host=localhost&service=local_cpu_httpd'
			#@browser.goto submit_passive_check_result_url
			#page.goto submit_passive_check_result_url
		#end
		
		
		#  The following is the function defined in NagiosServiceStatusDetailsPage which
		#  navigates to the page where plugin state and output have to be submitted.
		page.goto_nagios_service_url(host,service)
		sleep(5)
		
		@browser.table(:class => /optBox/).td(:class => /optBoxItem/).table(:class => /optBox/).select(:name => /plugin_state/).select status
		page.check_output = "Passive check result submitted by QA"
		page.perf_data = "Passive check result submitted by QA"
		page.commit_element.when_present.click
		sleep(10)
    end
end


Then /^I see an event in "(.+)" status is generated on Event Console page$/ do |status|
    on EventconsolePage do |page|
		sleep(5)
		page.all_events_element.when_present.click
		sleep(2)
        page.number_showing_events_element.when_present.text.to_i.should >= 1
        @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_monitorStatus/, :text => /#{status}/).when_dom_changed.exists?.should == true
    end
end


When /^I search for the events by severity and OpStatus and MonStatus$/ do
    on EventconsolePage do |page|
        page.severity_search = "OK"
		page.opstatus_search = "OPEN"
	    page.monstatus_search = "UP"
		sleep(3)
    end
end

#####################################################################################################
#####################################################################################################

#for Verify if actions taken in console of User1 show up for other logged in users

Given /^I logout of GW portal$/ do
    on DashboardPage do |page|
        sleep(5)
		page.logout
		sleep(5)
    end
end


Then /^I should see event is generated of host "(.+)" in status "(.+)"$/ do |host,status|
    on EventconsolePage do |page|
		sleep(10)
		page.all_events_element.when_present.click
		sleep(2)
        page.number_showing_events_element.when_present.text.to_i.should >= 1
	@browser.refresh()
	sleep(5)
        @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_monitorStatus/).text.should == "DOWN"
		puts "Event Generated on Event Console: "+host+" -- "+@browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_monitorStatus/).text
    end
end

#for Verify System Filter and Public Filter panes are collapsible

When /^I click On "(.+)" pane heading$/ do |filter|
    #@browser.div(:id => /naviPanel:panelSystemFilter/).span(:text => filter).when_present.click
	@browser.div(:class => /icePnlGrp  sideBarWrapper/).span(:text => filter).when_present.click
	sleep(4)
end


When /^I verify (.+) pane has collapsed$/ do |filter|
	if filter=="System Filters"
    @browser.link(:text => /Applications/).exists?.should == false
	elsif 
	@browser.link(:text => "All Events").exists?.should == false
	end
end

# for Verify the list of host groups displayed under HostGroups under System Filter

When /^I make a list of all the "(.+)" currently present$/ do |group|
	if group =="Host Groups"
			id_count=0
			$hg = Array.new
			hg_span_id = "frmTree:pnlTbSet:0:hstTree:n-0:TxtNdClick"
			
			while @browser.span(:id => hg_span_id).exists?
			group_name = @browser.span(:id => hg_span_id).text
			$hg << group_name
			id_count += 1
			hg_span_id="frmTree:pnlTbSet:0:hstTree:n-"+id_count.to_s+":TxtNdClick"
			end
			
			puts "HGs present are: "
			$hg.each do |hg|
			puts hg
			end
	else
		on StatusviewerPage do |page|
			page.services_tab_element.when_present.click
		end
			sleep(4)
	
			id_count=0
			$sg = Array.new
			sg_span_id = "frmTree:pnlTbSet:0:treeSrvc:n-0:TxtNdClick"
			              
			while @browser.span(:id => sg_span_id).exists?
			group_name = @browser.span(:id => sg_span_id).text
			$sg << group_name
			id_count += 1
			sg_span_id="frmTree:pnlTbSet:0:treeSrvc:n-"+id_count.to_s+":TxtNdClick"
			end
			
			puts "SGs present are: "
			$sg.each do |sg|
			puts sg
			end
	end
end


When /^I verify each "(.+)" present on Status Viewer is also visible on Event Console$/ do |group|
	if group =="hostgroup"
			@browser.div(:class => /icePnlGrp  sideBarWrapper/).link(:id => /naviPanel:systemFilterTree:1/).when_present.click
			sleep(3)
			$hg.each do |hg|
			@browser.div(:class => /icePnlGrp  sideBarWrapper/).link(:text => hg).exists?.should == true
			end
			puts "All HostGroups present on Event Console."
	else
			@browser.div(:class => /icePnlGrp  sideBarWrapper/).link(:id => /naviPanel:systemFilterTree:2/).when_present.click
			sleep(3)
			$sg.each do |sg|
			@browser.div(:class => /icePnlGrp  sideBarWrapper/).link(:text => sg).exists?.should == true
			end
			puts "All ServiceGoups present on Event Console."
	end
end

# for Verify the functionality of Resume/Pause Incoming Events 

When /^I select All Events filter$/ do
	@browser.link(:text => /All Events/).click
	sleep(10)
end


When /^verify that events have been stopped$/ do
	@browser.link(:text => /Resume Incoming Events/).exists?.should == true	
end


When /^I open a new browser window and generate an event "(.+)" for "(.+)"$/ do |state,host|
	browser = Watir::Browser.new
	browser.driver.manage.window.maximize
	#@browser2.goto StatusviewerPage
	#@browser2.goto BASE_URL + "status"
	#@browser.window(:title =>/status/).when_present.use
	
	#@browser.window(:id =>/newtab-window/).when_present.use
	#@browser.window(:title =>/New Tab/).when_present.use
	browser.goto BASE_URL + "status"
	browser.text_field(:name => /josso_username/).set "admin"
	browser.text_field(:name => /josso_password/).set "admin"
	browser.button(:value => /Login/).click
	sleep(5)
	browser.goto BASE_URL + "status"
	sleep(3)
	browser.div(:id => /divContents/).span(:text => /Linux Servers/).when_present.click
	sleep(3)
	browser.div(:id => /divContents/).span(:text => host).when_present.click
	sleep(3)
	browser.span(:text => /Check Results/).click
	sleep(1)
	browser.span(:text => /Submit Passive Check Result/).click
	sleep(4)
	browser.select(:name => /HVform:actionsPortlet_menuCheckResult/).select state
	browser.text_field(:name => /HVform:actionsPortlet_txtCheckOutputValue/).set state+" from window 2"
	browser.text_field(:name => /HVform:actionsPortlet_txtPerformanceDataValue/).set state+" from window 2"
	browser.button(:name => /HVform:actionsPortlet_btnSubmit/).click
	sleep(5)
	browser.close
end


Then /^verify no new event is populated for "(.+)" in state "(.+)"$/ do |host,state|
	@browser.window(:title =>/console/).use
	event_status_span_id = "contentPanel:icepnltabset:0:eventTableID:0:txt_monitorStatus"
	event_name_span_id = "contentPanel:icepnltabset:0:eventTableID:0:j_id226"
	
	id_count=0
	while @browser.span(:id => event_status_span_id).exists?
		
		if @browser.span(:id => event_status_span_id).text == state
			@browser.span(:id => event_name_span_id).text != host
		end	
			
		id_count += 1	
		event_status_span_id = "contentPanel:icepnltabset:0:eventTableID:"+id_count.to_s+":txt_monitorStatus"	
		event_name_span_id = "contentPanel:icepnltabset:0:eventTableID:"+id_count.to_s+":j_id226"
		
	end
end


When /^I Resume Incoming Events$/ do
	sleep(10)
	@browser.link(:text => /Resume Incoming Events/).when_present.click
	@browser.refresh
end


Then /^I verify that that new events are populated for "(.+)" in state "(.+)"$/ do |host,state|
	if host=="localhost"
		host="127.0.0.1"
	end
	event_name_span_id = "contentPanel:icepnltabset:0:eventTableID:0:j"   
	event_message_span_id = "contentPanel:icepnltabset:0:eventTableID:1:txt_textMessage"
	
	id_count=0
	
	puts @browser.div(:class => "tableWrapper").span(:id => event_name_span_id).text
=begin	
	while @browser.div(:class => "tableWrapper").span(:id => event_name_span_id).text == host
		
		if @browser.span(:id => event_name_span_id).text == host
			@browser.span(:id => event_message_span_id).text == state+" from window 2"
			puts "Event generated for "+host+"in state "+state
		end	
			
		id_count += 1
		event_name_span_id = "contentPanel:icepnltabset:0:eventTableID:"+id_count.to_s+":j"
		event_message_span_id = "contentPanel:icepnltabset:0:eventTableID:"+id_count.to_s+":txt_textMessage"	
	end
	
=end	
	
	
=begin	
	event_name_span_id = "contentPanel:icepnltabset:0:eventTableID:0:j_id226"                 
	event_message_span_id = "contentPanel:icepnltabset:0:eventTableID:1:txt_textMessage"
						  
	id_count=0
	while @browser.span(:id => event_name_span_id).exists?
		
		if @browser.span(:id => event_name_span_id).text == host
			@browser.span(:id => event_message_span_id).text == state+" from window 2"
			puts "Event generated for "+host+"in state "+state
		end	
			
		id_count += 1
		event_name_span_id = "contentPanel:icepnltabset:0:eventTableID:"+id_count.to_s+":j_id226"
		event_message_span_id = "contentPanel:icepnltabset:0:eventTableID:"+id_count.to_s+":txt_textMessage"
	end
=end	
	
end


And /^I select the Show Event Tile link$/ do
	on EventconsolePage do |page|
		page.show_event_tile_link_element.when_present.click
    end
end


And /^I select the host group "(.+)"$/ do |group|
	sleep(3)
	if group== "Linux Servers"
		group= "filterValue=Linux"
	elsif 
		group= "filterValue="+group
	end
	#@browser.link(:href => /#{group}/).image(:alt => //).when_present.click
	@browser.link(:href => /#{group}/).image(:src => /portal-statusviewer/).when_present.click
	
	#@browser.td(:class => /icePnlPopBody/).link(:href => /#{group}/).image(:alt => //).when_present.click
	#@browser.div(:id => /eventTileForm:icePnlSrsConsole/).link(:href => /#{group}/).image(:alt => //).when_present.click
	#@browser.div(:id => /eventTileForm/).link(:href => /#{group}/).image(:alt => //).when_present.click
	#@browser.div(:id => /eventTileForm/, :class => /icePnlSrs/).link(:href => /#{group}/).image(:alt => //).when_present.click
	#@browser.div(:name => /eventTileForm:popupEventTileDiv/).link(:href => /#{group}/).image(:alt => //).when_present.click
end


Then /^I see all events of host "(.+)" only are displayed$/ do |host|
	sleep(3)
	event_host_div_id = "contentPanel:icepnltabset:0:eventTableID:0:pnl_host"                 
				
	row = @browser.table(:id => /eventTableID/).rows.length
	puts "Rows in table: "+row.to_s

	for i in 1..row-1
		host_found = @browser.table(:id => /eventTableID/).div(:id => /#{event_host_div_id}/).link(:href => /#{host}/).span(:text => /#{host}/).exists?
			if host_found == true
				puts "Verified for host : "+host
				event_host_div_id = "contentPanel:icepnltabset:0:eventTableID:"+i.to_s+":pnl_host" 
			else
				puts "Failed!"
				puts i
				raise
			end
	end
end


Given /^I am on the Dashboard Enterprise View page$/ do
	@browser.goto BASE_URL + "dashboard/enterprise"
end


And /^I select the group "(.+)" from the "(.+)" filter$/ do |group,type|
	sleep(3)
	if type== "HostGroups"
		@browser.div(:class => /icePnlGrp  sideBarWrapper/).link(:id => /naviPanel:systemFilterTree:1/).when_present.click
	elsif type == "ServiceGroups"
		@browser.div(:class => /icePnlGrp  sideBarWrapper/).link(:id => /naviPanel:systemFilterTree:2/).when_present.click
	end
	sleep(3)
	@browser.div(:class => /icePnlGrp  sideBarWrapper/).link(:text => /#{group}/).when_present.click
end


Then /^I see all events of service "(.+)" only are displayed$/ do |service|
	sleep(3)
	event_service_div_id = "contentPanel:icepnltabset:0:eventTableID:0:pnl_serviceDescription"                 	
	row = @browser.table(:id => /eventTableID/).rows.length
	puts "Rows in table: "+row.to_s

	for i in 1..row-1
		service_found = @browser.table(:id => /eventTableID/).div(:id => /#{event_service_div_id}/).link(:href => /#{service}/).span(:text => /#{service}/).exists?
			if service_found == true
				puts "Verified for service : "+service
				event_service_div_id = "contentPanel:icepnltabset:0:eventTableID:"+i.to_s+":pnl_serviceDescription"
			else
				puts "Failed!"
				puts i
				raise
			end
	end
end

#acknowledging, notifying, accepting , closing and opening

And /^I select the "(.+)" button on Event Console$/ do |action|
	sleep(3)
	@browser.link(:text => action).when_present.click
=begin
	if action== "Acknowledge"
		@browser.link(:text => "Acknowledge").when_present.click
	elsif action== "Notify"
		@browser.link(:text => "Notify").when_present.click
	elsif action== "Accept"
		@browser.link(:text => "Accept").when_present.click
	elsif action== "Close"
		@browser.link(:text => "Close").when_present.click
	elsif action== "Open"
		@browser.link(:text => "Open").when_present.click
	end
=end
	sleep(2)
end


And /^I fill in the comment as "(.+)"$/ do |comment|
    on EventconsolePage do |page|
	   #filling in the comment and submitting
	   @browser.textarea(:name => /popupform:j_id/, :class => /iceInpTxtArea portlet-form-input-field popupText/).set comment
	   page.nagios_ack_comment_button_element.click
	   sleep(5)
    end
end


Then /^I see comment "(.+)" gets updated in the comment column of "(.+)"$/ do |comment,event|
	@browser.refresh
	sleep(5)
    on EventconsolePage do |page|
	if event == "NAGIOS"
	#@browser.div(:id => /contentPanel:icepnltabset:0:eventTableID:3:pnl_acknowledgeComment/).span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_acknowledgeComment/, :text => /#{comment}/).exists?.should == true
		if comment == "Acknowledged"
			comment_console= @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_acknowledgeComment/, :class => /iceOutTxt/).text
			comment_console.should include(comment)
	#@browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_acknowledgeComment/, :class => /iceOutTxt/, :text => /#{comment}/).exists?.should == true
		elsif comment == "Notified"
			page.operation_status_events_open_element.when_present.click
        		page.operation_status_events_notified_element.when_present.click
        		comment_console= @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_Comments/).when_present.text
			
		elsif comment == "Closed"
			page.operation_status_events_open_element.when_present.click
        		page.close_filter_element.when_present.click
        		comment_console= @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_Comments/).when_present.text
	
		elsif comment == "Opened"
			page.operation_status_events_open_element.when_present.click
        		page.open_filter_element.when_present.click
        		comment_console= @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_Comments/).when_present.text
        		puts "Comment on Console: "+comment_console
	
		elsif comment == "Accepted"
			page.operation_status_events_open_element.when_present.click
        		page.operation_status_events_accepted_element.when_present.click
        		comment_console= @browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_Comments/).when_present.text
		
		end
		comment_console.should include(comment)
		puts "Comment on Console: "+comment_console
	
	else
	#@browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_Comments/, :text => /#{comment}/).exists?.should == true
	@browser.div(:id => /contentPanel:icepnltabset:0:eventTableID:0:pnl_Comments/).span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_Comments/, :text => /#{comment}/).exists?.should == true
	puts "Comment on Console: "+@browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0:txt_Comments/).text
	end
   end
	
end



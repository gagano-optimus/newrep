When /^I select only a host on the status viewer page$/ do
    on StatusviewerPage do |page|
	page.linux_servers_element.when_present(100).click
	page.localhost_element.when_present(100).click
	
    end
end

When /^I select downtime option$/ do
    on StatusviewerPage do |page|
        page.downtime_element.when_present.click
	page.schedule_downtime_element.when_present.click
	sleep(8)
    end
end

When /^I schedule downtime$/ do
    on StatusviewerPage do |page|
	page.comment ="down by qa"
	page.type_down = 'Fixed'
	page.downtime_button_element.when_present.click
		 
    end
end

Then /^I wait and check host downtime status on status viewer page$/ do
	on StatusviewerPage do |page|
		sleep(45)
		page.linux_servers_element.when_present.click
		page.localhost_element.when_present.click
		page.downtime_value == "Yes"
		page.downtime_comment_tab_element.when_present.click
		sleep(3)
		page.downtime_comment_element.when_present.text == /This host has been scheduled for fixed downtime/
	end
end

Then /^the host downtime event gets displayed$/ do
	on EventconsolePage do |page|
		page.host_groups_events_element.click
		page.LS_link_element.when_present.click		
		sleep(5)
	end
end

When /^I schedule service downtime$/ do
    on StatusviewerPage do |page|        
		page.service_comment ="down by qa"
		page.service_type_down = 'Fixed'
		page.service_downtime_button_element.when_present.click		 
    end
end
	
Then /^I select a service on the status viewer page$/ do
	on StatusviewerPage do |page|
		page.linux_servers_element.when_present.click
		page.localhost_element.when_present.click
		page.local_cpu_httpd_element.when_present.click
    end
end

Then /^I wait and check service downtime status on status viewer page$/ do
	on StatusviewerPage do |page|		
		sleep(45)			
		page.linux_servers_element.when_present.click
		page.localhost_element.when_present.click
		page.local_cpu_httpd_element.when_present.click
		page.service_downtime_value == "Yes"
		page.service_downtime_comment_element.when_present.text == /This service has been scheduled for fixed downtime/
	end
end

Then /^I select the search tab and search a host by "(.+)"$/ do |search|
	on StatusviewerPage do |page|
		page.search_for_host(search)
		sleep(1)
	end
end
	
Then /^I should see the host as the search result$/ do
	on StatusviewerPage do |page|		
		sleep(2)
        results = page.search_count
        if results.split(" ")[0].to_i == 1
			page.search_result_element.exists?
			puts page.search_result_element.attribute_value("text")
		end
	end
end
	
When /^I select a host "(.+)" on status viewer page$/ do |host|
	visit AutodiscoveryPage
	visit StatusviewerPage
	sleep(3)    
	on StatusviewerPage do |page|
		page.select_hostname(host)
		sleep(6)
    	end
end


When /^I select "(.+)" downtime option with "(.+)","(.+)"$/ do |option,comment,time|
    on StatusviewerPage do |page|
        page.downtime(option,comment,time)
    end
end

When /^then submit passive check result with "(.+)"$/ do |state|
    on StatusviewerPage do |page|
        page.submit_check_results_host(state)
    end
end

Then /^verify that host "(.+)" is in "(.+)" status$/ do |host,state|
    on StatusviewerPage do |page|
	
		page.downtime_comment_tab_element.when_present.click
		sleep(3)
		@browser.table(:id => /HVform:CPtblComments/).tr(:id => /HVform:CPtblComments:0/).span(:text => /CPtxtCommentValue/, :text => /This host has been scheduled for fixed downtime/).exists?.should == true
		page.verify_hoststatus_hostsummary(state)
        page.verify_hostdown_entire_network(host,/#{state}:Scheduled/)
        page.verify_hostdown_hostgroup(state)
		visit EventconsolePage
		on EventconsolePage do |page|
		page.verify_hostdown_eventconsole
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			sleep(3)
			@browser.td(:class => /stateInfoPanel/).td(:class => /stateInfoTable1/).div(:text => state).exists? == true
			end
		end
    end
end

And /^since time should be displayed for "(.+)"$/ do |option|
	date = @browser.span(:id => /txtHostStateSince/).text.to_s
	date = date.reverse[0...22].reverse
	puts date
end
	

Then /^verify that host "(.+)" is in "(.+)" status on host summary page$/ do |host,state|
    on StatusviewerPage do |page|
        page.verify_hoststatus_hostsummary(state)	
    end
end

Then /^verify that host "(.+)" is in "(.+)","(.+)" status on Entire Network page$/ do |host,state,index|
    on StatusviewerPage do |page|
        page.verify_hoststatus_entire_network(host,state,index)	
    end
end

Then /^verify that host "(.+)" is in "(.+)" status on Hostgroup summary page$/ do |host,state|
    on StatusviewerPage do |page|
        page.verify_hoststatus_hostgroup(host,state)	
    end
end

Then /^verify that host "(.+)" is in "(.+)" status on Event Console page$/ do |host,state|
	visit EventconsolePage
    	on EventconsolePage do |page|
        	page.verify_hoststatus_eventconsole(host,state)	
    	end
end

Then /^verify that host is in "(.+)" state on Nagios Host Status Details page$/ do |state|
    visit NagiosHostStatusDetailsPage
	on NagiosHostStatusDetailsPage do |page|
		sleep(5)
		page.localhost_element.when_present.click
		sleep(3)
		@browser.td(:class => /stateInfoPanel/).td(:class => /stateInfoTable1/).div(:text => state).exists? == true
	end
end

When /^disable "(.+)" for the host$/ do |option|
    on StatusviewerPage do |page|
	
		if option == "notification"
        page.notification_element.when_present(100).click
        page.disable_notification_element.when_dom_changed.click	
		
		elsif option == "active checks"
		page.settings_element.when_present(100).click	
		page.disable_active_check_element.flash
        page.disable_active_check_element.when_dom_changed.click	
		
		elsif option == "passive checks"
		page.settings_element.when_dom_changed.click	
        page.disable_passive_check_host_element.when_dom_changed.click	
		
		elsif option == "flap detection"
		page.settings_element.when_present(100).click	
        page.disable_flap_detection_host_element.when_dom_changed.click	
		
		elsif option == "event handler"
		page.event_handlers_dropdown_element.when_dom_changed.click	
        page.disable_event_handlers_host_element.when_dom_changed.click	
		end
		
		page.submit_button_element.when_present.click	
		sleep(100)
    end
end

Then /^verify that "(.+)" are disabled for "(.+)"$/ do |option,host|
    on StatusviewerPage do |page|
	
	if option == "notifications"
		 visit StatusviewerPage
		 page.linux_servers_element.when_present.click
		 page.localhost_element.when_present.click
		 @browser.link(:text => /Enable Notifications/).when_dom_changed.exists?.should == true
		page.navigate_entire_network
        page.verify_notification_disable_entire_network(host)
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).td(:text => /Notifications:/).div(:class => /checksDISABLED/).exists?.should == true
		end   
      
	elsif option == "active checks"
	    page.verify_disable_active_check_host_summary_element.when_dom_changed.exists?.should == true
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).td(:text => /Active Checks:/).div(:class => /checksDISABLED/).exists?.should == true
		end
		
		elsif option == "passive checks"
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).td(:text => /Passive Checks:/).div(:class => /checksDISABLED/).exists?.should == true
		end
		
		elsif option == "flap detection"	
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).div(:class => /flapdetectionDISABLED/).exists?.should == true
		end
		
		elsif option == "event handler"
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).div(:class => /eventhandlersDISABLED/).exists?.should == true
		end
	end
  end
end

When /^enable "(.+)" for the host$/ do |option|
    on StatusviewerPage do |page|
		if option == "notification"	
			page.notification_element.when_present(100).click
			page.enable_notification_element.when_dom_changed.click	
			
		elsif option == "active checks"
			page.settings_element.when_present.click	
			page.enable_active_check_element.flash
			page.enable_active_check_element.when_dom_changed.click
		
		elsif option == "passive checks"
			page.settings_element.when_present(100).click	
			page.enable_passive_check_host_element.flash
			page.enable_passive_check_host_element.when_dom_changed.click	
		
		elsif option == "flap detection"
			page.settings_element.when_present.click	
			page.enable_flap_detection_host_element.when_dom_changed.click	
			
		elsif option == "event handler"
		page.event_handlers_dropdown_element.when_dom_changed.click	
        page.enable_event_handlers_host_element.when_dom_changed.click	
		
		elsif option == "reschedule next check"
		page.check_results_element.when_present(100).click	
        page.reschedule_next_check_element.when_present(100).click
		sleep(4)
		page.next_check_time = "12/30/2014 2:03:43"
		page.force_check_element.when_present.check
		end	
		
		page.submit_button_element.when_present.click	
		sleep(100)
    end
end

Then /^verify that "(.+)" are enabled for "(.+)"$/ do |option,host|
    on StatusviewerPage do |page|
		
		if option == "notification"
			page.verify_notification_enable_host_summary
			page.navigate_entire_network
			page.verify_notification_enable_entire_network(host)
			visit NagiosHostStatusDetailsPage
			on NagiosHostStatusDetailsPage do |page|
				page.localhost_element.when_present.click
				@browser.frame(:id => /myframe/).td(:text => /Notifications:/).div(:class => /checksENABLED/).exists?.should == true
		end
		
		elsif option == "active checks"
			page.verify_enable_active_check_host_summary_element.exists?.should == true
			visit NagiosHostStatusDetailsPage
			on NagiosHostStatusDetailsPage do |page|
				page.localhost_element.when_present.click
				@browser.frame(:id => /myframe/).td(:text => /Active Checks:/).div(:class => /checksENABLED/).exists?.should == true
		end
		
		elsif option == "passive checks"
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).td(:text => /Passive Checks:/).div(:class => /checksENABLED/).exists?.should == true
		end
		
		elsif option == "flap detection"
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).div(:class => /flapdetectionENABLED/).exists?.should == true
		end
		
		elsif option == "event handler"
		visit NagiosHostStatusDetailsPage
		on NagiosHostStatusDetailsPage do |page|
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).div(:class => /eventhandlersENABLED/).exists?.should == true
		end
		
		elsif option == "reschedule next check"
		@browser.span(:text => '12/30/2014 10:39:01 PM').exists?.should == true
	
	end
  end
end

When /^I goto search tab$/ do
	on StatusviewerPage do |page|
		@browser.link(:name => /frmTree:pnlTbSet:0.2/).td(:text => /Search/).when_present.click
		sleep(2)
	end
end		
		
When /^enter host name "(.+)" to be searched$/ do |hostname|
	on StatusviewerPage do |page|
		page.search_box = hostname
		page.go_search_element.when_present.click
		sleep(5)	
	end
end	

Then /^verify that "(.+)" is displayed as a search result$/ do |hostname|
	on StatusviewerPage do |page|
		@browser.link(:id => /frmTree:pnlTbSet:0:STtblResults:0:lnkSearchNdClick/).span(:text => hostname).exists?.should == true
	end
end	


Then /^last check time for "(.+)" should be displayed$/ do |option|
	on StatusviewerPage do |page|
		if option == "host"
		page.host_last_check_element.exists?.should ==true
		b = @browser.windows.size
		puts b
		
		elsif option == "service"
		page.service_local_cpu_element.when_present.click 
		sleep(3)
		page.service_last_check_element.exists?.should ==true
		end
	end
end	

When /^I select host availabilty portlet$/ do
	on StatusviewerPage do |page|
		page.host_availability_portlet_element.when_present(100).click
		sleep(5)
	end	
end	

When /^select custom date-time$/ do
	on StatusviewerPage do |page|
		@browser.select(:id => /HVform:HAmenuTimeSelector/).select('Custom Date-Time')
	end	
end	

Then /^calendar should be displayed and date-time should be editable$/ do
	on StatusviewerPage do |page|
		page.start_time_host_portlet = '02/26/2014 00:08'
		page.end_time_host_portlet = '03/29/2014 23:09'
		page.apply_host_portlet_element.when_present.click 
		page.calendar_img1_element.when_dom_changed.click
		page.start_date_element.when_present.click
		page.calendar_img2_element.when_dom_changed.click
		page.end_date_element.when_present.click
		page.apply_host_portlet_element.when_present.click 
	end	
end	

When /^click acknowledge button and fill details "(.+)"$/ do |comment|
	on StatusviewerPage do |page|
		page.acknowledge_element.when_present(100).click
		sleep(2)
		page.acknowledge_host_element.when_dom_changed.click
		sleep(7)
		page.services_ack_element.when_present(10).set
		page.acknowledge_comment = comment
		sleep(3)
		page.submit_ack_element.when_present.click 
	end	
end	

Then /^verify that comment "(.+)" is "(.+)" on host portlet under events tab,comments section and hostgroup page$/ do |comment,action|
	on StatusviewerPage do |page|
	if action == 'updated'

		@browser.span(:text => /Events/).when_dom_changed.click 
		@browser.table(:id => 'HVform:tbleventTableID').span(:text => comment).exists?.should == true
		@browser.span(:text => /Events/).when_dom_changed.click 
		
		@browser.span(:text => /Comments/).when_dom_changed.click 
		@browser.table(:id => 'HVform:CPtblComments').span(:text => comment).wait_until_present
		Watir::Wait.until { @browser.table(:id => 'HVform:CPtblComments').span(:text => comment).exists?.should == true }
		@browser.table(:id => 'HVform:CPtblComments').span(:text => comment).exists?.should == true
		
		@browser.span(:text => /Linux Servers/).when_present.click
		@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present(100).click 
		@browser.table(:id => 'HGVform:hostgrouptableID').span(:text => comment).wait_until_present
		@browser.table(:id => 'HGVform:hostgrouptableID').span(:text => comment).exists?.should == true
			
		elsif action == 'deleted'
			visit StatusviewerPage
			sleep(15)		
			page.select_hostname("localhost")
			@browser.span(:text => /Events/).when_dom_changed.click 
			@browser.table(:id => 'HVform:tbleventTableID').span(:text => comment).exists?.should == false
			@browser.span(:text => /Events/).when_dom_changed.click 
			@browser.span(:text => /Comments/).when_dom_changed.click 
			@browser.table(:id => 'HVform:CPtblComments').span(:text => comment).exists?.should == false
			@browser.span(:text => /Linux Servers/).when_present.click
			@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present(100).click 
			@browser.table(:id => 'HGVform:hostgrouptableID').span(:text => comment).exists?.should == false
		end	
	end	
end	

When /^remove the comment added$/ do
	on StatusviewerPage do |page|
		@browser.span(:text => /Comments/).wait_until_present
		@browser.span(:text => /Comments/).when_dom_changed.click
		page.delete_comment_element.when_present(100).click
		page.commit_element.when_present(100).click
		sleep(10)
	end	
end

Then /^verify that comment "(.+)" is "(.+)" on nagios page$/ do |comment,action|
	visit NagiosHostStatusDetailsPage
	on NagiosHostStatusDetailsPage do |page|
	
		if action == 'updated'
			sleep(20)
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).td(:text => comment).exists?.should == true
		
		elsif action == 'deleted'
			page.localhost_element.when_present.click
			@browser.frame(:id => /myframe/).td(:text => comment).exists?.should == false
		end	
	end
end

When /^set service "(.+)" of this host to "(.+)" state$/ do |service,state|
	on StatusviewerPage do |page|	
		@browser.span(:text => /#{service}/).when_present.click
		sleep(5)
		page.submit_check_results_service(state)
		sleep(15)
	end	
end

Then /^verify "(.+)" appears on service page under comment portlet$/ do |comment|
	on StatusviewerPage do |page|
		@browser.span(:text => /#{comment}/).exists?.should == true
	end	
end

Then /^I select Entire Network tab$/ do
	on StatusviewerPage do |page|
		@browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_dom_changed.click
    end
end

Then /^verify if notifications have been enabled globally$/ do
	on StatusviewerPage do |page|
		@browser.wait_until(450) do
		@browser.table(:id => /frmNV:nagiosPortlet_panelgridNotifications/).tr(:class => /icePnlGrdRow Row iceDatTbl_typERow iceDatTblRow1_typE/).td(:id => /frmNV:nagiosPortlet_panelgridNotifications-0-0/, :class => /icePnlGrdCol Col iceDatTbl_typECol iceDatTblCol1_typE/).span(:text => /Disabled/).exists?.should == false
		end
    end
end

Then /^verify if notifications have been disabled globally$/ do
	on StatusviewerPage do |page|
		@browser.table(:id => /frmNV:nagiosPortlet_panelgridNotifications/).tr(:class => /icePnlGrdRow Row iceDatTbl_typERow iceDatTblRow1_typE/).td(:id => /frmNV:nagiosPortlet_panelgridNotifications-0-0/, :class => /icePnlGrdCol Col iceDatTbl_typECol iceDatTblCol1_typE/).span(:text => /Disabled/).exists?.should == true
    end
end

Then /^verify if Flap Detection has been enabled globally$/ do
	on StatusviewerPage do |page|
		@browser.table(:id => /frmNV:nagiosPortlet_panelgridFlapDetection/).tr(:class => /icePnlGrdRow Row iceDatTbl_typERow iceDatTblRow1_typE/).td(:id => /frmNV:nagiosPortlet_panelgridFlapDetection-0-0/, :class => /icePnlGrdCol Col iceDatTbl_typECol iceDatTblCol1_typE/).span(:text => /Disabled/).exists?.should == false
    end
end

Then /^verify if Flap Detection has been disabled globally$/ do
	on StatusviewerPage do |page|
		@browser.table(:id => /frmNV:nagiosPortlet_panelgridFlapDetection/).tr(:class => /icePnlGrdRow Row iceDatTbl_typERow iceDatTblRow1_typE/).td(:id => /frmNV:nagiosPortlet_panelgridFlapDetection-0-0/, :class => /icePnlGrdCol Col iceDatTbl_typECol iceDatTblCol1_typE/).span(:text => /Disabled/).exists?.should == true
    end
end

Then /^I select the Groups for this Hosts link$/ do
	on StatusviewerPage do |page|
		page.group_for_host_element.when_dom_changed.click
    end
end

Then /^the hostgroup is displayed$/ do
	on StatusviewerPage do |page|
		page.group_for_host_linuxservers_element.exists?.should == true
    end
end

Then /^I close the Groups for this host window$/ do
	on StatusviewerPage do |page|
		page.close_window_element.when_present.click
    end
end

Then /^I select a service "(.+)" of host "(.+)" on status viewer page$/ do |service,host|
	@browser.refresh()
on StatusviewerPage do |page|
	sleep(10)
		page.linux_servers_element.when_present.click
		@browser.span(:text => host).when_present.click
		sleep(2)
		@browser.span(:text => service).when_present.click
    end
end
	

When /^then submit passive check result for service with "(.+)"$/ do |state|
    on StatusviewerPage do |page|
	sleep(25)
        page.submit_check_results_service(state)
		sleep(50)
    end
end

When /^verify that service "(.+)" is in "(.+)" status on Entire Network page$/ do |service,state|
    on StatusviewerPage do |page|
		visit StatusviewerPage
		sleep(25)
			if state == "CRITICAL"
				Watir::Wait.until{
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Critical:UnScheduled/).exists?.should == true
				}
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Critical:UnScheduled/).when_dom_changed.click


=begin
					@browser.table(:id => /frmNV:servicestatusportlet_PanelMain-0-1/).link(:text => /Critical:UnScheduled/).exists?.should == true
				}	
					@browser.table(:id => /frmNV:servicestatusportlet_PanelMain-0-1/).link(:text => /Critical:UnScheduled/).when_dom_changed.click
=end

			elsif state == "WARNING"
				Watir::Wait.until{
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Warning/).exists?.should == true
				}
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Warning/).when_dom_changed.click
		
			elsif state == "UNKNOWN"
				Watir::Wait.until{
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Unknown/).exists?.should == true
				}
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Unknown/).when_dom_changed.click
		
			elsif state == "OK"
				Watir::Wait.until{
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Ok/).exists?.should == true
				}
					@browser.table(:id => 'frmNV:tblServiceStatistics').link(:text => /Ok/).when_dom_changed.click
			end
			sleep(10)
				@browser.div(:id => 'frmNV:pnlpopupService').table(:id => 'frmNV:tblServiceListDatatable').span(:text => service).when_present.click
				sleep(10)
	    end
end

When /^verify that service is in "(.+)" status on Service Summary page$/ do |state|
    on StatusviewerPage do |page|
    	sleep(30)
		if state == "CRITICAL"
			@browser.span(:id => /SVform:SHtxtServiceState/, :text => /Unscheduled Critical/).when_dom_changed.exists?.should == true
			@browser.img(:src => /service-red.gif/).wait_until_present(180)
				
		elsif state == "WARNING"
			@browser.span(:id => /SVform:SHtxtServiceState/, :text => /Warning/).when_dom_changed.exists?.should == true
			@browser.img(:src => /service-yellow.gif/).wait_until_present(180)
				
		elsif state == "UNKNOWN"
			@browser.span(:id => /SVform:SHtxtServiceState/, :text => /Unknown/).when_dom_changed.exists?
			@browser.img(:src => /service-gray.gif/).wait_until_present(180)
				
		elsif state == "OK"
			@browser.span(:id => /SVform:SHtxtServiceState/, :text => /Ok/).when_dom_changed.exists?	
			@browser.img(:src => /service-green.gif/).wait_until_present(180)
		end
    end
end

Then /^I navigate to "(.+)" "(.+)" Nagios service page$/ do |host,service|
	on StatusviewerPage do |page|
		page.navigate_service_page_nagios(host,service)
    end
end		

When /^verify that service is in "(.+)" status on Nagios service page$/ do |state|
		
		if state == "CRITICAL"
			@browser.div(:class => /serviceCRITICAL/, :text => /CRITICAL/).when_present(45).exists?
		end		
		if state == "WARNING"
			@browser.div(:class => /serviceWARNING/, :text => /WARNING/).when_present(45).exists?
		end		
		if state == "UNKNOWN"
			@browser.div(:class => /serviceUNKNOWN/, :text => /UNKNOWN/).when_present(45).exists?
		end   
		if state == "OK"
			@browser.div(:class => /serviceOK/, :text => /OK/).when_present(45).exists?
		end
end

Then /^I select the Services tab on Status Viewer$/ do
	on StatusviewerPage do |page|
		page.services_tab_element.when_present.click
    end
end

Then /^I select a service group "(.+)" on status viewer page$/ do |service_group|
	on StatusviewerPage do |page|
		@browser.span(:text => service_group).when_present.click
		sleep(5)    
	end
end

When /^verify that service "(.+)" is in "(.+)" status on Servicegroup Summary page$/ do |service,state|
	on StatusviewerPage do |page|
		if state == "CRITICAL"
			@browser.span(:id => /SGVform:SGHSGHtxtHostState/, :text => /Unscheduled Critical/).when_dom_changed.exists?
			@browser.div(:id => /SGVform:frmServicefrom_panelsgrpError1/).link(:text => /Critical:UnScheduled/).when_dom_changed.click
			sleep(2)
			@browser.span(:text => service).exists?
			@browser.button(:name => /SGVform:cmdCloseWindow/).when_present.click
			sleep(2)
			page.check_event_service_group_summary_page(service)
		end
		
		if state == "WARNING"
			@browser.span(:id => /SGVform:SGHSGHtxtHostState/, :text => /Warning/).when_dom_changed.exists?
			@browser.link(:text => /Warning/).when_dom_changed.click
			sleep(2)
			@browser.span(:text => service).exists?
			@browser.button(:name => /SGVform:cmdCloseWindow/).when_present.click
			sleep(2)
			page.check_event_service_group_summary_page(service)
		end
		
		if state == "UNKNOWN"
			@browser.span(:id => /SGVform:SGHSGHtxtHostState/, :text => /Unknown/).when_dom_changed.exists?
			@browser.link(:text => /Unknown/).when_dom_changed.click
			sleep(2)
			@browser.span(:text => service).exists?
			@browser.button(:name => /SGVform:cmdCloseWindow/).when_present.click
			sleep(2)
			page.check_event_service_group_summary_page(service)
		end   
		
		if state == "OK"
			@browser.span(:id => /SGVform:SGHSGHtxtHostState/, :text => /Ok/).when_dom_changed.exists?
			@browser.link(:text => /Ok/).when_dom_changed.click
			sleep(2)
			@browser.span(:text => service).exists?
			@browser.button(:name => /SGVform:cmdCloseWindow/).when_present.click
			sleep(2)
			page.check_event_service_group_summary_page(service)
		end
	end
end

When /^I select the "(.+)" downtime option with comment "(.+)" and time "(.+)"$/ do |option,comment,time|
    on StatusviewerPage do |page|
        page.downtime_service(option,comment,time)
	sleep(30)
    end
end

Then /^verify that service "(.+)" of host "(.+)" is in "(.+)" downtime$/ do |service,host,option|
    on StatusviewerPage do |page|
	
		if option=='Fixed'
			@browser.span(:id => /SVform:SItxtServiceDowntimeValue/, :text => /Yes/).when_dom_changed.exists?
			@browser.span(:text => /This service has been scheduled for fixed downtime/).when_dom_changed.exists?
			page.navigate_service_page_nagios(host,service)
			@browser.div(:class => /downtimeACTIVE/, :text => /YES/).when_dom_changed.exists?
			@browser.td(:class => /commentOdd/, :text => /This service has been scheduled for fixed downtime/).when_dom_changed.exists?	
		else
			@browser.span(:text => /This service has been scheduled for flexible downtime/).when_dom_changed.exists?			
			page.navigate_service_page_nagios(host,service)
			@browser.td(:class => /commentOdd/, :text => /This service has been scheduled for flexible downtime/).when_dom_changed.exists?
			
		end
    end
end
      
When /^I disable notifications of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Notifications/).when_present.click
		@browser.span(:text => /Disable Notifications/).when_present.click
		sleep(2)
		@browser.button(:name => /SVform:actionsPortlet_btnSubmit/).click
		sleep(30)
    end
end

Then /^I verify notifications of service "(.+)" in sg "(.+)" of host "(.+)" have been disabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		page.services_tab_element.when_present.click
		page.select_service_group(sg)
		@browser.table(:id => /SGVform:stackedNagiosPortlet_panelgridNotifications/).link(:text => /Disabled Services/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "1. SG -> verified with "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/).click
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present.click
		sleep(3)
		@browser.table(:id => /HGVform:nagiosPortlet_panelgridNotifications/).link(:text => /Disabled Services/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "2. HG -> verified with "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/).click
		@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present.click
		@browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_present.click
		sleep(3)
		@browser.table(:id => /frmNV:nagiosPortlet_panelgridNotifications/).link(:text => /Disabled Services/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "3. HG -> verified with "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/).click
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /notificationsDISABLED/, :text => /DISABLED/).exists?
		puts "4. Nagios -> "+@browser.div(:class => /notificationsDISABLED/, :text => /DISABLED/).text
    end
end

Then /^I acknowledge the service problem$/ do
    on StatusviewerPage do |page|
		sleep(65)
		@browser.span(:text => /Acknowledge/).click
		sleep(1)
		@browser.span(:text => /Acknowledge Problem/).click
		sleep(1)
		@browser.textarea(:name => /SVform:actionsPortlet_txtComment/, :id => /SVform:actionsPortlet_txtComment/).set "Ack sent by QA"
		@browser.button(:name => /SVform:actionsPortlet_btnSubmit/).click
    end
end

When /^I enable notifications of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Notifications/).when_present.click
		@browser.span(:text => /Enable Notifications/).when_present.click
		sleep(2)
		@browser.button(:name => /SVform:actionsPortlet_btnSubmit/).click
		sleep(20)
    end
end

Then /^I verify notifications of service "(.+)" in sg "(.+)" of host "(.+)" have been enabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		page.services_tab_element.when_present.click
		@browser.span(:text => sg).when_present.click
		@browser.td(:id => /SGVform:SGVpanel4-0-0/).link(:text => /Ok/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "1. Verified on SG summary page:  "+@browser.span(:text => service).text
		@browser.button(:value => /close window/).click
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.table(:id => /HGVform:HGVpanel8/).link(:text => /Ok/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "2. Verified on HG summary page:  "+@browser.span(:text => service).text
		@browser.button(:value => /close window/, :name => /HGVform:cmdCloseWindow/).click
		@browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_present.click
		sleep(3)
		@browser.table(:id => /frmNV:networkViewPortlet_panel5/).link(:text => /Ok/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "3. Verified on Entire Network page:  "+@browser.span(:text => service).text
		@browser.button(:value => /close window/, :name => /frmNV:cmdCloseWindow/).click
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /notificationsENABLED/, :text => /ENABLED/).exists?
		puts "4. Nagios -> "+@browser.div(:class => /notificationsENABLED/, :text => /ENABLED/).text
    end
end

When /^I disable flap detection of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Settings/).when_present.click
		@browser.span(:text => /Disable Flap Detection/).when_present.click
		sleep(2)
		@browser.button(:value => /Submit/, :name => /SVform:actionsPortlet_btnSubmit/).click
    end
end

Then /^I verify flap detection of service "(.+)" in sg "(.+)" of host "(.+)" have been disabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /flapdetectionDISABLED/, :text => /DISABLED/).exists?
		
    end
end

When /^I enable flap detection of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Settings/).when_present.click
		@browser.span(:text => /Enable Flap Detection/).when_present.click
		sleep(2)
		@browser.button(:value => /Submit/, :name => /SVform:actionsPortlet_btnSubmit/).click
    end
end

Then /^I verify flap detection of service "(.+)" in sg "(.+)" of host "(.+)" have been enabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /flapdetectionENABLED/, :text => /ENABLED/).exists?
		
    end
end

When /^I disable active checks of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Settings/).when_present.click
		@browser.span(:text => /Disable Active Checks on Service/).when_present.click
		sleep(2)
		@browser.button(:value => /Submit/).click
    end
end

Then /^I verify active checks of service "(.+)" in sg "(.+)" of host "(.+)" have been disabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).exists?
		puts "1. Nagios -> "+@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).text
		visit StatusviewerPage
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present.click
		sleep(2)
		@browser.table(:id => /HGVform:nagiosPortlet_panelgridActiveChecks/).link(:text => /Disabled Service/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "2. Verified on HG summary page:  "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/, :name => /HGVform:nagiosPortlet_btnClose/).click
		@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present.click
		page.services_tab_element.when_present.click
		@browser.span(:text => sg).when_present.click
		@browser.table(:id => /SGVform:stackedNagiosPortlet_panelgridActiveChecks/).link(:text => /Disabled Service/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "3. Verified on SG summary page:  "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/).click
		@browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_present.click
		sleep(3)
		@browser.table(:id => /frmNV:nagiosPortlet_panelgridActiveChecks/).link(:text => /Disabled Service/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "4. Verified on Entire Network page:  "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/, :name => /frmNV:nagiosPortlet_btnClose/).click
	
    end
end

When /^I enable active checks of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Settings/).when_present.click
		@browser.span(:text => /Enable Active Checks on Service/).when_present.click
		sleep(2)
		@browser.button(:value => /Submit/, :name => /SVform:actionsPortlet_btnSubmit/).click
    end
end

Then /^I verify active checks of service "(.+)" in sg "(.+)" of host "(.+)" have been enabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /checksENABLED/, :text => /ENABLED/).exists?
		puts "Nagios -> "+@browser.div(:class => /checksENABLED/, :text => /ENABLED/).text
	
    end
end

When /^I disable passive checks of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Settings/).when_present.click
		@browser.span(:text => /Disable Passive Checks/).when_present.click
		sleep(2)
		@browser.button(:value => /Submit/, :name => /SVform:actionsPortlet_btnSubmit/).click
    end
end

Then /^I verify passive checks of service "(.+)" in sg "(.+)" of host "(.+)" have been disabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).exists?
		puts "1. Nagios -> "+@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).text
		visit StatusviewerPage
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present.click
		sleep(2)
		@browser.table(:id => /HGVform:nagiosPortlet_panelgridPassiveChecks/).link(:text => /Disabled Service/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "2. Verified on HG summary page:  "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/, :name => /HGVform:nagiosPortlet_btnClose/).click
		@browser.span(:text => /Events, Nagios Statistics & Host List/).when_present.click
		page.services_tab_element.when_present.click
		@browser.span(:text => sg).when_present.click
		@browser.table(:id => /SGVform:stackedNagiosPortlet_panelgridPassiveChecks/).link(:text => /Disabled Service/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "3. Verified on SG summary page:  "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/).click
		@browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_present.click
		sleep(3)
		@browser.table(:id => /frmNV:nagiosPortlet_panelgridPassiveChecks/).link(:text => /Disabled Service/).when_present.click
		sleep(2)
		@browser.span(:text => service).exists?
		puts "4. Verified on Entire Network page:  "+@browser.span(:text => service).text
		@browser.button(:value => /Close Window/, :name => /frmNV:nagiosPortlet_btnClose/).click
	
    end
end

When /^I enable passive checks of the service$/ do
    on StatusviewerPage do |page|
		@browser.span(:text => /Settings/).when_present.click
		@browser.span(:text => /Enable Passive Checks/).when_present.click
		sleep(2)
		@browser.button(:value => /Submit/, :name => /SVform:actionsPortlet_btnSubmit/).click
    end
end

Then /^I verify passive checks of service "(.+)" in sg "(.+)" of host "(.+)" have been enabled$/ do |service,sg,host|
	on StatusviewerPage do |page|
		
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /checksENABLED/, :text => /ENABLED/).exists?
		puts "Nagios -> "+@browser.div(:class => /checksENABLED/, :text => /ENABLED/).text
    end
end

When /^I select service group "(.+)" on status viewer page$/ do |sg|
    on StatusviewerPage do |page|
		page.services_tab_element.when_present(60).click
		@browser.span(:text => sg).when_present(60).click
		sleep(2)
    end
end

When /^I schedule "(.+)" downtime for all services with comment "(.+)" and time "(.+)"$/ do |option,comment,time|
    on StatusviewerPage do |page|
		
		page.downtime_element.when_present.click
		@browser.span(:text => /Schedule Downtime For All Services/).click
		sleep(3)
		@browser.textarea(:name => /SGVform:actionsPortlet_txtComment/).set comment
		@browser.select(:name => /SGVform:actionsPortlet_menuType/).select option
		if option == 'Flexible'
			@browser.text_field(:name => /SGVform:actionsPortlet_txtHours/).set time
			@browser.text_field(:name => /SGVform:actionsPortlet_txtMinutes/).set time	
		elsif option == 'Fixed'
			# in Fixed Downtime the time cannot be set. 
		end	
		@browser.button(:name => /SGVform:actionsPortlet_btnSubmit/).when_present.click
		sleep(20)
    end
end


Then /^I verify "(.+)" downtime of the service "(.+)" of host "(.+)"$/ do |option,service,host|
    on StatusviewerPage do |page|
		sleep(15)
		@browser.link(:name => /frmTree:pnlTbSet:0.0/).when_present.click
		sleep(15)
		page.select_hostname(host)
		page.select_service(service)
		sleep(2)	
		if option=='Fixed'
			@browser.span(:id => /SVform:SItxtServiceDowntimeValue/, :text => /Yes/).when_dom_changed.exists?
			@browser.span(:text => /This service has been scheduled for fixed downtime/).when_dom_changed.exists?
			page.navigate_service_page_nagios(host,service)
			@browser.div(:class => /downtimeACTIVE/, :text => /YES/).when_present(150).exists?			
			@browser.td(:class => /commentOdd/, :text => /This service has been scheduled for fixed downtime/).when_present(150).exists?
		elsif option=='Flexible'
			@browser.span(:text => /This service has been scheduled for flexible downtime/).when_dom_changed.exists?
			page.navigate_service_page_nagios(host,service)
			@browser.td(:class => /commentOdd/, :text => /This service has been scheduled for flexible downtime/).when_present(150).exists?
		end
    end
end

When /^I "(.+)" notifications of all services$/ do |state|
    on StatusviewerPage do |page|
		sleep(3)
		@browser.span(:text => /Notifications/).when_present(45).click
		sleep(1)
		if state == "disable"
		@browser.span(:text => /Disable notifications for all Services/).click
		elsif state == "enable"
		@browser.span(:text => /Enable notifications for all Services/).click
		end
		sleep(3)
		@browser.button(:value => /Submit/).click
		sleep(25)
    end
end

Then /^I verify notifications of service "(.+)" of host "(.+)" have been "(.+)"$/ do |service,host,option|
	on StatusviewerPage do |page|	
		page.navigate_service_page_nagios(host,service)
		if option=="disabled"
		@browser.div(:class => /notificationsDISABLED/, :text => /DISABLED/).when_present(45).exists?
		puts "Nagios -> "+@browser.div(:class => /notificationsDISABLED/, :text => /DISABLED/).text
		elsif option=="enabled"
		@browser.div(:class => /notificationsENABLED/, :text => /ENABLED/).when_present(60).exists?
		puts "Nagios -> "+@browser.div(:class => /notificationsENABLED/, :text => /ENABLED/).text
		end
    end
end

When /^I "(.+)" active checks of all services of the "(.+)"$/ do |state,group|
    on StatusviewerPage do |page|
		sleep(3)
		@browser.span(:text => /Settings/).when_present(45).click
		sleep(2)
		if state == "disable"
			@browser.span(:text => /Disable Active Checks for all Services/).click
		else state == "enable"
			@browser.span(:text => /Enable Active Checks for all Services/).click
		end
		sleep(3)
		@browser.button(:value => /Submit/).click
		sleep(70)
    end
end

Then /^I verify active checks of service "(.+)" of host "(.+)" have been "(.+)"$/ do |service,host,option|
	on StatusviewerPage do |page|
		if option=="disabled"
		page.navigate_service_page_nagios(host,service)
		@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).when_present(45).exists?
		#puts "Nagios -> "+@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).text
		puts "Nagios -> DISABLED"
		elsif option=="enabled"
		page.navigate_service_page_nagios("qa-ubuntu-12-4-64","local_cpu_httpd")
		@browser.div(:class => /checksENABLED/, :text => /ENABLED/).exists?
		#puts "Nagios -> "+@browser.div(:class => /checksENABLED/, :text => /ENABLED/).text
		puts "Nagios -> ENABLED"
		end
    end
end

Given /^I add the host "(.+)" to the new host group$/ do |host|
    @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /members_nonmembers/).select host
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /members_add_member/).click
end

Then /^I select a hostgroup "(.+)" on status viewer page$/ do |hostgroup|
	on StatusviewerPage do |page|
		@browser.span(:text => hostgroup).when_present.click
	end
end

When /^I schedule "(.+)" downtime for all "(.+)" with comment "(.+)" and time "(.+)"$/ do |option,object,comment,time|
    on StatusviewerPage do |page|
		page.downtime_element.when_present(45).click
		
		if object == "hosts"
		@browser.span(:text => /Schedule Downtime For All Hosts/).click
		elsif object == "services" 
		@browser.span(:text => /Schedule Downtime For All Services/).click
		end
		sleep(3)
		@browser.textarea(:name => /HGVform:actionsPortlet_txtComment/).set comment
		@browser.select(:name => /HGVform:actionsPortlet_menuType/).select option
		if option == 'Flexible'
			@browser.text_field(:name => /HGVform:actionsPortlet_txtHours/).set time
			@browser.text_field(:name => /HGVform:actionsPortlet_txtMinutes/).set time	
		elsif option == 'Fixed' 
			# in Fixed Downtime the time cannot be set.
		end	
		@browser.button(:name => /HGVform:actionsPortlet_btnSubmit/).when_present.click
	sleep(30)	
    end
end

Then /^I verify "(.+)" downtime for the host "(.+)"$/ do |option,host|
    on StatusviewerPage do |page|
	
		if option=='Fixed'	
			page.select_hostname(host)
			sleep(3)
			page.downtime_value == "Yes"
			@browser.span(:text => /Comments/).when_dom_changed.click
			sleep(3)
			@browser.span(:text => /This host has been scheduled for fixed downtime/).when_present(45).exists?
			#puts @browser.span(:text => /This host has been scheduled for fixed downtime/).text
			@browser.span(:text => /Comments/).when_dom_changed.click
			page.navigate_host_page_nagios(host)
			@browser.div(:class => /downtimeACTIVE/, :text => /YES/).exists?
			@browser.td(:class => /commentOdd/, :text => /This host has been scheduled for fixed downtime/).when_present(45).exists?
			
		elsif option=='Flexible'	
			page.select_hostname(host)
			sleep(3)
			@browser.span(:text => /Comments/).when_dom_changed.click
			sleep(2)
			@browser.span(:text => /This host has been scheduled for flexible downtime/).when_present(45).exists?
			#puts @browser.span(:text => /This host has been scheduled for flexible downtime/).text
			@browser.span(:text => /Comments/).when_dom_changed.click
			page.navigate_host_page_nagios(host)
			@browser.td(:class => /commentOdd/, :text => /This host has been scheduled for flexible downtime/).when_present(45).exists?
		end
    end
end

When /^I "(.+)" notifications of all hosts$/ do |state|
    on StatusviewerPage do |page|
		sleep(2)
		@browser.span(:text => /Notifications/).when_present(45).click
		sleep(1)
		if state == "disable"
		@browser.span(:text => /Disable notifications for all Hosts/).when_present(45).click
		elsif state == "enable"
		@browser.span(:text => /Enable notifications for all Hosts/).when_present(45).click
		end
		sleep(3)
		@browser.button(:value => /Submit/).click
		sleep(25)
    end
end


Then /^I verify notifications are "(.+)" for the host "(.+)"$/ do |option,host|
    on StatusviewerPage do |page|
		page.navigate_host_page_nagios(host)
		if option=='disabled'						
			@browser.div(:class => /notificationsDISABLED/, :text => /DISABLED/).when_present(45).exists?
		elsif option=='enabled'
			@browser.div(:class => /notificationsENABLED/, :text => /ENABLED/).when_present(45).exists?
		end
    end
end

Then /^I verify active checks of the service "(.+)" of host "(.+)" have been "(.+)"$/ do |service,host,option|
	on StatusviewerPage do |page|
		page.navigate_service_page_nagios(host,service)
		sleep(10)
		if option=="disabled"	
		@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).exists?
		puts "Nagios -> "+@browser.div(:class => /checksDISABLED/, :text => /DISABLED/).text
		elsif option=="enabled"
		@browser.div(:class => /checksENABLED/, :text => /ENABLED/).exists?
		puts "Nagios -> "+@browser.div(:class => /checksENABLED/, :text => /ENABLED/).text
		end
    end
end

When /^I verify that service "(.+)" is added to service group "(.+)" on Status Viewer page$/ do |service,sg|
    on StatusviewerPage do |page|
		sleep(10)
		@browser.span(:text => /#{service}/).exists?.should == true
		puts @browser.span(:text => /#{service}/).text
    end
end

When /^I should verify that service "(.+)" is removed from service group on Status Viewer page$/ do |serv|
    on StatusviewerPage do |page|
		sleep(10)
		@browser.td(:id => /j_id6-0-0/).span(:text => /#{serv}/).exists?.should == true
    end
end

 And /^remove acknowledgement of problem$/ do
	on StatusviewerPage do |page|
		page.acknowledge_element.when_present(100).click
		sleep(2)
		page.remove_acknowledge_element.when_dom_changed.click
		sleep(3)
		page.submit_ack_element.when_present.click
	end
end
 

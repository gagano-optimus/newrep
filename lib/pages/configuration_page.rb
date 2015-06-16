class ConfigurationPage
    include PageObject

    direct_url BASE_URL + "config"

    div :page_title, :class => "BreadcumbsInfoBar ClearFix"

    @@subtab_text = { "Services" => "Clone service", "Profiles" => "Profiles", "Hosts" => "Clone host", "Contacts" => "Contacts", "Escalations" => "Escalations", "Commands" => "New", "Time Periods" => "New", "Groups" => "New", "Control" => "Nagios cgi configuration", "Tools" => "Export to files", "Performance" => "Performance Configuration Administration", "Maintenance" => "Device Cleanup", "NoMa" => "Manage Notification Rules", "Configuration Reports" => "List commands", "Downtimes" => "You can add downtimes to your hostgroups", "Recurring Downtimes" => "Manage your recurring downtimes", "Device Cleanup" => "Device Cleanup", "Service Cleanup" => "Service Cleanup", "Externals Cleanup" => "Externals Cleanup", "Remove Unused Services" => "Remove unused services", "Close Events" => "Close events", "List Downtimes" => "Downtime", "Add Host Downtime" => "Add downtime by host and/or service", "Add Host Group Downtime" => "Add downtime by hostgroup, host and/or service", "Add Service Group Downtime" => "Add downtime by servicegroup, host and/or service"}

    def go_to_subtab(subtab)
        @browser.link(:text => /Configuration/).fire_event 'mouseover'
        @browser.link(:text => /#{subtab}/).when_present.click
    end
	
	def go_to_subtab_within(tab,subtab)
		@browser.link(:text => /Configuration/).fire_event 'mouseover'
		sleep(2)
		@browser.link(:text => /#{tab}/).fire_event 'mouseover'
		sleep(3)
		@browser.link(:text => /#{subtab}/).when_present.click
	end

    def check_subtab(subtab)
        self.wait_until(10) do
            self.page_title.include? subtab
            index = 1
            if subtab == "Commands" || subtab == "Time Periods" || subtab == "Groups"
                index = 0
            end
            if subtab == "Performance"
                @browser.frame(:id => "myframe").table.text.include? @@subtab_text[subtab]
            
			elsif subtab == "Maintenance" || subtab == "Configuration Reports" || subtab == "Downtimes" || subtab =="Recurring Downtimes"
                @browser.frame.div(:id => "content").text.include? @@subtab_text[subtab]
            
			elsif subtab == "NoMa"
                @browser.frame(:id => "myframe").div(:id => "application").text.include? @@subtab_text[subtab]
			
			elsif subtab == "Profiles" || subtab == "Contacts" || subtab == "Escalations"
                @browser.frame(:id => "myframe").frame(:name => "monarch_left").td(:class => "row2").text.include? @@subtab_text[subtab]
			
			elsif subtab == "Device Cleanup" || subtab == "Service Cleanup" || subtab == "Externals Cleanup" || subtab == "Remove Unused Services" || subtab == "Close Events" || subtab == "List Downtimes" || subtab == "Add Host Downtime" || subtab == "Add Host Group Downtime" || subtab == "Add Service Group Downtime"
				
				@browser.frame(:id => "myframe").div(:id => "content").text.include? @@subtab_text[subtab]
            
			else
                @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:class => "left", :index => index).text.include? @@subtab_text[subtab]
			
            end
        end
    end

end

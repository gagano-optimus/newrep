Given /^I am on the Cloud Hub page$/ do
    visit CloudHubPage
end

When /^I select "(.+)" for new connection$/ do |connection|
	if connection == "RedHat"
	@browser.frame(:id => "myframe").link(:href => /rhev/, :class => /button-l/).click
	else
	connection = connection.downcase
	@browser.frame(:id => "myframe").link(:href => /#{connection}/, :class => /button-l/).click
=begin
	on CloudHubPage do |page|
		#Modification
		#page.vmware_element.when_present.set
		#page.add_element.when_present.click
		page.add_vmware_element.when_present.click
	end
=end
	end
	sleep(3)
end

#Modification -- regarding wsuser password , (.+) -> (.*?)
When /^I start new configuration and set all fields as "(.*?)","(.*?)","(.*?)","(.*?)","(.*?)","(.*?)","(.*?)","(.*?)"$/ do |displayname,gwserver,wsuser,passwd,vmserver,username,pwd,interval|
	on CloudHubPage do |page|
		page.display_name = displayname
		page.groundwork_server = gwserver
		page.wsuser_name = wsuser
		page.wsuser_password = passwd
		page.server_name = vmserver
		page.username = username
		page.password = pwd
		page.interval = interval
	end
end

When /^I select the Storage View, Network View and Resource Pool View$/ do
	on CloudHubPage do |page|
		page.storage_view_element.set
		page.network_view_element.set
		page.resource_view_element.set
	end
end


When /^I save the connection$/ do
	on CloudHubPage do |page|
		page.save_element.when_present.click
		sleep(3)
	end
end

	

When /^test connection is done$/ do
	on CloudHubPage do |page|
		page.test_connection_element.wait_until_present
		page.test_connection_element.when_present.click
		sleep(3)
	end
end

And /^verify connection is established$/ do
		Watir::Wait.until {
		@browser.frame(:id => "myframe").div(:id => /testConResultMsg/).text.include? 'Connection successful!'
		}
end

And /^I navigate to cloud hub home page$/ do
	on CloudHubPage do |page|
		page.home_element.when_present.click
	end
end


Then /^I should navigate to the home page$/ do
	on CloudHubPage do |page|
		page.home.click
	end
end

 
And /^I delete the connection - "(.+)" created$/ do |name|

=begin	on CloudHubPage do |page|
		page.delete_element.when_present.click
		page.wait_until(5) do
			@browser.alert.ok
		end
	end
=end
	$table = @browser.frame(:id => /myframe/).table(:id => /example/, :class => /display dataTable/)	
	table_row = $table.td(:text => name).parent
	table_row.button(:value => /Delete/).click
	sleep(2)
	@browser.alert.ok
	sleep(5)
                
end
 

Then /^the connection - "(.+)" added should be in Stop state$/ do |name|
	#@browser.frame(:id => "myframe").td(:class => /serverStatusCol/).div(:class => /redcircle/).click
	$table = @browser.frame(:id => /myframe/).table(:id => /example/, :class => /display dataTable/)
	table_row = $table.td(:text => name).parent
	table_row.button(:value => /Start/).exists?.should == true	
		
end		


Given /^I start the new connection - "(.+)" created$/ do |name|
=begin	
on CloudHubPage do |page|
		page.startconnection_element.when_present.click
		sleep(5)
	end
=end
	$table = @browser.frame(:id => /myframe/).table(:id => /example/, :class => /display dataTable/)
	table_row = $table.td(:text => name).parent
	table_row.button(:value => /Start/).click
	sleep(10)
	
end


Then /^connection - "(.+)" should be started$/ do |name|
=begin	
on CloudHubPage do |page|
		page.green_element.exists?.should == true
	end
=end
	table_row = $table.td(:text => name).when_present.parent
	table_row.button(:value => /Stop/).exists?.should == true	
end	

#26
Then /^ESX-Vermont servers should be displayed on the Status viewer and Event console page$/ do
	sleep(240)
	visit StatusviewerPage
	on StatusviewerPage do |page|
	
		#@browser.frame(:id => "myframe").link(:id => "frmTree:pnlTbSet:0:hstTree:n-3:lnkNdClick").span(:text => /ESX:bernina.groundwork.groundworkopensource.com/).exists?.should == true
		#page.wait_until(360) do
			page.esx_bernina_element.exists?.should == true
			page.esx_morges_element.exists?.should == true
			page.esx_thun_element.exists?.should == true
			page.esx_wil_element.exists?.should == true
			page.esx_zurich_element.exists?.should == true
			page.esx_vssvermont_element.exists?.should == true
		#end
		
		end

		visit EventconsolePage
		on EventconsolePage do |page|
		page.host_groups_events_element.when_present.click
		sleep(10)
		page.esx_bernina_element.exists?.should == true
		page.esx_morges_element.exists?.should == true
		page.esx_thun_element.exists?.should == true
		page.esx_wil_element.exists?.should == true
		page.esx_zurich_element.exists?.should == true
		page.vssvermont_element.exists?.should == true
	end			
end	


When /^I click modify button of connection - "(.+)"$/ do |name|
=begin	
on CloudHubPage do |page|
		page.modify_element.when_present.click
	end
=end
	$table = @browser.frame(:id => /myframe/).table(:id => /example/, :class => /display dataTable/)	
	table_row = $table.td(:text => name).parent
	table_row.button(:value => /Modify/).click
end


When /^I click next button$/ do
	on CloudHubPage do |page|
		page.next_element.when_present.click
	end
end


When /^verify Cloud Hub Configuration page for "(.*?)" should be opened$/ do |connection|
	if connection == "RedHat"
	@browser.frame(:id => /myframe/).p(:text => /CloudHub Configuration wizard for RHEV-M/).exists?.should == true
	else	
	@browser.frame(:id => /myframe/).p(:text => /#{"Cloud Hub Configuration wizard for "+connection}/).when_present.exists?.should == true	
	end
=begin	
	on CloudHubPage do |page|
		page.cloudhub_element.exists?.should == true
	end
=end	
end

When /^I click delete button$/ do
	on CloudHubPage do |page|
		page.delete_element.when_present.click
		page.wait_until(5) do
			@browser.alert.ok
		end
	end
end

Then /^verify connection - "(.+)" should be deleted$/ do |name|
	table_row = $table.td(:text => name).exists?.should == false
=begin	
on CloudHubPage do |page|
	page.wait_until(10) do
		page.testconnection_element.exists?.should == false
	end	
	end
=end	
end


When /^I select one "(.+)" service "(.+)" and set thresholds as "(.+)" and "(.+)"$/ do |type,service,warning,critical|
	sleep(5)
	if type == "Hypervisor" 	
		@browser.frame(:id => /myframe/).checkbox(:id => /hyp_monitored_5/).when_present.set
		@browser.frame(:id => /myframe/).text_field(:id => /hyp_warningThreshold_5/).when_present.set warning
		@browser.frame(:id => /myframe/).text_field(:id => /hyp_criticalThreshold_5/).when_present.set critical
		$Service1 = service
		$Warning = warning
		$Critical = critical
	else
		@browser.frame(:id => /myframe/).checkbox(:id => /vm_monitored_18/).when_present.set
		@browser.frame(:id => /myframe/).text_field(:id => /vm_warningThreshold_18/).when_present.set warning
		@browser.frame(:id => /myframe/).text_field(:id => /vm_criticalThreshold_18/).when_present.set critical
		$Service1 = service
		$Warning = warning
		$Critical = critical
	end
end


And /^I remove one "(.+)" service "(.+)"$/ do |type,service|
	if type == "Hypervisor"	
		@browser.frame(:id => /myframe/).checkbox(:id => /hyp_monitored_4/).clear
		$Service = service
	else
		@browser.frame(:id => /myframe/).checkbox(:id => /vm_monitored_17/).clear
		$Service = service
	end
end

When /^save it$/ do
	on CloudHubPage do |page|
		page.save_element.when_present.click
		sleep(10)
	end
end


Then /^verify changes are done to "(.+)" on Status viewer page$/ do |type|
sleep(60)
 visit StatusviewerPage	
	if type == "Hypervisor"
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:32/).click
		sleep(3)
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:32-23/).click
		sleep(10)
		@browser.link(:text => /#{$Service1}/).click
		sleep(5)
		@browser.span(:id => /SVform:SItxtServiceStatusValue/, :text => /#{"W\/C="+$Warning+"\/"+$Critical}/).exists?.should == true
		@browser.link(:text => /#{$Service}/).exists?.should == false
		
	else
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:5/).click
		sleep(3)
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:5-0/).click
		sleep(15)
		@browser.link(:text => /#{$Service1}/).click
		sleep(5)
		@browser.span(:id => /SVform:SItxtServiceStatusValue/, :text => /#{"W\/C="+$Warning+"\/"+$Critical}/).exists?.should == true
		@browser.link(:text => /#{$Service}/).exists?.should == false
		
	end
	
end



When /^I select a vm service "(.+)"$/ do |service|
		on CloudHubPage do |page|
		page.vm_service_element.when_present.set
end

end

=begin
Then /^verify vm changes are done on Status viewer page$/ do
      sleep(100)
	   visit StatusviewerPage	
		on StatusviewerPage do |page|		
		page.esx_zurich_element.click
		sleep(2)
		page.bern_host_machine_element.click
		sleep(3)
		#page.cpu_uptime_element.exists?.should==true
		page.cpu_uptime_element.exists?.should==true
		sleep(3)

	   end
end
=end

When /^I select RedHat for new connection$/ do
	on CloudHubPage do |page|
		#page.redhat_element.when_present.set
		#page.add_element.click
		#sleep(3)
		page.add_redhat_element.when_present.click
	end
end


When /^I start new redhat configuration and set all fields as "(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)"$/ do |displayname,gwserver,wsuser,wsuser_passwd,rhserver,entrypoint,rhpwd,storepath,passcode,check_interval,sync_interval|
	on CloudHubPage do |page|
		page.rh_display_name = displayname
		page.rh_groundwork_server = gwserver
		page.wsuser_name = wsuser
		page.wsuser_password = wsuser_passwd
		page.server_name = rhserver
		page.rh_entrypoint = entrypoint
		page.rh_password = rhpwd
		page.rh_storepath = storepath
		page.rh_passcode = passcode
		page.rh_check_interval = check_interval
		page.rh_sync_interval = sync_interval
	end
end

		
	
Then /^rhev servers should be displayed on the Status viewer and Event console page$/ do
=begin	
sleep(600)
	visit StatusviewerPage
	on StatusviewerPage do |page|
	
		#page.wait_until(360) do
			page.rhev_vm_element.exists?.should == true
			page.rhev_m_element.exists?.should == true
		#end
	end
=end
		visit EventconsolePage
		on EventconsolePage do |page|
		page.host_groups_events_element.when_present.click
		sleep(5)		
		page.rhev_m_element.exists?.should == true
		page.rhev_vm_element.exists?.should == true
	end			
end			
		
=begin		
When /^verify Cloud Hub Configuration page for RHEVM should be opened$/ do
	on CloudHubPage do |page|
		page.wait_until(5) do
		page.rh_cloudhub_element.exists?.should == true
		end	
	end
end		
=end		
		
		
		
		
		
		#---------------------
	

When /^I move to next page$/ do
	on CloudHubPage do |page|
		page.next_element.click
		sleep(10)
	end
end


When /^I enter value in hypervisor warning threshold and critical threshold as"(.+)","(.+)"$/ do |hyp_warning_threshold,hyp_critical_threshold|
	on CloudHubPage do |page|
		page.hyp_warning_threshold = hyp_warning_threshold
		page.hyp_critical_threshold = hyp_critical_threshold
	end
end

When /^I enter value in vm warning threshold and critical threshold as"(.+)","(.+)"$/ do |vm_warning_threshold,vm_critical_threshold|
	on CloudHubPage do |page|
		page.vm_warning_threshold = vm_warning_threshold
		page.vm_critical_threshold = vm_critical_threshold
	end
end


And /^threshold validation messages should be displayed$/ do
		Watir::Wait.until {
		@browser.frame(:id => "myframe").div(:id => /controlbg/).text.include? 'Not a valid number.'
		}
end




Then /^verify connection is not established$/ do
       sleep(3)
		@browser.frame(:id => "myframe").div(:text => /GWOS connection failed!/).exists?.should==true
		on CloudHubPage do |page|
		page.next_element.should be_disabled
	end
		
		#@browser.frame(:id => "myframe").div(:id => /testConResultMsg/).text.include? 'RHEV-M server connection failed!' or 'GWOS connection failed!'	
end	


#Then /^verify red hat connection is not established$/ do
 #      sleep(3)
	#	@browser.frame(:id => "myframe").div(:text => /RHEV-M server connection failed!/).exists?.should==true
#end	


Then /^different validation messages should appear$/ do
		Watir::Wait.until {
		@browser.frame(:id => "myframe").span(:text => /Display name cannot be empty./).exists?.should==true
		@browser.frame(:id => "myframe").span(:text => /Server name cannot be empty./).exists?.should==true
		@browser.frame(:id => "myframe").span(:text => /User name cannot be empty./).exists?.should==true
		@browser.frame(:id => "myframe").span(:text => /Password cannot be empty./).exists?.should==true
		@browser.frame(:id => "myframe").span(:text => /Not a valid check interval/).exists?.should==true
		@browser.frame(:id => "myframe").span(:text => /Not a valid retry interval/).exists?.should==true
		}
		on CloudHubPage do |page|
		page.test_connection_element.should be_disabled
		sleep(3)
	end
end  


Then /^check interval validation message should be displayed$/ do
		Watir::Wait.until {
		@browser.frame(:id => "myframe").span(:text => /Not a valid check interval/).exists?.should==true
		}
end

#New steps to verify Views

Given /^I am on the Status page$/ do
	visit StatusviewerPage
end
	
Given /^I am on the Event page$/ do
	visit EventconsolePage
end
	
Given /^I verify the "(.+?)" hosts on Status viewer page$/ do |view|
	on StatusviewerPage do |page|
		sleep(5)
		page.status_verify(view)
	end
end
Then /^the hosts should be visible$/ do

end

Given /^I verify the "(.+?)" hosts on Event console page$/ do |view|		
	on EventconsolePage do |page|
		page.host_groups_events_element.when_present.click
		sleep(5)
		page.event_status_verify(view)
	end
end

And /^I delete all other connections created$/ do
	while @browser.frame(:id => /myframe/).button(:value => /Delete/).exists?
		@browser.frame(:id => /myframe/).button(:value => /Delete/).click
		sleep(2)
		@browser.alert.ok
		sleep(3)
	end
end

#Openstack
$OS
When /^I start new configuration and set fields as "(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)"$/ do |displayname,gwserver,wsuser,passwd,oserver,tenant_id,tenant_name,username,pwd,nova_port,keystone_port,ceilometer_port,check_interval,connection_retries|
on CloudHubPage do |page|
		page.display_name = displayname
		page.groundwork_server = gwserver
		page.wsuser_name = wsuser
		page.wsuser_password = passwd
		page.server_name = oserver
		page.tenant_id = tenant_id
		page.tenant_name = tenant_name
		page.username = username
		page.password = pwd
		page.nova_port = nova_port
		page.keystone_port = keystone_port
		page.ceilometer_port = ceilometer_port
		page.interval = check_interval
		page.connection_retries = connection_retries
	end
$OS = oserver[0...25]
end

Then /^OS-H and OS-M servers should be displayed on the Status viewer and Event console page$/ do
sleep(60)
visit StatusviewerPage
		visit StatusviewerPage
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree/, :text => /#{"OS-H:"+$OS}/).exists?.should == true
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree/, :text => /#{"OS-M:"+$OS}/).exists?.should == true
		

		visit EventconsolePage
	
		on EventconsolePage do |page|
		page.host_groups_events_element.when_present.click
		sleep(7)
		end
		@browser.link(:text => /#{"OS-H:"+$OS}/).exists?.should == true
		@browser.link(:text => /#{"OS-M:"+$OS}/).exists?.should == true			
end	

Then /^I verify Openstack connection is not established$/ do
       sleep(3)
		@browser.frame(:id => "myframe").div(:text => /OpenStack server connection failed/).exists?.should==true
		#@browser.frame(:id => "myframe").div(:id => /testConResultMsg/).text.include? 'RHEV-M server connection failed!' or 'GWOS connection failed!'	
end

And /^I remove a "(.+)" service "(.+)"$/ do |type,service|
	if type == "Hypervisor"	
		@browser.frame(:id => /myframe/).checkbox(:id => /hyp_monitored_2/).clear
		$Service = service
	else
		@browser.frame(:id => /myframe/).checkbox(:id => /vm_monitored_1/).clear
		$Service = service
end
end

And /^I select "(.+)" service "(.+)" and set thresholds as "(.+)" and "(.+)"$/ do |type,service,warning,critical|
	if type == "Hypervisor"	
		@browser.frame(:id => /myframe/).checkbox(:id => /hyp_monitored_1/).when_present.set
		@browser.frame(:id => /myframe/).text_field(:id => /hyp_warningThreshold_1/).when_present.set warning
		@browser.frame(:id => /myframe/).text_field(:id => /hyp_criticalThreshold_1/).when_present.set critical
		$Service1 = service
		$Warning = warning
		$Critical = critical
	else
		@browser.frame(:id => /myframe/).checkbox(:id => /vm_monitored_2/).when_present.set
		@browser.frame(:id => /myframe/).text_field(:id => /vm_warningThreshold_2/).when_present.set warning
		@browser.frame(:id => /myframe/).text_field(:id => /vm_criticalThreshold_2/).when_present.set critical
		$Service1 = service
		$Warning = warning
		$Critical = critical
end
end

Then /^verify changes are applied for "(.+)" on Status viewer page$/ do |type|
sleep(60)
visit StatusviewerPage
	if type == "Hypervisor"
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:4/).click
		sleep(3)
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:4-0/).click
		sleep(3)
		@browser.link(:text => /#{$Service}/).exists?.should == false
		@browser.link(:text => /#{$Service1}/).click
		sleep(5)
		@browser.span(:id => /SVform:SItxtServiceStatusValue/, :text => /#{"W\/C="+$Warning+"\/"+$Critical}/).exists?.should == true
	else
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:3/).click
		sleep(3)
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:3-0/).click
		sleep(3)
		@browser.link(:text => /#{$Service}/).exists?.should == false
		@browser.link(:text => /#{$Service1}/).click
		sleep(5)
		@browser.span(:id => /SVform:SItxtServiceStatusValue/, :text => /#{"W\/C="+$Warning+"\/"+$Critical}/).exists?.should == true
	end

end

And /^I clear all fields$/ do
on CloudHubPage do |page|
		page.display_name_element.clear()
		page.groundwork_server_element.clear()
		page.wsuser_name_element.clear()
		page.wsuser_password_element.clear()
		page.interval_element.clear()
		page.connection_retries_element.clear()
	end
end

#for redhat
And /^I clear all the fields$/ do
on CloudHubPage do |page|
		page.rh_display_name_element.clear()
		page.rh_groundwork_server_element.clear()
		page.wsuser_name_element.clear()
		page.wsuser_password_element.clear()
		page.interval_element.clear()
		page.connection_retries_element.clear()
	end
end

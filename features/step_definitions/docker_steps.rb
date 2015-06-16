When /^I start new docker configuration and set all fields as "(.*?)","(.*?)","(.*?)","(.*?)","(.*?)","(.*?)","(.*?)","(.*?)"$/ do |displayname,gwserver,wsuser,passwd,docker_server,prefix,check_interval,connection_retries|
	on CloudHubPage do |page|
		page.display_name = displayname
		page.groundwork_server = gwserver
		page.wsuser_name = wsuser
		page.wsuser_password = passwd
		page.app_server = docker_server
		page.conn_prefix = prefix
		page.interval = check_interval
		page.connection_retries = connection_retries
	end
end


And /^servers should be displayed on the Status viewer and Event console with host prefix "(.+)"$/ do |prefix|
sleep(75)
visit StatusviewerPage
#server_id = @browser.div(:id => /frmTree:pnlTbSet:0:hstTree-d-root-c/).span(:text => /DOCK-H:/).id
#puts server_id
@browser.div(:id => /frmTree:pnlTbSet:0:hstTree-d-root-c/).span(:text => /DOCK-H:/).when_present.click
sleep(5)
@browser.div(:id => /frmTree:pnlTbSet:0:hstTree-d-root-c/).span(:text => /#{prefix}/).when_present.click
#server.include? (/#{prefix}/)


end

When /^I select a "(.+)" service "(.+)" and set thresholds as "(.+)" and "(.+)"$/ do |type,service,warning,critical|
	sleep(5)
	if type == "Docker Engine"
		@browser.frame(:id => /myframe/).checkbox(:id => /hyp_monitored_1/).when_present.set
		@browser.frame(:id => /myframe/).text_field(:id => /hyp_warningThreshold_1/).when_present.set warning
		@browser.frame(:id => /myframe/).text_field(:id => /hyp_criticalThreshold_1/).when_present.set critical
		$Service1 = service
		$Warning = warning
		$Critical = critical
	else
		@browser.frame(:id => /myframe/).checkbox(:id => /vm_monitored_1/).when_present.set
		@browser.frame(:id => /myframe/).text_field(:id => /vm_warningThreshold_1/).when_present.set warning
		@browser.frame(:id => /myframe/).text_field(:id => /vm_criticalThreshold_1/).when_present.set critical
		$Service1 = service
		$Warning = warning
		$Critical = critical
	end
end

Then /^I verify changes are done to "(.+)" on Status viewer page$/ do |type|
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
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:2/).click
		sleep(3)
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:2-0/).click
		sleep(3)
		@browser.link(:text => /#{$Service}/).exists?.should == false
		@browser.link(:text => /#{$Service1}/).click
		sleep(5)
		@browser.span(:id => /SVform:SItxtServiceStatusValue/, :text => /#{"W\/C="+$Warning+"\/"+$Critical}/).exists?.should == true
	end

end

And /^I remove "(.+)" service "(.+)"$/ do |type,service|
	if type == "Docker Engine"	
		@browser.frame(:id => /myframe/).checkbox(:id => /hyp_monitored_2/).clear
		$Service = service
	else
		@browser.frame(:id => /myframe/).checkbox(:id => /vm_monitored_4/).clear
		$Service = service
end
end


When /^the connection test-docker exists$/ do
		Watir::Wait.until {
		@browser.frame(:id => "myframe").div(:id => /example_wrapper/).text.include? 'test_docker'
		}
end


Then /^host prefix validation message should be displayed$/ do
		Watir::Wait.until {
		@browser.frame(:id => "myframe").div(:id => /testConResultMsg/).text.include? 'Please chose another prefix.'
		}
end


Then /^validation message should be displayed$/ do
		Watir::Wait.until {
		@browser.alert.exists?.should == true
		sleep(2)
		@browser.alert.ok
		}
end

$Odl
Given /^I am on the Net Hub page$/ do
    visit NetHubPage
end


When /^I start a new configuration and set all fields as "(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)","(.+)"$/ do |displayname,gwserver,wsuser,wsuserpwd,odlserver,username,pwd,interval|
	on NetHubPage do |page|
		page.display_name = displayname
		page.groundwork_server = gwserver
		page.odl_server = odlserver
		page.username = username
		page.password = pwd
		page.wsuser_name = wsuser
		page.wsuser_pwd = wsuserpwd
		page.interval = interval	
	end
$Odl = odlserver[0...11]
end


Then /^ODL-H and ODl-M servers should be displayed on the Status viewer and Event console page$/ do
		sleep(45)
		visit StatusviewerPage
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree/, :text => /#{"ODL-H:"+$Odl}/).exists?.should == true
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree/, :text => /#{"ODL-M:"+$Odl}/).exists?.should == true
=begin	
on StatusviewerPage do |page|
	
	$Odl	
			page.ODL_H_element.exists?.should == true
			page.ODL_M_element.exists?.should == true
			
		end
=end
		visit EventconsolePage
	
		on EventconsolePage do |page|
		page.host_groups_events_element.when_present.click
		sleep(10)
			#page.ODL_H_element.exists?.should == true
			#page.ODL_M_element.exists?.should == true
		end
	@browser.link(:text => /#{"ODL-H:"+$Odl}/).exists?.should == true
	@browser.link(:text => /#{"ODL-M:"+$Odl}/).exists?.should == true			
end		


Then /^error messages should be displayed$/ do
		Watir::Wait.until {
		@browser.frame(:id => "myframe").span(:text => /Not a valid number./).exists?.should==true
		}
end


And /^I add a "(.+)" service "(.+)"$/ do |type,service|
	if type == "Network Controller"	
		table = @browser.frame(:id => /myframe/).table(:id => /example/, :class => /display/)
		table_row = table.td(:text => service).parent
		table_row.checkbox(:id => /monitored/).set
		sleep(5)
		$Service = service
else
		@browser.frame(:id => /myframe/).checkbox(:id => /vm_monitored_1/).set
		$Service = service
end
end

Then /^I verify service is added to "(.+)" on the Status viewer page$/ do |type|
sleep(60)
visit StatusviewerPage
	if type == "Network Controller"
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:3/).click
		sleep(3)
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:3-0/).click
		sleep(3)
		@browser.link(:text => /#{$Service}/).exists?.should == true


	else
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:2/).click
		sleep(3)
		@browser.link(:id => /frmTree:pnlTbSet:0:hstTree:2-0/).click
		sleep(3)
		@browser.link(:text => /#{$Service}/).exists?.should == true
	end

end

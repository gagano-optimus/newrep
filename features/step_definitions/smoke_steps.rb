require 'net/http'
require 'open-uri'
require 'rest_client'
require 'nokogiri'

#Scenario: Validate license key
Given /^I am on Monitor Enterprise license page$/ do
    #on LicensePage do |page|		
    #end
	visit LicensePage
	sleep(3)
end

When /^I add the license key$/ do
	#visit LicensePage
    on LicensePage do |page|
	    page.license_element.clear
		sleep(2)		
        page.license_element.set '#Wed Apr 30 20:21:56 PDT 2014
property_param_11=HHTmbaiLHVTYbwiTdiJRVHiRbwJJHdiVwYsHwTFFFRsFiYiYVdTndiimwbdbVTbFiHssiLndaLwsbsmbHJsTTiRbJsLJwwLRJLVTJYLbnTJTVTbF
property_param_10=30819f300d06092a864886f70d010101050003818d0030818902818100d31e16fdccecabb8920cf9daf591097e8d2b20a977c6c6ec41b9d832d9b5d3114dc1aa6fb493191ddcbad07f081a8e6259a89bc3a536f060fe67c31702df544676dbc399ca6cf1ee830e4259500cee86a670676206a290603981028b7fe14e907157efe78ce2d0e364cea39f1058bf1427f3344336aab22858780943307b39750203010001
creationDate=1398914516390
startDate=1398816000000
property_param_9=
property_param_8=YnbTwbTVwYLiJJFsRaRYssJJwRFLnYadnbdFRRsadsJV
property_param_7=TnYVJYVLJaFsHHRbdTdabbLbwRmLnVLJbTJmRwaLJaiR
property_param_6=Habw
property_param_5=TmnR
property_param_4=nRYmiRLbsmdHLsbVJVnJFLmVVLFRTawmJmLYHJTFsVFamFsHbnYHssRbTnbRnTRTaYRJHRRiiRVTaYnHJJFFHHHHYVibsYYY
property_param_3=mR
property_param_2=FFHsTHYaRaHsdH
property_param_1=dniVHwwnYV
property_orderID=GroundWork-7.0.2-CORE
expireAfterFirstRun=1903910400000
signature=3e129876f23df350fd6573b3b567cc7cb08f21f08809b2789cd68e4328a668bc2e42aa132484897bac86864b7fc4379e25b8c4787a722dff67b27969a24addfb7c928292cb24ae58003bb11252760095ca702b313d20b6262e24080d913d982ef2761e45c159b0cbd2c4770f93bddb688fcfbb8fa37b5d4b1d64e5539ea3dd3a
expirationDate=1903910400000
property_param_12=YmJHYisaVYdRFRbLmiJnTJHdmmHYFYVaTwdLRiTTLRwaan'
		sleep(3)
		page.applylicense_element.click
		sleep(5)
		
	end
	
end

Then /^the license key should be validated$/ do
sleep(5)
visit DashboardPage
=begin
on LicensePage do |page|
    Watir::Wait.until {
        @browser.td(:text =>'Thank you for validating the license. Your license is activated now. Happy Monitoring!').exists?
		}
	visit AdministrationViewPage
	end
=end
end

#Scenario: Validate build number
When /^I select show install info$/ do
    on DashboardPage do |page|
    	#page.dashboard_element.when_present.click
    	sleep(2)
        page.show_install_info_element.when_present.click
    end
end

Then /^I should see the correct build number$/ do |build|
    on DashboardPage do |page|
        info_text = @browser.span(:id => "last_checked").p(:text => /PostgreSQL/).text.split("\n")
        name = info_text.grep(/^name/)[0].split("= ")[1]
        version = info_text.grep(/^version/)[0].split("= ")[1]

        name.should == NAME
        version.should == VERSION
    end
end

#Scenario: Auto Discovery

Given /^I specify a filter "(.+?)" of type "(.+?)" and a Range\/Filter Pattern "(.+?)"$/ do |filterName, type, range|
    on AutodiscoveryPage do |page|
        #page.delete_old_filters
        page.add_filter('include','test','172.28.113.160-170') 

        page.select_control_type
        page.check_range_filter_name
    end
end

Then /^no errors should appear for "(.+?)"$/ do |filterName|
    @browser.frame(:id => "myframe").text.include?('Success') 
end


#Scenario: Create Host and Service Group.
Given /^I am on the Host Configuration page$/ do
    	visit HostconfigurationPage 
end

Given /^I remove all hosts from the hosts groups except localhost$/ do
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Host groups/).when_present.click
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Modify/).when_present.click
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Linux Servers/).when_present.click
    $selectList = @browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present(15).select(:name => "members")
    $selectList.options.map(&:text).each { |element| 
        if element != "localhost"
            $selectList.when_present.select(element)
        end  
    }
    @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:value, "Remove >>").click
end

Given /^I create a new Host group "(.+?)"$/ do |groupName|
   	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Host groups/).when_present.click
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /New/ ).when_present.click
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /name/).when_present.set groupName
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /alias/).set groupName
end


Given /^I add the hosts except localhost to the new host group$/ do
    $selectList = @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /nonmembers/)
		$selectContent = $selectList.options.map(&:text).each { |element| 
        if element == "localhost"
            $host_array << element
            $selectList.select(element)
		end
    }
   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:value, /<< Add/).click
end

When /^I "(.*?)" the changes$/ do |arg1|
    @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, "#{arg1}").click
end

Then /^"(.*?)" changes were "(.*?)" correctly$/ do |arg1, arg2|
    @browser.frame(:id => "myframe").frame(:name => "monarch_main").text.include?("Changes to hostgroup \"#{arg1}\" have been #{arg2}.")
    @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, "continue").click
end

#Scenario Create Service group
Given /^I am on the Service Configuration page$/ do
	visit ServiceConfigurationPage
end


Given /^I create a new Service Group "(.+)"$/ do |group|
=begin
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Service groups/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /New/, :href => /service_groups&task=new/).when_present.click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /name/).when_present.set 'SG1'
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /alias/).set 'SG1'
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, /add/).click
		$selectList = @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /host/)
		$selectContent = $selectList.options.map(&:text).each { |element| 
        $selectList.select(element)
        }
=end

@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Service groups/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /New/, :href => /service_groups&task=new/).when_present.click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /name/).when_present.set group
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /alias/).set group
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, /add/).click
		
		#$selectListnew = @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /host/)
		
		#$selectContentnew = $selectListnew.options.map(&:text).each { |element| 
        	#$selectListnew.select(element)
		#}
	
		sleep(3)
		#@browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present.select(:name => /services/).select(/local_/)
			
end


Given /^I add the services to the new Service Group$/ do
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /host/).option(:text => /localhost/).when_present.select
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present.select(:name => /services/).option(:text => /local_/).when_present.select
		#@browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present.select(:name => /services/).select(/local_/)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, 'add_services').click
		
end

Then /^service group should be created sucessfully$/ do
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, /save/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, /continue/).click
		
end

When /^I delete the service group "(.+?)"$/ do |groupName|
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Service groups/).when_present.click
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Modify/ ).when_present.click
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /#{groupName}/).when_present.click 
end
	
Then /^the service group should be deleted$/ do
    @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, "delete").click
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, "confirm_delete").click
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, "continue").click
end

#Scenario: Commit changes to Nagios
Given /^I am on Control Configuration page$/ do
	visit ControlPage
end

When /^I commit new objects to Nagios$/ do
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Commit/).click
    @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, 'commit').when_present.click
    #Optimuscomment: For processing required after commit
    sleep(5)
end

Then /^the commit should be successful$/ do
    @browser.frame(:id => "myframe").text.include?('Success')
end

#Scenario: Apply Applications on Event Console
Given /^I am on the Event Console page$/ do
    visit EventconsolePage
end

When /^I apply the filter System under Applications$/ do
    on EventconsolePage do |page|
        @browser.div(:class => "iceTreeRow", :index => 1).link(:index => 0).when_present.click
        page.application_system_event_element.when_present.click
        page.wait_until do
            page.events_application_types_element.when_present.text == "Events by ApplicationTypes=SYSTEM" 
        end
    end
end

Then /^I should see no errors$/ do
    sleep(5)
    rows = @browser.div(:class => "tableStatus").span(:class => "iceOutFrmt").when_present.text.to_i 
    rows.times do |x|
        output = @browser.span(:id => /_monitorStatus/, :index => x).text
        if output == "OK"
            output.should == "OK"
        elsif output == "WARNING"
            output.should == "WARNING"
        else
            output.should == "WARNING"
        end
    end
end

When /^I apply the filter Nagios under Applications$/ do
    on EventconsolePage do |page|
        @browser.div(:class => "iceTreeRow", :index => 1).link(:index => 0).when_present.click
        page.application_nagios_event_element.when_present.click
        page.wait_until do
            page.events_application_types_element.when_present.text == "Events by ApplicationTypes=NAGIOS"
        end
    end
end

Then /^I should see there are events in this view$/ do
    on EventconsolePage do |page|
        page.number_showing_events_element.when_present.text.to_i.should >= 1
    end
end

#Scenario: Apply Host Groups on Event Console
When /^I apply the filter "(.*?)" under "(.*?)"$/ do |arg1, arg2|
    on EventconsolePage do |page|
        if arg2 == "Host Groups"
            @browser.div(:class => "iceTreeRow", :index => 2).link(:index => 0).when_present.click
        elsif arg2 == "Service Group"
            @browser.div(:class => "iceTreeRow", :index => 3).link(:index => 0).when_present.click
        else
            @browser.div(:class => "iceTreeRow", :index => 4).link(:index => 0).when_present.click
        end
        @browser.link(:text => /#{arg1}/).when_present.click
    end
end

#Scenario: Check no pending state on Status Viewer
Given /^I am on the Status Viewer page$/ do
    visit StatusviewerPage
end

When /^all Hosts and Service states are set up$/ do
    on StatusviewerPage do |page|
        page.wait_until(610) do
            page.state_pending? == false
        end
    end
end

Then /^all states should not be on PENDING$/ do
    on StatusviewerPage do |page|
        page.state_pending?.should == false
    end
end

#Scenario: Check RDD graphs
When /^I select a Host$/ do
    on StatusviewerPage do |page|
        page.select_host("HG1","#{$host_array[0]}", "Linux Servers")
    end
end

Then /^I should see the RRD shown$/ do
    on StatusviewerPage do |page|
        page.performance_filter_element.when_present(10).click
        page.wait_until(10) do
            if !page.host_graph_element.exists?
                page.performance_filter_element.when_present.click
            end
            page.host_graph_element.when_present
        end
    end
end

#Scenario: Check Cacti graphs
When /^I select localhost$/ do
    on StatusviewerPage do |page|
        page.linux_servers_element.when_present.click
        page.localhost_element.when_present.click
    end
end

Then /^I should see that Cacti Graphs shown$/ do
    on StatusviewerPage do |page|
        page.performance_filter_element.when_present(10).click
        page.wait_until(60) do
            #Logged in user
            page.logged_in_user_element.when_present(10).click
            page.logged_in_user_image_element.when_present
            #Memory Usage
            page.memory_usage_element.when_present(10).click
            page.memory_usage_image_element.when_present.click
            #Processes Usage
            page.processes_usage_element.when_present(10).click
            page.processes_usage_image_element.when_present.click
        end
    end
end 


#Scenario Check groundwork default users login
Given /^I am on the Dashboard page$/ do
    #visit DashboardPage
end

Given /^I logout$/ do
    on DashboardPage do |page|
        page.logout
    end
end

When /^I login with (.+) user$/ do |user|
    on LoginPage do |page|
        page.login_user(user,user)
    end
end

Then /^I should see Welcome, (.+) message on dashboard$/ do |user|
    on DashboardPage do |page|
        page.correct_login?(user)
    end
end

Given /^I am on the "(.+)" page$/ do |page|
	if page == 'Event Console'
		  visit EventconsolePage
	elsif page == 'Views'
		visit ViewPage
	elsif page == 'BSM'	
		visit BSMPage
	end
end

And /^I select host "(.+)" on "(.+)" page$/ do |host,page|
sleep(20)
	if page == 'Event Console'
		on EventconsolePage do |page|
			page.all_events_element.when_present.click
			page.host_search_element.set host
			page.search_link_element.when_present.click
			@browser.span(:id => /contentPanel:icepnltabset:0:eventTableID:0/, :text => host).when_present.click
		end
	
	elsif page == 'Views'
		on ViewPage do |page|
			page.geooffice_element.when_present.click
			sleep(3)
			page.editmap_element.fire_event 'mouseover'
			page.addicon_element.fire_event 'mouseover'
			page.addhost_element.when_present.click
			page.background_element.when_present(40).click
			page.hostname = host
			page.modify_button_element.when_present.click
			sleep(2)
			@browser.frame(:id => 'myframe').image(:alt => 'host-'+host).when_present.click
			sleep(5)
		end
		
	elsif page == 'BSM'
		@browser.frame(:id => "myframe").link(:text => 'Manage groups').when_present.click
		@browser.frame(:id => "myframe").link(:class => "update").when_present.click
		@browser.frame(:id => "myframe").div(:id => 'yw0').div(:id => 'all_members').span(:text => 'H: '+host).when_present.click
		@browser.frame(:id => "myframe").div(:id => 'yw0').div(:id => 'all_members').span(:text => 'H: '+host).when_present.click
		@browser.frame(:id => "myframe").div(:class => "form").button(:value => "Add >").when_present.click
		@browser.frame(:id => "myframe").button(:value => "Save").when_present.click
		@browser.frame(:id => "myframe").div(:class => "bsmgroup").table(:class => "bsmtreetable").td(:text => "GroundWork Monitor").when_present.click
		sleep(5)
		@browser.frame(:id => "myframe").div(:class => "bsmtreeRow host").table(:class => "bsmtreetable").link(:text => /#{host}/).when_present.click
		@browser.window(:title => 'status').when_present.use
	end
end
	
	
Then /^selected host "(.+)" should be redirected to the Status Viewer page$/ do |host|
	on StatusviewerPage do |page|
		page.status_element.exists?.should == true
	end
		@browser.span(:text => host).exists?.should == true
end

And /^I remove host "(.+)" from "(.+)" page$/ do |host,page|
	if page == 'Event Console'
		visit EventconsolePage
	elsif page == 'Views'
		visit ViewPage  
			on ViewPage do |page|
				page.geooffice_element.when_present.click
				sleep(3)
				@browser.frame(:id => 'myframe').image(:alt => 'host-'+host).when_present.right_click
				page.unlock_element.when_present.click
				sleep(2)
				@browser.frame(:id => 'myframe').image(:alt => 'host-'+host).when_present.right_click
				page.delhostobject_element.when_present.click
				sleep(2)
				@browser.alert.ok
				sleep(5)
			end
	
	elsif page == 'BSM'
		@browser.window(:title => 'Business').when_present.use
		@browser.frame(:id => "myframe").link(:text => 'Manage groups').when_present.click
		@browser.frame(:id => "myframe").link(:class => "update").when_present.click
		@browser.frame(:id => "myframe").div(:id => 'yw2').div(:id => 'selected_members_box').span(:text => 'H: '+host).when_present.click
		@browser.frame(:id => "myframe").div(:class => "form").button(:value => "< Remove").when_present.click
		@browser.frame(:id => "myframe").button(:value => "Save").when_present.click
		@browser.frame(:id => "myframe").div(:class => "bsmtreeRow").link(:text => /#{host}/).exists?.should == false
	end
end

class UserManagementPage
    include PageObject

	link :membership_management, :class => /MembershipButton/
	link :group_management, :class => /GroupButton/

def access_restriction(user,permission,module1,module2)

	if user == 'admin'
		table_row = @browser.table(:class => /UIGrid/).td(:text => /gw-monitoring-administrator/).parent
		table_row.img(:class => /EditMembershipIcon/).when_present.click
	elsif user == 'root'
		table_row = @browser.table(:class => /UIGrid/).td(:text => /gw-portal-administrator/).parent
		table_row.img(:class => /EditMembershipIcon/).when_present.click	
	elsif user == 'user'
		@browser.link(:text => '2').when_present.when_present.click
		sleep(5)
		table_row = @browser.table(:class => /UIGrid/).td(:text => /gw-portal-user/).when_present.parent
		sleep(5)
		table_row.img(:class => /EditMembershipIcon/).when_present.click
	elsif user == 'operator'
		table_row = @browser.table(:class => /UIGrid/).td(:text => /gw-monitoring-operator/).parent
		table_row.img(:class => /EditMembershipIcon/).when_present.click
	else
		puts 'User not valid'

	end

	sleep(5)
	
	if permission == 'deny'	
		@browser.checkbox(:name => /#{module1}/).clear
		@browser.checkbox(:name => /#{module2}/).clear
	elsif permission == 'grant'
		@browser.checkbox(:name => /#{module1}/).set
		@browser.checkbox(:name => /#{module2}/).set
	else
		puts 'Wrong permission defined'
	end
	sleep(3)
	@browser.link(:text => /Save/).when_present.click
	@browser.span(:text => /saved successfully/).wait_until_present
	@browser.link(:text => /OK/).when_present.click
	sleep(4)
end


def access_error(gw_module)
	if gw_module == 'Cacti'
		gw_module_actual = 'Advanced'
	elsif gw_module == 'Monarch'
		gw_module_actual = 'Configuration'
	elsif gw_module == 'Nagvis'
		gw_module_actual = 'Views'
	elsif gw_module == 'BIRT-Reports'
		gw_module_actual = 'Reports'
	end
	@browser.link(:text => /#{gw_module_actual}/).when_present.click
	sleep(8)

	if gw_module == 'BIRT-Reports'
		@browser.link(:id => /reportTreePortlet_frmTree:reportTreePortlet_reportTree:0/).when_present.click
		@browser.span(:text => 'host availability').when_present.click
		sleep(5)
		@browser.frame(:id => "birtViewer").body.text.include?("Application BIRT-Reports not authorized for this membership. Please contact GroundWork Administrator").should == true
	else
		#@browser.frame(:id => "myframe").head(:title => /Authorization Error/).should == true
		@browser.frame(:id => "myframe").body.text.include?("Application #{gw_module} not authorized for this membership. Please contact GroundWork Administrator").should == true
	
end
end


def access_granted(gw_module)
	if gw_module == 'Cacti'
		gw_module_actual = 'Advanced'
		title = 'Console'
	elsif gw_module == 'Monarch'
		gw_module_actual = 'Configuration'
		title = 'Monarch'
	elsif gw_module == 'Nagvis'
		gw_module_actual = 'Views'
		title = 'NagVis 1.7.9'
	elsif gw_module == 'BIRT-Reports'
		gw_module_actual = 'Reports'
	end
	
	if gw_module == 'CloudHub'
		@browser.goto BASE_URL + "groundwork-administration/cloudhubview"
	else
		@browser.link(:text => /#{gw_module_actual}/).when_present.click
	end	
	sleep(8)
	if gw_module == 'BIRT-Reports'
		@browser.link(:id => /reportTreePortlet_frmTree:reportTreePortlet_reportTree:0/).when_present.click
		@browser.span(:text => 'host availability').when_present.click
		sleep(5)
		@browser.frame(:id => 'birtViewer').div(:id => 'parameterDialogokButton').button(:title => 'OK').when_present.click
	elsif gw_module == 'Monarch'
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host wizard/).when_present.click
	elsif gw_module == 'Cacti'
		@browser.frame(:id => /myframe/).link(:text => /New Graphs/).when_present.click
	elsif gw_module == 'Nagvis'
		@browser.frame(:id => /myframe/).span(:text => /Options/, :id => /wui-ddheader/).when_present.click
	elsif gw_module == 'CloudHub'
		@browser.frame(:id => "myframe").link(:href => /rhev/, :class => /button-l/).when_present.click
	end
end

def add_group(add,user,group)
	
	@browser.link(:text => group).click
	sleep(3)
	
	if add == 'add'	
		@browser.text_field(:id => /username/).set user
		if user == 'user'
			@browser.select_list(:class => /selectbox/).select "gw-portal-user"
		elsif user == 'operator'
			@browser.select_list(:class => /selectbox/).select "gw-monitoring-operator"
		end
		sleep(2)
		@browser.link(:text => /Save/).click
	sleep(3)
	elsif add == 'remove'
		table_row = @browser.table(:class => /UIGrid/).td(:text => user).parent
		table_row.img(:class => /Delete/).when_present.click
		sleep(2)
		@browser.alert.ok
		sleep(5)
	end
		
end

end

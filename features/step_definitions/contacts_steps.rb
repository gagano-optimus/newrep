Given /^I am on the Contacts page$/ do
	visit ContactsPage
end

Given /^I create a new contact "(.+)"$/ do |contact|
	on ContactsPage do |page|
		page.create_contact(contact,contact,contact+'@portal.com')
	end
end

Then /^the contact "(.+)" should be created$/ do |contact|
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text.include?("Contact \"#{contact}\" added.")
end

Given /^I create a new contact group "(.+)"$/ do |contactgroup|
	on ContactsPage do |page|
		page.create_contact_group(contactgroup,contactgroup)
	end
end

Then /^the contact group "(.+)" should be created$/ do |contactgroup|
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text.include?("Contactgroup \"#{contactgroup}\" has been saved.")
end	

Given /^I am on the Hosts page$/ do
		visit HostconfigurationPage
end

Given /^I add contact group to the hostgroup$/ do
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).select(:id => /contactgroup.nonmembers/).option(:value => /contactgroup/).when_present.select
	
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).button(:name => /contactgroup_add_member/, :value => /<< Add/).when_present.click
end

Given /^I delete Contact "(.+)"$/ do |contact|
	on ContactsPage do |page|
		page.delete_contact(contact)
	end
end

Then /^the contact "(.+)" should be deleted$/ do |contact|
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text.include?("Removed:")
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text.include?(contact)
end

Given /^I delete Contact group "(.+)"$/ do |contactgroup|
	on ContactsPage do |page|
		page.delete_contact_group(contactgroup)
	end
end

Then /^the contact group "(.+)" should be deleted$/ do |contactgroup|
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text.include?("Removed:")
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text.include?(contactgroup)
end

############################################################################################

# for "modifying" a contact group

And /^I "(.+)" a contact group with name "(.+)"$/ do |action,group_name|

	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	frameleft.link(:text => /Contact groups/).when_present.click
	
	if action == 'copy'
		frameleft.link(:text => /Copy/).when_present.click
		frameleft.link(:text => /#{group_name}/).when_present.click
		framemain.text_field(:name => /name/).when_present.set "cpy-"+group_name 
		framemain.text_field(:name => /alias/).when_present.set "cpy-"+group_name 
		framemain.button(:value => "Add").when_present.click
		#framemain.button(:name => /continue/).when_present.click
		
	elsif action == 'rename'
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{group_name}/).when_present.click
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => 'new_name').set group_name+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		#framemain.button(:name => /continue/).when_present.click
		
	elsif action == 'modify'
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{group_name}/).when_present.click
		framemain.select(:name => /contact/).select "contact1"
		framemain.button(:name => /contact_remove_member/).when_present.click
		framemain.select(:name => /contact_nonmembers/).select "nagiosadmin"
		framemain.button(:name => /contact_add_member/).when_present.click
		framemain.button(:name => /save/).when_present.click
		#framemain.button(:name => /continue/).when_present.click
	end
end	


Then /^a new copy contact group with name "(.+)" should be created$/ do |group_name|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{group_name}/).exists?.should == true
end	


Then /^the renamed contact group with name "(.+)" should exist$/ do |group_name|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /Contact groups/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{group_name}/).exists?.should == true
end	


And /^I rename the contact group "(.+)" to "(.+)"$/ do |old_name,new_name|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /#{old_name}/).when_present.click
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => 'new_name').set new_name
		framemain.button(:value => /Rename/).when_present.click
		framemain.button(:name => /continue/).when_present.click
end	


Then /^the modifications to contact group "(.+)" should exist$/ do |group_name|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /#{group_name}/).when_present.click
		framemain.select(:name => /contact/).option(:text => /nagiosadmin/).exists?.should == true
end	

# for Modifying, renaming, copying and deleting a new contact

And /^I "(.+)" the contact "(.+)"$/ do |action,contact|

	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	if action == 'copy'
		frameleft.link(:text => /Copy/).when_present.click
		frameleft.link(:text => /#{contact}/).when_present.click
		framemain.text_field(:name => /name/).when_present.clear
		framemain.text_field(:name => /name/).when_present.set "cpy-"+contact 
		framemain.text_field(:name => /alias/).when_present.clear
		framemain.text_field(:name => /alias/).when_present.set "cpy-"+contact 
		framemain.button(:value => "Add", :name => "add").when_present.click
		
	elsif action == 'rename'
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{contact}/).when_present.click
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => 'new_name').set contact+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		
	elsif action == 'modify'
		frameleft.link(:text => /Contacts/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{contact}/).when_present.click
		framemain.text_field(:name => /alias/).set "new_alias"
		framemain.select(:name => /template/).select "generic-contact-2"
		framemain.button(:name => /save/).when_present.click
		
	end
end	


Then /^the contact "(.+)" should be "(.+)" successfully$/ do |contact,action|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
	if action == 'modified'
	framemain.td(:class => 'data0').text.include? ("Change to contact \"#{contact}\" accepted.")
	
	elsif action == 'copied'
	framemain.td(:class => 'data0').text.include? ("Contact \"#{contact}\" added.")
	
	elsif action == 'renamed'
	framemain.td(:class => 'data0').text.include? ("Renamed:")
	
	end
end


# for creating a new contact template

And /^I create a new contact template "(.+)"$/ do |contact|
	on ContactsPage do |page|
		page.create_contact_template(contact)
	end
end


Then /^the template "(.+)" should be created$/ do |template|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
	framemain.td(:class => 'data0').text.include? ("Contact template \"#{template}\" has been saved.")
	framemain.button(:name => /continue/).when_present.click
	
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{template}/).when_present.click
	
	framemain.checkbox(:value => /d/).when_present.set?
	framemain.checkbox(:value => /u/).when_present.set?
	framemain.checkbox(:value => /c/).when_present.set?
	
end

# for Modifying, copying and renaming a new contact template

And /^I "(.+)" the contact template "(.+)"$/ do |action,template|

	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	if action == 'modify'
		frameleft.link(:text => /Contact templates/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		
		framemain.select(:name => /host_notification_period/).when_present.select "24x7"
		framemain.select(:name => /service_notification_period/).when_present.select "24x7"
		
		framemain.button(:name => /save/).when_present.click
	
	elsif action == 'copy'
		frameleft.link(:text => /Copy/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		
		framemain.text_field(:name => /name/).when_present.set "cpy-"+template 
		
		framemain.button(:value => "Add", :name => "add").when_present.click
		
	elsif action == 'rename'
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => 'new_name').set template+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		
	elsif action == 'delete'
		frameleft.link(:text => /Contact templates/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		framemain.button(:value => /Delete/).when_present.click
		framemain.button(:value => /Yes/).when_present.click
	end
end	


Then /^the contact template "(.+)" should be "(.+)" successfully$/ do |template,action|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
	if action == 'modified'
	framemain.td(:class => 'data0').text.include? ("Changes to contact template \"#{template}\" have been saved.")
	
	elsif action == 'copied'
	framemain.td(:class => 'data0').text.include? ("Contact template \"#{template}\" has been saved.")
	
	elsif action == 'renamed'
	framemain.td(:class => 'data0').text.include? ("Renamed:")
	
	elsif action == 'deleted'
	framemain.td(:class => 'data0').text.include? ('Removed:')
	framemain.td(:class => 'data0').text.include? (" "+template+"-renamed ")
	end
end

# for Verifying a contact template cannot be deleted which is used in a contact

And /^I assign the contact template "(.+)" to contact "(.+)"$/ do |template,contact|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
	frameleft.link(:text => /Contacts/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{contact}/).when_present.click
	framemain.select(:name => /template/).select template
	framemain.button(:name => /save/).when_present.click
	framemain.button(:name => /continue/).when_present.click
end


And /^I delete the contact template "(.+)"$/ do |template|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
	frameleft.link(:text => /Contact templates/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{template}/).when_present.click
	framemain.button(:name => /delete/).when_present.click	
end

#########################  HOST ESCALATIONS  ##############################
# for Creating a host escalation tree

And /^I create a new host escalation "(.+)"$/ do |escalation|
	on EscalationPage do |page|
		page.create_host_escaltion(escalation)
	end
end


Then /^the host escalation "(.+)" should be created successfully$/ do |escalation|
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? ("Host escalation \"#{escalation}\" has been saved.")
end


And /^I create a host escalation tree "(.+)" using "(.+)"$/ do |tree,escaltion|
	visit EscalationPage
	on EscalationPage do |page|
		page.create_host_escalation_tree(tree,escaltion)
	end
end	


Then /^the host escalation tree "(.+)" should be created successfully$/ do |tree|
	visit EscalationPage
	on EscalationPage do |page|
		page.verify_host_tree(tree)
	end
end

# for Assign a host escalation tree to a host

And /^I assign the host escalation tree "(.+)" to host "(.+)"$/ do |tree,host|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	frameleft.link(:text => /Hosts/).click
	frameleft.link(:text => /Linux Servers/).click
	frameleft.link(:text => /#{host}/).click
	frameleft.link(:text => /Detail/).click
	  
	framemain.button(:value => /Escalation Trees/).when_present.click
	framemain.select(:name => 'host_escalation').select(tree)
	framemain.button(:value => 'Save').when_present.click
	framemain.td(:class => 'data0').text.include? ("Changes to \"#{host}\" accepted.")
	framemain.button(:value => 'Close').when_present.click
end


Then /^the host escalation tree "(.+)" should be applied successfully for "(.+)"$/ do |tree,host|
framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	visit HostconfigurationPage
	frameleft.link(:text => /Hosts/).when_present.click
	frameleft.link(:text => /Linux Servers /).when_present.click
	frameleft.link(:text => /#{host}/).when_present.click
	frameleft.link(:text => /Detail/).click
	framemain.button(:value => /Escalation Trees/).when_present.click
	
	framemain.select(:name => /host_escalation/).option(:value => tree).attribute_value("selected") == ""
end

# for Assigning a host escalation tree to a host group

And /^I assign the host escalation tree "(.+)" to host group "(.+)"$/ do |tree,group|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	frameleft.link(:text => /Host groups/).click
	frameleft.link(:text => /Modify/).click
	frameleft.link(:text => /#{group}/).click
	
	framemain.select(:name => /host_escalation_id/).select tree
	
	framemain.button(:value => 'Save').when_present.click
	framemain.td(:class => 'data0').text.include? ("Changes to hostgroup \"#{group}\" have been saved.")
	framemain.button(:value => 'Continue').when_present.click
end

Then /^the host escalation tree "(.+)" should be applied successfully for host group "(.+)"$/ do |tree,group|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	visit HostconfigurationPage
	frameleft.link(:text => /Host groups/).click
	frameleft.link(:text => /Modify/).click
	frameleft.link(:text => /#{group}/).click
		
	framemain.select(:name => /host_escalation_id/).option(:value => tree).attribute_value("selected") == ""
end

# for Modifying and renaming a host escalation

And /^I "(.+)" the host escalation "(.+)"$/ do |action,escalation|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present

	if action == 'modify'
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /host escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).click
		
		framemain.text_field(:name => 'first_notification').set '2'
		framemain.text_field(:name => 'last_notification').set '4'
		framemain.text_field(:name => 'notification_interval').set '30'
		framemain.checkbox(:value => 'd', :name => 'escalation_options').clear
		framemain.checkbox(:value => 'r', :name => 'escalation_options').when_present.set
		framemain.button(:value => 'Save').when_present.click
	elsif action == 'rename'
		frameleft.link(:text => /#{escalation}/).click
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => /new_name/).set escalation+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (" "+escalation+"-renamed")
		framemain.button(:value => /Continue/).when_present.click
	elsif action == "delete"
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /host escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).click
		
		framemain.button(:value => /Delete/).when_present.click
		framemain.button(:name => /confirm_delete/).when_present.click

		framemain.td(:class => 'data0').text.include? ("Removed:")
		framemain.td(:class => 'data0').text.include? (" "+escalation+"-renamed")
		
		framemain.button(:value => /Continue/).when_present.click
	end
end

 
Then /^the host escalation "(.+)" should be "(.+)" successfully$/ do |escalation,action|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
	if action == 'modified'
		framemain.td(:class => 'data0').text.include? ("Changes to \"#{escalation}\" have been saved.")
	elsif action == 'renamed'
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /host escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).exists?.should == true
	elsif action == "deleted"	
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /host escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).exists?.should == false
	end
end

# for Renaming a host escalation tree 

And /^I rename the host escalation tree "(.+)"$/ do |tree|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
		frameleft.link(:text => /Escalation trees/).when_present.click
		frameleft.link(:text => /host escalation tree/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{tree}/).click
		
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => /new_name/).set tree+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (" "+tree+"-renamed")
		framemain.button(:value => /Continue/).when_present.click
end

 
Then /^the host escalation tree "(.+)" should be renamed successfully$/ do |tree|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
		frameleft.link(:text => /Escalation tree/).when_present.click
		frameleft.link(:text => /host escalation tree/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{tree}/).exists?.should == true
end

# for deleting the host escalation tree 

And /^I delete the host escalation tree "(.+)"$/ do |tree|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	frameleft.link(:text => /Escalation trees/).when_present.click
	frameleft.link(:text => /host escalation tree/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{tree}/).click
		
	framemain.button(:value => /Delete/).when_present.click
	framemain.button(:name => /confirm_delete/).when_present.click
	framemain.td(:class => 'data0').text.include? ("Removed:")
	framemain.td(:class => 'data0').text.include? (" "+tree+"-renamed")

	framemain.button(:value => /Continue/).when_present.click
end


Then /^the host escalation tree "(.+)" should be deleted successfully$/ do |tree|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
		frameleft.link(:text => /Escalation tree/).when_present.click
		frameleft.link(:text => /host escalation tree/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{tree}/).exists?.should == false
end


Then(/^the cloned "(.+)" "(.+)" should preserve the contact group assignment "(.+)"$/) do |item,object,cg| 
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	if item == "host"
		visit HostconfigurationPage
		frameleft.link(:text => /Hosts/).click
		frameleft.link(:text => /Linux Servers/).click
		frameleft.link(:text => /#{object}/).click
		frameleft.link(:text => /Detail/).click
	elsif item == "service"
		visit ServiceConfigurationPage
		frameleft.link(:text => /Services/).click
		frameleft.link(:text => /#{object}/).click
	end
	#framemain.select(:name => /contactgroup/).include?(cg)
	framemain.select(:name => /contactgroup/).option(:value => cg).exists?.should == true 
end


Given(/^I am on the Profiles Configuration page$/) do
    visit ProfilesConfigurationPage
end

#################################################################################################
#########################    SERVICE     ########################################################

And /^I create a new service "(.+)"$/ do |service_name|
	on ServiceConfigurationPage do |page|
		page.create_service(service_name)		
	end
end

And /^I apply "(.+)" to a host$/ do |service|
	visit HostconfigurationPage
	on HostconfigurationPage do |page|
		page.visit_host_configuration
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:name => 'services').when_present.click
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').select(:name => 'add_service').select(service)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:name => 'submit').when_present.click
	end
	visit ServiceConfigurationPage
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
	end
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	framemain.link(:text => /Apply Hosts/).when_present.click
	framemain.checkbox(:name => 'apply_check').when_present.set
	framemain.radio(:value => 'merge').when_present.set
	framemain.button(:value => 'Apply').when_present.click
end


And /^I apply the copy of "(.+)" to a host$/ do |service_name|
	visit HostconfigurationPage
	service=service_name+"-copy"
	on HostconfigurationPage do |page|
		page.visit_host_configuration
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:name => 'services').when_present.click
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').select(:name => 'add_service').select(service)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:name => 'submit').when_present.click
	end
	visit ServiceConfigurationPage
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
	end
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	framemain.link(:text => /Apply Hosts/).when_present.click
	framemain.checkbox(:name => 'apply_check').when_present.set
	framemain.radio(:value => 'merge').when_present.set
	framemain.button(:value => 'Apply').when_present.click
end

Then /^the changes made for "(.+)" should reflect in Status Viewer$/ do |service_name|
	sleep(20)
	visit StatusviewerPage
	on StatusviewerPage do |page|
		page.selecthost('Linux Servers', 'localhost')
		@browser.span(:text => service_name).exists?.should == true
		@browser.span(:text => service_name).when_present.click
		sleep(3)
	end
end

Then /^the changes made for copy of "(.+)" should reflect in Status Viewer$/ do |service|
	sleep(20)
	visit StatusviewerPage
	service_name=service+"-copy"
	on StatusviewerPage do |page|
		page.selecthost('Linux Servers', 'localhost')
		@browser.span(:text => service_name).exists?.should == true
		@browser.span(:text => service_name).when_present.click
		sleep(3)
	end
end

And /^I delete the service "(.+)"$/ do |service_name|
	visit ServiceConfigurationPage 
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service_name)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:value => /Delete/).when_present.click
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:value => /Yes/).when_present.click
	end
	
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? ("Removed:")
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? (" "+service_name+" ")
end

And /^I delete the "(.+)" service "(.+)"$/ do |type,service|
visit ServiceConfigurationPage 
	if type == "copied"
		service_name=service+"-copy"
	elsif type == "renamed"
		service_name=service+"-copy_renamed"
	end
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service_name)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:value => /Delete/).when_present.click
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').button(:value => /Yes/).when_present.click
	end
	
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? ("Removed:")
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? (" "+service_name+" ")
end
	
And /^I search for a service with keyword "(.+)"$/ do |keyword|
	on ServiceConfigurationPage do |page|
		page.search_service(keyword)
	end
	sleep(5)
end
	
Then /^all the services having the "(.+)" in their name should be displayed in search results$/ do |keyword|

	row = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').div(:id => 'resultdiv').table(:align => 'left').rows.length
	puts row
	
	for i in 0..row-1
		status = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').div(:id => 'resultdiv').table(:align => 'left').td(:class => 'row_lt' ,:text => /#{keyword}/).exists?
			if status == true
				puts status
			else
				puts status
				puts i
				raise
				
			end
	end
end		

And /^I clone the service "(.+)"$/ do |service_name|
	
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_left').link(:text => /Clone service/).when_present.click
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	framemain.select(:name => 'clone_service').select(service_name)
	framemain.button(:name => 'next').when_present.click
	framemain.text_field(:name => 'name').attribute_value("value") == service_name+"-copy"
	framemain.button(:name => 'next').when_present.click
end
Then /^a copy of the service "(.+)" should be created$/ do |service_name|
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').td(:class => 'data0').text.include? (service_name+"-copy")
end

And /^I create a service template "(.+)"$/ do |template|
	on ServiceConfigurationPage do |page|
		page.create_template(template)
	end
end

And /^I apply the template "(.+)" to the copy of "(.+)"$/ do |template, service_name|
visit ServiceConfigurationPage
service=service_name+"-copy"
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
		
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => 'new_name').set service+"_renamed"
		framemain.button(:value => /Rename/).when_present.click
		framemain.select(:name => /template/).select(template)
		framemain.button(:value => /Save/).when_present.click
	end
end

Then /^the template "(.+)" should be applied successfully for renamed copy of "(.+)"$/ do |template, service_name|
visit ServiceConfigurationPage
service=service_name+"-copy_renamed"
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').select(:name => /template/).option(:value => template).attribute_value("selected") == ""
	end
end

And /^I "(.+)" the service template "(.+)"$/ do |action, template|
visit ServiceConfigurationPage
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	
	if action == 'modify'
		frameleft.link(:text => /Service templates/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		framemain.checkbox(:name => 'check_freshness_override').when_present.clear
		framemain.checkbox(:name => 'check_freshness').when_present.set
		framemain.checkbox(:name => 'notification_interval_override').when_present.clear
		framemain.text_field(:name => 'notification_interval').when_present.set '30'
		framemain.button(:value => /Save/).when_present.click
	
	elsif action == 'rename'
		frameleft.link(:text => /Service templates/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => 'new_name').set template+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		
	elsif action == 'delete'
		frameleft.link(:text => /Service templates/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		framemain.button(:value => /Delete/).when_present.click
		framemain.button(:value => /Yes/).when_present.click
	end
end	
		
	
Then /^template "(.+)" should be "(.+)" successfully$/ do |template, action|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	if action == 'modified'
		framemain.text.include? ('Saved:')
	elsif action == 'renamed'
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (template+"-renamed")
	elsif action == 'deleted'
		framemain.td(:class => 'data0').text.include? ('Removed:')
		framemain.td(:class => 'data0').text.include? (template+"-renamed")
	end
end

And /^I create a service dependency "(.+)"$/ do |dependency|
	on ServiceConfigurationPage do |page|
		page.create_dependency(dependency)
	end
end

And /^I apply the dependency "(.+)" to service "(.+)"$/ do |dependency, service|
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
	end
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	#framemain.link(:text => /Service Dependencies/).when_present.click
	#framemain.select(:name => /dep_template/).select(dependency)
	#framemain.select(:name => /depend_on_host/).select('same host')
	#framemain.button(:value => /Add Dependency/).when_present.click
	framemain.link(:text => /Apply Hosts/).when_present.click
	framemain.checkbox(:name => 'apply_dependencies').when_present.set
	framemain.radio(:value => 'merge').when_present.set
	framemain.button(:value => 'Apply').when_present.click
	framemain.td(:class => 'data0').text.include? ('Changes applied to 1 services. ')
end

And /^I "(.+)" the service dependency "(.+)"$/ do |action, dependency|
	visit ServiceConfigurationPage
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	frameleft.link(:text => /Service dependencies/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{dependency}/).when_present.click
		if action == 'modify'
			framemain.select(:name => 'service_name').select('local_users')
			framemain.button(:value => /Save/).when_present.click
	
		elsif action == 'rename'
			framemain.button(:value => /Rename/).when_present.click
			framemain.text_field(:name => 'new_name').set dependency+"-renamed"
			framemain.button(:value => /Rename/).when_present.click
		
		elsif action == 'delete'
			framemain.button(:value => /Delete/).when_present.click
			framemain.button(:value => /Yes/).when_present.click
			frameleft.link(:text => /Service dependencies/).when_present.click
			frameleft.link(:text => /Modify/).when_present.click
			frameleft.link(:text => /#{dependency}/).when_present.click
			framemain.button(:value => /Delete/).when_present.click
			framemain.button(:value => /Yes/).when_present.click
			
		elsif action == 'copy'
			frameleft.link(:text => /Copy/).when_present.click
			frameleft.link(:href => /obj=service_dependency_templates&task=copy/, :text => /#{dependency}/).when_present.click
			framemain.text_field(:name => 'name').set dependency+"-copy"
			framemain.button(:value => /Add/).when_present.click
		end
end

And /^delete the assigned service dependency "(.+)"$/ do |dependency|
visit ServiceConfigurationPage
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	frameleft.link(:text => /Service dependencies/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{dependency}/).when_present.click
	framemain.button(:value => /Delete/).when_present.click
end
	
Then /^the dependency "(.+)" should be "(.+)" successfully$/ do |dependency, action|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	if action == 'applied'
	framemain.td(:class => 'data0').text.include? (dependency)
		
	elsif action == 'created'
	framemain.td(:class => 'data0').text.include? ("Service dependency template \"#{dependency}\" has been saved.")
	
	elsif action == 'modified'
	framemain.td(:class => 'data0').text.include? ("Changes to service dependency template \"#{dependency}\" have been saved.")
	
	elsif action == 'renamed'
	framemain.td(:class => 'data0').text.include? ('Renamed:')
	framemain.td(:class => 'data0').text.include? (dependency+"-renamed")
	
	elsif action == 'deleted'
	framemain.td(:class => 'data0').text.include? ('Removed:')
	framemain.td(:class => 'data0').text.include? (" "+dependency+"-renamed ")
	
	elsif action == 'copied'
	framemain.td(:class => 'data0').text.include? ("Service dependency template \"#{dependency}-copy\" has been saved.")
	
	end
end
	

And /^remove dependency from "(.+)"$/ do |service|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
	end
	framemain.link(:text => /Service Dependencies/).when_present.click
	framemain.link(:text => /remove service dependency assignment/).when_present.click
end

Then /^"(.+)" should be removed successfully$/ do |dependency|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	framemain.td(:class => 'data2', :text => dependency).exists?.should == false
end

And /^I apply dependency "(.+)" to host localhost for service "(.+)"$/ do |dependency, service|
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /Hosts/).when_present.click
		frameleft.link(:text => /Linux Servers /).when_present.click
		frameleft.link(:text => /localhost /).when_present.click
		frameleft.link(:text => /#{service}/).when_present.click
		framemain.button(:value => /Service Dependencies/).when_present.click
		framemain.select(:name => /dep_template/).select(dependency)
		framemain.select(:name => /depend_on_host/).select('localhost')
		framemain.button(:value => /Add Dependency/).when_present.click
end

		
And /^remove dependency from localhost for service "(.+)"$/ do |service|
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /Hosts/).when_present.click
		frameleft.link(:text => /Linux Servers /).when_present.click
		frameleft.link(:text => /localhost/).when_present.click
		frameleft.link(:text => /#{service}/).when_present.click
		framemain.button(:value => /Service Dependencies/).when_present.click
		framemain.link(:text => /remove service dependency assignment/).when_present.click
end

Then /^there should be a validation message due to existing dependency$/ do
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').td(:id => 'errors').text.include? (' Please correct the following:')
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').td(:id => 'errors').text.include? (' Cannot delete until all dependencies are removed/reassigned. ')
end

And /^I create a service extended info template "(.+)"$/ do |template|
	on ServiceConfigurationPage do |page|
		page.create_extended_template(template)
	end
end

Then /^the extended info template "(.+)" should be "(.+)" successfully$/ do |template, action|
framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	if action == 'created'
		framemain.td(:class => 'data0').text.include? ("Extended service info template \"#{template}\" has been saved.")
		
	elsif action == 'applied'
		visit HostconfigurationPage
		frameleft.link(:text => /Hosts/).when_present.click
		frameleft.link(:text => /Linux Servers /).when_present.click
		frameleft.link(:text => /localhost/).when_present.click
		frameleft.link(:text => /local_cpu_java/).when_present.click
		framemain.select(:name => 'ext_info').option(:value => template).attribute_value("selected") == ""
		
	elsif action == 'modified'
		framemain.td(:class => 'data0').text.include? ("Changes to extended service info template \"#{template}\" have been saved.")
		visit ServiceConfigurationPage
		frameleft.link(:text => /Service extended info/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{template}/).when_present.click
		framemain.select(:name => 'icon_image').option(:value => 'aix.gif').attribute_value("selected") == ""
		
	elsif action == 'renamed'
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (" "+template+"-renamed ")
	
	elsif action == 'deleted'
		framemain.td(:class => 'data0').text.include? ('Removed:')
		
	elsif action == 'copied'
		framemain.td(:class => 'data0').text.include? ("Extended service info template \"#{template}\"-copied has been saved.")
	end
end
	
	
And /^I apply the extended info template "(.+)" to service "(.+)"$/ do |template, service|
framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present	
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
	end
	framemain.select(:name => 'ext_info').select(template)
	framemain.button(:value => /Save/).when_present.click
	framemain.td(:class => 'data0').text.include? ('Saved:')
	framemain.td(:class => 'data0').text.include? (service)
	framemain.link(:text => /Apply Hosts/).when_present.click
	framemain.checkbox(:name => 'apply_extinfo_service').when_present.set
	framemain.radio(:value => 'merge').when_present.set
	framemain.button(:value => 'Apply').when_present.click
	framemain.td(:class => 'data0').text.include? ('Changes applied to 1 services. ')
end

And /^I "(.+)" the service extended info template "(.+)"$/ do |action, template|
	visit ServiceConfigurationPage
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		if action == 'modify'
			frameleft.link(:text => /Service extended info/).when_present.click
			frameleft.link(:text => /Modify/).when_present.click
			frameleft.link(:text => /#{template}/).when_present.click
			framemain.select(:name => 'icon_image').select("aix.gif")
			framemain.text_field(:name => 'icon_image_alt').clear
			framemain.text_field(:name => 'icon_image_alt').set 'aix.gif'
			framemain.button(:value => /Save/).when_present.click
					
		elsif action == 'rename'
			frameleft.link(:text => /Service extended info/).when_present.click
			frameleft.link(:text => /Modify/).when_present.click
			frameleft.link(:text => /#{template}/).when_present.click
			framemain.button(:value => /Rename/).when_present.click
			framemain.text_field(:name => 'new_name').set template+"-renamed"
			framemain.button(:value => /Rename/).when_present.click
					
		elsif action == 'copy' 
			frameleft.link(:text => /Service extended info/).when_present.click
			frameleft.link(:text => /Copy/).when_present.click
			frameleft.link(:text => /#{template}/).when_present.click
			framemain.text_field(:name => 'name').set template+"-copy"
			framemain.button(:value => 'Add').when_present.click
			
			
		elsif action == 'delete'
			template_renamed=template+"-renamed"
			frameleft.link(:text => /Service extended info/).when_present.click
			frameleft.link(:text => /Modify/).when_present.click
			frameleft.link(:text => /#{template_renamed}/).when_present.click
			framemain.button(:value => /Delete/).when_present.click
			framemain.button(:value => /Yes/).when_present.click
			
			visit ServiceConfigurationPage
			template_copied=template+"-copy"
			frameleft.link(:text => /Service extended info/).when_present.click
			frameleft.link(:text => /Modify/).when_present.click
			frameleft.link(:text => /#{template_copied}/).when_present.click
			framemain.button(:value => /Delete/).when_present.click
			framemain.button(:value => /Yes/).when_present.click
		end
end
	
And /^I remove the service extended info template from service "(.+)"$/ do |service|
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
	end
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	framemain.select(:name => 'ext_info').select("")
	framemain.button(:value => /Save/).when_present.click
	framemain.link(:text => /Apply Hosts/).when_present.click
	framemain.checkbox(:name => 'apply_extinfo_service').when_present.set
	framemain.radio(:value => 'merge').when_present.set
	framemain.button(:value => 'Apply').when_present.click
	framemain.td(:class => 'data0').text.include? ('Changes applied to 1 services. ')
end

Then /^the info template "(.+)" should be removed successfully$/ do |template|
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').link(:text => /Service Detail/).when_present.click
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').select(:name => 'ext_info').option(:value => "").attribute_value("selected") == ""
end

And /^I "(.+)" the service group "(.+)"$/ do |action, group|
visit ServiceConfigurationPage
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	frameleft.link(:text => /Service groups/).when_present.click
	frameleft.div(:id => /service_groups/).link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{group}/).when_present.click
		
		if action == 'modify'
			framemain.select(:name => 'host').select('localhost')
			sleep(5)
			framemain.select(:name => 'services').select('local_users')
			framemain.button(:name => 'add_services').when_present.click
			framemain.button(:value => /Save/).when_present.click
					
		elsif action == 'rename'
			framemain.button(:value => /Rename/).when_present.click
			framemain.text_field(:name => 'new_name').set group+"-renamed"
			framemain.button(:value => /Rename/).when_present.click
		
		elsif action == 'delete'
			visit ServiceConfigurationPage
			frameleft.link(:text => /Service groups/).when_present.click
			frameleft.div(:id => /service_groups/).link(:text => /Modify/).when_present.click
			frameleft.link(:text => /#{group}/).when_present.click
			framemain.button(:value => /Delete/).when_present.click
			framemain.button(:value => /Yes/).when_present.click
		end
end
		
Then /^"(.+)" should be "(.+)" successfully$/ do |group, action|
framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
	if action == 'modified'
		framemain.td(:class => 'data0').text.include? (" Changes to \"#{group}\" accepted. ")
		
	elsif action == 'renamed'
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (" "+group+"-renamed ")
	
	elsif action == 'deleted'
		framemain.td(:class => 'data0').text.include? ('Removed:')
		framemain.td(:class => 'data0').text.include? (/#{group}/)
	end
end

Given /^I am on the Escalation page$/ do
	visit EscalationPage
end

And /^I create a new service escalation "(.+)"$/ do |escalation|
	on EscalationPage do |page|
		page.create_escaltion(escalation)
	end
end

Then /^the escalation "(.+)" should be created successfully$/ do |escalation|
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? ("Service escalation \"#{escalation}\" has been saved.")
end

And /^I create a service escalation tree "(.+)" using "(.+)"$/ do |escalation_tree, escaltion|
	visit EscalationPage
	on EscalationPage do |page|
		page.create_escalation_tree(escalation_tree,escaltion)
	end
end	
	
Then /^the escalation tree "(.+)" should be created successfully$/ do |escalation_tree|
	visit EscalationPage
	on EscalationPage do |page|
		page.verify_tree(escalation_tree)
	end
end

And /^I assign the service escalation tree "(.+)" to service "(.+)"$/ do |tree,service|
	on ServiceConfigurationPage do |page|
		page.open_services
		page.check_service(service)
	end
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	framemain.select(:name => 'escalation').select(tree)
	framemain.link(:text => 'Apply Hosts').when_present.click
	framemain.checkbox(:name => 'apply_escalation_service').when_present.set
	framemain.radio(:value => 'merge').when_present.set
	framemain.button(:value => 'Apply').when_present.click
	framemain.td(:class => 'data0').text.include? ('Changes applied to 1 services. ')
end
	
Then /^the escalation tree "(.+)" should be applied successfully for "(.+)"$/ do |tree,service|
framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	visit HostconfigurationPage
	frameleft.link(:text => /Hosts/).when_present.click
	frameleft.link(:text => /Linux Servers /).when_present.click
	frameleft.link(:text => /localhost/).when_present.click
	frameleft.link(:text => /#{service}/).when_present.click
	framemain.select(:name => 'escalation').option(:value => tree).attribute_value("selected") == ""
end

And /^I assign the escalation tree "(.+)"$/ do |tree|
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').select(:name => 'escalation').select(tree)
end

And /^tree "(.+)" should be assigned to service group "(.+)"$/ do |tree,group|
	visit ServiceConfigurationPage
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	on ServiceConfigurationPage do |page|
		page.open_service_group(group)
	end
	
	framemain.select(:name => 'escalation').option(:value => tree).attribute_value("selected") == ""
end

And /^I assign service group "(.+)"$/ do |group|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	framemain.button(:name => 'assign_service_groups').when_present.click
	framemain.select(:name => 'servicegroups_nonmembers').select(group)
	framemain.button(:value => /<< Add/).when_present.click
	framemain.button(:value => 'Save').when_present.click
end

Then /^there should be an error message for duplicate service group "(.+)"$/ do |group|
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	framemain.td(:class => 'error').text.include? (" Duplicate: Service group \"#{group}\" already exists. ")
end

Then /^there should be a validation message for illegal characters$/ do
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').div(:id => 'messageBox').text.include? ('There is a problem with your form.')
	@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').div(:id => 'messageBox').text.include? ('Field [name]: The name field cannot contain any of the following characters:')
end

##########################################################################
########################   SERVICE  Escalation   #########################

# for Renaming and modifying a service escalation

And /^I "(.+)" the service escalation "(.+)"$/ do |action,escalation|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present

	if action == 'rename'
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /service escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).click
		
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => /new_name/).set escalation+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (" "+escalation+"-renamed")
		framemain.button(:value => /Continue/).when_present.click
	elsif action == 'modify'
		frameleft.link(:text => /#{escalation}/).click
		
		framemain.text_field(:name => 'first_notification').set '2'
		framemain.text_field(:name => 'last_notification').set '4'
		framemain.text_field(:name => 'notification_interval').set '30'
		framemain.checkbox(:value => 'c', :name => 'escalation_options').clear
		framemain.checkbox(:value => 'w', :name => 'escalation_options').when_present.set
		framemain.button(:value => 'Save').when_present.click	
	elsif action == "delete"
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /service escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).click
		
		framemain.button(:value => /Delete/).when_present.click
		framemain.button(:name => /confirm_delete/).when_present.click

		framemain.td(:class => 'data0').text.include? ("Removed:")
		framemain.td(:class => 'data0').text.include? (" "+escalation+"-renamed")
		
		framemain.button(:value => /Continue/).when_present.click
	end
end


Then /^the service escalation "(.+)" should be "(.+)" successfully$/ do |escalation,action|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
	if action == 'renamed'
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /service escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).exists?.should == true
	elsif action == 'modified'
		framemain.td(:class => 'data0').text.include? ("Changes to \"#{escalation}\" have been saved.")
		framemain.button(:value => /Continue/).when_present.click		
	elsif action == "deleted"	
		frameleft.link(:text => /Escalations/).when_present.click
		frameleft.link(:text => /service escalation/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{escalation}/).exists?.should == false
	end
end

# for Renaming and deleting a service escalation tree

And /^I "(.+)" the service escalation tree "(.+)"$/ do |action,tree|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	frameleft.link(:text => /Escalation trees/).when_present.click
	frameleft.link(:text => /service escalation tree/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{tree}/).click
	
	if action == 'rename'
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => /new_name/).set tree+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (" "+tree+"-renamed")
		framemain.button(:value => /Continue/).when_present.click
	elsif action == 'delete'
		framemain.button(:value => /Delete/).when_present.click
		framemain.button(:name => /confirm_delete/).when_present.click
		
		framemain.td(:class => 'data0').text.include? ("Removed:")
		framemain.td(:class => 'data0').text.include? (" "+tree+"-renamed")
	end
end

 
Then /^the service escalation tree "(.+)" should be "(.+)" successfully$/ do |tree,action|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
	frameleft.link(:text => /Escalation tree/).when_present.click
	frameleft.link(:text => /service escalation tree/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	
	if action == 'renamed'	
		frameleft.link(:text => /#{tree}/).exists?.should == true
	elsif action == 'deleted'
		frameleft.link(:text => /#{tree}/).exists?.should == false
	end
end

# for Deleting a service escalation tree

And /^I rename the service escalation tree "(.+)"$/ do |tree|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	
		frameleft.link(:text => /Escalation trees/).when_present.click
		frameleft.link(:text => /service escalation tree/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{tree}/).click
		
		framemain.button(:value => /Rename/).when_present.click
		framemain.text_field(:name => /new_name/).set tree+"-renamed"
		framemain.button(:value => /Rename/).when_present.click
		framemain.td(:class => 'data0').text.include? ('Renamed:')
		framemain.td(:class => 'data0').text.include? (" "+tree+"-renamed")
		framemain.button(:value => /Continue/).when_present.click
end

 
Then /^the service escalation tree "(.+)" should be renamed successfully$/ do |tree|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		
		frameleft.link(:text => /Escalation tree/).when_present.click
		frameleft.link(:text => /service escalation tree/).when_present.click
		frameleft.link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{tree}/).exists?.should == true
end

##########################################################################
########################   SERVICE   #####################################


And /^I select the service "(.+)"$/ do |service|
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft.link(:text => /Services/).when_present.click
		frameleft.link(:text => /#{service}/).when_present.click
end


# for Deleting hosts should remove their corresponding services from service group (Status Viewer Scenario)

Given /^I create a new Service Group with name "(.+)"$/ do |sg_name|
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text, /Service groups/).click
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /New/, :href => /service_groups&task=new/).when_present.click
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /name/).when_present.set sg_name
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name, /alias/).set sg_name
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, /add/).click
	sleep(3)
end


Given /^I add the service "(.+)" of host "(.+)" to the new Service Group$/ do |service,host|
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /host/).option(:text => host).when_present.select
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present.select(:name => /services/).option(:text => service).when_present.select
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name, 'add_services').click
end


When /^I select the service group "(.+)"$/ do |sg|
    on ServiceConfigurationPage do |page|
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Service groups/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{sg}/).click 
		sleep(2)	
    end
end


When /^I remove the service "(.+)" of host "(.+)" from service group "(.+)"$/ do |service,host,sg|
    on ServiceConfigurationPage do |page|

		#view=service_group&obj=servicegroups&name=SG4&host=&service=&del_host=qa-ubuntu-12-4-64&del_service=icmp_ping_alive&remove_service=1
	
		href_value = String.new("")
		href_value = "view=service_group&obj=servicegroups&name="+sg+"&host=&service=&del_host="+host+"&del_service="+service+"&remove_service=1"
		puts href_value
		
		#Removing the service with the above URL
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").link(:href => /#{href_value}/).click 
		puts @browser.frame(:id => "myframe").frame(:name => "monarch_main").link(:href => /#{href_value}/).text
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
    end
end


###################################################################
################    HOST GROUP     ################################


Then(/^I remove member host "(.+)" and add "(.+)"$/) do |host_init,host_final| 
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /members/).select host_init
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /members_remove_member/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /members_nonmembers/).select host_final
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /members_add_member/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
end


Then(/^I verify that host "(.+)" is a member of hostgroup "(.+)" on "(.+)"$/) do |host,hg,page|
	if page=="Host Configuration page"
		# Checking the presence of the host on the on Hosts Configuration Page	
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /members/).include?(host)
		
    else
		sleep(4)
		@browser.span(:text => hg).when_present.click
		sleep(2)
		# Checking the presence of hosts on the on Hosts Configuration Page	
		@browser.div(:id => /divContents/).span(:text => host).exists?.should == true
	end
end


# for Verify changing contactgroup associated with a hostgroup

Then(/^I select the hostgroup "(.+)"$/) do |hostgroup| 
	    visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host groups/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{hostgroup}/).click
		sleep(2)
end


Then(/^I change the contact group from "(.+)" to "(.+)"$/) do |cg_init,cg_final| 
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /contactgroup/).select cg_init
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /contactgroup_remove_member/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /contactgroup_nonmembers/).select cg_final
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /contactgroup_add_member/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
end


Then(/^I verify that the Contact Group is "(.+)"$/) do |cg_changed| 
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /contactgroup/).include?(cg_changed)
		puts @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /contactgroup/).include?(cg_changed)
end


Given /^I add the hosts except the host localhost to the new host group$/ do
    $selectList = @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /nonmembers/)
		$selectContent = $selectList.options.map(&:text).each { |element| 
        if element != "localhost"
            $host_array << element
            $selectList.select(element)
		end
    }
   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:value, /<< Add/).click
   # printing the hosts
   puts "Number of hosts added : "+ $host_array.length.to_s
   $host_array.each do |host_array|
	puts host_array
   end
   
end

# for Verify copying a hostgroup

Then(/^I copy the host group with name copy-"(.+)"$/) do |hg| 
	    visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host groups/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Copy/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{hg}/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).set "copy-"+hg
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).set "copy-"+hg
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "add").click
		sleep(2)
end


Then(/^I verify the copy of hostgroup "(.+)" has been added to the GW portal$/) do |hg|
	copy_of_hg = "copy-"+hg
    on HostconfigurationPage do |page|
		visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host groups/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{copy_of_hg}/).click
		sleep(2)
	# Checking the presence of hosts on the on Hosts Configuration Page	
		$host_array.each do |host_array|
			@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /members/).include?(host_array)
		end
    end

	on StatusviewerPage do |page|
		visit StatusviewerPage
		sleep(4)
		@browser.span(:text => copy_of_hg).when_present.click
		sleep(2)
	# Checking the presence of hosts on the on Hosts Configuration Page	
		$host_array.each do |host_array|
			@browser.div(:id => /divContents/).span(:text => host_array).exists?.should == true
		end
	end
end

# for renaming a host group

Then(/^I rename the hostgroup to renamed-"(.+)"$/) do |hg| 
		new_name = "renamed-"+hg
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /new_name/).set new_name
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
		sleep(2)
end


Then(/^I verify that hostgroup has been renamed to renamed-"(.+)"$/) do |hg|
	new_name = "renamed-"+hg
    on HostconfigurationPage do |page|
		visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host groups/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{new_name}/).click
		sleep(2)
		puts "Hosts on Hosts Configuration: "
	# Checking the presence of hosts on the on Hosts Configuration Page	
		$host_array.each do |host_array|
			@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /members/).include?(host_array)
			puts @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /members/).option(:value => host_array).text
		end
    end

	on StatusviewerPage do |page|
		visit StatusviewerPage
		sleep(4)
		@browser.span(:text => new_name).when_present.click
		sleep(2)
		puts "Hosts on Status Viewer: "
	# Checking the presence of hosts on the on Hosts Configuration Page	
		$host_array.each do |host_array|
			@browser.div(:id => /divContents/).span(:text => host_array).exists?.should == true
			puts @browser.div(:id => /divContents/).span(:text => host_array).text
		end
	end
end


##################################################################################################
###########################    HOSTS      ########################################################

#for Verify creating a host using Host Wizard 

Then(/^I select the "(.+)" option$/) do |option|
    @browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{option}/).when_present.click	
end

      
Then(/^I add a new host "(.+)" with IP address "(.+)" and services "(.+)" and "(.+)" as a "(.+)"$/) do |host_name,ip,service1,service2,save_as|
    on HostconfigurationPage do |page|
       #page 1 of host wizard
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).set host_name
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).set host_name
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /address/).set ip
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /next/).click
	   sleep(2)
	   
	   #page 2 of host wizard
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /host_template/).when_present(45).select "generic-host"
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /next/).click
	   sleep(2)
	   
	   #page 3 of host wizard
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /hostgroups_nonmembers/).select "Linux Servers"
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /hostgroups_add_member/).click
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /next/).click
	   sleep(2)
		
	   #page 4 of host wizard
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /services/).select service1
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /add_service/).click
	   sleep(3)
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /services/).select service2
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /add_service/).click
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /next/).click
	   sleep(2)
	   
	   #last page of Host Wizard
	   if save_as == "host"
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /continue/).click
	   else
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save_as_profile/).click
	   sleep(2)
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
	   end
	   
    end
end


Then(/^I verify that the host "(.+)" has been added to the GW portal$/) do |host_name|
    on HostconfigurationPage do |page|
		visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Hosts/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Linux Servers/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => host_name).exists? 
    end

	on StatusviewerPage do |page|
		visit StatusviewerPage
		sleep(10)
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.span(:text => host_name).exists?
	end
	
end

# for Verify changing ip address for a host if 2 hosts have same ip address

Then(/^I verify ip address of host "(.+)" has been updated to "(.+)"$/) do |host,ip|
    on HostconfigurationPage do |page|
		visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Hosts/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Linux Servers/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{host}/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Detail/).click
	    sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /address/).attribute_value("value") == ip
    end
end


#for Verify checking hostname duplicacy and deleting host


Then(/^I attempt to add a new host with name "(.+)" with IP address "(.+)" and services "(.+)" and "(.+)"$/) do |host_name,ip,service1,service2|
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).set host_name
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).set host_name
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /address/).set ip
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /next/).click
    end
end


Then(/^a host wizard error message for host "(.+)" should be generated$/) do |host_name| 
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").td(:text => "Host "+host_name+" already exists.").exists?
    end
end


Then(/^I select the host "(.+)" of hostgroup "(.+)"$/) do |host_name,hostgroup| 
	visit HostconfigurationPage
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Hosts/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Linux Servers/).click
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{host_name}/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Detail/).click
	sleep(3)
end
 

Then(/^I delete the host$/) do
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /delete/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /confirm_delete_host/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /continue/).click
end


Then(/^I verify that the host "(.+)" has been deleted$/) do |host_name|
	on StatusviewerPage do |page|
		visit StatusviewerPage
		sleep(50)
		page.linux_servers_element.when_present.click
		sleep(10)
		@browser.span(:text => host_name).exists?.should == false
	end
end

# for Verify cloning a host

Then(/^I clone the host "(.+)"$/) do |hostname|
    on HostconfigurationPage do |page|
	   sleep(3)
	   clone_name = "clone-"+hostname
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).set clone_name
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).set clone_name
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /address/).set "127.0.0.2"
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /host/).select hostname
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /add_clone_host/).click
	   sleep(2)
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
    end
end


Then(/^I verify that the clone of host "(.+)" with services "(.+)" and "(.+)" has been added to the GW portal$/) do |host_name,service1,service2|

	sleep(3)
	clone_name = "clone-"+host_name
	   
    on HostconfigurationPage do |page|
		visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Hosts/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Linux Servers/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => clone_name).exists? 
    end
	on StatusviewerPage do |page|
		visit StatusviewerPage
		sleep(4)
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.span(:text => clone_name).exists?
		@browser.span(:text => clone_name).click
		@browser.span(:text => service1).exists?
		@browser.span(:text => service2).exists?
		sleep(1)
	end
end


Then(/^I select the clone of host "(.+)" of hostgroup "(.+)"$/) do |host_name,hostgroup| 

		sleep(3)
		clone_name = "clone-"+host_name
	
	    visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Hosts/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Linux Servers/).click
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{clone_name}/).click
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Detail/).click
	    sleep(3)
end


# for Verify creating a host using Host Wizard and saving it as a profile

Then(/^I verify host "(.+)" exists as a "(.+)" profile$/) do |host_name,type| 

	    visit ProfilesConfigurationPage
		sleep(3)
		
		if type == "host"
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host profiles/).click
		else
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Service profiles/).click
		end
		
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
		sleep(1)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => host_name).exists? == true
end

# for Verify searching a host using hostname and host IP
 
 
Then(/^I search a host by "(.+)"$/) do |option|
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /input/).set option
	   sleep(5)
    end
end
 
  
Then(/^the search output should be "(.+)"$/) do |output|
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").td(:text => output).exists?.should == false
	   
    end
end
 
# for Verify modifying a host
 
Then(/^I rename the host "(.+)"$/) do |host|
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
	   sleep(2)
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /new_name/).set "renamed-"+host
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
	   sleep(2)
    end
end 


Then(/^I edit host alias$/) do
    on HostconfigurationPage do |page|
	   host_alias = String.new("")
	   host_alias = @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).attribute_value("value")
	   puts host_alias
	   host_alias = "edited_"+host_alias
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).set host_alias
	   sleep(2)
    end
end 
 

Then(/^I edit host IP address as "(.+)"$/) do |address|
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /address/).set address
    end
end  
 
 
Then(/^I change host template as "(.+)"$/) do |template|
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /template/).select template
	   sleep(1)
    end
end   
 
 
And(/^I change its contact group from "(.+)" to "(.+)"$/) do |cg_old,cg_new|
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /contactgroup_override/).clear
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /contactgroup/).select cg_old
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /contactgroup_remove_member/).click
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /contactgroup_nonmembers/).select cg_new
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /contactgroup_add_member/).click
	sleep(1)
end   
 
 
Then(/^I save the host editing$/) do
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
    end
end   
 
Then(/^I save the service editing$/) do
    on HostconfigurationPage do |page|
	   @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
    end
end  

Then(/^I verify that changes to host "(.+)" have been saved with address as "(.+)" and template as "(.+)"$/) do |host,address,template|
	host_alias = "edited_"+host
	
		#checking host alias 
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).attribute_value("value") == host_alias
		
		#checking host IP Address
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /address/).attribute_value("value") == host_alias
		
		#checking host template
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /template/).selected?(template)
end 
 
 
 
Then(/^I revert the changes made with the host$/) do
    on HostconfigurationPage do |page|
	
		#renaming the host
		name = String.new("")
		name = @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).attribute_value("value")
		if name.include? "renamed-"
			puts name.slice "renamed-"
			name["renamed-"]= ""
		end
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
	    sleep(2)
	    @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /new_name/).set name
	    @browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
	    sleep(2)
		
		#renaming the host alias
		host_alias = String.new("")
	    host_alias = @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).attribute_value("value")
	    puts host_alias
		if host_alias.include? "edited_"
			puts host_alias.slice "edited_"
			host_alias["edited_"]= ""
		end
	    @browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /alias/).set host_alias
	    sleep(2)
		
		#resetting the IP Address
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /address/).set "172.28.113.207"
		
		#reselecting the host template
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /template/).select "generic-host"
		
		#saving the changes
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /save/).click
    end
end  
 
# Verify deleting a host using 'Delete Host' option
 
Then(/^I select host "(.+)" to be deleted$/) do |host|
    on HostconfigurationPage do |page|
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /search/).select "*"
		sleep(4)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:value => host).set(true)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "remove_host").when_present.click
		sleep(5)
    end
end  
 
# Verify deleting a host using 'Delete Host Services' option
 
Then(/^I select and delete the service "(.+)" of host "(.+)" to be deleted$/) do |service,host|
    on HostconfigurationPage do |page|
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /service/).select service
		sleep(4)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:value => host).set(true)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "remove_host").when_present.click
		sleep(5)
    end
end  
   
# Verify deleting a service using 'Delete host services' option
 
Then(/^I verify that the service "(.+)" of host "(.+)" has been deleted$/) do |service,host|
	on StatusviewerPage do |page|
		visit StatusviewerPage
		
		page.linux_servers_element.when_present.click
		sleep(10)
		@browser.span(:text => host).when_present.click
		sleep(3)
		@browser.div(:id => /divContents/).span(:text => service).exists?.should == false
	end
end 
 
# Verify modifying a host on cfg file 
 
Then(/^I open the hosts.cfg file$/) do
	on ControlPage do |page|
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").link(:href => "/monarch/monarch_file.cgi?file=/monarch/workspace/hosts.cfg").click
		sleep(3)
	end
end   
 
 
Then(/^I verify host "(.+)" with alias "(.+)" and ip "(.+)" and template "(.+)" on hosts.cfg file$/) do |host,host_alias,ip,template|
	@browser.window(:title => "hosts.cfg").when_present.use
    sleep(2)
	#@browser.text.include? ("host_name			"+host)
	#@browser.text.include? ("alias			"+/#{host_alias}/)  # gives "can't convert Regexp into String (TypeError) " error
	@browser.pre(:text => "	alias				"+host_alias+" ").exists?.should == true
	#actual line from cfg file inside quotes --->    "	alias				kjdscsbc "
	
	sleep(2)
	@browser.window(:title =>/control/).when_present.use
	@browser.window(:title =>"hosts.cfg").close
	sleep(5)
end  
 

################################################################################################
##################  PARENT CHILD PAIR  ######################################################### 
 
 
Then(/^I create a new Parent Child pair with "(.+)" as parent and "(.+)" as child$/) do |parent,child|
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /New/).when_present.click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /parent/).select parent
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /children_nonmembers/).select child
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "children_add_member").click
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "save").click
end 
 
 
Then(/^I verify that pair exists with "(.+)" as parent and "(.+)" as child$/) do |parent,child|
    on HostconfigurationPage do |page|
		visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Parent child/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{parent}/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /children/).include?(child)
		puts "On Host Configuration page: "
		puts "Parent : "+parent
		puts "Child  : "+@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /children/).option(:value => child).text
    end

	on StatusviewerPage do |page|
		sleep(15)
		visit StatusviewerPage
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.span(:text => child).when_present.click
		sleep(2)
		@browser.link(:text => /Parents for this Host/).when_present.click
		sleep(3)
		@browser.span(:text => /#{parent}/).exists?.should == true
		puts "On Status Viewer: "
		puts "Parent : "+@browser.span(:text => /#{parent}/).text
		puts "Child  : "+child
	end
end
 
 
Then(/^I select the "(.+)" "(.+)" parent child pair$/) do |parent,child|
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).when_present.click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{parent}/).click
	sleep(3)
end 


Then(/^I delete the "(.+)" "(.+)" parent child pair$/) do |parent,child|
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /delete/).click
end 


Then(/^I verify that "(.+)" "(.+)" parent child pair has been deleted$/) do |parent,child|
    on HostconfigurationPage do |page|
		visit HostconfigurationPage
		sleep(2)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Parent child/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
		sleep(3)
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{parent}/).exists?.should == false
    end

	on StatusviewerPage do |page|
		sleep(15)
		visit StatusviewerPage
		page.linux_servers_element.when_present.click
		sleep(2)
		@browser.span(:text => child).when_present.click
		sleep(2)
		@browser.link(:text => /Parents for this Host/).when_present.click
		sleep(3)
		@browser.span(:text => /#{parent}/).exists?.should == true
		puts "On Status Viewer: "
		puts "Parent : "+@browser.span(:text => /#{parent}/).text
		puts "Child  : "+child
	end
end

################################################################################################
##################  Host Template  #############################################################

# for Verify creating a host template

Then(/^I create a new host template with name "(.+)"$/) do |name|
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /New/).when_present.click
	sleep(3)
		
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).set name
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /active_checks_enabled/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /passive_checks_enabled/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /check_command/).select "check_http"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /command_line/).set ""
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /check_period/).select "workhours"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /check_interval/).set "1"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /retry_interval/).set ""
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /max_check_attempts/).set "4"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /check_freshness/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /freshness_threshold/).set "50"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /obsess_over_host/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /flap_detection_enabled/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /low_flap_threshold/).set "10"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /high_flap_threshold/).set "100"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /event_handler_enabled/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /event_handler/).select "check-host-alive"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:value => /d/, :name => /stalking_options/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /process_perf_data/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /notifications_enabled/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:value => /d/, :name => /notification_options/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:value => /r/, :name => /notification_options/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /notification_period/).select "workhours"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /notification_interval/).set "5"  
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /contactgroup_nonmembers/).select "nagiosadmin"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /contactgroup_add_member/).click
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /retain_status_information/).set(true)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").checkbox(:name => /retain_nonstatus_information/).set(true)
=begin
	*Active checks enabled: Checked
	*Passive checks enabled: Checked
	*Check command: check_http
	*Command line: Leave it blank
	*Check period: workhours
	*Check interval: 1
	*#Retry Interval: blank
	*Max check attempts: 4
	*Check freshness: Checked
	*Freshness threshold: 50
	*Obsess over host: Checked
	*Flap detection enabled: Checked
	*Low flap threshold: 10
	*High flap threshold: 100
	*Event handler enabled: Checked
	*Event handler: Check-host-alive
	*Stalking options: Down
	*Process perf data: Checked
	*Notifications enabled: Checked
	*Notification options: Down, Recovery
	*Notification period: workhours
	*Notification interval: 5
	*Contact Groups: Helpdesk
	*Retain status information: Checked	
	*Retain nonstatus information: Checked	
=end		
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "add").click
	sleep(2)
end 


Then(/^I verify that a new host template with name "(.+)" has been "(.+)"$/) do |name,action|
	visit HostconfigurationPage
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host templates/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
	sleep(3)
		
	if action=='created'
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).exists?.should == true
		puts "Host Template on Host Configuration page : "+@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).text
	elsif action == 'deleted'
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).exists?.should == false
		puts "Host Template "+name+" on Host Configuration page no longer exists."
	end
end

# for Verify copying and deleting a host template

Then(/^I copy the host template with name "(.+)"$/) do |name|
	copy_name = "copy-"+name
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host templates/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Copy/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).set copy_name
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "add").click
end
 
 
Then(/^I delete the host template "(.+)"$/) do |name|
	visit HostconfigurationPage
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host templates/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "delete").click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "confirm_delete").click
		
end


Then(/^I attempt to delete the host template "(.+)"$/) do |name|
	visit HostconfigurationPage
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host templates/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "delete").click
end


# for Verify a host template which is applied to a host cannot be deleted
 
Then(/^an error message with respect to host "(.+)" is displayed$/) do |host|
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").td(:text => /Cannot delete until all dependencies are removed/).exists?.should == true
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").td(:text => /#{host}/).exists?.should == true
end
 
# for Verify modifying a host template 
 
Then(/^I select the host template "(.+)" for modifying$/) do |name|
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).when_present.click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).click
	sleep(2)
end


Then(/^I rename the host template to renamed-"(.+)"$/) do |name|
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /new_name/).set "renamed-"+name
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /rename/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => /continue/).click
end  


Then(/^I change Max check attempts = "(.+)" and Check Interval = "(.+)" of the host template$/) do |max_chk_atpt,chk_ivl|
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /check_interval/).set chk_ivl
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /max_check_attempts/).set max_chk_atpt
end  

 
Then(/^I save the modifications$/) do 
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "save").click
end 
 
 
Then(/^I verify host template modifications have been made$/) do 
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /check_interval/).value == "5"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /max_check_attempts/).value == "6"
end  
 
# for creating a host extended info template and applying it to a host
 
Then(/^I create a new host extended info template with name "(.+)"$/) do |name|
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /New/).when_present.click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /name/).set name
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /notes/).set "East block switch"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /notes_url/).set "http://www.gwos.com/"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /action_url/).set "http://www.gwos.com/"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /icon_image/).select "switch.gif"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /icon_image_alt/).set "Switch"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /vrml_image/).select "switch.jpg"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /statusmap_image/).select "switch.gd2"
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /2d_coords/).set ""
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => /3d_coords/).set ""
	
=begin
	
	Name: extended_info_host
	Note: East block switch
	Notes url: http://www.gwos.com/
	Action url: http://www.gwos.com/
	Icon image: switch.gif
	Icon image alt: Switch
	Vrml image: switch.jpg
	Statusmap image: switch.gd2
	2nd coords: Leave it blank
	3rd coords: Leave it blank
	Click on Add.
	
=end		
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "add").click
	sleep(2)
end 
 

Then(/^I verify that a new host extended info template with name "(.+)" has been "(.+)"$/) do |name,action|
	visit HostconfigurationPage
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host extended info/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
	sleep(3)
		
	if action=='created'
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).exists?.should == true
		puts "Host extended info template on Host Configuration page : "+@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).text
	elsif action=='deleted'
		@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).exists?.should == false
		puts "Host extended info template "+name+" on Host Configuration page no longer exists."
	end
end  
 
 
Then(/^I "(.+)" its host extended info template as "(.+)"$/) do |action,name|
	if action=="save"
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /extended_info/).select name
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "save").click
		sleep(2)
	elsif action=="verify"
		@browser.frame(:id => "myframe").frame(:name => "monarch_main").select(:name => /extended_info/).selected?(name)
	end
end  
 
# for Verify copying a host extended info template and deleting it

Then(/^I copy the host extended info template with name copy-"(.+)"$/) do |name|
	copy_name= "copy-"+name
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Copy/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").text_field(:name => "name").set copy_name
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "add").click
end 

       
Then(/^I delete the host extended info template with name "(.+)"$/) do |name|
	visit HostconfigurationPage
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Host extended info/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /Modify/).click
	sleep(3)
	@browser.frame(:id => "myframe").frame(:name => "monarch_left").link(:text => /#{name}/).click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "delete").click
	sleep(2)
	@browser.frame(:id => "myframe").frame(:name => "monarch_main").button(:name => "confirm_delete").click
end

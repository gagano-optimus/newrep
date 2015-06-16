class EscalationPage
    include PageObject

    direct_url BASE_URL + "config/escalations"
	
	

 def create_escaltion(name)
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	frameleft.link(:text => /Escalations/).when_present.click
	frameleft.link(:text => /service escalation/).when_present.click
	frameleft.link(:text => /New/).when_present.click
	framemain.text_field(:name => 'name').when_present.set name
	framemain.text_field(:name => 'first_notification').set '1'
	framemain.text_field(:name => 'last_notification').set '3'
	framemain.text_field(:name => 'notification_interval').set '60'
	framemain.select(:name => 'escalation_period').select('24x7')
	framemain.checkbox(:value => 'c', :name => 'escalation_options').when_present.set
	framemain.button(:value => 'Add').when_present.click
 end

 def create_escalation_tree(tree,escalation)
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	frameleft.link(:text => /Escalation trees/).when_present.click
	frameleft.link(:text => /service escalation tree/).when_present.click
	frameleft.link(:text => /New/).when_present.click
	framemain.text_field(:name => 'name').when_present.set tree
	framemain.button(:value => 'Add').when_present.click
	framemain.select(:name => 'escalation').select(escalation)
	framemain.button(:value => 'Add Escalation').when_present.click
	framemain.select(:name => 'contactgroups_nonmembers').select('nagiosadmin')
	framemain.button(:value => /<< Add/).when_present.click
	framemain.button(:value => 'Save').when_present.click
	framemain.button(:value => 'Assign Hosts').when_present.click
	framemain.select(:name => 'hosts_nonmembers').select('localhost')
	framemain.button(:value => /<< Add/).when_present.click
	framemain.button(:value => 'Save').when_present.click
 end

 def verify_tree(tree)
 framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	frameleft.link(:text => /Escalations/).when_present.click
	frameleft.link(:text => /Escalation trees/).when_present.click
	frameleft.link(:text => /service escalation tree/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{tree}/).exists?.should == true
 end
 
 ########################## HOST ESCALATION  ##############################
 
 
 def create_host_escaltion(escalation)
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	frameleft.link(:text => /Escalations/).when_present.click
	frameleft.link(:text => /host escalation/).when_present.click
	frameleft.link(:text => /New/).when_present.click
	framemain.text_field(:name => 'name').when_present.set escalation
	framemain.text_field(:name => 'first_notification').set '1'
	framemain.text_field(:name => 'last_notification').set '3'
	framemain.text_field(:name => 'notification_interval').set '60'
	framemain.select(:name => 'escalation_period').select('24x7')
	framemain.checkbox(:value => 'd', :name => 'escalation_options').when_present.set
	framemain.button(:value => 'Add').when_present.click
 end
 
 
 def create_host_escalation_tree(tree,escalation)
	framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
	frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	
	frameleft.link(:text => /Escalation trees/).when_present.click
	frameleft.link(:text => /host escalation tree/).when_present.click
	frameleft.link(:text => /New/).when_present.click
	framemain.text_field(:name => 'name').when_present.set tree
	framemain.button(:value => 'Add').when_present.click
	
	framemain.select(:name => 'escalation').select(escalation)
	framemain.button(:value => 'Add Escalation').when_present.click
	framemain.select(:name => 'contactgroups_nonmembers').select('nagiosadmin')
	framemain.button(:value => /<< Add/).when_present.click
	framemain.button(:value => 'Save').when_present.click
	framemain.button(:value => 'Assign Hosts').when_present.click
	framemain.select(:name => 'hosts_nonmembers').select('localhost')
	framemain.button(:value => /<< Add/).when_present.click
	framemain.button(:value => 'Save').when_present.click
 end
 
 
 def verify_host_tree(tree)
framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
	frameleft.link(:text => /Escalations/).when_present.click
	frameleft.link(:text => /Escalation trees/).when_present.click
	frameleft.link(:text => /host escalation tree/).when_present.click
	frameleft.link(:text => /Modify/).when_present.click
	frameleft.link(:text => /#{tree}/).exists?.should == true
 end
 
 
end

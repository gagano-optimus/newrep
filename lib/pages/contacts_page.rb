class ContactsPage
    include PageObject

    direct_url BASE_URL + "config/contacts"
	
	in_frame(:id => 'myframe') do |frame|
        in_frame({:name => 'monarch_left'}, frame) do |frame|
				#td :table, :class => /row1_menuitem/, :frame => frame
				link :contacts, :text => /Contact/, :frame => frame
				link :contacts_new, :text => /New/, :frame => frame
            
			
		end

        in_frame({:name => 'monarch_main'}, frame) do |frame_main|
            
			
			text_field :contact_name, :name => /name/, :frame => frame_main
			text_field :contact_alias, :name => /alias/, :frame => frame_main
			text_field :contact_email, :name => /email/, :frame => frame_main
			select_list :contact_template, :name => /template/, :frame => frame_main
			button :contact_add, :name => "add", :frame => frame_main
			button :continue, :value => "Continue", :frame => frame_main
		end
	end
			
			
			
			
			
def create_contact(name,alias_name,email)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).td(:class => /row1_menuitem/).link(:text => /Contacts/).when_present.click
	
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /New/).when_present.click
	sleep(5)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).text_field(:name => /name/).when_present.set name
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).text_field(:name => /alias/).when_present.set alias_name
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).text_field(:name => /email/).when_present.set email
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).select(:name => /template/).option(:value => /generic-contact-1/).when_present.select
	sleep(3)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).td(:class => /buttons/).button(:name => /add/).when_present.click
	sleep(2)
end

def create_contact_group(group_name,alias_name)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Contact groups/).when_present.click
	
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /New/).when_present.click
	sleep(5)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).text_field(:name => /name/).when_present.set group_name
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).text_field(:name => /alias/).when_present.set alias_name
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).select(:name => /contact_nonmembers/).option(:value => /contact/).when_present.select
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).button(:name => /contact_add_member/).when_present.click
	sleep(3)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).td(:class => /buttons/).button(:name => /add/).when_present.click
	sleep(2)
end

def delete_contact(contact)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).td(:class => /row1_menuitem/).link(:text => /Contacts/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Modify/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /#{contact}/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).td(:class => /buttons/).button(:name => /delete/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).button(:value => /Yes/).when_present.click
end

def delete_contact_group(contactgroup)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Contact groups/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Modify/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /#{contactgroup}/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).td(:class => /buttons/).button(:name => /delete/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).button(:value => /Yes/).when_present.click
end
	
	
def create_contact_template(name)

	#@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).td(:class => /row1_menuitem/).link(:text => /Contact templates/).when_present.click
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Contact templates/).when_present.click
	
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /New/).when_present.click
	sleep(5)
	
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).text_field(:name => /name/).when_present.set name
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).select(:name => /host_notification_period/).when_present.select "workhours"
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:value => /d/).when_present.set(true)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:value => /u/).when_present.set(true)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).select(:name => /host_notification_commands/).when_present.select "host-notify-by-sendemail"
	
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).select(:name => /service_notification_period/).when_present.select "workhours"
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:value => /c/).when_present.set(true)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:value => /u/).when_present.set(true)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).select(:name => /service_notification_commands/).when_present.select "service-notify-by-sendemail"
	
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).td(:class => /buttons/).button(:name => /add/).when_present.click
	sleep(2)
end
	
	

end

	
	

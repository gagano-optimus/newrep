class ServiceConfigurationPage
    include PageObject

    direct_url BASE_URL + "config/services"

    link :service_templates, :text => " Service templates"
    text_field :max_check_attempts, :name => "max_check_attempts"
	
	in_frame(:id => 'myframe') do |frame|
        in_frame({:name => 'monarch_left'}, frame) do |frame|
		
			link :new_service, :text => /New service/, :frame => frame
			link :search_service, :text => /Search/, :frame => frame
		
		end
		
		in_frame({:id => 'monarch_main'}, frame) do |frame_main|
			text_field :service_name, :name => /name/, :frame => frame_main
			textarea :command_line, :name => /command_line/, :frame => frame_main
			text_field :search_field, :name => /input/, :frame => frame_main
			
			
			select_list :service_template, :name => /template/, :frame => frame_main
			select_list :service_command, :name => /command/, :frame => frame_main
			
			button :add, :value => /Add/, :frame => frame_main
			button :save, :value => /Save/, :frame => frame_main
			button :delete, :value => /Delete/, :frame => frame_main
			button :yes, :value => /Yes/, :frame => frame_main
			
			link :service_check, :text => /Service Check/, :frame => frame_main
			
		
		end
	end

    def open_generic_service
        frame = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
        frame.link(:text => /Service templates/).when_present.click
        frame.link(:text => /Modify/).when_present.click
        frame.link(:text => /generic-service/).when_present.click
    end

    def set_max_attempts
        frame = @browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present
        frame.text_field(:name => "max_check_attempts").when_present.set "1"
        frame.button(:name => "save").when_present.click
    end

    def open_services
        frame = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
        frame.link(:text => /Services/).when_present.click
    end

    def check_service(name)
        frame = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
        frame.link(:text => /#{name}/).when_present.click
    end
    
    def set_max_check_attempts
        frame = @browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present
        frame.text_field(:name => "max_check_attempts").when_present.set "1"
		frame.checkbox(:name => /active_checks_enabled/).clear
		frame.button(:name => "save").when_present.click
	end
	
    def reset_max_check_attempts
       	frame = @browser.frame(:id => "myframe").frame(:name => "monarch_main").when_present
        frame.text_field(:name => "max_check_attempts").when_present.set "3"
		frame.checkbox(:name => /active_checks_enabled/).set
		frame.button(:name => "save").when_present.click
	end

	
	def visit_service_configuration
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		frameleft.link(:text => /Services/).when_present.click
		frameleft.link(:text => /local_cpu_java/).when_present.click
		framemain.link(:text => /Service Profiles/).when_present.click
	end

	def verify_service_profile_addition(service_profile)
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		framemain.select(:id => /profiles.members/).option(:value => service_profile).exists?.should == true
	end
	
	def verify_service_profile_deletion(service_profile)
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		framemain.select(:id => /profiles.members/).option(:value => service_profile).exists?.should == false
	end
	
	def create_service(name)
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /New service/).when_present.click
		framemain.text_field(:name => /name/).set name
		framemain.select(:name => /template/).select("generic-service")
		framemain.button(:value => /Add/).when_present.click
		framemain.link(:text => /Service Check/).when_present.click
		framemain.select(:name => /command/).select("check_http")
		framemain.textarea(:name => /command_line/).clear
		framemain.textarea(:name => /command_line/).set 'check_http!20!70'
		framemain.button(:value => /Save/).when_present.click
	end
	
	def search_service(name)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_left').link(:text => /Search/).when_present.click
		sleep(5)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text_field(:name => 'input').set name
		sleep(5)
	end
	
	def create_template(name)
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /Service templates/).when_present.click
		frameleft.div(:id => /service_templates/).link(:text => /New/).when_present.click
		framemain.text_field(:name => 'name').set name
		framemain.button(:value => /Add/).when_present.click
		framemain.select(:name => 'template').select('generic-service')		
		framemain.checkbox(:name => 'check_period_override').when_present.clear
		framemain.select(:name => 'check_period').select('workhours')
		framemain.checkbox(:name => 'max_check_attempts_override').when_present.clear
		framemain.text_field(:name => 'max_check_attempts').set '5'
		framemain.button(:value => /Save/).when_present.click
		sleep(3)
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? ('Saved:')
		@browser.frame(:id => 'myframe').frame(:name => 'monarch_main').text.include? (name)
	end
	
	def create_dependency(name)
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present

		frameleft.link(:text => /Service dependencies/).when_present.click
		frameleft.div(:id => /service_dependencies/).link(:text => /New/).when_present.click
		framemain.text_field(:name => 'name').set name
		framemain.select(:name => 'service_name').select('local_cpu_httpd')
		framemain.checkbox(:name => 'execution_failure_criteria', :value => 'c').when_present.set
		framemain.checkbox(:name => 'execution_failure_criteria', :value => 'u').when_present.set
		framemain.checkbox(:name => 'notification_failure_criteria', :value => 'c').when_present.set
		framemain.checkbox(:name => 'notification_failure_criteria', :value => 'u').when_present.set
		framemain.button(:value => /Add/).when_present.click
	end
	
	def create_extended_template(name)
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
				  
		frameleft.link(:text => /Service extended info/).when_present.click
		frameleft.div(:id => /service_extended_info/).link(:text => /New/).when_present.click
		framemain.text_field(:name => 'name').set name
		framemain.textarea(:name => 'notes').set 'testing service extended info template'
		framemain.text_field(:name => 'notes_url').set 'www.gwos.com'
		framemain.text_field(:name => 'action_url').set 'www.gwos.com'
		framemain.select(:name => 'icon_image').select("3d_cloud.gif")
		framemain.text_field(:name => 'icon_image_alt').set '3d_cloud'
		framemain.button(:value => /Add/).when_present.click
	end
	
	def open_service_group(name)
		framemain = @browser.frame(:id => 'myframe').frame(:name => 'monarch_main').when_present
		frameleft = @browser.frame(:id => "myframe").frame(:name => "monarch_left").when_present
		
		frameleft.link(:text => /Service groups/).when_present.click
		frameleft.div(:id => /service_groups/).link(:text => /Modify/).when_present.click
		frameleft.link(:text => /#{name}/).when_present.click
	end
		
		
end

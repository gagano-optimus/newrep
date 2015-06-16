class ControlPage
    include PageObject

    direct_url BASE_URL + "config/control"
	
=begin	
	in_frame(:id => 'myframe') do |frame|
        in_frame({:name => 'monarch_left'}, frame) do |frame|
            link :nagios_main, :text => /Nagios main configuration/, :frame => frame
            link :notification, :text => /Notification/, :frame => frame
		end
		in_frame({:id => 'monarch_main'}, frame) do |frame_main|
		    checkbox :enable_check, :name => /enable_notifications/, :frame => frame
            
		end
		button :save_next, :name => /next/, :frame => frame
	end
=end	

	def enable_notification
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Nagios main configuration/).when_present.click
	sleep(5)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Notification/).when_present.click
	sleep(6)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:name => /enable_notifications/).clear
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:name => /enable_notifications/).set
	end
	
	def save_next
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).button(:name => /next/).when_present.click
	end
	
	def disable_notification
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Nagios main configuration/).when_present.click
	sleep(5)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Notification/).when_present.click
	sleep(6)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:name => /enable_notifications/).clear
	end	
	
	
	def enable_flap_detection
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Nagios main configuration/).when_present.click
	sleep(5)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Flapping Control/).when_present.click
	sleep(6)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:name => /enable_flap_detection/).clear
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:name => /enable_flap_detection/).set
	end	
	
	
	def disable_flap_detection
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Nagios main configuration/).when_present.click
	sleep(5)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_left/).link(:text => /Flapping Control/).when_present.click
	sleep(6)
	@browser.frame(:id => /myframe/).frame(:name => /monarch_main/).checkbox(:name => /enable_flap_detection/).clear
	end	
	
end	
class NagiosServiceStatusDetailsPage
    include PageObject

    direct_url BASE_URL + "advanced/nagios-app/NagiosServiceDetailView"

   
	in_frame(:id => 'myframe') do |frame|
        link :localhost_local_cpu_httpd, :text => /local_cpu_httpd/, :frame => frame
		 
    end
	
	
	link :passive_check_result, :text => /Submit passive check result for this service/
	text_field :check_output, :name => /plugin_output/
	text_field :perf_data, :name => /performance_data/
	button :commit, :name => /btnSubmit/
	
	
	def goto_nagios_service_url(host,service)
		new_base_url = String.new
		# copying the BASE_URL to a new string
		new_base_url = BASE_URL
		# slicing off the /portal/classic/ from the BASE_URL
		if new_base_url.include? "/portal/classic/"
			#puts new_base_url.slice "/portal/classic/"
			new_base_url["/portal/classic/"]= ""
		end
	
		# creating the new URL to acces the page 
        submit_passive_check_result_url = String.new
		submit_passive_check_result_url = new_base_url + "/nagios-app/cmd.cgi?cmd_typ=30&host="+host+"&service="+service
		#puts submit_passive_check_result_url
		# now accessing the Nagios Submit passive check result page of the service via the new URL
		@browser.goto submit_passive_check_result_url
    end
    
end

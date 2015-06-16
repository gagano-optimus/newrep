class StatusviewerPageBackup
    include PageObject

    direct_url BASE_URL + "status"

    span :pending_host_groups_statics, :id =>'frmNV:tblHostGroupStatistics:3:outputtxtTotalValue'
    span :pending_host_statics, :id =>'frmNV:tblhostStatistics:3:outputtxtHostTotalValue'

    span :pending_service_groups_statics, :id =>'frmNV:tblServiceGroupStatistics:4:outputtxtTotalValue'
    span :pending_service_statics, :id =>'frmNV:tblServiceStatistics:4:outputtxtServiceTotalValue'

    span :total_services, :id => "frmNV:tblServiceStatistics:outtxtTotalServiceCount"
    span :total_hosts, :id => "frmNV:tblhostStatistics:outputtxtTotalHostCount"

    span :performance_filter, :text =>'Host Availability & Performance Measurement'
    image :host_graph, :id => 'HVform:j_id957'

    span :linux_servers, :text => /Linux Servers/ 
    span :localhost, :text => 'localhost'
	span :local_cpu_httpd, :text => /local_cpu_httpd/
	
	#for scheduling downtime
	span :downtime, :text => /Downtime/ 
	span :schedule_downtime, :text => /Schedule Downtime/ 
	
	textarea :comment, :id => /HVform:actionsPortlet_txtComment/
	select_list :type_down, :id => "HVform:actionsPortlet_menuType"
	button :downtime_button, :id => "HVform:actionsPortlet_btnSubmit"
	span :downtime_value, :id => "HVform:HItxtHostDowntimeValue"
	span :downtime_comment_tab, :id => "HVform:commentsHeader"
	span :downtime_comment, :id => /HVform:CPtblComments:0/
	
	#for scheduling service downtime
	text_field :service_comment, :id => /SVform:actionsPortlet_txtComment/
	select_list :service_type_down, :id => "SVform:actionsPortlet_menuType"
	button :service_downtime_button, :id => "SVform:actionsPortlet_btnSubmit"
	span :service_downtime_value, :id => "SVform:SItxtServiceDowntimeValue"
	span :service_downtime_comment, :id => /SVform:CPtblComments:0/
    span :logged_in_user, :id =>'HVform:tblperfmeasurement_Portlet:1:PMpnlCollapsible_outtxt'
    image :logged_in_user_image, :id =>'HVform:tblperfmeasurement_Portlet:1:j_id991'

    span :memory_usage, :id =>'HVform:tblperfmeasurement_Portlet:2:PMpnlCollapsible_outtxt'
    image :memory_usage_image, :id =>'HVform:tblperfmeasurement_Portlet:2:j_id991'

    span :processes_usage, :id =>'HVform:tblperfmeasurement_Portlet:3:PMpnlCollapsible_outtxt'
    image :processes_usage_image, :id =>'HVform:tblperfmeasurement_Portlet:3:j_id991'

    #span :custom_group, :class => "iceOutTxt", :text => "CG1"
    #div :custom_group, :id => /frmTree:pnlTbSet:0:hstTree/, :text => "CG1"
    div :custom_group, :id => /frmTree:pnlTbSet:0:hstTree-d-0/
    link :hosts_link, :id => "frmTree:pnlTbSet:0.0"
    link :services_link, :id => "frmTree:pnlTbSet:0.1"
    link :open_servicegroup, :id => "frmTree:pnlTbSet:0:treeSrvc:0"
	link :local_cpu_httpd, :text => "local_cpu_httpd"
    #link :icmp_ping_alive, :text => "icmp_ping_alive"

    link :check_results, :text => /Check Results/
    link :passive_result, :text => /Submit Passive Check Result/

    #for services check
    text_field :check_output, :id => "SVform:actionsPortlet_txtCheckOutputValue"
    text_field :performance_data, :id => "SVform:actionsPortlet_txtPerformanceDataValue"
    select_list :check_results_list, :id => "SVform:actionsPortlet_menuCheckResult"
    button :submit_button_service, :id => /SVform:actionsPortlet_btnSubmit/

#for hosts check
    text_field :check_output_host, :name => /HVform:actionsPortlet_txtCheckOutputValue/
    text_field :performance_data_host, :name => /HVform:actionsPortlet_txtPerformanceDataValue/
    select :check_results_list_host, :name => /HVform:actionsPortlet_menuCheckResult/
    button :submit_button_host, :name => /HVform:actionsPortlet_btnSubmit/
    select_list :downtime_option, :id => /HVform:actionsPortlet_menuType/
	
	link :hosts_tab,  :id => /frmTree:pnlTbSet:0.0/, :name => /frmTree:pnlTbSet:0.0/
	link :services_tab, :id => /frmTree:pnlTbSet:0.1/, :name => /frmTree:pnlTbSet:0.1/
    link :search_tab, :id => /frmTree:pnlTbSet:0.2/, :name => /frmTree:pnlTbSet:0.2/
    text_field :search_box, :id => "frmTree:pnlTbSet:0:STtxtSearchQuery"
    button :search_button, :value => "Go"
    span :search_count, :id => "frmTree:pnlTbSet:0:STtxtSearchCount"
    span :search_result, :id => /frmTree:pnlTbSet:0:STtblResults:0:STsrchNdClick/, :text => /localhost/
	
	
    link :hosts_all_link, :id => "frmTree:pnlTbSet:0:hstTree:0"
    link :group_all_link, :id => "frmTree:pnlTbSet:0:treeSrvc:0"

    div :page_title, :class => "BreadcumbsInfoBar ClearFix"
    span :page_text, :id => "frmNV:HostGrpStatusPortlet_TxtHstGpStats"

	link :status, :text => "Status"
	span :host_status, :text => "BSM:Business Objects"
	span :hostname, :text => "baden"
	link :zurich, :id => "frmTree:pnlTbSet:0:hstTree:7"
	link :linux_host_machine, :id => "frmTree:pnlTbSet:0:hstTree:7-3"
	span :bern_host_machine, :text => /VEMA:bern/
	span :cpu_usage, :text => /summary.quickStats.overallCpuUsage/
	link :vss_vermont, :id => "frmTree:pnlTbSet:0:hstTree:8"
	link :vss_zurich, :id => "frmTree:pnlTbSet:0:hstTree:8-4"
	link :zurich, :id => "frmTree:pnlTbSet:0:hstTree:7"
	span :cpu_uptime, :text => /summary.quickStats.uptimeSeconds/
	select :filter, :id => /frmTree:pnlTbSet:0:STmenuSortSelect/
	link :net_view, :id => /frmTree:pnlTbSet:0:hstTree/, :text => /NET:/
	link :pool_view, :id => /frmTree:pnlTbSet:0:hstTree/, :text => /POOL:/
	link :storage_view, :id => /frmTree:pnlTbSet:0:hstTree/, :text => /STOR:/
	link :esx_bernina,:id => /frmTree:pnlTbSet:0:hstTree/, :text => /ESX:bernina/
	link :esx_morges,:id => /frmTree:pnlTbSet:0:hstTree/, :text => /ESX:morges/
	link :esx_thun,:id => /frmTree:pnlTbSet:0:hstTree/, :text => /ESX:thun/
	link :esx_wil,:id => /frmTree:pnlTbSet:0:hstTree/, :text => /ESX:wil/
	link :esx_zurich,:id => /frmTree:pnlTbSet:0:hstTree/, :text => /ESX:zurich/
	span :esx_vss_zurich,:text => /VEMA:zurich.groundwork.groundworkopensource.com/
	link :esx_vssvermont,:id => /frmTree:pnlTbSet:0:hstTree/, :text => /VSS:vermont/
	link :rhev_vm, :id => /frmTree:pnlTbSet:0:hstTree/, :text => /RHEV-H:/
	link :rhev_m, :id => /frmTree:pnlTbSet:0:hstTree/, :text => /RHEV-M:eng-rhev-m-1.groundwork.groundworkopensource.com/


#entire network page
	span :entire_network, :text => /Entire Network/
	
	#disable/enable notifications
	span :notification, :text => /Notifications/
	span :disable_notification, :text => 'Disable Notifications'
	button :submit_button, :name => /HVform:actionsPortlet_btnSubmit/
	span :enable_notification, :text => /Enable Notifications/
	
	#disable/enable active checks for hosts
	span :settings, :text => /Settings/
	span :disable_active_check, :text => /Disable Active Checks on Host/
	link :verify_disable_active_check_host_summary, :text => /Enable Check/	
	span :enable_active_check, :text => /Enable Active Checks on Host/
	link :verify_enable_active_check_host_summary, :text => /Disable Check/
	
	#disable/enable passive checks for hosts
	span :disable_passive_check_host, :text => /Disable Passive Checks/
	span :enable_passive_check_host, :text => /Enable Passive Checks/
	
	#disable/enable flap detection for hosts
	span :disable_flap_detection_host, :text => /Disable Flap Detection/
	span :enable_flap_detection_host, :text => /Enable Flap Detection/
	
	#disable/enable event handler for hosts
	span :event_handlers_dropdown, :text => /Event Handlers/
	span :disable_event_handlers_host, :text => /Disable Event Handler/
	span :enable_event_handlers_host, :text => /Enable Event Handler/
	
	span :reschedule_next_check, :text => /Re-Schedule the Next Check/
	text_field :next_check_time, :id => /HVform:actionsPortlet_txtCheckTimeValue/
	checkbox :force_check, :name => /HVform:actionsPortlet_chkBoxForceCheck/
	text_field :search_box, :name => /frmTree:pnlTbSet:0:STtxtSearchQuery/
	button :go_search, :name => /frmTree:pnlTbSet:0:STsearchTreePortlet_btnSearch/
	span :host_last_check, :id => /HVform:HItxtLastCheckTime/
	span :service_local_cpu, :text => /local_cpu_httpd/
	span :service_last_check, :id => /SVform:SItxtLastCheckTime/
	span :host_availability_portlet, :text => /Host Availability & Performance Measurement/
	select :host_availability_dropdown, :id => /HVform:HAmenuTimeSelector/
	text_field :start_time_host_portlet, :name => /HVform:HAstartDateTime/
	text_field :end_time_host_portlet, :name => /HVform:HAendDateTime/
	button :apply_host_portlet, :name => /HVform:HAsubmitApply/
	
	#Acknowledge
	link :acknowledge, :text => /Acknowledge/					
	#span :acknowledge, :text => /Acknowledge/
	span :acknowledge_host, :text => /Acknowledge This Host Problem/
	checkbox :services_ack, :class => /iceSelBoolChkbx portlet-form-field/
	textarea :acknowledge_comment, :id => /HVform:actionsPortlet_txtComment/	
	button :submit_ack, :id => /HVform:actionsPortlet_btnSubmit/			
	checkbox :services_check_result_ack, :class => /iceSelOneMnu portlet-form-field/
	text_field :check_output, :name => /SVform:actionsPortlet_txtCheckOutputValue/
	text_field :perf_data, :name => /SVform:actionsPortlet_txtPerformanceDataValue/
	button :submit_ack_service, :name => /SVform:actionsPortlet_btnSubmit/
	span :remove_acknowledge, :text => /Remove Acknowledgment of Problem/
	
	#calendar
	image :calendar_img1, :id => /HVform:j_id879/
	image :calendar_img2, :id => /HVform:j_id881/
	td :start_date, :class => /day/, :text => /14/
	td :end_date, :class => /day/, :text => /16/
	
	#delete comment
	button :delete_comment, :name => /CPcmdDeleteComment/
	button :commit, :name => /CPcmdDeletePopUpCommit/
	
	link :group_for_host, :id => /HVform:linkGroupPoup/, :text => /Groups for this Host/
	span :group_for_host_linuxservers, :text => /Linux Servers/
	button :close_window, :name => /HVform:btnGroupPopClose/, :title => /Close Window/
	
    def state_pending?
        self.pending_host_groups_statics_element.when_present.text != '0' or
        self.pending_host_statics_element.when_present.text != '0' or
        self.pending_service_groups_statics_element.when_present.text != '0' or
        self.pending_service_statics_element.when_present.text != '0'
    end

    def select_host(hostGroup, host, patch_host)
        @browser.span(:text => "#{hostGroup}").when_present.click
        sleep(3)
        @browser.span(:text => "#{patch_host}").when_present.click
        if host == ""
            @browser.span(:id => "frmTree:pnlTbSet:0:hstTree:n-0-3:TxtNdClick").when_present.click
        else
            @browser.span(:text => "#{host}").when_present.click
        end
    end

    def get_host(index)
        tree = @browser.div(:id => "frmTree:pnlTbSet:0:treeSrvc-d-0-c").when_present
        element = tree.div(:class => "iceTreeRow", :index => index)
        element.text[/\(.*?\)/].gsub('(','').gsub(')','')
    end

#for service status
	
    def submit_check_results(state)
        #self.check_results_element.when_present.click
        self.check_results_element.when_dom_changed.click
        sleep(2)
        if self.passive_result_element.exists?
            #self.passive_result_element.when_present.click
            self.passive_result_element.when_dom_changed.click
        else
            #self.check_results_element.when_present.click
            self.check_results_element.when_dom_changed.click
            #self.passive_result_element.when_present.click
            self.passive_result_element.when_dom_changed.click
        end
        self.check_results_list = state
        self.check_output = state
        self.performance_data = state
	
    end
	
#for host status
	
	def submit_check_results_host(state)				
        self.check_results_element.when_dom_changed.click
		self.passive_result_element.when_dom_changed.click
		sleep(8)		
        self.check_results_list_host = state
   	    self.check_output_host = state
        self.performance_data_host = state
        self.submit_button_host_element.when_present.click
	    sleep(20)
    end

    def search_for_host(host)
        self.search_tab_element.when_present.click
        self.wait_until(10) do
            self.search_box_element.exists?
        end
        self.search_box = host
        sleep(2)
        self.search_button
        sleep(2)
        results = self.search_count
        results.split(" ")[0].to_i
    end

    def results_not_found(host)
        self.search_tab_element.when_present.click
        self.wait_until(10) do
            self.search_box_element.exists?
        end
        self.search_box = host
        sleep(1)
        self.search_button
        sleep(2)
        @browser.text.include? "No results found"

    end

	def status_verify(view)
		if view == "Storage View"
			self.storage_view_element.exists?.should == true
			self.storage_view_element.when_present.click
			sleep(5)
		
		elsif view == "Network View"
			self.net_view_element.exists?.should == true
			self.net_view_element.when_present.click
			sleep(5)
		elsif view == "Resource Pool"
			self.pool_view_element.exists?.should == true
			self.pool_view_element.when_present.click
			sleep(5)
		end
	end
	
	def selecthost(hostgroup, host)
	@browser.span(:text => hostgroup).when_present.click
	sleep(3)
	@browser.span(:text => host).when_present.click
	sleep(2)
	end
	
	def select_hostname(host)
		self.linux_servers_element.when_present.click
		@browser.div(:id => /frmTree:pnlTbSet:0:hstTree/).span(:text => host).when_present.click
		#@browser.span(:text => host).when_present.click
	end
    
    
	def downtime(option,comment,time)
		self.downtime_element.when_present.click
		self.schedule_downtime_element.when_present.click
		sleep(5)
		@browser.textarea(:name => /HVform:actionsPortlet_txtComment/).set comment
		self.downtime_option = option
		if option == 'Flexible'
		
			@browser.text_field(:name => /HVform:actionsPortlet_txtHours/).set time
			@browser.text_field(:name => /HVform:actionsPortlet_txtMinutes/).set time	
			@browser.button(:name => /HVform:actionsPortlet_btnSubmit/).when_present.click
		else 
			@browser.button(:name => /HVform:actionsPortlet_btnSubmit/).when_present.click
			sleep(3)
		end	
	end
	
	def verify_hostdown_entire_network(host,state)
		@browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_present.click
		@browser.link(:id => /frmNV:tblhostStatistics:1:lnkhoststatus/,:text => state).when_present.click
		sleep(1)
		@browser.span(:text => host).when_present.exists?.should == true
	end
	
	def verify_hostdown_hostgroup(state)
		@browser.span(:text => /Linux Servers/).when_present.click
		@browser.span(:text => /#{state.capitalize}/).when_present.exists?.should == true
	end


	def verify_hoststatus_hostsummary(state)
		sleep(10)
		@browser.table(:id => /HVform:HVpanel15/).span(:id => /HVform:txtHostState/, :text => /#{state.capitalize}/).when_dom_changed.exists?.should == true
	end
	

	def verify_hoststatus_entire_network(host,state,index)
		sleep(10)
		@browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_present.click
		@browser.link(:id => /frmNV:tblhostStatistics:#{index}:lnkhoststatus/,:text => /#{state.capitalize}/).when_present.click
		sleep(3)
		@browser.span(:text => host).when_present.exists?.should == true
	end

	
	def verify_hoststatus_hostgroup(host,state)
		sleep(10)
		@browser.span(:text => /Linux Servers/).when_present.click
		@browser.table(:id => /HGVform:tblhostStatistics/).link(:text => /#{state.capitalize}/).when_present(100).click
		sleep(3)
		@browser.div(:id => /HGVform:pnlpopuphost/).span(:text => host).exists?.should == true
	end
	
	def navigate_entire_network
	 @browser.link(:id => /frmNavigationTabset:icePnlTbSet:0:icePnlTabClick/).span(:text => /Entire Network/).when_present.click
	end
	
	def verify_notification_disable_entire_network(host)
	 @browser.link(:id => /frmNV:nagiosPortlet_linkNotificationsHosts/).when_present(100).click
	 sleep(2)
	 @browser.span(:text => host).when_present(200).exists?.should == true
	end
	
	def verify_notification_disable_host_summary
      @browser.link(:text => /Enable Notifications/).when_present(400).exists?.should == true
	end
	
	def verify_notification_enable_host_summary
      @browser.link(:text => /Disable Notifications/).when_present.exists?.should == true
	end
	
	def verify_notification_enable_entire_network(host)
	 @browser.link(:id => /frmNV:nagiosPortlet_linkNotificationsHosts/).when_present.click
	 sleep(2)
	 @browser.span(:text => host).when_present.exists?.should == false
	end
	
	def verify_disable_active_check_entire_network(host)
	 @browser.link(:id => /frmNV:nagiosPortlet_linkActiveChecksHosts/).when_present(100).click
	 sleep(2)
	 @browser.span(:text => host).when_present(400).exists?.should == false
	
	end
	
	def select_service(service)
		@browser.span(:text => service).when_present.click
		sleep(2)
	end
	
	def submit_check_results_service(state)
		self.check_results_element.when_dom_changed.click
		self.passive_result_element.when_dom_changed.click
		sleep(6)		
		self.check_results_list = state
		self.check_output = state
		self.performance_data = state
		self.submit_button_service_element.when_present.click	

	end
	
	
	def navigate_service_page_nagios(host,service)
        #URL to access the page
		#http://server.groundworkopensource.com/nagios-app/extinfo.cgi?type=2&host=localhost&service=local_cpu_httpd
		
		new_base_url = String.new
		# copying the BASE_URL to a new string
		new_base_url = BASE_URL
		# slicing off the /portal/classic/ from the BASE_URL
		if new_base_url.include? "/portal/classic/"
			new_base_url["/portal/classic/"]= ""
		end
	
		# creating the new URL to access the Nagios service page 
        nagios_servive_page_url = String.new
		nagios_servive_page_url = new_base_url + 
		"/nagios-app/extinfo.cgi?type=2&host="+host+"&service="+service
		# now accessing the page via the new URL
		@browser.goto nagios_servive_page_url
		
		sleep(2)
    end
	
	def select_service_group(service_group)
		@browser.span(:text => service_group).when_present.click
		sleep(2)
	end
	
	def check_event_service_group_summary_page(service)
		@browser.span(:id => /SGVform:eventHeader/, :text=> /Events & Service List/).click
		sleep(2)
		@browser.span(:id => /SGVform:SLtblService:0:SLtxtNameService/, :text => service).exists?
		proof2 = @browser.span(:id => /SGVform:SLtblService:0:SLtxtNameService/, :text => service).text
		#puts proof2
		@browser.span(:id => /SGVform:eventHeader/, :text=> /Events & Service List/).click
	end

	
	def downtime_service(option,comment,time)
		@browser.link(:text => /Downtime/).click				
		sleep(1)
		@browser.link(:text => /Schedule Downtime For This Service/).click	
		sleep(2)
		@browser.textarea(:name => /SVform:actionsPortlet_txtComment/).set comment
		@browser.select(:name => /SVform:actionsPortlet_menuType/).select option
		sleep(2)								
		
		if option == 'Flexible'
			@browser.text_field(:name => /SVform:actionsPortlet_txtHours/).set time
			@browser.text_field(:name => /SVform:actionsPortlet_txtMinutes/).set time	
			@browser.button(:name => /SVform:actionsPortlet_btnSubmit/).when_present.click
		else 
			@browser.button(:name => /SVform:actionsPortlet_btnSubmit/).when_present.click
			sleep(3)
		end	
	end
	
	def navigate_host_page_nagios(host)
	
		new_base_url = String.new
		# copying the BASE_URL to a new string
		new_base_url = BASE_URL
		# slicing off the /portal/classic/ from the BASE_URL
		if new_base_url.include? "/portal/classic/"
			new_base_url["/portal/classic/"]= ""
		end
	
		# creating the new URL to access the Nagios service page 
        nagios_host_page_url = String.new
		nagios_host_page_url = new_base_url + 
		"/nagios-app/extinfo.cgi?type=1&host="+host
		# now accessing the page via the new URL
		@browser.goto nagios_host_page_url
		
		sleep(2)
    end
end

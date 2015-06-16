class NetHubPage
    include PageObject

direct_url BASE_URL + "groundwork-administration/nethubview"

	in_frame(:id => 'myframe') do |frame|		

		link :add_opendaylight, :class => /button-l/, :href => /opendaylight/, :frame => frame
		
		text_field :display_name, :id => /common.displayName/, :frame => frame
		text_field :groundwork_server, :id => /groundwork.server.name/, :frame => frame
		text_field :odl_server, :id => /virtualEnv.serverName/, :frame => frame
		text_field :username, :id => /virtualEnv.username/, :frame => frame
		text_field :password, :name => /connection.password/, :frame => frame
		text_field :wsuser_name, :id => /groundwork.webservices.username/, :frame => frame
		text_field :wsuser_pwd, :name => /gwos.wsPassword/, :frame => frame
		text_field :interval, :name => /common.uiCheckIntervalMinutes/, :frame => frame
		text_field :ns_warning_threshold, :id => /vm_warningThreshold_1/, :frame => frame
		text_field :ns_critical_threshold, :id => /vm_criticalThreshold_1/, :frame => frame
		
		button :save, :value => /Save/, :frame => frame
		button :test_connection, :value => /Test Connection/, :frame => frame
		button :home, :value => /Home/, :frame => frame
		button :startconnection, :id => /startStopServerbtn/, :frame => frame
		button :modify, :value => /Modify/, :frame => frame
		button :next, :value => /Next/, :frame => frame
		button :delete, :value => /Delete/, :frame => frame
		button :next, :value => /Next/, :frame => frame
		
		div :green, :class => /greencircle/, :frame => frame
		p :nethub, :text => /Net Hub Configuration wizard for Open Daylight /, :frame => frame
		td :testconnection, :text => "test", :frame => frame
		
		

	end
end

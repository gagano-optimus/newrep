class NagiosHostStatusDetailsPage
    include PageObject

    direct_url BASE_URL + "advanced/nagios-app/NagiosHostsView"
   
	in_frame(:id => 'myframe') do |frame|
        link :localhost, :title => /127.0.0.1/, :text => /localhost/, :frame => frame

    end
end

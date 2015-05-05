class AutodiscoveryPage
    include PageObject

    direct_url BASE_URL + "auto-disc"
 
    in_frame(:id => 'myframe') do |frame|

        select_list :filter_type, :name => 'filter_type', :frame => frame
        text_field :range_filter_name, :name => 'filter_name', :frame => frame
        text_field :range_filter_pattern, :name => 'filter_value', :frame => frame
        text_field :discovery_definition_name, :name =>  "discover_name_new", :frame => frame
        text_field :discovery_definition_description, :name =>  "description", :frame => frame

        checkbox :NmapTCP, :value => "Nmap TCP", :frame => frame
        checkbox :SNMP, :value => "SNMP", :frame => frame

    end

    def delete_filter(name)
        filter = @browser.frame(:id => "myframe").button(:name => "delete_filter_#{name}")
        if filter.exists?
            filter.when_present.click   
        end
    end

   def delete_confirm_filter
       filter_delete = @browser.frame(:id => "myframe").button(:name => "yes")
       if filter_delete.exists?
            filter_delete.when_present.click   
        end
    end

   
    def delete_confirm(name1)
        filter = @browser.frame(:id => "myframe").button(:name => "delete_filter_#{name1}")
 
          filter.exists?.should == false
        
    end

    def add_filter(name,range,type)
        self.filter_type=type
        self.range_filter_name=name
        self.range_filter_pattern=range
    end

    def add_schema(name)
        @browser.frame(:id => "myframe").button(:name => "new_group").when_present.click
        self.discovery_definition_name = name
        self.discovery_definition_description= name
        @browser.frame(:id => "myframe").select(:name => "schema").select("GroundWork-Discovery-Pro")
        @browser.frame(:id => "myframe").select(:name => "auto").select("Auto")
        @browser.frame(:id => "myframe").select(:name => "template").select("GroundWork-Default-Pro")
        @browser.frame(:id => "myframe").button(:name => "create_group").when_present.click

    end
end

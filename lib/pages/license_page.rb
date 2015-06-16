class LicensePage
    include PageObject

    direct_url BASE_URL + "groundwork-administration/licenseview"
	

	text_field :license, :name => /licform:keyTxt/
    	button :applylicense, :value => /Validate License Key/
	text_field :master_password, :id => /masterkeyCredentials/
    	text_field :ws_password, :id => /apiCredentials/
	text_field :remote_password, :id => /remoteapiCredentials/
    	text_field :proxy_password, :id => /proxyCredentials/
    	text_field :encryption_tool, :id => /toolCredentials/   
	
 
 def timestamp(account_update)
	if account_update == 'Update API Account'
		@last_updated_timestamp = @browser.span(:id => /lastUpdateAPICredentials/).text.to_s
	elsif account_update == 'Update Master Password'
		@last_updated_timestamp = @browser.span(:id => /lastUpdateMainCredentials/).text.to_s
	elsif account_update == 'Update Proxy Account'
		@last_updated_timestamp = @browser.span(:id => /lastUpdateProxyCredentials/).text.to_s 
	end
	return @last_updated_timestamp
	
 end 
 
 

 def set_license lic
    self.license = lic
    self.apply_license
 end
 

 def set_encryption(password)
	self.encryption_tool = password
 end
 

 def set_password (account_name,password)
	if account_name == 'Webervices API Account Info'
		self.ws_password = password
	elsif account_name == 'Master Account Info'
		self.master_password = password
	elsif account_name == 'Remote API Account Info'
		self.remote_password = password
	elsif account_name == 'Proxy Account Info'
		self.proxy_password = password        
 	end
 end
  

 def set_nullpassword (account_name)
     	if account_name == 'Webervices API Account Info'
        	self.ws_password_element.clear
     	elsif  account_name == 'Master Account Info'
       		self.master_password_element.clear
     	elsif account_name == 'Remote API Account Info'
       		self.remote_password_element.clear
     	elsif account_name == 'Proxy Account Info'
        	self.proxy_password_element.clear
	end
 end

  
 def confirm_message(account_name, message_span)
	
	if account_name == 'Webervices API Account Info'
		message_span.text.include?('Confirmation : API account updated successfully!').should == true

    	elsif account_name == 'Master Account Info'
		message_table = @browser.table(:id => /sysacctmgmtform:messagesOutput/)
		message_table.tr(:index => 0).text.include?('API account testing(SOAP): SUCCESS! ==> 200 OK').should == true
		proxy = message_table.tr(:index => 1).text
		puts proxy
		message_table.tr(:index => 1, :text => /#{proxy}/).exists?.should == true
		message_table.tr(:index => 2).text.include?('Confirmation : API account updated successfully!').should == true
		message_table.tr(:index => 3).text.include?('Confirmation : Proxy account updated successfully!').should == true
		message_table.tr(:index => 4).text.include?('Confirmation : Master password updated successfully!').should == true
	
    	elsif account_name == 'Remote API Account Info'
        	message_span.text.include?('Confirmation : Remote API account updated successfully!').should == true
	
	end
 end
 

 def error_message(account_name)
	error_span = @browser.span(:class => /error-message/).when_present
	puts error_span.text

 	if account_name == 'Master Account Info'
		@browser.span(:id => /sysacctmgmtform/, :class => /iceMsgError/, :text => /MasterPassword: Validation Error/ ).exists?
         
	elsif account_name == 'Proxy Account Info'
		error_span.text.include?('Proxy account testing(Cacti) :  FAILED! ==> 401 Unauthorized').should == true
         
	elsif account_name == 'Webervices API Account Info'
		error_span.text.include?('API account testing(SOAP) :  FAILED! ==> 401 Unauthorized').should == true
	end
 end

end

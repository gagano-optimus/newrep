Given(/^I am on License Page$/) do
  	visit AdministrationViewPage
  	on AdministrationViewPage do |page|
   		page.go_to_subtab("License")
  	end
end


When(/^I enter a password "(.+)" for "(.+)"$/) do |password, account_name| 
   	on LicensePage do |page|
		if password == "as_blank"
			page.set_nullpassword(account_name)
		else
  			page.set_password(account_name,password)
		end
  	end
end



And(/^I click on "(.+)" button to "(.+)"$/) do |account_update, operation|
	if operation == 'update'
		if account_update == 'Update API Account'
			@ws_token_before_update = @browser.span(:id => /sysacctmgmtform:encApiCredentials/).text.to_s
		end
		on LicensePage do |page|
			if account_update != 'Update Remote Account'	
				@last_updated_timestamp_before = page.timestamp(account_update)
			end
		end	
		@browser.button(:value => /#{account_update}/).when_present.click
		@browser.alert.ok
		sleep(5)
		
	elsif operation == 'test'
		@browser.button(:id => /#{account_update}/).when_present.click
		
	elsif operation == 'generate'
		@password_before_generate = @browser.td(:id => /toolpanel-1-1/).text.to_s
    		@browser.button(:value => /#{account_update}/).when_present.click
		
	elsif operation == 'test all passwords'
		@browser.button(:id => /sysacctmgmtform:test/).when_present.click

	end
	
end


Then(/^"(.+)" message should be displayed for "(.+)"$/) do |message_status, account_name|
   	
	$message_span = @browser.span(:class => /info-message/).when_present
	if message_status == 'confirmation' 
		on LicensePage do |page|
        		page.confirm_message(account_name, $message_span)  
		end
		
	elsif message_status == 'error'
		on LicensePage do |page|
			page.error_message(account_name)
		end

	elsif message_status == 'warning'
		@browser.span(:id => /sysacctmgmtform/, :class => /iceMsgError/).text.include? ('Value is required.')
	
	elsif message_status == 'test'
		if account_name == 'Webervices API Account Info'
			$message_span.text.include?('API account testing(SOAP): SUCCESS! ==> 200 OK').should == true

		elsif account_name == 'Proxy Account Info'
			$message_span.text.include? ('Proxy account testing(Cacti) :  SUCCESS! ==> 200 OK').should == true

		elsif account_name == 'API and Proxy accounts'
			message_table = @browser.table(:id => /sysacctmgmtform:messagesOutput/)		
			message_table.tr(:index => 0).text.include?('API account testing(SOAP): SUCCESS! ==> 200 OK').should == true
			message_table.tr(:index => 1).text.include?('Proxy account testing(Cacti) :  SUCCESS! ==> 200 OK').should == true

		end
		
	end

end


And (/^last updated timestamp should be "(.+)" after "(.+)"$/) do |status, account_update|
	on LicensePage do |page|
		if account_update != 'Update Remote Account'	
				@last_updated_timestamp_after = page.timestamp(account_update)
		end

		if status == 'updated'
			if account_update != 'Update Remote Account'
      				if @last_updated_timestamp_before == @last_updated_timestamp_after
					puts 'Timestamp is same. Update failed'
					raise
				else
					puts 'Timestamp is different. Update successful'
				end
			end
		elsif status == 'unchanged'
			if @last_updated_before == @last_updated_after
				puts 'Timestamp is same. Update failed. This is expected'
			else
				puts 'Timestamp is different. Update failed'
				raise
			end
		end
	end
end


And (/^a new token should be generated for "(.+)"$/) do |account_name|
	if account_name == 'Webervices API Account Info'	
		@ws_token_after_update = @browser.span(:id => /sysacctmgmtform:encApiCredentials/).text.to_s

		if @ws_token_before_update == @ws_token_after_update
			puts 'Token is same. Update failed'
			raise

		else
			puts 'Token is different.'

		end
	elsif 
		puts 'Token is not generated in the account'

	end
end


		
Then(/^error message should be displayed for "(.+)"$/) do |account_name|
  	on LicensePage do |page|
  		page.error_message(account_name)
 	end
end

	
When(/^I enter "(.+?)" as password under the Encryption Tool$/) do |password|
	@browser.text_field(:id => /toolCredentials/).set password
end


Then(/^a new encrypted password should be generated$/) do
	@password_after_generate = @browser.td(:id => /toolpanel-1-1/).text.to_s

	if (@password_before_generate == @password_after_generate)
		puts "Password is same after generation. Generate Failed!"
		raise
	else
		puts "New encrypted password generated!"
	end
end


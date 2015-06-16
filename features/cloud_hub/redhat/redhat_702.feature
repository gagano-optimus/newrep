Feature: CloudHub - RedHat
	In order to know that the build is working
	As a tester
	I want to see CloudHub - RedHat module functionality working

#########################  RedHat Connection  ############################## 
  
Scenario: Add new Cloud Hub Configuration for RedHat
 	Given I am on the Cloud Hub page
 	When I select "RedHat" for new connection
 	When I start new redhat configuration and set all fields as "test","localhost","wsuser","wsuser","eng-rhev-m-1.groundwork.groundworkopensource.com","api","#m3t30r1t3","/usr/local/groundwork/java/jre/lib/security/cacerts","changeit","6","4"
 	And I select the Storage View, Network View and Resource Pool View
 	And I save the connection
	And test connection is done
	And verify connection is established
 	And I navigate to cloud hub home page
 	Then the connection - "test" added should be in Stop state
 
 

Scenario: Start Cloud Hub Configuration for RedHat
 	Given I am on the Cloud Hub page
 	And I start the new connection - "test" created
 	Then connection - "test" should be started
 	Then rhev servers should be displayed on the Status viewer and Event console page
 

  
Scenario Outline: Verify addition of Storage View, Network View and Resource Pool hosts on Status Page
 	Given I am on the Status page
 	And I verify the "<view>" hosts on Status viewer page
 	Then the hosts should be visible
 
 Scenarios:
 |view|
 |Storage View|
 |Network View|
 |Resource Pool|
 
  
 Scenario Outline: Verify addition of Storage View, Network View and Resource Pool hosts on Event Console Page
 	Given I am on the Event page
 	And I verify the "<view>" hosts on Event console page
 	Then the hosts should be visible
 
 Scenarios:
 |view|
 |Storage View|
 |Network View|
 |Resource Pool|
 


  
Scenario: Visit RedHat connection's Threshold Configuration page  
 	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test"
 	And test connection is done 
 	And I click next button
 	Then verify Cloud Hub Configuration page for "RedHat" should be opened


#Scenario: Visit Cloud Hub Configuration page 
 #Given I am on the Cloud Hub page
 #When I click modify button
 #And I click next button
 #Then verify Cloud Hub Configuration page for RHEVM should be opened

  
 
Scenario: Failed Red Hat Cloud Hub Configuration setup
 	Given I am on the Cloud Hub page
 	When I select "RedHat" for new connection
 	When I start new redhat configuration and set all fields as "test345","local","testing123","testing123","eng-rhev-m-1.groundwork.groundworkopensource.com","api123","#m3tt3","/usr/local/groundwork/java/jre/cacerts","changeisgood","5","2"
 	And I save the connection
	And test connection is done
	Then verify connection is not established 
 	And I navigate to cloud hub home page
	And I delete the connection - "test345" created  

  
Scenario: Failed Red Hat Cloud Hub Configuration setup due to special characters and long strings
 	Given I am on the Cloud Hub page
 	When I select "RedHat" for new connection
 	When I start new redhat configuration and set all fields as "^%$^$","!@#$%^&*()_+aswedeswaqsvghuynn","$%#&*)","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","5","2"
 	And I save the connection
	And test connection is done
	Then verify connection is not established
 	And I navigate to cloud hub home page
 	And I delete the connection - "^%$^$" created 
 

Scenario: Failed Red Hat Cloud Hub Configuration setup with blank inputs
 	Given I am on the Cloud Hub page
 	When I select "RedHat" for new connection
 	And I clear all the fields
 	And I save the connection
 	Then different validation messages should appear
 	
  
Scenario: Failed Red Hat Cloud Hub Configuration setup due to special characters in check and sync interval fields
 	Given I am on the Cloud Hub page
 	When I select "RedHat" for new connection
 	When I start new redhat configuration and set all fields as "test3456","localhost","wsuser","wsuser","eng-rhev-m-1.groundwork.groundworkopensource.com","api","#m3t30r1t3","/usr/local/groundwork/java/jre/lib/security/cacerts","changeit","&^%$","&^%$"
 	And I save the connection
 	Then check interval validation message should be displayed     
 
  
Scenario: Validating redhat Cloud Hub Configuration messages upon inputting special characters in warning and critical thresholds 
 	Given I am on the Cloud Hub page
 	When I select "RedHat" for new connection
 	When I start new redhat configuration and set all fields as "test34567","localhost","wsuser","wsuser","eng-rhev-m-1.groundwork.groundworkopensource.com","api","#m3t30r1t3","/usr/local/groundwork/java/jre/lib/security/cacerts","changeit","5","2"
 	And I save the connection
	And test connection is done
 	And I move to next page
 	When I enter value in hypervisor warning threshold and critical threshold as"^%$*","^%$*"
 	And I enter value in vm warning threshold and critical threshold as"^%$*","^%$*"
 	And I save the connection
 	Then threshold validation messages should be displayed
 	And I navigate to cloud hub home page
 	And I delete the connection - "test34567" created 
 
  
Scenario: Delete connection
 	Given I am on the Cloud Hub page
 	And I delete the connection - "test" created
 	Then verify connection - "test" should be deleted
	And I delete all other connections created

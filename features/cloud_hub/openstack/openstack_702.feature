Feature: CloudHub - OpenStack
	In order to know that the build is working
	As a tester
	I want to see CloudHub - OpenStack module functionality working

  
Scenario: Add new Openstack connection under Cloud Hub
	Given I am on the Cloud Hub page
 	When I select "Openstack" for new connection
	When I start new configuration and set fields as "test","localhost","wsuser","wsuser","agno.groundwork.groundworkopensource.com","6fd89a41705441a5b718aebe07a763d0","demo","demo","55d794a346cf413a","8774","5000","8777","5","-1"
 	And I save the connection
 	And test connection is done
 	And verify connection is established
 	And I navigate to cloud hub home page
 	Then the connection - "test" added should be in Stop state
  
Scenario: Start Openstack connection
	Given I am on the Cloud Hub page
 	And I start the new connection - "test" created
 	Then connection - "test" should be started
 	Then OS-H and OS-M servers should be displayed on the Status viewer and Event console page

  
Scenario: Visit Openstack connection's Threshold Configuration page  
	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test"
 	And test connection is done 
 	And I click next button
 	Then verify Cloud Hub Configuration page for "Open Stack" should be opened

  
Scenario: Verify Openstack connection with blank fields
 	Given I am on the Cloud Hub page
 	When I select "Openstack" for new connection
 	And I clear all fields
 	And I save the connection
 	Then different validation messages should appear

  
Scenario: Verify Openstack test connection with invalid input
 	Given I am on the Cloud Hub page
 	When I select "Openstack" for new connection
 	When I start new configuration and set fields as "test123","localhost123","wsuser123","testing=","agno.groundwork.groundworkopensource.com","6fd89a41705441a5b718aebe07a763d011","demo11","demo11","55d794a346cf413a11","8774","5000","8777","5","-1"
 	And I save the connection
 	And test connection is done
 	Then verify connection is not established
 	And I navigate to cloud hub home page
 	And I delete the connection - "test123" created

  
Scenario: Verify Openstack connection with special characters and long strings
 	Given I am on the Cloud Hub page
 	When I select "Openstack" for new connection
 	When I start new configuration and set fields as "@R$%^T","!@#$%^&*()_+abvfcdeswaqzxsedcf","#%#$$$","!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","*%&*%*&%(*%","7","2345343","8774","5000","8777","5","-1"
 	And I save the connection
 	And test connection is done
 	Then verify connection is not established  
 	And I navigate to cloud hub home page
 	And I delete the connection - "@R$%^T" created

  
Scenario: Verify error messages on entering special characters in Warning and Critical thresholds fields 
 	Given I am on the Cloud Hub page
	When I select "Openstack" for new connection
 	When I start new configuration and set fields as "test1234","localhost","wsuser","wsuser","agno.groundwork.groundworkopensource.com","6fd89a41705441a5b718aebe07a763d0","demo","demo","55d794a346cf413a","8774","5000","8777","5","-1"
 	And I save the connection
 	And test connection is done
 	And I move to next page
 	When I enter value in hypervisor warning threshold and critical threshold as"^%$*","^%$*"
 	And I enter value in vm warning threshold and critical threshold as"^%$*","^%$*"
 	And I save the connection
 	Then threshold validation messages should be displayed
 	And I navigate to cloud hub home page
 	And I delete the connection - "test1234" created  

  
Scenario: Verify Openstack connection with special characters in check interval field
 	Given I am on the Cloud Hub page
 	When I select "Openstack" for new connection
 	When I start new configuration and set fields as "test1234","localhost","wsuser","wsuser","agno.groundwork.groundworkopensource.com","6fd89a41705441a5b718aebe07a763d0","demo","demo","55d794a346cf413a","8774","5000","8777","ngsji","-1"
 	And I save the connection
 	Then check interval validation message should be displayed 

  
Scenario: Verify Openstack test connection with invalid ports
 	Given I am on the Cloud Hub page
 	When I select "Openstack" for new connection
 	When I start new configuration and set fields as "test345","localhost","wsuser","wsuser","agno.groundwork.groundworkopensource.com","6fd89a41705441a5b718aebe07a763d0","demo","demo","55d794a346cf413a","4005","4005","8877","5","-1"
 	And I save the connection
	And test connection is done
	Then I verify Openstack connection is not established
 	And I navigate to cloud hub home page
 	And I delete the connection - "test345" created 

  
Scenario: Verify editing Hypervisor Services on Thresholds configuration page
 	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test"
 	And test connection is done
 	And I click next button
 	And I remove a "Hypervisor" service "free_ram_mb"
 	And save it
 	Then verify changes are applied for "Hypervisor" on Status viewer page

  
Scenario: Verify editing Virtual Machine Services on Thresholds configuration page
 	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test"
 	And test connection is done
 	And I click next button
 	And I remove a "Virtual Machine" service "cpu_util"
 	And save it
 	Then verify changes are applied for "Virtual Machine" on Status viewer page
 


  
Scenario: Delete Openstack connections
 	Given I am on the Cloud Hub page
 	And I delete the connection - "test" created
 	Then verify connection - "test" should be deleted
	And I delete all other connections created

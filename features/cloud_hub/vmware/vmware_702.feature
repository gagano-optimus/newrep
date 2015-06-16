Feature: CloudHub - VMWare
	In order to know that the build is working
	As a tester
	I want to see CloudHub - VMWare module functionality working

#########################  VM-Ware Connection ##############################

  
Scenario: Add new Cloud Hub Configuration for VMWare
 	Given I am on the Cloud Hub page
 	When I select "VMWare" for new connection
 	When I start new configuration and set all fields as "test","localhost","wsuser","wsuser","vermont2","groundwork\optimus-qa-test","gwopt@321","5"
 	And I select the Storage View, Network View and Resource Pool View
 	And I save the connection
 	And test connection is done
 	And verify connection is established
 	And I navigate to cloud hub home page
 	Then the connection - "test" added should be in Stop state
 
  
Scenario: Start Cloud Hub Configuration for VMWare
 	Given I am on the Cloud Hub page
 	And I start the new connection - "test" created
 	Then connection - "test" should be started
 	Then ESX-Vermont servers should be displayed on the Status viewer and Event console page

  
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

  
Scenario: Visit VMware connection's Threshold Configuration page  
 	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test"
 	And test connection is done 
 	And I click next button
 	Then verify Cloud Hub Configuration page for "VMware" should be opened

  
Scenario: Verify editing Hypervisor Services on Thresholds configuration page
	 Given I am on the Cloud Hub page
	 When I click modify button of connection - "test"
	 And test connection is done
	 And I click next button
	 When I select one "Hypervisor" service "summary.quickStats.overallCpuUsage" and set thresholds as "9999999999" and "9999999999"
	 And I remove one "Hypervisor" service "syn.host.cpu.used"
	 And save it
	 Then verify changes are done to "Hypervisor" on Status viewer page

   
Scenario: Verify editing Virtual Machine Services on Thresholds configuration page
	 Given I am on the Cloud Hub page
	 When I click modify button of connection - "test"
	 And test connection is done
	 And I click next button
	 When I select one "Virtual Machine" service "summary.quickStats.uptimeSeconds" and set thresholds as "9999999999" and "9999999999"
	 And I remove one "Virtual Machine" service "syn.vm.cpu.cpuToMax.used"
	 And save it
	 Then verify changes are done to "Virtual Machine" on Status viewer page
 
   
Scenario: Verify VMware test connection with invalid input
	 Given I am on the Cloud Hub page
	 When I select "VMWare" for new connection
	 When I start new configuration and set all fields as "test123","localhost345","wsuser123","testing123","vermont211","groundwork\optimus-qa-test-456","gwopt@3214567","7"
	 And I select the Storage View, Network View and Resource Pool View
	 And I save the connection
	 And test connection is done
	 Then verify connection is not established
	 And I navigate to cloud hub home page
	 And I delete the connection - "test123" created 
  
  
  
Scenario: Verify VMware connection with blank fields
	 Given I am on the Cloud Hub page
	 When I select "VMWare" for new connection
	 And I clear all fields
	 And I save the connection
	 Then different validation messages should appear
  
  
   
Scenario: Verify VMware connection with special characters and long strings
	 Given I am on the Cloud Hub page
	 When I select "VMWare" for new connection
	 When I start new configuration and set all fields as "!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","@#%$%","!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","*%&*%*&%(*%","7"
	 And I select the Storage View, Network View and Resource Pool View
	 And I save the connection
	 And test connection is done
	 Then verify connection is not established  
	 And I navigate to cloud hub home page
	 And I delete the connection - "!@#$%^&*()_+abvfcdeswaqzxsedcf" created  
  
  
Scenario: Verify VMware connection with special characters in check interval field
	 Given I am on the Cloud Hub page
	 When I select "VMWare" for new connection
	 When I start new configuration and set all fields as "test","localhost","wsuser","wsuser","vermont2","groundwork\optimus-qa-test","gwopt@321","*&^%"
	 And I select the Storage View, Network View and Resource Pool View
	 And I save the connection
	 Then check interval validation message should be displayed   
 
  
Scenario: Verify error messages on entering special characters in Warning and Critical thresholds fields 
	Given I am on the Cloud Hub page
	When I select "VMWare" for new connection
	When I start new configuration and set all fields as "test345","localhost","wsuser","wsuser","vermont2","groundwork\optimus-qa-test","gwopt@321","7"
	And I select the Storage View, Network View and Resource Pool View
	And I save the connection
	And test connection is done
	And I move to next page
	When I enter value in hypervisor warning threshold and critical threshold as"^%$*","^%$*"
	And I enter value in vm warning threshold and critical threshold as"^%$*","^%$*"
	And I save the connection
	Then threshold validation messages should be displayed
	And I navigate to cloud hub home page
 	And I delete the connection - "test345" created  
 
   
Scenario: Delete connection
	Given I am on the Cloud Hub page
 	And I delete the connection - "test" created
 	Then verify connection - "test" should be deleted
	And I delete all other connections created
 

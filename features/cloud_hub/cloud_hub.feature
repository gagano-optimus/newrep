Feature: Cloud Hub
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

#########################  VM-Ware Connection ##############################


Scenario: Add new Cloud Hub Configuration for VMWare
 Given I am on the Cloud Hub page
 When I select VMWare for new connection
 When I start new configuration and set all fields as "test","localhost","UTUBhTB7lsn52W9+8LuE8A==","vermont2","groundwork\optimus-qa-test","gwopt@321","5"
 And I select the Storage View, Network View and Resource Pool View
 And I save the connection
 And test connection is done
 And verify connection is established
 And I navigate to cloud hub home page
 Then the connection added should be in Stop state
 

Scenario: Start Cloud Hub Configuration for VMWare
 Given I am on the Cloud Hub page
 And I start the new connection created
 Then it should be started
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
 When I click modify button
 And test connection is done 
 And I click next button
 Then verify Cloud Hub Configuration page should be opened


Scenario: Hypervisor Services visible on Status Viewer page
 Given I am on the Cloud Hub page
 When I click modify button
 And test connection is done
 And I click next button
 When I select a hypervisor service "summary.quickStats.overallCpuUsage"
 And save it
 Then verify changes are done on Status viewer page 


Scenario: VM Services visible on Status Viewer page
 Given I am on the Cloud Hub page
 When I click modify button
 And test connection is done
 And I click next button
 When I select a vm service "summary.quickStats.uptimeSeconds"
 And save it
 Then verify vm changes are done on Status viewer page
 

Scenario: Verify VMware test connection with invalid input
 Given I am on the Cloud Hub page
 When I select VMWare for new connection
 When I start new configuration and set all fields as "test123","localhost345","testing123","vermont211","groundwork\optimus-qa-test-456","gwopt@3214567","7"
 And I select the Storage View, Network View and Resource Pool View
 And I save the connection
 And test connection is done
 Then verify connection is not established
 And I navigate to cloud hub home page
 And I delete the connection just created  
  
  

Scenario: Verify VMware connection with blank fields
 Given I am on the Cloud Hub page
 When I select VMWare for new connection
 And I save the connection
 Then different validation messages should appear
  
  

Scenario: Verify VMware connection with special characters and long strings
 Given I am on the Cloud Hub page
 When I select VMWare for new connection
 When I start new configuration and set all fields as "!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","!@#$%^&*()_+abvfcdeswaqzxsedcf","*%&*%*&%(*%","7"
 And I select the Storage View, Network View and Resource Pool View
 And I save the connection
 And test connection is done
 Then verify connection is not established  
 And I navigate to cloud hub home page
 And I delete the connection just created  
  

Scenario: Verify VMware connection with special characters in check interval field
 Given I am on the Cloud Hub page
 When I select VMWare for new connection
 When I start new configuration and set all fields as "test","localhost","UTUBhTB7lsn52W9+8LuE8A==","vermont2","groundwork\optimus-qa-test","gwopt@321","*&^%"
 And I select the Storage View, Network View and Resource Pool View
 And I save the connection
 Then check interval validation message should be displayed   
 

Scenario: Verify error messages on entering special characters in Warning and Critical thresholds fields 
 Given I am on the Cloud Hub page
 When I select VMWare for new connection
 When I start new configuration and set all fields as "test","localhost","UTUBhTB7lsn52W9+8LuE8A==","vermont2","groundwork\optimus-qa-test","gwopt@321","7"
 And I select the Storage View, Network View and Resource Pool View
 And I save the connection
 And test connection is done
 And I move to next page
 When I enter value in hypervisor warning threshold and critical threshold as"^%$*","^%$*"
 And I enter value in vm warning threshold and critical threshold as"^%$*","^%$*"
 And I save the connection
 Then threshold validation messages should be displayed
 And I navigate to cloud hub home page
 And I delete the connection just created  
 

Scenario: Delete connection
 Given I am on the Cloud Hub page
 When I click delete button
 Then verify connection should be deleted
 
#########################  RedHat Connection  ############################## 

Scenario: Add new Cloud Hub Configuration for RedHat
 Given I am on the Cloud Hub page
 When I select RedHat for new connection
 When I start new redhat configuration and set all fields as"test","localhost","UTUBhTB7lsn52W9+8LuE8A==","eng-rhev-m-1.groundwork.groundworkopensource.com","api","#gwopt@321","/usr/local/groundwork/java/jre/lib/security/cacerts","changeit","6","4"
 And I select the Storage View, Network View and Resource Pool View
 And I save the connection
# And test connection is done
# And verify connection is established
 And I navigate to cloud hub home page
 Then the connection added should be in Stop state
 
 

 Scenario: Start Cloud Hub Configuration for RedHat
 Given I am on the Cloud Hub page
 And I start the new connection created
 Then it should be started
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
 

Scenario: Visit Cloud Hub Configuration page 
 Given I am on the Cloud Hub page
 When I click modify button
 And I click next button
 Then verify Cloud Hub Configuration page for RHEVM should be opened

  

 Scenario: Failed Red Hat Cloud Hub Configuration setup
 Given I am on the Cloud Hub page
 When I select RedHat for new connection
 When I start new redhat configuration and set all fields as"test","local","testing123","eng-rhev-m-1.groundwork.groundworkopensource.com","api123","#m3tt3","/usr/local/groundwork/java/jre/cacerts","changeisgood","5","2"
 And I save the connection
# And test connection is done
# Then verify connection is not established 
 And I navigate to cloud hub home page
 And I delete the connection just created  


 Scenario: Failed Red Hat Cloud Hub Configuration setup due to special characters and long strings
 Given I am on the Cloud Hub page
 When I select RedHat for new connection
 When I start new redhat configuration and set all fields as"!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","!@#$%^&*()_+aswedeswaqsvghuynn","5","2"
 And I save the connection
#And test connection is done
#Then verify connection is not established
 And I navigate to cloud hub home page
 And I delete the connection just created  
 

 Scenario: Failed Red Hat Cloud Hub Configuration setup with blank inputs
 Given I am on the Cloud Hub page
 When I select RedHat for new connection
 And I save the connection
 Then different validation messages for redhat connection should appear
 

Scenario: Failed Red Hat Cloud Hub Configuration setup due to special characters in check and sync interval fields
 Given I am on the Cloud Hub page
 When I select RedHat for new connection
 When I start new redhat configuration and set all fields as"test","localhost","UTUBhTB7lsn52W9+8LuE8A==","eng-rhev-m-1.groundwork.groundworkopensource.com","api","#gwopt@321","/usr/local/groundwork/java/jre/lib/security/cacerts","changeit","&^%$","&^%$"
 And I save the connection
 Then check interval validation message should be displayed   
# And I navigate to cloud hub home page
# And I delete the connection just created  
 

 Scenario: Validating redhat Cloud Hub Configuration messages upon inputting special characters in warning and critical thresholds 
 Given I am on the Cloud Hub page
 When I select RedHat for new connection
 When I start new redhat configuration and set all fields as"test","localhost","UTUBhTB7lsn52W9+8LuE8A==","eng-rhev-m-1.groundwork.groundworkopensource.com","api","#gwopt@321","/usr/local/groundwork/java/jre/lib/security/cacerts","changeit","5","2"
 And I save the connection
#And test connection is done
 And I move to next page
 When I enter value in hypervisor warning threshold and critical threshold as"^%$*","^%$*"
 And I enter value in vm warning threshold and critical threshold as"^%$*","^%$*"
 And I save the connection
 Then threshold validation messages should be displayed
 And I navigate to cloud hub home page
 And I delete the connection just created 
 

Scenario: Delete connection
 Given I am on the Cloud Hub page
 When I click delete button
 Then verify connection should be deleted

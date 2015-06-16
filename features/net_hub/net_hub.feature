Feature: NetHub - OpenDaylight
	In order to know that the build is working
	As a tester
	I want to see NetHub - OpenDaylight module functionality working

##############  OPEN DAYLIGHT CONNECTION #####################

Scenario: Add new Open Daylight connection under Net Hub
 	Given I am on the Net Hub page
 	When I select "OpenDaylight" for new connection
	When I start a new configuration and set all fields as "ODL","localhost","admin","6szcoii8MC3otuEEi6zaVA==","172.28.113.201:8080","admin","admin","5"
 	And I save the connection
 	And test connection is done
 	And verify connection is established
 	And I navigate to cloud hub home page
 	Then the connection - "ODL" added should be in Stop state

Scenario: Start Open Daylight connection
	Given I am on the Net Hub page
	And I start the new connection - "ODL" created
 	Then connection - "ODL" should be started
 	Then ODL-H and ODl-M servers should be displayed on the Status viewer and Event console page

Scenario: Visit Open Daylight connection's Threshold Configuration page 
 	Given I am on the Net Hub page
 	When I click modify button of connection - "ODL"
 	And test connection is done 
 	And I click next button
 	Then verify Cloud Hub Configuration page for "Open Daylight" should be opened



#Scenario: Verify adding new Virtual Machine Services
#Given I am on the Net Hub page
#When I click modify button of connection - "test_docker"
#And test connection is done
#And I click next button
#When I add a "Network Controller" service "collisionCount"
#And save it
#Then I verify service is added to "Network Controller" on the Status viewer page


Scenario: Verify adding new Network Switch Services
 	Given I am on the Net Hub page
 	When I click modify button of connection - "ODL"
 	And test connection is done
 	And I click next button
 	When I add a "Network Switch" service "collisionCount"
 	And save it
 	Then I verify service is added to "Network Switch" on the Status viewer page


Scenario: Verify Open Daylight connection with blank fields
 	Given I am on the Net Hub page
 	When I select "Opendaylight" for new connection
	And I clear all fields
 	And I save the connection
 	Then different validation messages should appear

Scenario: Verify Open Daylight connection with special characters in check interval field
 	Given I am on the Net Hub page
 	When I select "Opendaylight" for new connection
 	When I start a new configuration and set all fields as "test","localhost","admin","6szcoii8MC3otuEEi6zaVA==","172.28.113.201:8080","admin","admin","%$$%"
 	And I save the connection
 	Then check interval validation message should be displayed

Scenario: Verify error messages on entering special characters in Warning and Critical thresholds fields
	Given I am on the Net Hub page
	When I select "Opendaylight" for new connection
	When I start a new configuration and set all fields as "test1","localhost","admin","6szcoii8MC3otuEEi6zaVA==","172.28.113.201:8080","admin","admin","5"
	And I save the connection
 	And test connection is done
 	And I move to next page
 	And I enter value in vm warning threshold and critical threshold as"^%$*","^%$*"
 	And I save the connection
 	Then error messages should be displayed
 	And I navigate to cloud hub home page
 	And I delete the connection - "test1" created     
  

Scenario: Verify Open Daylight test connection with invalid input
 	Given I am on the Net Hub page
 	When I select "Opendaylight" for new connection
 	When I start a new configuration and set all fields as "test123","localhost","admin","6szcoii8MC3otuEEi6zaVA==77","172.28.113.201:8080","admin","admin","5"
 	And I save the connection
 	And test connection is done
 	Then verify connection is not established
 	And I navigate to cloud hub home page
 	And I delete the connection - "test123" created  

Scenario: Delete Open Daylight connections
 	Given I am on the Net Hub page
 	And I delete the connection - "ODL" created
 	Then verify connection - "ODL" should be deleted
	And I delete all other connections created

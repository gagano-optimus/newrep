Feature: CloudHub - Docker
	In order to know that the build is working
	As a tester
	I want to see CloudHub - Docker module functionality working


Scenario: Add new Docker Configuration
 	Given I am on the Cloud Hub page
 	When I select "Docker" for new connection
 	When I start new docker configuration and set all fields as "test_docker","localhost","RESTAPIACCESS","OAv8xVUnH8WeO2h0qzU2CIdH+1CJbrJxssv95GF4skE=","dock-01-qa:8081","docker1-","5","-1"
 	And I save the connection
 	And test connection is done
 	And verify connection is established
 	And I navigate to cloud hub home page
 	Then the connection - "test_docker" added should be in Stop state
 

Scenario: Start Docker Connection
 	Given I am on the Cloud Hub page
 	And I start the new connection - "test_docker" created
 	Then connection - "test_docker" should be started
 	And servers should be displayed on the Status viewer and Event console with host prefix "docker1-"


Scenario: Visit Docker connection's Threshold Configuration page  
 	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test_docker"
 	And test connection is done 
 	And I click next button
 	Then verify Cloud Hub Configuration page for "Docker" should be opened

# Refer to JIRA CLOUDHUB-191 : unable to start invalid connection
Scenario: Verify starting Docker connection with invalid input
 	Given I am on the Cloud Hub page
 	When I select "Docker" for new connection
 	When I start new docker configuration and set all fields as "invalid_docker","localhost123","RESTAPIACCESS123","testing123","abcdock-01-qa:8081","docker2-","5","-1"
 	And I save the connection
 	And test connection is done
 	Then verify connection is not established
	And I navigate to cloud hub home page
	And I start the new connection - "invalid_docker" created
	Then validation message should be displayed
 	And I delete the connection - "invalid_docker" created 


Scenario: Verify editing Docker Engine Services on Thresholds configuration page
 	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test_docker"
 	And test connection is done
 	And I click next button
 	When I select a "Docker Engine" service "cpu.usage.system" and set thresholds as "9999999999" and "9999999999"
	And I remove "Docker Engine" service "syn.memory.usage"
 	And save it
 	Then I verify changes are done to "Docker Engine" on Status viewer page


Scenario: Verify editing Docker Container Services on Thresholds configuration page
 	Given I am on the Cloud Hub page
 	When I click modify button of connection - "test_docker"
 	And test connection is done
 	And I click next button
 	When I select a "Docker Container" service "memory.working_set" and set thresholds as "9999999999" and "9999999999"
	And I remove "Docker Container" service "syn.cpu.usage.system"
 	And save it
 	Then I verify changes are done to "Docker Container" on Status viewer page
 

Scenario: Verify Docker test connection with invalid input
 	Given I am on the Cloud Hub page
 	When I select "Docker" for new connection
 	When I start new docker configuration and set all fields as "test_docker_1","localhost123","RESTAPIACCESS123","testing123","abcdock-01-qa:8081","docker2-","5","-1"
 	And I save the connection
 	And test connection is done
 	Then verify connection is not established
 	And I navigate to cloud hub home page
 	And I delete the connection - "test_docker_1" created 
  

Scenario: Verify Docker connection with blank fields
 	Given I am on the Cloud Hub page
 	When I select "Docker" for new connection
	And I clear all fields
 	And I save the connection
 	Then different validation messages should appear
  

Scenario: Verify Docker connection with special characters and long strings
 	Given I am on the Cloud Hub page
 	When I select "Docker" for new connection
 	When I start new docker configuration and set all fields as "@R$%^T","test345","@#%@#$%","#$%@%@#$@#$@","@#%@#$%@#$","abc123-","5","-1"
 	And I save the connection
 	And test connection is done
 	Then verify connection is not established  
 	And I navigate to cloud hub home page
 	And I delete the connection - "@R$%^T" created  
  

Scenario: Verify Docker connection with special characters in check interval field
 	Given I am on the Cloud Hub page
 	When I select "Docker" for new connection
 	When I start new docker configuration and set all fields as "test_docker_2","localhost","RESTAPIACCESS","OAv8xVUnH8WeO2h0qzU2CIdH+1CJbrJxssv95GF4skE=","dock-01-qa:8081","docker3-","abcd","-1"
 	And I save the connection
 	Then check interval validation message should be displayed
 

Scenario: Verify error messages on entering special characters in Warning and Critical thresholds fields 
 	Given I am on the Cloud Hub page
	When I select "Docker" for new connection
 	When I start new docker configuration and set all fields as "test_docker_123","localhost","RESTAPIACCESS","OAv8xVUnH8WeO2h0qzU2CIdH+1CJbrJxssv95GF4skE=","dock-01-qa:8081","docker4-","5","-1"
 	And I save the connection
 	And test connection is done
 	And I move to next page
 	When I enter value in hypervisor warning threshold and critical threshold as"^%$*","^%$*"
 	And I enter value in vm warning threshold and critical threshold as"^%$*","^%$*"
 	And I save the connection
 	Then threshold validation messages should be displayed
 	And I navigate to cloud hub home page
 	And I delete the connection - "test_docker_123" created   

# Refer to the JIRA - CLOUDHUB-189
Scenario: Verify error message appears on saving multiple connections with same host prefix
	Given I am on the Cloud Hub page
	When the connection test-docker exists
	And I select "Docker" for new connection
	And I start new docker configuration and set all fields as "test_docker_2","localhost","RESTAPIACCESS","OAv8xVUnH8WeO2h0qzU2CIdH+1CJbrJxssv95GF4skE=","dock-01-qa:8081","docker1-","5","-1"
	And I save the connection
	Then host prefix validation message should be displayed
 

Scenario: Delete Docker connections
 	Given I am on the Cloud Hub page
 	And I delete the connection - "test_docker" created
 	Then verify connection - "test_docker" should be deleted
	And I delete all other connections created

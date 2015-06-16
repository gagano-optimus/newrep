Feature: Status ViewerServices
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version


########################################   Pre-requisites   ########################################################

Scenario: Auto Discovery with auto-commit
  Given I am on the Auto Discovery page
  And I use the default discovery definition
  And I change the mode to auto commit
  And I add an address filter "auto-commit-service" of type "include" with range "172.28.112.152"
  Then I start the discovery
  And I remove filter "auto-commit-service"

Scenario: Create a Service group SG51
  Given I am on the Service Configuration page
  And I create a new Service Group with name "SG51"
  And I add the service "ssh_alive of host "qa-ubuntu-10-4-64" to the new Service Group
  And service group should be created sucessfully
  

Scenario: Change settings on service template page
Given I am on Services Configuration page
And I modify max check attempts and disable active checks in generic services
And I am on Control Configuration page
When I commit new objects to Nagios
Then the commit should be successful

#################################################### Service ##############################################################

Scenario Outline: Submit passive check results for a service and verify on Nagios service page
  Given I am on the Status Viewer page
  When I select a service "ssh_alive" of host "qa-ubuntu-10-4-64" on status viewer page
  And then submit passive check result for service with "<service status>"
  Then I navigate to "qa-ubuntu-10-4-64" "ssh_alive" Nagios service page 
  And verify that service is in "<service status>" status on Nagios service page
    Scenarios:
	| service status |
	| UNKNOWN     |


Scenario Outline: Submit passive check results for a service and verify on Servicegroup Summary page
  Given I am on the Status Viewer page
  When I select a service "ssh_alive" of host "qa-ubuntu-10-4-64" on status viewer page
  And then submit passive check result for service with "<service_status>"
  Then I select the Services tab on Status Viewer
  Then I select a service group "SG51" on status viewer page
  And verify that service "ssh_alive" is in "<service_status>" status on Servicegroup Summary page
   Scenarios:
  | service_status |
	| WARNING     	 |
	


Scenario Outline: Submit passive check results for a service and verify on Entire Network page
  Given I am on the Status Viewer page
  When I select a service "ssh_alive" of host "qa-ubuntu-10-4-64" on status viewer page
  And then submit passive check result for service with "<service status>"
  And I select Entire Network tab
  Then verify that service "ssh_alive" is in "<service status>" status on Entire Network page
  
  Scenarios:
  | service status |
  | OK             |
 
 
Scenario Outline: Submit passive check results for a service and verify on Service Summary page
  Given I am on the Status Viewer page
  When I select a service "ssh_alive" of host "qa-ubuntu-10-4-64" on status viewer page
  And then submit passive check result for service with "<service status>"
  Then verify that service is in "<service status>" status on Service Summary page  
  
  Scenarios:
  | service status |
  | CRITICAL       |
  
 
Scenario: Verify presence of last check time on service tab
  Given I am on the Status Viewer page
  When I select a service "ssh_alive" of host "qa-ubuntu-10-4-64" on status viewer page
  Then last check time for "service" should be displayed
  And since time should be displayed for "service"
  
Scenario Outline: Schedule service down using flexible/fixed downtime option
  Given I am on the Status Viewer page
  And I select a service "ssh_alive" of host "qa-ubuntu-10-4-64" on status viewer page
  Then I select the "<option>" downtime option with comment "down by qa" and time "1"
  Then verify that service "ssh_alive" of host "qa-ubuntu-10-4-64" is in "<option>" downtime
  
  Scenarios:
  | option   |
  | Flexible |
  | Fixed    |
   
  
#####################################   Service Group   #############################################    
 
Scenario Outline: Schedule downtime for all services of a service group
  Given I am on the Status Viewer page
  And I select service group "SG51" on status viewer page
  And I schedule "<option>" downtime for all services with comment "Down by QA" and time "1"
  Then I verify "<option>" downtime of the service "ssh_alive" of host "qa-ubuntu-10-4-64"
	Scenarios:
  | option   |
	| Flexible |
	| Fixed    |
 

Scenario: Disabling and enabling Notification for all services of a service group
  Given I am on Control Configuration page
  And I enable notifications from nagios main configuration 
  And I click save and next
  When I commit new objects to Nagios
  Then the commit should be successful  
  Then I am on the Status Viewer page
  And I select service group "SG51" on status viewer page
  Then I "disable" notifications of all services
  Then I verify notifications of service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" have been "disabled"
  Then I am on the Status Viewer page
  And I select service group "SG51" on status viewer page
  Then I "enable" notifications of all services
  Then I verify notifications of service "ssh_alive" of host "qa-ubuntu-10-4-64" have been "enabled"
 
Scenario: Disabling and enabling Active Checks for all services of a service group
  Given I am on the Status Viewer page
  And I select service group "SG51" on status viewer page
  Then I "disable" active checks of all services of the "servicegroup"
  Then I verify active checks of service "ssh_alive" of host "qa-ubuntu-10-4-64" have been "disabled"
  Then I am on the Status Viewer page
  And I select service group "SG51" on status viewer page
  Then I "enable" active checks of all services of the "servicegroup"
  Then I verify active checks of service "ssh_alive" of host "qa-ubuntu-10-4-64" have been "enabled"

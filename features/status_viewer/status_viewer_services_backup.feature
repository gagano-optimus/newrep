Feature: Status ViewerServices
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version


########################################   Pre-requisites   ########################################################

Scenario: Verify creating a host using Host Wizard
Given I am on the Host Configuration page
And I select the "Host wizard" option
And I add a new host "qa-ubuntu-10-4-64" with IP address "172.28.112.152" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
Then I am on Control Configuration page
And I commit new objects to Nagios
And the commit should be successful


Scenario: Verify creating a host using Host Wizard
Given I am on the Host Configuration page
And I select the "Host wizard" option
And I add a new host "qa-sles-11-64" with IP address "172.28.113.177" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
Then I am on Control Configuration page
And I commit new objects to Nagios
And the commit should be successful


Scenario: Creating a hostgroup
  Given I am on the Hosts page
  And I create a new Host group "TheHostGroup"
  And I add the host "qa-cent6-64" to the new host group
  When I "add" the changes
  Then "TheHostGroup" changes were "saved" correctly	
  Then I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful


Scenario: Create a Service group SG5
  Given I am on the Service Configuration page
  And I create a new Service Group with name "SG5"
  And I add the service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" to the new Service Group
  And service group should be created sucessfully
  Then I am on Control Configuration page
  And I commit new objects to Nagios
  Then the commit should be successful	


Scenario: Change settings on service template page
Given I am on Services Configuration page
And I modify max check attempts and disable active checks in generic services
And I am on Control Configuration page
When I commit new objects to Nagios
Then the commit should be successful

#################################################### Service ##############################################################

Scenario Outline: Submit passive check results for a service and verify on Nagios service page
  Given I am on the Status Viewer page
  When I select a service "icmp_ping_alive" of host "qa-sles-11-64" on status viewer page
  And then submit passive check result for service with "<service status>"
  Then I navigate to "qa-sles-11-64" "icmp_ping_alive" Nagios service page 
  And verify that service is in "<service status>" status on Nagios service page
    Scenarios:
	| service status |
	| UNKNOWN     |
	| CRITICAL    |
	| WARNING     |
	| OK          | 


Scenario Outline: Submit passive check results for a service and verify on Servicegroup Summary page
  Given I am on the Status Viewer page
  When I select a service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" on status viewer page
  And then submit passive check result for service with "<service_status>"
  Then I select the Services tab on Status Viewer
  Then I select a service group "SG5" on status viewer page
  And verify that service "local_cpu_httpd" is in "<service_status>" status on Servicegroup Summary page
   Scenarios:
    	| service_status |
    	| CRITICAL    |
	| UNKNOWN     |
	| WARNING     |
	| OK          |


Scenario Outline: Submit passive check results for a service and verify on Entire Network page
  Given I am on the Status Viewer page
  When I select a service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" on status viewer page
  And then submit passive check result for service with "<service status>"
  And I select Entire Network tab
  Then verify that service "local_cpu_httpd" is in "<service status>" status on Entire Network page
  
  Scenarios:
  | service status |
  | CRITICAL       |
  | WARNING        |
  | UNKNOWN        |
  | OK             |
 
 
Scenario Outline: Submit passive check results for a service and verify on Service Summary page
  Given I am on the Status Viewer page
  When I select a service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" on status viewer page
  And then submit passive check result for service with "<service status>"
  Then verify that service is in "<service status>" status on Service Summary page
  
  Scenarios:
  | service status |
  | CRITICAL       |
  | WARNING        |
  | UNKNOWN        |
  | OK             | 


Scenario Outline: Schedule service down using flexible/fixed downtime option
  Given I am on the Status Viewer page
  And I select a service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" on status viewer page
  Then I select the "<option>" downtime option with comment "down by qa" and time "1"
  Then verify that service "local_cpu_httpd" of host "localhost" is in "<option>" downtime
  
  Scenarios:
  | option   |
  | Flexible |
  | Fixed    |
   
  
#####################################   Service Group   #############################################    
  
Scenario Outline: Schedule downtime for all services of a service group
  Given I am on the Status Viewer page
  And I select service group "SG5" on status viewer page
  And I schedule "<option>" downtime for all services with comment "Down by QA" and time "1"
  Then I verify "<option>" downtime of the service "local_cpu_httpd" of host "qa-ubuntu-10-4-64"
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
  And I select service group "SG5" on status viewer page
  Then I "disable" notifications of all services
  Then I verify notifications of service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" have been "disabled"
  Then I am on the Status Viewer page
  And I select service group "SG5" on status viewer page
  Then I "enable" notifications of all services
  Then I verify notifications of service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" have been "enabled"


Scenario: Creating a hostgroup
  Given I am on the Hosts page
  And I create a new Host group "TheHostGroup"
  And I add the host "qa-ubuntu-10-4-64" to the new host group
  When I "add" the changes
  Then "TheHostGroup" changes were "saved" correctly	
  Then I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful	  
 
 
Scenario: Disabling and enabling Active Checks for all services of a service group
  Given I am on the Status Viewer page
  And I select service group "SG5" on status viewer page
  Then I "disable" active checks of all services of the "servicegroup"
  Then I verify active checks of service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" have been "disabled"
  Then I am on the Status Viewer page
  And I select service group "SG5" on status viewer page
  Then I "enable" active checks of all services of the "servicegroup"
  Then I verify active checks of service "local_cpu_httpd" of host "qa-ubuntu-10-4-64" have been "enabled"

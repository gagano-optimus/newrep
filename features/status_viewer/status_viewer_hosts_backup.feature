Feature: Status Viewer
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version

###############################################  Pre-Requisites  ##########################################################################

Scenario: Verify creating a host using Host Wizard
  Given I am on the Host Configuration page
  And I select the "Host wizard" option
  And I add a new host "qa-cent6-64" with IP address "172.28.111.201" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
  Then I am on Control Configuration page
  And I commit new objects to Nagios
  And the commit should be successful


Scenario: Verify creating a host using Host Wizard
  Given I am on the Host Configuration page
  And I select the "Host wizard" option
  And I add a new host "qa-rh6-64-2" with IP address "172.28.113.167" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
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
  And I add the service "local_cpu_httpd" of host "qa-cent6-64" to the new Service Group
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


###############################################  Hosts  ####################################################################
@as
Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Event Console page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host "qa-cent6-64" is in "<host status>","<index>" status on Event Console page
  Scenarios:
    | host status  |
    | UNREACHABLE  |
    | DOWN         |
    | UP           |
	
@as
Scenario Outline: Schedule host down using flexible/fixed downtime option.
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And I select "<option>" downtime option with "down by qa","1"
  And then submit passive check result with "DOWN"
  Then verify that host "qa-cent6-64" is in "Down" status
  Scenarios:
    | option   |
    | Fixed    |
    | Flexible |
	

Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Host Summary page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host "qa-cent6-64" is in "<host status>" status on host summary page
    Scenarios:
    | host status  |
    | UNREACHABLE  |
    | DOWN         |
    | UP           |
	

Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Entire Network page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host "qa-cent6-64" is in "<host status>","<index>" status on Entire Network page
    Scenarios:
    | host status  | index |
    | UNREACHABLE  | 2     |
    | DOWN         | 0     |
    | UP           | 4     |
	

Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Hostgroup summary page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host "qa-cent6-64" is in "<host status>","<index>" status on Hostgroup summary page
    Scenarios:
    | host status  | index |
    | UNREACHABLE  | 2     |
    | DOWN         | 0     |
    | UP           | 4     |
	

Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Nagios Host Status Details page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host is in "<host status>" state on Nagios Host Status Details page
   
  Scenarios:
   | host status | 
   | UNREACHABLE | 
   | DOWN        | 
   | UP          |	
   

Scenario: Disable notifications for a host and verify on host summary,entire network and nagios page
  Given I am on Control Configuration page
  And I enable notifications from nagios main configuration 
  And I click save and next
  And I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And disable "notification" for the host
  Then verify that "notifications" are disabled for "qa-cent6-64"


Scenario: Enable notifications for a host and verify on host summary,entire network and nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And enable "notification" for the host
  Then verify that "notifications" are enabled for "qa-cent6-64" 
   

Scenario: Disable active checks for a host and verify on host summary,entire network and nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  #And disable "active checks" for the host
  Then verify that "active checks" are disabled for "qa-cent6-64"
  

Scenario: Enable active checks for a host and verify on host summary,entire network and nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And enable "active checks" for the host
  Then verify that "active checks" are enabled for "qa-cent6-64" 
  

Scenario: Disable passive checks for a host and verify on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And disable "passive checks" for the host
  Then verify that "passive checks" are disabled for "qa-cent6-64"
  

Scenario: Enable passive checks for a host and verify on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And enable "passive checks" for the host
  Then verify that "passive checks" are enabled for "qa-cent6-64"
  

Scenario: Disable flap detection for a host and verify on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And disable "flap detection" for the host
  Then verify that "flap detection" are disabled for "qa-cent6-64"
  
@111
Scenario: Enable flap detection for a host and verify on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And enable "flap detection" for the host
  Then verify that "flap detection" are enabled for "qa-cent6-64"
  
@111 
Scenario: Disable event handler for a host and verify on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And disable "event handler" for the host
  Then verify that "event handler" are disabled for "qa-cent6-64"
  
@111
Scenario: Enable event handler for a host and verify on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And enable "event handler" for the host
  Then verify that "event handler" are enabled for "qa-cent6-64"
  
@111
Scenario: Reschedule next check for a host and verify on host summary page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And enable "reschedule next check" for the host
  Then verify that "reschedule next check" are enabled for "qa-cent6-64"
  

Scenario Outline: Search host using IP Address/Alias
  Given I am on the Status Viewer page
  When I goto search tab
  And enter host name "<hostname>" to be searched
  Then verify that "qa-cent6-64" is displayed as a search result
  Scenarios:
  |hostname      |
  |qa-cent6-64   |
  |172.28.111.201|
  

Scenario Outline: Verify prescence of last check time on service and host tab
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  Then last check time for "<option>" should be displayed
  Scenarios:
  |option |
  |host   |
  |service|
  

Scenario: Verify custom date time on host availabilty portlet
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And I select host availabilty portlet
  And select custom date-time
  Then calendar should be displayed and date-time should be editable
 

Scenario: Acknowledge host problem verify on host summary and hostgroup page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "DOWN"
  And click acknowledge button and fill details "test_ack"
  Then verify that comment "test_ack" is "updated" on host portlet under events tab,comments section and hostgroup page
 

Scenario: Acknowledge host comment on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "DOWN"
  And click acknowledge button and fill details "test_ack"
  Then verify that comment "test_ack" is "updated" on nagios page
  

Scenario: Removing host comment and verify on host summary and hostgroup page 
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And remove the comment added
  Then verify that comment "test_ack" is "deleted" on host portlet under events tab,comments section and hostgroup page
  

Scenario: Removing host comment and verify on nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And remove the comment added
  Then verify that comment "test_ack" is "deleted" on nagios page

Scenario: Acknowledge host comment
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "DOWN"
  And click acknowledge button and fill details "test_ack"
  Then verify that comment "test_ack" is "updated" on host portlet under events tab,comments section and hostgroup page
  And verify that comment "test_ack" is "updated" on nagios page

 
Scenario: Remove Acknowledge host comment
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And remove acknowledgement of problem 
  And remove the comment added
  Then verify that comment "test_ack" is "deleted" on nagios page
  And verify that comment "test_ack" is "deleted" on host portlet under events tab,comments section and hostgroup page


Scenario: Acknowledge host and verify comment on its service page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "DOWN"
  And click acknowledge button and fill details "test_ack"
  And set service "local_cpu_httpd" of this host to "CRITICAL" state
  Then verify comment appears on service page under comment portlet
  

Scenario: Viewing hostgroup of a host on host summary page
  Given I am on the Status Viewer page
  And I select only a host on the status viewer page
  And I select the Groups for this Hosts link
  Then the hostgroup is displayed
  And I close the Groups for this host window


Scenario: Deleting hosts should remove their corresponding services from service group 
  Given I am on the Host Configuration page
  And I select the "Host wizard" option
  And I add a new host "qa-rh6-64-2" with IP address "172.28.113.167" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
  Then I am on the Service Configuration page
  And I create a new Service Group with name "SG4"
  And I add the service "local_cpu_httpd" of host "localhost" to the new Service Group
  And I add the service "icmp_ping_alive" of host "qa-rh6-64-2" to the new Service Group
  And service group should be created sucessfully
  Then I am on Control Configuration page
  And I commit new objects to Nagios
  Then the commit should be successful 
  Then I am on the Status Viewer page
  And I select service group "SG4" on status viewer page
  And I verify that service "local_cpu_httpd" is added to service group "SG4" on Status Viewer page
  And I verify that service "icmp_ping_alive" is added to service group "SG4" on Status Viewer page
  Then I am on the Service Configuration page
  And I select the service group "SG4"
  Then I remove the service "icmp_ping_alive" of host "qa-rh6-64-2" from service group "SG4"
  Then I am on Control Configuration page
  And I commit new objects to Nagios
  Then the commit should be successful 
  Then I am on the Status Viewer page  
  And I select service group "SG4" on status viewer page
  And I should verify that service "icmp_ping_alive" is removed from service group on Status Viewer page


################################################  Host Group  #############################################################  
   
Scenario Outline: Schedule downtime for all hosts of a host group 
  Given I am on the Status Viewer page
  When I select a hostgroup "TheHostGroup" on status viewer page
  And I schedule "<option>" downtime for all "hosts" with comment "Down by QA" and time "1"
  Then I verify "<option>" downtime for the host "qa-ubuntu-12-4-64"
  Scenarios:
    	| option   |
	| Flexible |
	| Fixed    |


Scenario: Disable and enable notification of all hosts of a host group
  Given I am on Control Configuration page
  And I enable notifications from nagios main configuration 
  And I click save and next
  When I commit new objects to Nagios
  Then the commit should be successful  
  When I am on the Status Viewer page
  And I select a hostgroup "TheHostGroup" on status viewer page
  And I "disable" notifications of all hosts
  Then I verify notifications are "disabled" for the host "qa-cent6-64"
  When I am on the Status Viewer page
  And I select a hostgroup "TheHostGroup" on status viewer page
  And I "enable" notifications of all hosts
  Then I verify notifications are "enabled" for the host "qa-cent6-64"
  

Scenario: Disable and enable notification of all services associated with a host group  
  Given I am on Control Configuration page
  And I enable notifications from nagios main configuration 
  And I click save and next
  When I commit new objects to Nagios
  Then the commit should be successful  
  When I am on the Status Viewer page
  And I select a hostgroup "TheHostGroup" on status viewer page
  And I "disable" notifications of all services
  Then I verify notifications of service "local_cpu_httpd" of host "qa-cent6-64" have been "disabled"
  Then I am on the Status Viewer page
  And I select a hostgroup "TheHostGroup" on status viewer page
  And I "enable" notifications of all services
  Then I verify notifications of service "local_cpu_httpd" of host "qa-cent6-64" have been "enabled"
  

Scenario: Disabling and enabling Active Checks for all services of a host group
  Given I am on the Status Viewer page
  And I select a hostgroup "TheHostGroup" on status viewer page
  Then I "disable" active checks of all services of the "hostgroup"
  Then I verify active checks of the service "local_cpu_httpd" of host "qa-cent6-64" have been "disabled"
  Then I am on the Status Viewer page
  And I select a hostgroup "TheHostGroup" on status viewer page
  Then I "enable" active checks of all services of the "hostgroup"
  Then I verify active checks of the service "local_cpu_httpd" of host "qa-cent6-64" have been "enabled"

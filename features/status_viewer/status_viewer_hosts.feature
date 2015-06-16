Feature: Status Viewer
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version

###############################################  Pre-Requisites  ##########################################################################

Scenario: Auto Discovery with auto-commit
  Given I am on the Auto Discovery page
  And I use the default discovery definition
  And I change the mode to auto commit
  And I add an address filter "auto-commit" of type "include" with range "172.28.111.201"
  Then I start the discovery
  And I remove filter "auto-commit"


Scenario: Creating a hostgroup
  Given I am on the Hosts page
  And I create a new Host group "TheHostGroup"
  And I add the host "qa-cent6-64" to the new host group
  When I "add" the changes
  Then "TheHostGroup" changes were "saved" correctly


Scenario: Change settings on service template page
  Given I am on Services Configuration page
  And I modify max check attempts and disable active checks in generic services
  And I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful


###############################################  Hosts  ####################################################################

Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Event Console page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host "qa-cent6-64" is in "<host status>" status on Event Console page
  Scenarios:
    | host status  |
    | UNREACHABLE  |
	

Scenario Outline: Schedule host down using flexible/fixed downtime option.
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And I select "<option>" downtime option with "down by qa","1"
  And then submit passive check result with "DOWN"
  Then verify that host "qa-cent6-64" is in "DOWN" status
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
    | DOWN         |
	

Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Entire Network page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host "qa-cent6-64" is in "<host status>","<index>" status on Entire Network page
    Scenarios:
    | host status  | index |
    | DOWN         | 0     |
  

Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Hostgroup summary page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host "qa-cent6-64" is in "<host status>","<index>" status on Hostgroup summary page
    Scenarios:
    | host status  | index |
    | UNREACHABLE  | 2     |


Scenario Outline: Set host status unreachable/(unschedule)down/up and verify on Nagios Host Status Details page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "<host status>"
  Then verify that host is in "<host status>" state on Nagios Host Status Details page
   
  Scenarios:
   | host status | 
   | UP          |	
   

Scenario: Disable active checks for a host and verify on host summary,entire network and nagios page
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And disable "active checks" for the host
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
  

Scenario Outline: Search host using IP Address/Alias
  Given I am on the Status Viewer page
  When I goto search tab
  And enter host name "<hostname>" to be searched
  Then verify that "qa-cent6-64" is displayed as a search result
  Scenarios:
  |hostname      |
  |qa-cent6-64   |
  |172.28.111.201|
  

Scenario: Verify presence of last check time on host tab
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  Then last check time for "host" should be displayed
  And since time should be displayed for "host"

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
 

Scenario: Acknowledge host comment
  Given I am on the Status Viewer page
  When I select a host "qa-cent6-64" on status viewer page
  And then submit passive check result with "DOWN"
  And click acknowledge button and fill details "test_ack"
  Then verify that comment "test_ack" is "updated" on host portlet under events tab,comments section and hostgroup page
  And verify that comment "test_ack" is "updated" on nagios page




################################################  Host Group  #############################################################  

Scenario Outline: Schedule downtime for all hosts of a host group 
  Given I am on the Status Viewer page
  When I select a hostgroup "TheHostGroup" on status viewer page
  And I schedule "<option>" downtime for all "hosts" with comment "Down by QA" and time "1"
  Then I verify "<option>" downtime for the host "qa-cent6-64"
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
  

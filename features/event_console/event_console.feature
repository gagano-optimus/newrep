@event_console
Feature: Event Console
    In order to know that the build is working
    As a tester
    I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version

################  PRE-REQUISITES  ######################

Scenario: Change settings on service template page
  Given I am on Services Configuration page
  And I modify max check attempts and disable active checks in generic services
  And I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful

Scenario: Change settings on host template page
  Given I am on Host Configuration page
  And I modify max check attempts and disable active checks in generic hosts
  And I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful
  
Scenario: Adding host 'qa-rh6-64-2' by auto discovery
  Given I am on the Auto Discovery page
  And I use the default discovery definition
  And I change the mode to auto commit
  And I add an address filter "hosts_ec" of type "include" with range "172.28.113.167"
  Then I start the discovery

Scenario: Create Host group "HG7"
  Given I am on the Host Configuration page
  And I create a new Host group "HG7"
  And I add the host "qa-rh6-64-2" to the new host group
  When I "add" the changes
  Then "HG2" changes were "saved" correctly
  

Scenario: Create Service group "SG7"
Given I am on the Service Configuration page
And I create a new Service Group "SG7"
And I add the service "icmp_ping_alive" of host "qa-rh6-64-2" to the new Service Group
Then service group should be created sucessfully
And I am on Control Configuration page
When I commit new objects to Nagios
Then the commit should be successful

##############   TEST CASES   #######################
  
#################  OpStatus   ###################### 

Scenario: Open log message on Event Console
Given I am on the Event Console page
And I apply the filter "NAGIOS" under Applications 
When I select 1 event
And I perform the action open log message
And I navigate to operation status open filter
Then the events selected must be display


Scenario: Close log message on Event Console
Given I am on the Event Console page
And I apply the filter "NAGIOS" under Applications
When I select 1 event
And I perform the action close log message
And I navigate to operation status close filter
Then the events selected must be display


Scenario: Accept log message on Event Console 
Given I am on the Event Console page
And I apply the filter "NAGIOS" under Applications 
When I select 1 event
And I perform the action accept log message
And I navigate to operation status "accepted" filter
Then I should see there are events in this view
And I revert the changes


Scenario: Notify log message on Event Console (GWTC 7500)
Given I am on the Event Console page
And I apply the filter "NAGIOS" under Applications 
When I select 1 event
And I perform the action notify log message
And I navigate to operation status "notified" filter
Then I should see there are events in this view
And I revert the changes


#######################  AppType   ########################### 


Scenario: Apply SYSTEM filter Applications on Event Console
Given I am on the Event Console page
When I apply the filter "SYSTEM" under Applications 
Then I should see there are events in this view


Scenario: Apply ARCHIVE filter Applications on Event Console
Given I am on the Event Console page
When I apply the filter "ARCHIVE" under Applications 
Then I should see there are events in this view


Scenario: Apply AUDIT filter Applications on Event Console
Given I am on the Event Console page
When I apply the filter "AUDIT" under Applications 
Then I should see there are events in this view


Scenario: Apply BSM filter Applications on Event Console
Given I am on the Event Console page
When I apply the filter "BSM" under Applications 
Then I should see there are events in this view


Scenario: Apply SNMPTRAP filter Applications on Event Console
Given I am on the Event Console page
When I apply the filter "SNMPTRAP" under Applications 
Then I should see there are events in this view


Scenario: Apply SYSLOG filter Applications on Event Console
Given I am on the Event Console page
When I apply the filter "SYSLOG" under Applications 
Then I should see there are events in this view


Scenario: Apply CACTI filter Applications on Event Console
Given I am on the Event Console page
When I apply the filter "CACTI" under Applications 
Then I should see there are events in this view


######################  Public Filters   ######################### 


Scenario: Apply All Open Events on Event Console
Given I am on the Event Console page
When I apply the filter "All Open Events" 
Then I should see there are events in this view


Scenario: Apply Critical on Event Console
Given I am on the Event Console page
When I apply the filter "Critical" 
Then I should see there are events in this view


Scenario: Apply Warning on Event Console
Given I am on the Event Console page
When I apply the filter "Warning" 
Then I should see there are events in this view


Scenario: Apply Nagios Warning on Event Console
Given I am on the Event Console page
When I apply the filter "Nagios Warning" 
Then I should see there are events in this view


Scenario: Apply Last 5 SNMPTRAP Warning on Event Console
Given I am on the Event Console page
When I apply the filter "Last 5 SNMPTRAP Warning" 
Then I should see there are events in this view


Scenario: Apply Last 10 min NAGIOS Critical filter on Event Console
Given I am on the Event Console page
When I apply the filter "Last 10 Minutes NAGIOS Critical" 
Then I should see there are events in this view


Scenario: Apply Current Troubled Open Events filter on Event Console
Given I am on the Event Console page
When I apply the filter "Current Troubled Open Events" 
Then I should see there are events in this view

#################################################################


Scenario: Verify search by messages on Event Console
Given I am on the Event Console page
And I select all open events
And I search for the events with the message "SSH OK"
When I click the Search button
Then I should only see events with the message "SSH OK"


Scenario: Verify search in new tab on Event Console
Given I am on the Event Console page
And I click on the new tab button
Then I see the window for new tab
And I search for the events with the message "HTTP OK" on the new tab
And I click the Search button
Then I should only see events with the message "HTTP OK" on the new tab


Scenario Outline: Generate a service alert
  Given I am on the Status Viewer page
  And I select a host and a service
  And I select submit passive Check Result with "<event status>"
  And I am on the Event Console page
  And I apply the filter "All Events"
  Then I see an event gets displayed with status as "<event status>"
  Scenarios:
    | event status |
    | CRITICAL     |
    | WARNING      |
    | UNKNOWN      |
    | OK           |


Scenario: Verify updation of tab label and running a blank search 
Given I am on the Event Console page
And I enter a new tab name "TestTab004"
Then the tab name gets updated as "TestTab004"
And I revert the change to the tab made above
And I run a blank search
Then an error message for running blank search is generated


#Scenario: Verify updation of tab label with an invalid name 
#Given I am on the Event Console page
#And I enter an invalid tab name
#Then an error message gets generated
#And the tab name does not get updated


Scenario: Verify functionality of Reset button 
Given I am on the Event Console page
And I fill in some values in textboxes and dropdowns
And I select the Reset button
Then all fields should get cleared


Scenario Outline: Generating event from Nagios and verifying on Event Console (part 1)
Given I am on Nagios Service Status Details page
And I navigate to "localhost" "local_cpu_httpd" Nagios service page
And I submit passive check result for "localhost" "local_cpu_httpd" with "<event status>"
Then I am on the Event Console page
Then I see an event in "<event status>" status is generated on Event Console page
Scenarios:
    | event status |
    | WARNING      |
    | OK           |
	

Scenario Outline: Generating event from Nagios and verifying on Event Console (part 2)
Given I am on Nagios Service Status Details page
And I navigate to "localhost" "local_cpu_httpd" Nagios service page
And I submit passive check result for "localhost" "local_cpu_httpd" with "<event status>"
Then I am on the Event Console page
Then I see an event in "<event status>" status is generated on Event Console page
Scenarios:
    | event status |
	| UNKNOWN      |
	| CRITICAL     |	


Scenario: Verify search by severity + OpStatus + MonStatus on Event Console 
Given I am on the Event Console page
And I apply the filter "All Events"
And I search for the events by severity and OpStatus and MonStatus
When I click the Search button
Then I should see there are events in this view

###########################################################################

Scenario: Verify if actions taken in console of User1 show up for other logged in users (GWTC 8732)
Given I am on the Status Viewer page
When I select a host "qa-rh6-64-2" on status viewer page
And then submit passive check result with "DOWN"
Then I logout of GW portal
And I login with operator user
When I am on the Event Console page
Then I should see event is generated of host "qa-rh6-64-2" in status "DOWN" 
Then I logout of GW portal
And I login with admin user
Then I am on the Status Viewer page
When I select a host "qa-rh6-64-2" on status viewer page
And then submit passive check result with "UP"


Scenario: Verify System Filter and Public Filter panes are collapsible (GWTC 8736)
Given I am on the Event Console page
When I click On "System Filters" pane heading
Then I verify System Filters pane has collapsed
When I click On "Public Filters" pane heading
Then I verify Public Filters pane has collapsed
Then I click On "System Filters" pane heading
Then I click On "Public Filters" pane heading


Scenario: Verify the list of host groups displayed under HostGroups under System Filter (GWTC 8737)
Given I am on the Status Viewer page
And I make a list of all the "Host Groups" currently present
Then I am on the Event Console page
And I verify each "hostgroup" present on Status Viewer is also visible on Event Console


Scenario: Verify the list of service groups displayed under ServiceGroups under System Filter (GWTC 8738)
Given I am on the Status Viewer page
And I make a list of all the "Service Groups" currently present
Then I am on the Event Console page
And I verify each "servicegroup" present on Status Viewer is also visible on Event Console
 

Scenario: Verify acknowledging a Nagios event 
Given I am on the Event Console page
And I apply the filter "NAGIOS" under Applications 
And I select 1 event
And I select the Actions button
And I select the Nagios Acknowledge option and fill in the acknowledge comment as "Event Acknowledged by QA"
Then I see acknowledgement comment "Event Acknowledged by QA" gets updated in the comment column of event  


Scenario: Verify event search by device hostname 
Given I am on the Event Console page
And I apply the filter "All Events"
And I search a device "qa-rh6-64-2"
Then I see all events of host "qa-rh6-64-2" only are displayed
 
 
Scenario: Verify functionality of 'Show Event Tile' link
Given I am on the Event Console page
And I select the Show Event Tile link
And I select the host group "HG7"
Then I see all events of host "qa-rh6-64-2" only are displayed


Scenario: Verify cross-links from Dashboard to Event Console
Given I am on the Dashboard Enterprise View page
And I select the host group "HG7"
Then I see all events of host "qa-rh6-64-2" only are displayed


Scenario: Verify filtering of events by HostGroup
Given I am on the Event Console page
And I select the group "HG7" from the "HostGroups" filter
Then I see all events of host "qa-rh6-64-2" only are displayed


Scenario: Verify filtering of events by ServiceGroup
Given I am on the Event Console page
And I select the group "SG7" from the "ServiceGroups" filter
Then I see all events of service "icmp_ping_alive" only are displayed

################################################################


Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a SYSTEM event 
Given I am on the Event Console page
And I apply the filter "SYSTEM" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "SYSTEM"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |


Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a AUDIT event 
Given I am on the Event Console page
And I apply the filter "AUDIT" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "AUDIT"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |


Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a BSM event 
Given I am on the Event Console page
And I apply the filter "BSM" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "BSM"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |


Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a CACTI event 
Given I am on the Event Console page
And I apply the filter "CACTI" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "CACTI"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |	
	
	
Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a NAGIOS event 
Given I am on the Event Console page
And I apply the filter "NAGIOS" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "NAGIOS"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged  | 
	| Notify      |Notified by QA     |Notified      | 
	| Accept      |Accepted by QA     |Accepted      |
	| Close       |Closed by QA       |Closed        |
	| Open        |Opened by QA       |Opened        |
	
	
Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a VEMA event 
Given I am on the Event Console page
And I apply the filter "VEMA" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "VEMA"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |
	
	
Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a CHRHEV event 
Given I am on the Event Console page
And I apply the filter "CHRHEV" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "CHRHEV"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |
	
	
Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a ARCHIVE event 
Given I am on the Event Console page
And I apply the filter "ARCHIVE" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "ARCHIVE"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |
	
	
Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a SEL event 
Given I am on the Event Console page
And I apply the filter "SEL" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "SEL"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |
	
	
Scenario Outline: Verify acknowledging, notifying, accepting , closing and opening a SNMPTRAP event 
Given I am on the Event Console page
And I apply the filter "SNMPTRAP" under Applications 
And I select 1 event
And I select the "<button>" button on Event Console
And I fill in the comment as "<comment>"
Then I see comment "<comment_view>" gets updated in the comment column of "SNMPTRAP"  
Scenarios:
    | button      |comment            |comment_view    | 
	| Acknowledge |Acknowledged by QA |Acknowledged by | 
	| Notify      |Notified by QA     |Notified by     | 
	| Accept      |Accepted by QA     |Accepted by     |
	| Close       |Closed by QA       |Closed by       |
	| Open        |Opened by QA       |Opened by       |
####################  TEST DATA DELETION  ######################


Scenario: Deleting the service group "SG7"
Given I am on the Service Configuration page
And I "delete" the service group "SG7"


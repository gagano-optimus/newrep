Feature: Auto Discovery

Scenario: Auto discovery with valid range/filter
 Given I am on auto-discovery page
 And I enter filter name as "test", filter pattern as "172.28.113.168" and choose type as "include"
 When I add the filter
 And perform auto-discovery with control type as auto-commit
 Then "172.28.113.168" host should be shown on the status viewer.

Scenario: Auto discovery with invalid range/filter
 Given I am on auto-discovery page
 And I enter filter name as "test1", filter pattern as "172.28.113." and choose type as "include"
 When I add the filter
 And perform auto-discovery
 Then error should be shown in the event during discovery stage of  auto-discovery

@456
Scenario: Add a range/filter
 Given I am on auto-discovery page
 And I enter filter name "172.28.113.211", filter pattern "172.28.113.211" and choose type "include"
 When I add filter
 Then the filter "172.28.113.211" should be added in the list of added filters

@456
Scenario: Delete a range/filter
 Given I am on auto-discovery page
 And I delete a filter of name "172.28.113.211"
 When I click 'Yes' on the subsequent page asking for confirming the deletion
 Then the filter "172.28.113.211" should be removed from the list of added filters


Scenario: Duplicate filter error
  Given I am on auto-discovery page
  And I create a duplicate range-filter with name "testnew", type "include" and range "172.28.113.160"
  When I try to add the Range/Filter
  Then I should see the duplicate message error for "testnew"

@123	
Scenario: Auto discovery with discovery definition not having any discovery method
  Given I am on auto-discovery page
  And I create a discovery definition "newtest" and create "testnew" filter of type "include" and range "172.28.113.160"
  When I Uncheck definition methods
  And save the definition
  And I launch go
  Then I should see no method assign message error for "newtest"


Scenario: New discovery definition
 Given I am on auto-discovery page
 When I add a new discovery definition "newschema" filling all the required details
 Then the added discovery definition "newschema" should be shown in the list of discovery definitions
  

Scenario: New discovery definition without a definition name and import schema
 Given I am on auto-discovery page
 And I add a new discovery definition
 When I click 'create' leaving discovery name and import schema blank
 Then discovery name and import schema required error message should be shown

Scenario: Filter of type 'include' and 'exclude'
 Given I am on auto-discovery page
 And I add a filter with type 'include' with range '172.28.113.165-167'
 And I add a filter with type 'exclude' with range '172.28.113.165'
 When I perform auto-discovery with control type 'auto-commit'
 Then hosts '172.28.113.166' and '172.28.113.167' should be shown in status viewer but not '172.28.113.165'.


Scenario: No range is assigned to discovery definition
 Given I am on auto-discovery page
 And I uncheck all the filters
 When I perform auto discovery
 Then no ranges assigned error message is shown

Scenario: Auto discovery with control type interactive
 Given I am on auto-discovery page
 And control type of discovery definition is 'interactive'
 And I add a filter with range '172.28.113.166'
 When I perform auto discovery
 And I process the records after the discovery
 And I commit the results
 Then the host should be shown in status viewer

Scenario: Auto discovery with control type auto
 Given I am on auto-discovery page
 And control type of discovery definition is 'auto'
 And I add a filter with range '172.28.113.166'
 When I perform auto discovery
 And I commit the results
 Then the host should be shown in status viewer

Scenario: Auto discovery with control type auto-commit
 Given I am on auto-discovery page
 And control type of discovery definition is 'auto commit'
 And I add a filter with range '172.28.113.166'
 When I perform auto discovery
 Then the host should be shown in status viewer

Scenario: Auto discovery with discovery definition having Nmap method
 Given I am on auto-discovery page
 And I edit the discovery definition
 And I check 'Nmap TCP', uncheck 'SNMP' and then save.
 When I perform auto discovery
 Then results shown should be of Nmap only

Scenario: Auto discovery with discovery definition having SNMP method
 Given I am on auto-discovery page
 And I edit the discovery definition
 And I check 'SNMP', uncheck 'Nmap TCP' and then save.
 When I perform auto discovery
 Then results shown should be of SNMP only

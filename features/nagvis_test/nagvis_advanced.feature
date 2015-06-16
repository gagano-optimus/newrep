Feature: Navgis Advanced
	In order to know that Nagvis is working
	As a tester
	I want to check the basic functionality 
		
Scenario: Display Build and version
Given Build and version

Scenario: Preparation - Check hosts 
  Given I am on the Status Viewer page
  When I open hosts all filter
  Then I should see all the hosts
  When I open group all filter
  Then I should see all the services

Scenario Outline: Overview Page
  Given I am on the Views page
  When I hover the "<Map>"
  Then the "<Map>" summary state should be "<State>"
  And  the "<Map>" summary output should match
  And  the "<Map>" map child information should match
  Examples:
    |  Map               |	State		|
    |  hostgroups       |	CRITICAL	|	
    |  servicegroups   |	CRITICAL	|	
    |  submaps         |	DOWN		|
 

Scenario Outline: Hosts group map
  Given I am on the Views page
  And I click on "hostgroups" map
  When I hover "<Group name>" icon on "hostgroup" map
  Then the Host "<Group name>" state should be "<State>"
  And  the Host "<Group name>" output should match
  And  the Host "<Group name>" child information should match
  Examples:
     |  Group name      |   State      	|
     |  hosts all       |   CRITICAL	|
     |  hosts critical  |   CRITICAL	|
     |  hosts ok        |   CRITICAL	|
     |  hosts pending   |   PENDING   	|
     |  hosts unknown   |   CRITICAL	|
     |  hosts warning   |   CRITICAL	|
     |  hosts up        |   CRITICAL   	|
     |  hosts down      |   CRITICAL	|


Scenario Outline: Service group map
  Given I am on the Views page
  And I click on "servicegroups" map
  When I hover "<Group name>" icon on "servicegroup" map
  Then the Service "<Group name>" state should be "<State>"
  And  the Service "<Group name>" output should match
  And  the Service "<Group name>" child information should match
  Examples:
     |  Group name          |   State      |
     |  group-all           |   CRITICAL   |
     |  group-ok            |   OK         |
     |  group-warning       |   WARNING    |
     |  group-critical      |   CRITICAL   |
     |  group-unknown       |   UNKNOWN    |
     |  group-pending       |   PENDING    |


Scenario Outline: Submaps
  Given I am on the Views page
  And I click on "submaps" map
  When I hover "<Map name>" icon on "map" map
  Then the Map "<Map name>" state should be "<State>"
  And  the Map "<Map name>" output should match
  And  the Map "<Map name>" child information should match
  Examples:
     |  Map name            |   State      |
     |  Hosts_Up            |   CRITICAL   |
     |  Hosts_Down          |   DOWN   	   |
     |  hostgroups          |   CRITICAL   |
     |  servicegroups       |   CRITICAL   |

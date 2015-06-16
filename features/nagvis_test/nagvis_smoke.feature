Feature: Navgis 
	In order to know that Nagvis is working
	As a tester
	I want to check the basic functionality 

Scenario: Display Build and version
Given Build and version

Scenario: Auto Discovery with auto-commit
  Given I am on the Auto Discovery page
  And I use the default discovery definition
  And I change the mode to auto commit
  And I add an address filter "nagvis_filter" of type "include" with range "172.28.113.162"
  When I start the discovery
  Then I should see the hosts "172.28.113.162" in Status viewer

Scenario: Create Hosts group
  	Given I am on the Host Configuration page
  	And I create a new Host group "HG2"
  	And I add the hosts except localhost to the new host group
  	When I "add" the changes
  	Then "HG2" changes were "saved" correctly

Scenario: Create Service group
  	Given I am on the Service Configuration page
  	And I create a new Service Group "SG1"
  	And I add the services to the new Service Group
  	Then service group should be created sucessfully
  	
 Scenario: Commit changes to Nagios
	Given I am on Control Configuration page
	When I commit new objects to Nagios
	Then the commit should be successful

###################  ADD SPECIAL #######################
	
Scenario: Add a special textbox
	Given I am on the Views page
	And I add a special textbox with "textbox"
	And I verify the textbox
	And I delete the textboxadded
	And I verify deleted textboxadded

Scenario: Create a Stateless line
	Given I am on the Views page
	And I make and verify stateless line
	And I delete and verify stateless line

Scenario: Create a Container
	Given I am on the Views page
	And I make a container witout url with error
	And I make a container
	And I verify the weblink inside container
	And I delete the container
	And I verify deleted container	
	
###############################################################
Scenario Outline: Rename Map
	Given I am on the Views page
	And I select "<oldname>" and rename it with "<newname>"
	Then I should be able to see the "<newname>" map
	Scenarios:
	|oldname       |newname        |
	|World         |testmap        |
	|testmap       |World          |

Scenario: Saving a map with invalid name
	Given I am on the Views page
	And I save a map with "ab@12"
	Then the created map with name "ab@12" should not be saved

Scenario: Create and Deleting a map
	Given I am on the Views page
	And I save a map with "Deletetestmap"
	Then I delete the map with "Deletetestmap"
	And I verify that the map with "Deletetestmap" has been deleted

Scenario: Importing a map
	Given I am on the Views page
	And I import a map
	And I delete the imported map "test"
	
Scenario Outline: Manage background
	Given I am on the Views page
	And I create a views background name "<name>" color "<color>" width "<width>" height "<height>"
	And I create a map with backgroundimage
	And I upload a background image
	And I create a map with uploadimage
	And I delete created background "<delete_map>" and "<delete_upload>"
	Scenarios:
	|name      | color| width| height| delete_map | delete_upload |
	|testimage |FF216B|1024  |768	 |name		  | uploadimage   |
	
Scenario: Manage Shapes
	Given I am on the Views page
	And I upload a shape
	And I create a map with the shape
	And I delete the shape that cannot be deleted
	Given I am on the Views page
	And I delete the shape
	
Scenario: Validation message for Manage Shapes
	Given I am on the Views page
	And I upload a shape with invalid format
	And I see validation message

Scenario: Export map to static
	Given I am on the Views page
	And I export a map to static
	And I delete the static map "statictest"

Scenario: Error message exporting invalid static map
	Given I am on the Views page
	And error message appears appears saving invalid staticmap

Scenario: User permission
	Given I am on the Views page
	And I give user permission to "gw-portal-user"
	And I logout from current user
	When I login with "user" gwuser
	Then I should be able to see the "PublicWeb" map
	And I logout from current user
	And I login with admin

Scenario: Reset User permission	
	Given I reset the user permission of "gw-portal-user"	

Scenario: User permission operator
	Given I am on the Views page
	And I give operator permission to "gw-monitoring-operator"
	And I logout from current user
	When I login with "operator" gwuser
	Then I should be able to see the "PublicWeb" map
	#And I do not see other maps
	And I logout from current user
	And I login with admin

Scenario: Reset User permission	operator
	Given I reset the user permission of "gw-monitoring-operator"	

Scenario: Cloning a NagVis object
	Given I am on the Views page
	And I add host "itmon-win" of type icon "host" on the map
	Then I clone the object "itmon-win"
	And I delete both the objects "itmon-win" added

Scenario: Verify rename and display of a map placed on a map
	Given I am on the Views page
	And I add host "CorpWeb" of type icon "map" on the map
	And I select "CorpWeb" and rename it with "CorpWeb001"
	Then the map should get renamed to name "CorpWeb001" on the map
	And I select "CorpWeb001" and rename it with "CorpWeb"
	And I delete "CorpWeb" icon on map
	
Scenario: Verification of cross-links
 	Given I am on the Views page
	When I select host "itmon-win" on "Views" page
 	Then selected host "itmon-win" should be redirected to the Status Viewer page
 	And I remove host "itmon-win" from "Views" page
	
###################  ADD ICON & LINE #######################
 
Scenario: Create map
	Given I am on the Views page
	And I save a map with "testgw"

Scenario Outline: Add an icon
	Given I am on the Views page
	And I select icon "<option>" and create "<object>"
	And I verify "<option>" and "<object>"
	And I delete "<object>" and verify "<option>"
	Scenarios:
	|option		 |	object		|
	|host  		 |	itmon-win	|
	|service	 |	itmon-win	|
	|map		 |	GeoOffice 	|
	|hostgroup	 |	HG2		|
	|servicegroup	 |	SG1		|

Scenario Outline: Add a Line
	Given I am on the Views page
	And I select line "<option>" and create "<object>"
	And I verify the line "<option>" and "<object>"
	And I delete and verify the line
	Scenarios:
	|option		 |	object		|
	|host  		 |	itmon-win	|
	|service	 |	itmon-win	|
	|hostgroup	 |	HG2		|
	|servicegroup	 |	SG1		|
	|map		 |	GeoOffice 	|

Scenario Outline: Modify map Options
	Given I am on the Views page
	And I modify map with backgrnd "<backgrnd>" aliasname "<aliasname>" color "<color>" mapiconset "<mapiconset>"
	And I verify modified map options "<aliasname>"
	Scenarios:
	|backgrnd     |aliasname  |color  |mapiconset|
	|OfficeLan.png |changedmap|#FF216B|earth|

########################################################
Scenario: Delete map
	Given I am on the Views page
	Then I delete the map with "testgw"
	And I verify that the map with "testgw" has been deleted

Scenario: Delete Hosts group
  	Given I am on the Host Configuration page
  	And I delete "HG2" Host group

Scenario: Delete Service group
   	Given I am on the Service Configuration page
	And I delete "SG1" Service group 
	
Scenario: Remove Host and filter
	Given I remove the filter "nagvis_filter" and the host "172.28.113.162"-"itmon-win"
   
Scenario: Commit changes to Nagios
	Given I am on Control Configuration page
	When I commit new objects to Nagios
	Then the commit should be successful

Feature: Custom Groups
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

	
Scenario: Display Build and version
Given Build and version


Scenario: Create Custom group 
 Given I am on the Custom groups page
 When I create a new custom group "CG11" with type "Hostgroup" and children "HG11"
 And I save and publish
 Then I verify status "Published" for custom group "CG11" with type "Host Group"  


Scenario: Editing Custom group and removing all its children
  Given I am on the Custom groups page
  When I select the existing custom group created and remove all its children    
  And I save and publish the custom group 
  Then an error message for selecting children should appear
  

Scenario: Edit Custom group
  Given I am on the Custom groups page
  And I have a Custom group to "edit"
  When I edit custom group with name "CG11" and add "Linux Servers" as a child
  And I save and publish
  Then I verify that changes were done for custom group "CG11" with type "Host Group"-"HG11" and status "Published"   


Scenario: Delete Custom Groups
  Given I am on the Custom groups page
  And I have a Custom group to "delete"
  When I delete the custom group "CG11"
  Then I verify that custom group "CG11" with type "Host Group" was deleted


Scenario: Edit more than one custom group
  Given I am on the Custom groups page
  And I create two Custom groups "CG11" of type "HostGroup" with child "HG11" and "CG22" of type "ServiceGroup" with child "SG11"
  When I try to edit two Custom groups at the same time
  Then an error "Cannot edit multiple custom groups" should appear


Scenario: Delete more than one custom group
  Given I am on the Custom groups page
  When I delete two Custom groups "CG11" and "CG22" at the same time
  Then a warning "Please confirm your delete action" should appear


Scenario: Create duplicate Custom group
  Given I am on the Custom groups page
  And I create a custom group "CG11" with type "Hostgroup" and children "HG11"
  And I save and publish
  When I try to create an identical custom group with name "CG11" type "Hostgroup" and child "HG11"
  Then an error message should appear
 

Scenario: Custom group with mixing children
  Given I am on the Custom groups page
  And I create a service custom group "CG22" of type "ServiceGroup" and child "SG11"
  And I save and publish
  When I create a custom group "Master" of type "CustomGroup" with the ones created before "CG11" and "CG22"
  Then I should see the mixing children error


Scenario: Custom group save but not published
  Given I am on the Custom groups page
  When I delete the custom group "CG11"
  When I delete the custom group "CG22"
  And I create a custom group "CG11" with type "Hostgroup" and children "HG11"
  When I save
  Then it should not appear on Status viewer
  

Scenario: Custom group order on Event Console
  Given I am on the Event Console page
  When I apply the filter Host Group 
  Then the groups should be in order
  
 
#OptimusComment:Moved bug folder 
Scenario: Custom group view
  Given I am on the Custom groups page
  And I delete custom groups created
  And I create a custom group "CG11" with type "Hostgroup" and children "HG11"
  And I save and publish
  When I am on the Event Console page
  And I select the custom group on Event Console of type "Host Group"
  Then the custom group should not be highlighted
  
  
#OptimusComment:Moved bug folder
Scenario: Custom group view 
  Given I am on the Status Viewer page
  And I select the custom group created
  Then I should not open a hostgroup view and delete custom group created "CG11"


Scenario: Delete Hosts group
  Given I am on the Host Configuration page
  And I delete "HG11" Host group
 
 
Scenario: Delete Service group
   Given I am on the Service Configuration page
   And I delete "SG11" Service group 
 

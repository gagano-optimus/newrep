Feature: Dashboard Test
    In order to know that the build is working
    As a tester
    I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version

Scenario Outline: Verify module inaccessiblity for different users
	Given I am on the User Management page
	And I navigate to membership management
	And I "deny" portal user "<user>" to access modules "<module1>" and "<module2>"
	And I logout and login with "<user>"
	Then accessing "<module1>" and "<module2>" should display access error
	And I logout and login with "admin"
	
Scenarios:
	|user    |module1	|module2	|
	|admin   |Monarch	|Cacti		|
	|root	 |Cacti		|BIRT-Reports	|
	|operator|Nagvis	|BIRT-Reports	|
	|user	 |Nagvis	|Nagvis		|



Scenario Outline: Verify module accessiblity for different users
	Given I am on the User Management page
	And I navigate to membership management
	And I "grant" portal user "<user>" to access modules "<module1>" and "<module2>"
	And I logout and login with "<user>"
	Then "<module1>" and "<module2>" should be accessible and should not display any errors
	And I logout and login with "admin"

Scenarios:
	|user    |module1	|module2	|
	|admin   |Monarch	|Cacti		|
	|root	 |Cacti		|BIRT-Reports	|
	|operator|Nagvis	|BIRT-Reports	|

Scenario Outline: Verify adding users into different groups
	Given I am on the User Management page
	And I navigate to group management
	And I "add" user - "<user>" in group - "GroundWork Administrators"
	And I navigate to membership management
	And I "grant" portal user "<user>" to access modules "<module1>" and "<module2>"
	And I "deny" portal user "<user>" to access modules "<module3>" and "<module4>"
	And I logout and login with "<user>"
	And "<module1>" and "<module2>" should be accessible and should not display any errors
	Then accessing "<module3>" and "<module4>" should display access error
	When I logout and login with "admin"	
 	And I am on the User Management page
	And I navigate to group management	
	Then I "remove" user - "<user>" in group - "GroundWork Administrators"

Scenarios:
	|user    |module1	|module2	|module3	|module4	|
	|user	 |Monarch	|BIRT-Reports	|Nagvis		|Cacti		|
	|operator|CloudHub	|Cacti		|Nagvis		|BIRT-Reports	|

Scenario: Dashboard tab exists for new user
 Given I am on the New Staff page under Group
 And I create a new user account with username "optimus" and password "optimus123" and firstname "optimus" and lastname "information" and email "optimus@info.com"
 And I login with "optimus" and "optimus123"
 Then I should see the dashboard page

Scenario: Default dashboard can be edited by root user
  Given I login with "root" and "root"
  And I navigate to Site Editor to edit the current dashboard page
  When I add a portlet
  And I edit the portlet configuration
  And I add another portlet and edit its configuration
  Then I should see the added portlets

Scenario: Deleting a portlet by root user
  Given I login with "root" and "root"
  And I navigate to Site Editor to edit the current dashboard page
  When I delete the added portlets
  Then I should not see the portlets

Scenario: Remove user created
  Given I go to User Management under Groups
  And I select Search users
  When I delete the user with name "optimus"
  Then the user should be deleted

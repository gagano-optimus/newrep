Feature: Contacts Test
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

Scenario: Display Build and version
  Given Build and version

Scenario: Adding host 'qa-ubuntu-12-4-64' by auto discovery
  Given I am on the Auto Discovery page
  And I use the default discovery definition
  And I change the mode to auto commit
  And I add an address filter "hosts-contacts" of type "include" with range "172.28.113.207"
  Then I start the discovery

  
Scenario: Create a new contact
  Given I am on the Contacts page
  And I create a new contact "contact1"
  Then the contact "contact1" should be created


Scenario: Modifying, copying and renaming a new contact
 Given I am on the Contacts page
 And I "modify" the contact "contact1"
 Then the contact "contact1" should be "modified" successfully
 And I "copy" the contact "contact1"
 Then the contact "contact1" should be "copied" successfully
 And I "rename" the contact "cpy-contact1"
 Then the contact "cpy-contact1" should be "renamed" successfully
 
  
Scenario: Create a new contact group
  Given I am on the Contacts page
  And I create a new contact group "contactgroup1"
  Then the contact group "contactgroup1" should be created
  
  
Scenario: Copying a contact group
	Given I am on the Contacts page
	And I "copy" a contact group with name "contactgroup1"
	Then a new copy contact group with name "cpy-contactgroup1" should be created
	
	
Scenario: Renaming a contact group
	Given I am on the Contacts page
	And I "rename" a contact group with name "cpy-contactgroup1"
	Then the renamed contact group with name "cpy-contactgroup1-renamed" should exist	
	
	
Scenario: Modifying a contact group
	Given I am on the Contacts page
	And I "modify" a contact group with name "cpy-contactgroup1-renamed"
	Then the modifications to contact group "cpy-contactgroup1-renamed" should exist	
	

Scenario: Create a new contact template
  Given I am on the Contacts page
  And I create a new contact template "contact_temp1"
  Then the template "contact_temp1" should be created
  
  
Scenario: Modifying, copying, renaming and deleting a new contact template
 Given I am on the Contacts page
 And I "modify" the contact template "contact_temp1"
 Then the contact template "contact_temp1" should be "modified" successfully
 And I "copy" the contact template "contact_temp1"
 Then the contact template "cpy-contact_temp1" should be "copied" successfully
 And I "rename" the contact template "cpy-contact_temp1"
 Then the contact template "cpy-contact_temp1" should be "renamed" successfully
 And I "delete" the contact template "cpy-contact_temp1-renamed"
 Then the contact template "cpy-contact_temp1-renamed" should be "deleted" successfully
 
 
Scenario: Verify a contact template cannot be deleted which is used in a contact
 Given I am on the Contacts page
 And I assign the contact template "contact_temp1" to contact "contact1"
 Then I am on the Contacts page
 And I delete the contact template "contact_temp1"
 Then there should be a validation message due to existing dependency


Scenario: Create a new hostgroup including a contact group
  Given I am on the Hosts page
  And I create a new Host group "HG22"
  And I add the hosts except localhost to the new host group
  And I add contact group to the hostgroup
  When I "add" the changes
  Then "HG22" changes were "saved" correctly

Scenario: Commit changes to Nagios
  Given I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful


Scenario: Verify Cloning a host preserves contact group assignments 
	Given I am on the Host Configuration page
	And I select the host "qa-ubuntu-12-4-64" of hostgroup "Linux Servers"
	And I change its contact group from "nagiosadmin" to "contactgroup1"
	And I save the host editing
	Then I select the "Clone host" option
	And I clone the host "qa-ubuntu-12-4-64"
	Then the cloned "host" "clone-qa-ubuntu-12-4-64" should preserve the contact group assignment "contactgroup1" 


Scenario: Verify Cloning a service preserves contact group assignments 
	Given I am on the Service Configuration page
	And I select the service "tcp_ssh"
	And I change its contact group from "nagiosadmin" to "contactgroup1"
	And I save the service editing
	And I clone the service "tcp_ssh"
	Then a copy of the service "tcp_ssh" should be created
	Then the cloned "service" "tcp_ssh-copy" should preserve the contact group assignment "contactgroup1" 


################ Deleting Contacts/Contact Groups  ################# 
  
Scenario: Deleting host 'qa-ubuntu-12-4-64'
 Given I am on the Host Configuration page
 Then I select the host "qa-ubuntu-12-4-64" of hostgroup "Linux Servers"
 And I delete the host
  
  
Scenario: Deleting host 'clone-qa-ubuntu-12-4-64'
 Given I am on the Host Configuration page
 Then I select the host "clone-qa-ubuntu-12-4-64" of hostgroup "Linux Servers"
 And I delete the host

  
Scenario: Delete Contact
  Given I am on the Contacts page
  And I delete Contact "contact1"
  Then the contact "contact1" should be deleted

 
Scenario: Delete Contact "cpy-contact1-renamed"
  Given I am on the Contacts page
  And I delete Contact "cpy-contact1-renamed"
  
 
Scenario: Delete Contact group
  Given I am on the Contacts page
  And I delete Contact group "contactgroup1"
  Then the contact group "contactgroup1" should be deleted
  
 
Scenario: Delete Contact group
  Given I am on the Contacts page
  And I delete Contact group "cpy-contactgroup1-renamed"
   

Scenario: Delete Contact template "contact_temp1"	
  Given I am on the Contacts page
  And I delete Contact "contact_temp1"
  
  
Scenario: Commit changes to Nagios  
  Given I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful

    
#####################   HOST ESCALATIONS    ##########################
######################################################################


Scenario: Create a host escalation tree
 Given I am on the Escalation page
 And I create a new host escalation "HE"
 Then the host escalation "HE" should be created successfully
 And I create a host escalation tree "HET" using "HE"
 Then the host escalation tree "HET" should be created successfully


Scenario: Assign a host escalation tree to a host
 Given I am on the Host Configuration page
 And I assign the host escalation tree "HET" to host "localhost"
 Then the host escalation tree "HET" should be applied successfully for "localhost"


Scenario: Assign a host escalation tree to a host group
 Given I am on the Host Configuration page
 And I assign the host escalation tree "HET" to host group "Linux Servers"
 Then the host escalation tree "HET" should be applied successfully for host group "Linux Servers"


Scenario: Modifying and renaming a host escalation 
 Given I am on the Escalation page
 And I "modify" the host escalation "HE"
 Then the host escalation "HE" should be "modified" successfully
 And I "rename" the host escalation "HE"
 Then the host escalation "HE" should be "renamed" successfully
 
 
Scenario: Renaming a host escalation tree
 Given I am on the Escalation page
 And I rename the host escalation tree "HET"
 Then the host escalation tree "HET" should be renamed successfully 

 
Scenario: Deleting a host escalation
 Given I am on the Escalation page
 And I "delete" the host escalation "HE-renamed"
 Then the host escalation "HE-renamed" should be "deleted" successfully  

 
Scenario: Deleting a host escalation tree
 Given I am on the Escalation page
 And I delete the host escalation tree "HET-renamed"
 Then the host escalation tree "HET-renamed" should be deleted successfully  
 
 
 
 
 
 
 
 
 

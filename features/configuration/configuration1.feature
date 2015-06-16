Feature: Configuration Test
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version

###############################  Service / Service Group  #########################################

Scenario: Verify creating a new service and applying it to a host
 Given I am on the Service Configuration page
 And I create a new service "test_service"
 And I apply "test_service" to a host
 And I am on Control Configuration page
 When I commit new objects to Nagios
 Then the commit should be successful
 Then the changes made for "test_service" should reflect in Status Viewer
 And I delete the service "test_service"
 
Scenario: Verify searching for services
  Given I am on the Service Configuration page
  And I search for a service with keyword "tcp"
  Then all the services having the "tcp" in their name should be displayed in search results
 
Scenario: Cloning an existing service and applying it to a host
 Given I am on the Service Configuration page
 And I clone the service "tcp_ssh"
 Then a copy of the service "tcp_ssh" should be created
 And I apply the copy of "tcp_ssh" to a host
 And I am on Control Configuration page
 When I commit new objects to Nagios
 Then the commit should be successful
 Then the changes made for copy of "tcp_ssh" should reflect in Status Viewer
 And I delete the "copied" service "tcp_ssh"

Scenario: Creating a service template
 Given I am on the Service Configuration page
 And I create a service template "ST2"
 And I clone the service "tcp_ssh"
 And I apply the template "ST2" to the copy of "tcp_ssh"
 Then the template "ST2" should be applied successfully for renamed copy of "tcp_ssh"
 And I delete the "renamed" service "tcp_ssh"

Scenario: Modifying, renaming and deleting a service template
 Given I am on the Service Configuration page
 And I "modify" the service template "ST2"
 Then template "ST2" should be "modified" successfully
 And I "rename" the service template "ST2"
 Then template "ST2" should be "renamed" successfully
 And I "delete" the service template "ST2"
 Then template "ST2" should be "deleted" successfully
 
Scenario: Creating a service dependency and apply it to a service
 Given I am on the Service Configuration page
 And I create a service dependency "SD1"
 Then the dependency "SD1" should be "created" successfully
 And I apply the dependency "SD1" to service "tcp_ssh"
 Then the dependency "SD1" should be "applied" successfully 

Scenario: Applying a service dependency to a host-service
 Given I am on the Host Configuration page
 And I apply dependency "SD1" to host localhost for service "local_cpu_httpd"
 Then the dependency "SD1" should be "applied" successfully
 And delete the assigned service dependency "SD1"
 Then there should be a validation message due to existing dependency

Scenario: Removing service dependency assignment from a host-service
 Given I am on the Host Configuration page
 And remove dependency from localhost for service "local_cpu_httpd"
 Then "SD1" should be removed successfully
  
Scenario: Modifying, renaming, copying and and deleting a service dependency
 Given I am on the Service Configuration page
 And I "modify" the service dependency "SD1"
 Then the dependency "SD1" should be "modified" successfully
 And I "rename" the service dependency "SD1"
 Then the dependency "SD1" should be "renamed" successfully
 And I "copy" the service dependency "SD1"
 Then the dependency "SD1" should be "copied" successfully
 And I "delete" the service dependency "SD1"
 Then the dependency "SD1" should be "deleted" successfully

Scenario: Verify creating a service extended info template and applying it to a service
 Given I am on the Service Configuration page
 And I create a service extended info template "SEI1"
 Then the extended info template "SEI1" should be "created" successfully
 And I apply the extended info template "SEI1" to service "local_cpu_java"
 Then the extended info template "SEI1" should be "applied" successfully

Scenario: Removing service extended info template assignment from a service
 Given I am on the Service Configuration page
 And I remove the service extended info template from service "local_cpu_java"
 Then the info template "SEI1" should be removed successfully

Scenario: Modifying, renaming, copying and deleting a service extended info template
 Given I am on the Service Configuration page
 And I "modify" the service extended info template "SEI1"
 Then the extended info template "SEI1" should be "modified" successfully
 And I "rename" the service extended info template "SEI1"
 Then the extended info template "SEI1" should be "renamed" successfully
 And I "copy" the service extended info template "SEI1"
 Then the extended info template "SEI1" should be "copied" successfully
 And I "delete" the service extended info template "SEI1"
 Then the extended info template "SEI1-renamed" should be "deleted" successfully

Scenario: Modifying, renaming and deleting a service group
 Given I am on the Service Configuration page
 And I create a new Service Group "SG5"
 And I add the services to the new Service Group
 Then service group should be created sucessfully
 And I "modify" the service group "SG5"
 Then "SG5" should be "modified" successfully
 And I "rename" the service group "SG5"
 Then "SG5" should be "renamed" successfully
 And I "delete" the service group "SG5"
 Then "SG5" should be "deleted" successfully


Scenario: Create a service escalation tree
 Given I am on the Escalation page
 And I create a new service escalation "E1"
 Then the escalation "E1" should be created successfully
 And I create a service escalation tree "ET1" using "E1"
 Then the escalation tree "ET1" should be created successfully
 
Scenario: Assign an escalation tree to a service
 Given I am on the Service Configuration page
 And I assign the service escalation tree "ET1" to service "tcp_gw_listener"
 Then the escalation tree "ET1" should be applied successfully for "tcp_gw_listener"
 
Scenario: Assign an escalation tree to a service group
 Given I am on the Service Configuration page
 And I create a new Service Group "test_group"
 And I add the services to the new Service Group
 And I assign the escalation tree "ET1"
 Then service group should be created sucessfully
 And tree "ET1" should be assigned to service group "test_group"

Scenario: Assign a service group to an escalation tree directly
 Given I am on the Service Configuration page
 And I create a new Service Group "serv_group2"
 And I add the services to the new Service Group
 And I am on the Escalation page
 And I create a service escalation tree "ET6" using "E1"
 And I assign service group "serv_group2"
 Then tree "ET6" should be assigned to service group "serv_group2"
 

Scenario: Renaming and modifying a service escalation 
 Given I am on the Escalation page
 And I "rename" the service escalation "E1"
 Then the service escalation "E1" should be "renamed" successfully
 And I "modify" the service escalation "E1-renamed"
 Then the service escalation "E1-renamed" should be "modified" successfully


Scenario: Renaming a service escalation tree
 Given I am on the Escalation page
 And I "rename" the service escalation tree "ET1"
 Then the service escalation tree "ET1-renamed" should be "renamed" successfully
 

Scenario: Deleting a service escalation 
 Given I am on the Escalation page
 And I "delete" the service escalation "E1-renamed"
 Then the service escalation "E1-renamed" should be "deleted" successfully
 

Scenario: Deleting a service escalation tree
 Given I am on the Escalation page
 And I "delete" the service escalation tree "ET1-renamed"
 Then the service escalation tree "ET1-renamed" should be "deleted" successfully

 
Scenario: Verify validation message on creating a duplicate service group
 Given I am on the Service Configuration page
 And I create a new Service Group "service_group"
 And I add the services to the new Service Group
 Then service group should be created sucessfully
 Given I am on the Service Configuration page
 And I create a new Service Group "service_group"
 Then there should be an error message for duplicate service group "serv_group"
 
Scenario: Verify validation message on creating a service group with illegal characters
 Given I am on the Service Configuration page
 And I create a new Service Group "!@#$%"
 Then there should be a validation message for illegal characters
 
 Scenario: Verify importing host profiles
Given I am on profile page
When I select a profile to import
And select host files to import
Then it should be added to Host Profiles

Scenario: Verify importing service profiles
Given I am on profile page
When I select a profile to import
And select service files to import
Then it should be added to Service Profiles

Scenario: Assign host profile to host
Given I am on profile page
When I create a new host profile "test_hp" with description "test_desc"
And select a host and save
Then host profile "test_hp" should be added to that host on configuration page


Scenario: Assign service profile to host
Given I am on profile page
When I create a new service profile "test_sp" with description "test_desc"
And select a service and save
Then service profile "test_sp" should be added to that service on configuration page

Scenario: Delete host profile
Given I am on profile page
When I navigate to new host profile created
And select host profile
And I delete it
Then host profile "test_hp" should be deleted

Scenario: Delete service profile
Given I am on profile page
When I navigate to new service profile created
And select service profile
And I delete it
Then service profile "test_sp" should be deleted

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
  And I "delete" the contact template "contact_temp1"
  Then the contact template "contact_temp1" should be "deleted" successfully
  
  
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
 
 

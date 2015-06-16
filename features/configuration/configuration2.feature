Feature: Configuration Test
	In order to know that the build is working
	As a tester
	I want to see certain basic functionality working

Scenario: Display Build and version
Given Build and version


#################################    HOSTS      #########################################


Scenario: Verify creating a host using Host Wizard 
 Given I am on the Host Configuration page
 And I select the "Host wizard" option
 And I add a new host "qa-ubuntu-12-4-64" with IP address "172.28.113.207" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 Then I verify that the host "qa-ubuntu-12-4-64" has been added to the GW portal
 

Scenario: Verify checking hostname duplicacy and deleting host
 Given I am on the Host Configuration page
 And I select the "Host wizard" option
 And I add a new host "qa-rhel-6-64" with IP address "172.28.113.209" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 Then I am on the Host Configuration page
 And I select the "Host wizard" option
 And I attempt to add a new host with name "qa-rhel-6-64" with IP address "172.28.113.209" and services "local_cpu_httpd" and "icmp_ping_alive"
 Then a host wizard error message for host "qa-rhel-6-64" should be generated
 Then I select the host "qa-rhel-6-64" of hostgroup "Linux Servers"
 And I delete the host
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 And I verify that the host "qa-rhel-6-64" has been deleted
 

Scenario: Verify cloning a host
 Given I am on the Host Configuration page
 And I select the "Clone host" option
 And I clone the host "qa-ubuntu-12-4-64"
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 Then I verify that the clone of host "qa-ubuntu-12-4-64" with services "local_cpu_httpd" and "icmp_ping_alive" has been added to the GW portal
 Then I select the clone of host "qa-ubuntu-12-4-64" of hostgroup "Linux Servers"
 And I delete the host
 

Scenario: Verify creating a host using Host Wizard and saving it as a profile
 Given I am on the Host Configuration page
 And I select the "Host wizard" option
 And I add a new host "qa-rhel-6-64" with IP address "172.28.113.209" and services "local_cpu_httpd" and "icmp_ping_alive" as a "profile"
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 Then I am on the Profiles Configuration page
 And I verify host "qa-rhel-6-64" exists as a "host" profile
 And I verify host "qa-rhel-6-64" exists as a "service" profile
 Then I am on the Host Configuration page	
 Then I select the host "qa-rhel-6-64" of hostgroup "Linux Servers"
 And I delete the host


Scenario Outline: Verify searching a host using hostname and host IP
 Given I am on the Host Configuration page
 And I select the "Search hosts" option
 And I search a host by "<option>"
 Then the search output should be "<output>"
Scenarios:
    | option         | output            |
    | 172.28.113.207 | qa-ubuntu-12-4-64 |
    | ubuntu         | qa-ubuntu-12-4-64 |
	| !@#$%^         | Nothing found     |
	| 255.255.255.255| Nothing found     |


Scenario: Verify renaming host name and host alias
 Given I am on the Host Configuration page
 And I select the "Host wizard" option
 And I add a new host "qa-rhel-6-64" with IP address "172.28.113.209" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
 Then I am on the Host Configuration page
 Then I select the host "qa-rhel-6-64" of hostgroup "Linux Servers"
 Then I rename the host "qa-rhel-6-64"
 And I edit host alias
 And I edit host IP address as "255.255.255.255"
 And I save the host editing
 Then I am on the Host Configuration page
 And I select the host "qa-rhel-6-64" of hostgroup "Linux Servers"
 Then I verify that changes to host "renamed-qa-rhel-6-64" have been saved with address as "255.255.255.255" and template as "gdma-windows-host"
 Then I am on the Host Configuration page	
 Then I select the host "renamed-qa-rhel-6-64" of hostgroup "Linux Servers"
 And I delete the host
	

Scenario: Verify changing host template of a host
 Given I am on the Host Configuration page
 And I select the "Host wizard" option
 And I add a new host "qa-rhel-6-64" with IP address "172.28.113.209" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
 Then I am on the Host Configuration page
 Then I select the host "qa-rhel-6-64" of hostgroup "Linux Servers"
 And I change host template as "gdma-windows-host"
 And I save the host editing
 Then I am on the Host Configuration page
 And I select the host "qa-rhel-6-64" of hostgroup "Linux Servers"
 Then I verify that changes to host "qa-rhel-6-64" have been saved with address as "172.28.113.209" and template as "gdma-windows-host"
	

Scenario: Verify deleting a service using 'Delete host services' option
 Given I am on the Host Configuration page
 And I select the "Delete host services" option
 And I select and delete the service "local_cpu_httpd" of host "qa-rhel-6-64" to be deleted
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 And I verify that the service "local_cpu_httpd" of host "qa-rhel-6-64" has been deleted
 
	
Scenario: Verify deleting a host using 'Delete hosts' option
 Given I am on the Host Configuration page
 And I select the "Delete hosts" option
 And I select host "qa-rhel-6-64" to be deleted
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 And I verify that the host "qa-rhel-6-64" has been deleted
	

	
################    HOST GROUP     ##############################################	
	

Scenario: Verify changing contactgroup associated with a hostgroup
  Given I am on the Contacts page
  And I create a new contact "contact4"
  Then the contact "contact4" should be created
  When I am on the Contacts page
  And I create a new contact group "contactgroup4"
  Then the contact group "contactgroup4" should be created
  When I am on the Contacts page
  And I create a new contact group "contactgroup5"
  Then the contact group "contactgroup5" should be created
  When I am on the Hosts page
  And I create a new Host group "HG4"
  And I add the hosts except the host localhost to the new host group
  And I add contact group to the hostgroup
  When I "add" the changes
  Then "HG4" changes were "saved" correctly	
  Then I am on the Host Configuration page
  Then I select the hostgroup "HG4"
  And I change the contact group from "contactgroup4" to "contactgroup5"
  Then I am on the Host Configuration page
  When I select the hostgroup "HG4"
  Then I verify that the Contact Group is "contactgroup5"
  Then I am on the Host Configuration page
  And I delete "HG4" Host group
	

Scenario: Verify copying a hostgroup
  Given I am on the Hosts page
  And I create a new Host group "HG4"
  And I add the hosts except the host localhost to the new host group
  And I add contact group to the hostgroup
  When I "add" the changes
  Then "HG4" changes were "saved" correctly	
  Then I copy the host group with name copy-"HG4"
  Then I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful	
  Then I verify the copy of hostgroup "HG4" has been added to the GW portal
  Then I am on the Host Configuration page
  And I delete "HG4" Host group
  And I delete "copy-HG4" Host group
  
  
Scenario: Verify renaming a hostgroup
  Given I am on the Hosts page
  And I create a new Host group "HG4"
  And I add the hosts except the host localhost to the new host group
  And I add contact group to the hostgroup
  When I "add" the changes
  Then "HG4" changes were "saved" correctly	  
  Then I am on the Host Configuration page
  Then I select the hostgroup "HG4"
  And I rename the hostgroup to renamed-"HG4"
  Then I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful
  Then I verify that hostgroup has been renamed to renamed-"HG4"
  Then I am on the Host Configuration page
  And I delete "renamed-HG4" Host group
  
 
Scenario: Verify adding and deleting a parent child pair
  Given I am on the Hosts page
  When I select the "Parent child" option
  Then I create a new Parent Child pair with "localhost" as parent and "qa-ubuntu-12-4-64" as child
  Then I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful
  Then I verify that pair exists with "localhost" as parent and "qa-ubuntu-12-4-64" as child
  Then I am on the Host Configuration page
  When I select the "Parent child" option
  And I select the "localhost" "qa-ubuntu-12-4-64" parent child pair
  Then I delete the "localhost" "qa-ubuntu-12-4-64" parent child pair
  And I verify that "localhost" "qa-ubuntu-12-4-64" parent child pair has been deleted
  
Scenario: Verify creating a host template
  Given I am on the Hosts page
  Then I select the "Host templates" option
  Then I create a new host template with name "template_host"
  Then I verify that a new host template with name "template_host" has been "created"
  
  
Scenario: Verify copying and deleting a host template
  Given I am on the Hosts page
  Then I copy the host template with name "template_host"
  Then I verify that a new host template with name "copy-template_host" has been "created" 
  Then I delete the host template "copy-template_host"
  Then I verify that a new host template with name "copy-template_host" has been "deleted"
  

Scenario: Verify a host template which is applied to a host cannot be deleted
  Given I am on the Host Configuration page
  And I select the host "qa-ubuntu-12-4-64" of hostgroup "Linux Servers"
  And I change host template as "template_host"
  And I save the host editing
  When I attempt to delete the host template "template_host"
  Then an error message with respect to host "qa-ubuntu-12-4-64" is displayed
  Then I am on the Host Configuration page
  And I select the host "qa-ubuntu-12-4-64" of hostgroup "Linux Servers"
  And I change host template as "generic-host"
  And I save the host editing
  
  
Scenario: Verify renaming and modifying a host template
  Given I am on the Hosts page
  Then I select the "Host templates" option
  When I select the host template "template_host" for modifying
  Then I rename the host template to renamed-"template_host"
  Then I select the "Host templates" option
  When I select the host template "renamed-template_host" for modifying
  Then I change Max check attempts = "6" and Check Interval = "5" of the host template
  Then I save the modifications
  Then I am on the Hosts page
  Then I select the "Host templates" option
  And I select the host template "renamed-template_host" for modifying
  Then I verify host template modifications have been made
  
  
Scenario: Verify creating a host extended info template and applying it to a host
  Given I am on the Hosts page
  Then I select the "Host extended info" option
  Then I create a new host extended info template with name "extended_info_host"
  Then I verify that a new host extended info template with name "extended_info_host" has been "created"  
  Then I am on the Host Configuration page
  And I select the host "localhost" of hostgroup "Linux Servers"
  And I "save" its host extended info template as "extended_info_host"
  Then I am on the Host Configuration page
  Then I select the host "localhost" of hostgroup "Linux Servers"
  And I "verify" its host extended info template as "extended_info_host"
  
 
Scenario: Verify copying a host extended info template and deleting it
  Given I am on the Hosts page
  Then I select the "Host extended info" option  
  And I copy the host extended info template with name copy-"extended_info_host"
  Then I verify that a new host extended info template with name "extended_info_host" has been "created"
  When I am on the Hosts page
  Then I select the "Host extended info" option  
  And I delete the host extended info template with name "copy-extended_info_host"
  Then I verify that a new host extended info template with name "copy-extended_info_host" has been "deleted"
  
  
Scenario: Verify changing host associated with a hostgroup
  Given I am on the Hosts page
  And I create a new Host group "HG3"
  And I add the hosts except the host localhost to the new host group
  When I "add" the changes
  Then "HG3" changes were "saved" correctly	
  Then I am on the Host Configuration page
  Then I select the hostgroup "HG3"
  And I remove member host "qa-ubuntu-12-4-64" and add "localhost"
  Then I am on Control Configuration page
  When I commit new objects to Nagios
  Then the commit should be successful
  Then I am on the Host Configuration page
  When I select the hostgroup "HG3"
  Then I verify that host "localhost" is a member of hostgroup "HG3" on "Host Configuration page"
  Then I am on the Status Viewer page
  Then I verify that host "localhost" is a member of hostgroup "HG3" on "Status Viewer"
  
  
Scenario: Verify changing ip address for a host if 2 hosts have same ip address
 Given I am on the Host Configuration page
 And I select the "Host wizard" option
 And I add a new host "address-ubuntu12-4" with IP address "172.28.113.207" and services "local_cpu_httpd" and "icmp_ping_alive" as a "host"
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 When I am on the Host Configuration page
 Then I select the host "address-ubuntu12-4" of hostgroup "Linux Servers"
 And I edit host IP address as "172.28.112.155"
 And I save the host editing
 Then I am on Control Configuration page
 And I commit new objects to Nagios
 And the commit should be successful
 Then I verify ip address of host "address-ubuntu12-4" has been updated to "172.28.112.155"
  
 

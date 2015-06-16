Feature: License Page
	 In order to know that the build is working
	 As a tester
	 I want to see certain basic functionality working


Scenario Outline: Verify updating an account with valid password
 Given I am on License Page
 When I enter a password "groundwork123" for "<account_name>"
 And I click on "<account_update>" button to "update"
 Then "confirmation" message should be displayed for "<account_name>"
 And last updated timestamp should be "updated" after "<account_update>"
 And a new token should be generated for "<account_name>"


 Scenarios:

  |	account_name			|	account_update		|
  |	Master Account Info		|	Update Master Password	|
  |	Webervices API Account Info	|	Update API Account	|	
  |	Remote API Account Info		|	Update Remote Account	|	

#JIRA for webservices spelling



Scenario Outline: Verify updating an account with invalid password
 Given I am on License Page
 When I enter a password "12345" for "<account_name>"
 And I click on "<account_update>" button to "update"
 Then "error" message should be displayed for "<account_name>"
 And last updated timestamp should be "unchanged" after "<account_update>"


 Scenarios:

  |	account_name			|	account_update		|
  |	Master Account Info		|	Update Master Password	|
  |	Proxy Account Info		|	Update Proxy Account	|



Scenario Outline: Verify updating an account with blank password
 Given I am on License Page
 When I enter a password "as_blank" for "<account_name>"
 And I click on "<account_update>" button to "update"
 Then "warning" message should be displayed for "<account_name>"


 Scenarios:

  |	account_name			|	account_update		|
  |	Master Account Info		|	Update Master Password	|
  |	Webervices API Account Info	|	Update API Account	|
  |	Proxy Account Info		|	Update Proxy Account	|



Scenario Outline: Verify "Test" functionality of an account if password is not updated
 Given I am on License Page
 When I enter a password "groundwork" for "<account_name>"
 And I click on "<account_test>" button to "test"
 Then "error" message should be displayed for "<account_name>"
 

 Scenarios:
  |	account_name			|	account_test	|
  |	Webervices API Account Info	|  	apitest		|
  |	Proxy Account Info		| 	proxytest	|



Scenario Outline: Verify "Test" functionality of an account for updated password
 Given I am on License Page
 When I click on "<account_test>" button to "test"
 Then "test" message should be displayed for "<account_name>"


 Scenarios:
  |	account_name			|	account_test	|
  |	Webervices API Account Info	|  	apitest		|
  |	Proxy Account Info		| 	proxytest	|

  

Scenario Outline: Verify random updating of password between two accounts
 Given I am on License Page
 When I enter a password "groundwork" for "<first_account_name>"
 And I click on "<account_update>" button to "update"
 Then "confirmation" message should be displayed for "<second_account_name>"
 And last updated timestamp should be "updated" after "<account_update>"
 And a new token should be generated for "<second_account_name>"


 Scenarios:
  | first_account_name		 |	second_account_name		|	account_update		   |
  | Master Account Info		 |	Webervices API Account Info	|	Update API Account	   |
  | Master Account Info     	 | 	Proxy Account Info 		|    	Update Proxy Account   	   |
  | Webervices API Account Info  |   	Master Account Info 	        |    	Update Master Password 	   |
  | Webervices API Account Info  |   	Proxy Account Info   	        |    	Update Proxy Account   	   |
  | Proxy Account Info           | 	Webervices API Account Info 	|    	Update API Account     	   | 
  | Proxy Account Info           |   	Master Account Info 	        |   	Update Master Password 	   |
  


Scenario: Verify password generation through Encryption tool
 Given I am on License Page
 When I enter "groundwork" as password under the Encryption Tool
 And I click on "Generate" button to "generate"
 Then a new encrypted password should be generated


Scenario: Verify functionality of 'Test All' Button 
 Given I am on License Page
 When I click on "Test All" button to "test all passwords"
 Then "test" message should be displayed for "API and Proxy accounts"

 

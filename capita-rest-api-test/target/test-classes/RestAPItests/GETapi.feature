Feature: Test cases for GET method

Background: hide Authorization
     * def baseurl = baseurl
     * url baseurl
     * header Authorization = "hcp " + token
     #* configure report = false    
     #* configure readTimeout = 1000
		  
Scenario: Validate that document can be retrived by Document ID
		Given path path1
		When method get
		Then status 200 OK		
		Then match response contains 'Text 2'
		Then match responseHeaders["TFL-CorrespondenceID"] == ['#(CorrespondenceID)']
		Then match responseHeaders["TFL-Comment"] == [Text2.txt]
		Then match responseHeaders["TFL-Created"] != []
		Then match responseHeaders["TFL-Modified"] != []
		Then match responseHeaders["TFL-Contract"] == [AttachmentInbound]
		Then match responseHeaders["TFL-DocumentID"] == ['#(DocumentID)']
		Then match responseHeaders["TFL-Repository"] == [Business Operations]
		Then match responseHeaders["TFL-SourceSystem"] == [Amdocs]

Scenario: Validate GET Response when No file exist with given Document ID  
		Given path path1 +"12"	
		When method get
		Then status 404 Not Found
		Then match response contains 'Message: Document does not exist.'

Scenario: Validate GET Response when Document ID path is invalid  
		Given path InvalidDocumentIDPath
		* print InvalidDocumentIDPath
		When method get
		Then status 400 Bad Request 
		* print response
		
Scenario: Validate that get document by Document ID method should not work when authentication token is not passed  
		Given path path1
		And header Authorization = ' '	
		When method get
		Then status 401 Unauthorized
		Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'

Scenario: Validate that Document can be retrived by Correspondence ID
		Given path path2
		When method get
		Then status 200 OK		
		Then match response contains 'Text 2'
		Then match responseHeaders["TFL-CorrespondenceID"] == ['#(CorrespondenceID)']
		Then match responseHeaders["TFL-Comment"] == [Text2.txt]
		Then match responseHeaders["TFL-Created"] != []
		Then match responseHeaders["TFL-Modified"] != []
		Then match responseHeaders["TFL-Contract"] == [AttachmentInbound]
		Then match responseHeaders["TFL-DocumentID"] == ['#(DocumentID)']
		Then match responseHeaders["TFL-Repository"] == [Business Operations]
		Then match responseHeaders["TFL-SourceSystem"] == [Amdocs]
		Then match responseHeaders["TFL-RelatedDocumentID"] != []
		* def RelatedDocumentID = responseHeaders['TFL-RelatedDocumentID'][0]
		* print RelatedDocumentID
		* def path3 = common_path+source_system2+RelatedDocumentID
		* print path3
		
Scenario: Validate GET Response when No file exists with given correspondence Id 
		Given path path2 +"12"	
		When method get
		Then status 404 Not Found
		Then match response contains 'Message: Document does not exist.'

Scenario: Validate GET Response when correspondence Id path is invalid
		Given path InvalidCorrespondenceIDPath
		* print InvalidCorrespondenceIDPath
		When method get
		Then status 400 Bad Request 
		
Scenario: Validate GET Response when source system of correspondence Id is invalid  
		Given path InvalidService
		* print InvalidService
		When method get
		Then status 400 Bad Request
		Then match response contains 'Message: Source System Not Exist:'
		 			
Scenario: Validate that get document by Correspondence ID method should not work when authentication token is not passed  
		Given path path2
		And header Authorization = ' '	
		When method get
		Then status 401 Unauthorized
    Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'

Scenario: Validate that related Document can be get by Document ID
		Given path path4
		When method get
		Then status 200 OK		
		Then match response contains 'Text 1'
		Then match responseHeaders["TFL-CorrespondenceID"] == ['#(CorrespondenceID)']
		Then match responseHeaders["TFL-Comment"] == [Text2.txt]
		Then match responseHeaders["TFL-Created"] != []
		Then match responseHeaders["TFL-Modified"] != []
		Then match responseHeaders["TFL-Contract"] == [AttachmentInbound]
		Then match responseHeaders["TFL-DocumentID"] == ['#(DocumentID)']
		Then match responseHeaders["TFL-Repository"] == [Business Operations]
		Then match responseHeaders["TFL-SourceSystem"] == [Amdocs]		

Scenario: Validate that related Document can not be get by Document ID when document ID is not valid/exist
		Given path path4 +"12"	
		When method get
		Then status 404 Document does not exist. Document ID:
		Then match response contains 'Details: Document does not exist. Document ID:'

Scenario: Validate that related Document can not be get by Document ID when related document is not attached
		Given path RelDocIDNotExist	
		When method get
		Then status 404 File does not exist. Document path:
		Then match response contains 'Details: File does not exist. Document path:'		

Scenario: Validate that related Document can not be get by Document ID when document ID path is invalid  
		Given path InvalidRelatedDocumentIDPath
		* print InvalidRelatedDocumentIDPath
		When method get
		Then status 400 Bad Request 
						 			
Scenario: Validate that get Document by related Document ID method should not work when authentication token is not passed  
		Given path path4
		And header Authorization = ' '	
		When method get
		Then status 401 Unauthorized
		Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'

Scenario: Validate that related Document can be get by Correspondence ID
		Given path path5
		When method get
		Then status 200 OK
		Then match response contains 'Text 1'
		Then match responseHeaders["TFL-CorrespondenceID"] == ['#(CorrespondenceID)']
		Then match responseHeaders["TFL-Comment"] == [Text2.txt]
		Then match responseHeaders["TFL-Created"] != []
		Then match responseHeaders["TFL-Modified"] != []
		Then match responseHeaders["TFL-Contract"] == [AttachmentInbound]
		Then match responseHeaders["TFL-DocumentID"] == ['#(DocumentID)']
		Then match responseHeaders["TFL-Repository"] == [Business Operations]
		Then match responseHeaders["TFL-SourceSystem"] == [Amdocs]		

Scenario: Validate that related Document can not be get by Correspondence ID when Correspondence ID is not valid/exist    
		Given path path5 +"12"	
		When method get
		Then status 404 Document does not exist. Correspondence ID:
		Then match response contains 'Details: Document does not exist. Correspondence ID:'
		
Scenario: Validate that related Document can not be get by Correspondence ID when related document is not exist/attached   
		Given path RelCorIDNotExist	
		When method get
		Then status 404 File does not exist. Document path:
		Then match response contains 'Details: File does not exist. Document path:'		

Scenario: Validate that related Document can not be get by Correspondence ID when Correspondence ID path is invalid
		Given path InvalidRelatedCorrespondenceIDPath
		* print InvalidRelatedCorrespondenceIDPath
		When method get
		Then status 400 Bad Request 
		
Scenario: Validate that related Document can not be get by Correspondence ID when Source system is invalid  
		Given path InvalidRelatedService
		* print InvalidRelatedService
		When method get
		Then status 400 Invalid Document Identifier
		Then match response contains 'Details: Invalid Document Identifier: '
		 			
Scenario: Validate that get related document by Correspondence ID method should not work when authentication token is not passed  
		Given path path5
		And header Authorization = ' '	
		When method get
		Then status 401 Unauthorized
		Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'
		

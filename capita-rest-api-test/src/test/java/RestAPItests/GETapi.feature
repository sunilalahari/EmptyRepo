Feature: Test cases for GET REST APIs method

Background: hide Authorization
     * def baseurl = baseurl
     * url baseurl
     * header Authorization = "hcp " + token
     * configure report = false    
     * configure readTimeout = 5000

Scenario: Verify GET API for Get_By_Document_ID, Get_By_Correspondence_Id, Get_Related_By_Document_ID and Get_Related_By_Correspondence_ID requests
			* print 'Upload Document Inbound custom metadata and verify that the document is uploaded by using tryGetDocumentIdRequestData'
			* def baseurl1 = baseurl + "/Documents.svc"
			* url baseurl1
			* header Authorization = "hcp " + token
			* def corrid = corrid
			* configure readTimeout = 60000000
			* def corrospondenceid = read('../data/upload_DocumentInbound.xml')
			* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
			* def repository = 'Business Operations'
			* def sourcesystem = 'Amdocs'
			* def contract = 'DocumentInbound'
			* def xsi_type = '&quot;#(contract)&quot'
			* set corrospondenceid/Envelope/Body/Upload/repository = repository
			* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
			* set corrospondenceid/Envelope/Body/Upload/metadata = contract
			Given request read('../data/upload_DocumentInbound.xml')
			When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
			* configure readTimeout = 60000000
			Then status 200	
			
			* print 'Get the document id from response and replace in the response upload_DocumentInbound_expected.xml and match response'
			* def docid = get response /Envelope/Body/UploadResponse/UploadResult
			* def upload_DocumentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
			* set upload_DocumentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid	
			And match response == read('../data/upload_DocumentInbound_expected.xml')
			* print response
			* def DocumentID1 = docid
			* def CorrespondenceID1 = corrid
			
			* def baseurl1 = baseurl + "/Documents.svc"
			* url baseurl1
			* header Authorization = "hcp " + token
			* def corrid = corrid
			* def contract = 'AttachmentInbound'
			* configure readTimeout = 60000000
			
			* print 'Upload Attachement Inbound custom metadata and verify that the document is uploaded by using tryGetDocumentIdRequestData'
			* def docid = get response /Envelope/Body/UploadResponse/UploadResult
			* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
			* def RelatedDocID = docid
			* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
			* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
			* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = RelatedDocID
			* def repository = 'Business Operations'
			* def sourcesystem = 'Amdocs'
			* def contract = 'AttachmentInbound'
			* def xsi_type = '&quot;#AttachmentInbound(contract)&quot'
			* set corrospondenceid/Envelope/Body/Upload/repository = repository
			* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
			* set corrospondenceid/Envelope/Body/Upload/metadata = contract
			* def corrid = corrid + "1"
			* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
			* def baseurl1 = baseurl + "/Documents.svc"
			* url baseurl1
			* header Authorization = "hcp " + token
			Given request read('../data/upload_AttachmentInbound.xml')
			When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
			Then status 200	
			And print response
			
			* print 'Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response'
			* def docid = get response /Envelope/Body/UploadResponse/UploadResult
			* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
			* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid	
			And match response == read('../data/upload_DocumentInbound_expected.xml')
			* def DocumentID = docid
			* def CorrespondenceID = corrid
				  
		  * print 'Scenario: Validate that document can be retrived by Document ID'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
			Given path common_path+'/'+DocumentID
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
		
		  * print 'Scenario: Validate GET Response when No file exist with given Document ID' 
		  * def baseurl = baseurl 
		  * url baseurl
		  * header Authorization = "hcp " + token
			Given path common_path+'/'+DocumentID +"12"	
			When method get
			Then status 404 Not Found
			Then match response contains 'Message: Document does not exist.'
		
		  * print 'Scenario: Validate GET Response when Document ID path is invalid'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
			Given path common_path+'12/'+DocumentID,
			When method get
			Then status 400 Bad Request 
			* print response
			
			* print 'Scenario: Validate that get document by Document ID method should not work when authentication token is not passed'
			* def baseurl = baseurl
			* url baseurl
			* header Authorization = "hcp " + token
		  Given path common_path+'/'+DocumentID
			And header Authorization = ' '	
			When method get
			Then status 401 Unauthorized
			Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'
		
		  * print 'Scenario: Validate that Document can be retrived by Correspondence ID'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+source_system1+CorrespondenceID
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
			Then match responseHeaders["TFL-RelatedDocumentID"] == ['#(RelatedDocID)']
			* def RelatedDocumentID = responseHeaders['TFL-RelatedDocumentID'][0]
		
		  * print 'Scenario: Validate GET Response when No file exists with given correspondence Id'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token	
		  Given path common_path+source_system1+CorrespondenceID +"12"
			When method get
			Then status 404 Not Found
			Then match response contains 'Message: Document does not exist.'
		
		  * print 'Scenario: Validate GET Response when correspondence Id path is invalid'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+'12'+source_system1+CorrespondenceID
			When method get
			Then status 400 Bad Request 
			
		  * print 'Scenario: Validate GET Response when source system of correspondence Id is invalid'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+'/EPT1/'+CorrespondenceID;
			When method get
			Then status 400 Bad Request
			Then match response contains 'Message: Source System Not Exist:'
			 			
		  * print 'Scenario: Validate that get document by Correspondence ID method should not work when authentication token is not passed'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+source_system1+CorrespondenceID;
			And header Authorization = ' '	
			When method get
			Then status 401 Unauthorized
		  Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'
		
		  * print 'Scenario: Validate that related Document can be get by Document ID'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path +"/" +source_system2+DocumentID
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
		
		  * print 'Scenario: Validate that related Document can not be get by Document ID when document ID is not valid/exist'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
			Given path common_path+"/" +source_system2+DocumentID +"12"		
			When method get
			Then status 404 Document does not exist. Document ID:
			Then match response contains 'Details: Document does not exist. Document ID:'
		
		  * print 'Scenario: Validate that related Document can not be get by Document ID when document ID path is invalid'  
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
			Given path common_path+'12/'+source_system2+DocumentID
			When method get
			Then status 400 Bad Request 
							 			
		  * print 'Scenario: Validate that get Document by related Document ID method should not work when authentication token is not passed'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+"/"+source_system2+DocumentID
			And header Authorization = ' '	
			When method get
			Then status 401 Unauthorized
			Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'
		
		  * print 'Scenario: Validate that related Document can be get by Correspondence ID'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+source_system1+"/"+source_system2+CorrespondenceID
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
		
		  * print 'Scenario: Validate that related Document can not be get by Correspondence ID when Correspondence ID is not valid/exist'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+source_system1+"/"+source_system2+CorrespondenceID + "12"	
			When method get
			Then status 404 Document does not exist. Correspondence ID:
			Then match response contains 'Details: Document does not exist. Correspondence ID:'
			
		  * print 'scenario: Validate that related Document can not be get by Correspondence ID when Correspondence ID path is invalid'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
			Given path common_path+'12'+source_system1+"/"+source_system2+CorrespondenceID
			When method get
			Then status 400 Bad Request 
			
		  * print 'Scenario: Validate that related Document can not be get by Correspondence ID when Source system is invalid'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+"/"+source_system2+CorrespondenceID
			When method get
			Then status 400 Invalid Document Identifier
			Then match response contains 'Details: Invalid Document Identifier: '
			 			
		  * print 'Scenario: Validate that get related document by Correspondence ID method should not work when authentication token is not passed'
		  * def baseurl = baseurl
		  * url baseurl
		  * header Authorization = "hcp " + token
		  Given path common_path+source_system1+"/"+source_system2+CorrespondenceID
			And header Authorization = ' '	
			When method get
			Then status 401 Unauthorized
			Then match response contains 'Message: Invalid credentials or token expired. Please re-login !'
			
			* print 'Delete uploaded Document Inbound (related document) document using DeleteByDocumentId'	
			* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
			* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = RelatedDocID
			* def baseurl1 = baseurl + "/Documents.svc"
			* url baseurl1
			And header Authorization = "hcp " + token
			Given request read('../data/DeleteByDocumentId.xml')
			When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
			Then status 200
			And print response
			And match response == read('../data/DeleteByDocumentId_expected.xml')
		
		  * print 'Scenario: Validate that related Document can not be get by Document ID when related document is not attached'
		  Given path common_path+"/" +source_system2+DocumentID
			* def baseurl = baseurl
			* url baseurl
			And header Authorization = "hcp " + token
			When method get
			Then status 404 File does not exist. Document path:
			Then match response contains 'Details: File does not exist. Document path:'	
			
		  * print 'Scenario: Validate that related Document can not be get by Correspondence ID when related document is not attached'
			* def baseurl = baseurl
			* url baseurl
			And header Authorization = "hcp " + token
			Given path common_path+source_system1+source_system2+CorrespondenceID
			When method get
			Then status 404 File does not exist. Document path:
			* print response
			Then match response contains 'Details: File does not exist. Document path:'
			
		  * print 'Delete uploaded attachement Inbound document using DeleteByDocumentId'	
			* def DeleteByDocumentId = read('../data/DeleteByDocumentId2.xml')
			* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = DocumentID
			* def baseurl1 = baseurl + "/Documents.svc"
			* url baseurl1
			* header Authorization = "hcp " + token
			Given request read('../data/DeleteByDocumentId2.xml')
			When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
			Then status 200
			And print response
			And match response == read('../data/DeleteByDocumentId_expected.xml')							
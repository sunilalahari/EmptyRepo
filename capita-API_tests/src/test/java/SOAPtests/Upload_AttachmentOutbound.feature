#@parallel=false
Feature: test soap end point

Background:
#* url demoBaseUrl + '/soap'
# this live url should work if you want to try this on your own
#* url 'https://dev-docstore1-evidentialapp.azurewebsites.net/Document.svc'
* def baseurl = baseurl
* url baseurl
* header Authorization = "hcp " + token
* def corrid = corrid

* configure readTimeout = 60000000

Scenario: Upload SourceSystem CDIS and verify that the document is uploaded by using tryGetDocumentIdRequestData
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'CDIS'
	* def contract = 'AttachmentOutbound'
	* def xsi_type = '&quot;#AttachmentOutbound(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid	
	And match response == read('../data/upload_DocumentInbound_expected.xml')	
	
	
	#Verify that the document is uploaded by using TryGetByMetadataSearch
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/repository = repository
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/sourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/CorrespondenceID = corrid
	* print TryGetByMetadataSearch
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByMetadataSearch'
	Then status 200
	And print response
    * def created_date = get response /Envelope/Header/TFL-Created
	* def modified_date = get response /Envelope/Header/TFL-Modified
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentOutbound_expected.xml')
	* set TryGetByMetadataSearch/Envelope/Header/TFL-CorrespondenceID = corrid
	* set TryGetByMetadataSearch/Envelope/Header/TFL-DocumentID = docid
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Created = created_date
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Modified = modified_date
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Repository = repository
	* set TryGetByMetadataSearch/Envelope/Header/TFL-SourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Header/TFL-SourceSystem = contract
	And match response == read('../data/TryGetByMetadataSearch_AttachmentOutbound_expected.xml')
	And print response
	
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/repository = repository
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/sourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/CorrespondenceID = corrid
	
	#Verify the error when using TryGetByMetadataSearch without authentication header
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/repository = repository
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/sourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/CorrespondenceID = corrid
	* print TryGetByMetadataSearch
	#And header Authorization = "hcp " + token
	Given request read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByMetadataSearch'
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login'
	
	
	
	* def tryGetByCorrespondenceId = read('../data/TryGetByCorrespondenceId.xml')
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/correspondenceId = corrid	
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/sourceSystem = sourcesystem	
	
	# Verify that the document is uploaded by using TryGetByCorrespondenceId 
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByCorrespondenceId'
	#Then status 200	
	Then print response	
	* def created_date = get response /Envelope/Header/TFL-Created
	* def modified_date = get response /Envelope/Header/TFL-Modified
	* def tryGetByCorrespondenceId = read('../data/TryGetByCorrespondenceId_expected.xml')
	* set tryGetByCorrespondenceId/Envelope/Header/TFL-CorrespondenceID = corrid
	* set tryGetByCorrespondenceId/Envelope/Header/TFL-DocumentID = docid
	* set tryGetByCorrespondenceId/Envelope/Header/TFL-Created = created_date
	* set tryGetByCorrespondenceId/Envelope/Header/TFL-Modified = modified_date
	* set tryGetByCorrespondenceId/Envelope/Header/TFL-Repository = repository
	* set tryGetByCorrespondenceId/Envelope/Header/TFL-SourceSystem = sourcesystem
	* set tryGetByCorrespondenceId/Envelope/Header/TFL-SourceSystem = contract
	And match response == read('../data/TryGetByCorrespondenceId_expected.xml')
	
	* def tryGetByCorrespondenceId = read('../data/TryGetByCorrespondenceId.xml')
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/correspondenceId = corrid	
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/sourceSystem = sourcesystem	
	
	# Verify that the document is uploaded by using TryGetByCorrespondenceId with no authentication 
	#And header Authorization = "hcp " + token
	Given request read('../data/TryGetByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByCorrespondenceId'
	#Then status 200	
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login'
	
	* def corrid = '123456789'
	* def tryGetByCorrespondenceId = read('../data/TryGetByCorrespondenceId.xml')
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/correspondenceId = corrid
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/sourceSystem = sourcesystem	
	#Verify that the document is uploaded by using TryGetByCorrespondenceId with no-existing documentId
	
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByCorrespondenceId'
	#Then status 200	
		
	Then print response	
	And match response == read('../data/TryGetByCorrespondenceId_expected_failsgracefully.xml')
	
	
	#Verify error message by using TryGetByCorrespondenceId with invalid correspondenceId
	
	* def corrid = '123456789#$'
	* def tryGetByCorrespondenceId = read('../data/TryGetByCorrespondenceId.xml')
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/correspondenceId = corrid
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByCorrespondenceId'
	#Then status 200
	
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Correspondance Identifier: 123456789#$ Reason : Must use only characters 0 to 9, a to z and A to Z or the following: $ - _ . + ! * ( )' 
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid Correspondance Identifier: 123456789#$ Reason : Must use only characters 0 to 9, a to z and A to Z or the following: $ - _ . + ! * ( )'
	
	
	# Verify error message on tryGetByCorrespondenceId when correspondenceID is not provided
	* def tryGetByCorrespondenceId = read('../data/TryGetByCorrespondenceId.xml')
	* set tryGetByCorrespondenceId/Envelope/Body/TryGetByCorrespondenceId/sourceSystem = sourcesystem
	#Verify error message on using TryGetByCorrespondenceId with no correspondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByCorrespondenceId_Nocorrid.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByCorrespondenceId'
	#Then status 200	
	#* def docid = 'BOPS202006130CDIS-30043x'	
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: correspondenceId'
	And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: correspondenceId Event ID'
	
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/repository = repository
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/sourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/CorrespondenceID = corrid
	
	#Verify the error when using TryGetByMetadataSearch fails gracefully
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/repository = repository
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/sourceSystem = sourcesystem
	* def corrid = '2554447242'
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/CorrespondenceID = corrid
	* print TryGetByMetadataSearch
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByMetadataSearch_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByMetadataSearch'
	Then print response	
	Then print response	
	And match response == read('../data/TryGetByMetadataSearch_expected_failsgracefully.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')

Scenario: Upload SourceSystem CDIS with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_DocumentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'CDIS'
	* def contract = 'AttachmentOutbound'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_DocumentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_DocumentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_DocumentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_DocumentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	#Verify error by using UpdateByCorrespondenceId with no authentication header
	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceId.xml')
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceID = corrid	
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem
	Given request read('../data/UpdateByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login ! Correlation ID'	
	
	
	
	#Verify the error by using UpdateByCorrespondenceId with missing correspondenceId
	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceId_nocorrid.xml')
	#* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceId = corrid
	#* def comment = corrid
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem
	* print UpdateByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByCorrespondenceId_nocorrid.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: correspondenceId'
	And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: correspondenceId Event ID'	

	
	#Verify error by using GetByDocumentId with invalid correspondenceId
	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceId.xml')
	* def corrid = 'ww22$$##'
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceID = corrid
	#* def comment = corrid
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem	
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Correspondance Identifier: ww22$$## Reason : Must use only characters 0 to 9, a to z and A to Z or the following: $ - _ . + ! * ( )'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid Correspondance Identifier: ww22$$## Reason : Must use only characters 0 to 9, a to z and A to Z or the following: $ - _ . + ! * ( )'
	
	#Verify error by using UpdateByCorrespondenceId with non-existing correspondenceID
	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceId.xml')
	* def corrid = 'abcdzzz'
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceID = corrid	
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Document does not exist. Correspondence ID: abcdzzz Source System: CDIS'
	And match response /Envelope/Body/Fault/detail contains 'Message: Document does not exist. Correspondence ID: abcdzzz Source System: CDIS Event ID'
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')

Scenario: Upload SourceSystem CDIS with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'CDIS'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Upload SourceSystem CDIS with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'CDIS'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: CDIS Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: CDIS Repository Knowledge Base Event'	
	
	
Scenario: Upload SourceSystem Amdocs with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Amdocs Repository Enforcement Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Amdocs Repository Enforcement Operations Event'
	
Scenario: Upload SourceSystem Amdocs with repository Business Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	
	
	# Verify error message on deleting file with no authorization
	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	#And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login !'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login ! Correlation ID'
	
	# Delete a file using DeleteByDocumentId
	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
	# Verify error message on deleting a document which does not exists
	* def docid = 'BOPS202008060ACC-60008'
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Document does not exist. Document ID: BOPS202008060ACC-60008'
	And match response /Envelope/Body/Fault/detail contains 'Message: Document does not exist. Document ID: BOPS202008060ACC-60008 Event ID'
	
	# Verify error message on deleting a document with invalid documentId
	* def docid = 'BOP202008060ACC-60008'
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Document Identifier: BOP202008060ACC-60008'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid Document Identifier: BOP202008060ACC-60008 Event ID'
	
	# Verify error message on deleting a document with documentId not provided
	#* def docid = 'BOP202008060ACC-60008'
	#* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	#* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	#* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId_nodocid.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: documentId'
	And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: documentId Event ID'
	
	
Scenario: Upload SourceSystem Amdocs with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Amdocs Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Amdocs Repository Knowledge Base Event'

Scenario: Upload SourceSystem Email with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    #* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Verify error message on deleting file using DeleteByCorrespondenceId with no authorization
	
	* def DeleteByCorrespondenceId = read('../data/DeleteByCorrespondenceId.xml')
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/correspondenceId = corrid
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/sourceSystem = sourcesystem
	* print DeleteByCorrespondenceId
	#And header Authorization = "hcp " + token
	Given request read('../data/DeleteByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByCorrespondenceId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login !'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login ! Correlation ID'
	
	# Verify deleting file using DeleteByCorrespondenceId
	
	* def DeleteByCorrespondenceId = read('../data/DeleteByCorrespondenceId.xml')
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/correspondenceId = corrid
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/sourceSystem = sourcesystem
	* print DeleteByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByCorrespondenceId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByCorrespondenceId_expected.xml')
	
	# Verify error message on deleting a document which does not exists using DeleteByCorrespondenceId
	#* def corrid = 'BOPS202008060ACC-60008'
	* def DeleteByCorrespondenceId = read('../data/DeleteByCorrespondenceId.xml')
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/correspondenceId = corrid
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/sourceSystem = sourcesystem
	* print DeleteByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByCorrespondenceId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Document does not exist. Correspondence ID:'
	And match response /Envelope/Body/Fault/detail contains 'Message: Document does not exist. Correspondence ID:'
	
	# Verify error message on deleting a document with invalid correspondenceId
	* def corrid = '2554447242##$$'
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/correspondenceId = corrid
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/sourceSystem = sourcesystem
	* print DeleteByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByCorrespondenceId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Correspondance Identifier: 2554447242##$$ Reason : Must use only characters 0 to 9, a to z and A to Z or the following: $ - _ . + ! * ( )'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid Correspondance Identifier: 2554447242##$$ Reason : Must use only characters 0 to 9, a to z and A to Z or the following: $ - _ . + ! * ( )'
	
	# Verify error message on deleting a document with correspondenceId not provided	
	* def DeleteByCorrespondenceId = read('../data/DeleteByCorrespondenceId.xml')
	* set DeleteByCorrespondenceId/Envelope/Body/DeleteByCorrespondenceId/sourceSystem = sourcesystem
	* print DeleteByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByCorrespondenceId_nocorrid.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByCorrespondenceId'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: correspondenceId'
	And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: correspondenceId Event ID'
	
Scenario: Upload SourceSystem Email with repository Business Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Upload SourceSystem Email with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	#Then status 400
    And print response	
	#And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Email Repository Knowledge Base'
	#And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Email Repository Knowledge Base Event'
	
Scenario: Upload SourceSystem Eptica with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Upload SourceSystem Eptica with repository Business Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Upload SourceSystem Eptica with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Eptica Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Eptica Repository Knowledge Base Event'	
	
Scenario: Upload SourceSystem TFL Online with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Upload SourceSystem TFL Online with repository Business Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Upload SourceSystem TFL Online with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: TFL Online Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: TFL Online Repository Knowledge Base Event'	
	
Scenario: Upload SourceSystem Taranto with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Taranto'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# Cleanup Delete uploaded document using DeleteByDocumentId	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Upload SourceSystem Taranto with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Taranto'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Taranto Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Taranto Repository Knowledge Base Event'	
	
Scenario: Upload SourceSystem Articles with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	And header Authorization = "hcp " + token
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: Articles'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: Articles Event'

Scenario: Upload SourceSystem Articles with repository Business Operations
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Articles Repository Business Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Articles Repository Business Operations Event'

Scenario: Upload SourceSystem Articles with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Articles Repository Enforcement Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Articles Repository Enforcement Operations Event'
	
Scenario: Upload SourceSystem DAR Material with repository Business Operations
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: DAR Material'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: DAR Material Event'
	
Scenario: Upload SourceSystem DAR Material with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_EpticaArticle.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* def contract = 'EpticaArticle'
	* def xsi_type = '&quot;#EpticaArticle(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: DAR Material'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: DAR Material Event'
	
Scenario: Upload SourceSystem DAR Material with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_AttachmentOutbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	
	Given request read('../data/upload_AttachmentOutbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: DAR Material Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: DAR Material Repository Knowledge Base Event'
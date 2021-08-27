#@parallel=false
Feature: test soap end point

Background:
* def baseurl = baseurl
* url baseurl
* header Authorization = "hcp " + token
* def corrid = corrid
* def contract = 'AttachmentInbound'
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
	And header Authorization = "hcp " + token
	Given request read('../data/upload_EpticaArticle.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EpticaArticle_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	And print docid
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	And print RelatedDocID
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
	And print corrospondenceid

   # * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	And print corrospondenceid
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'CDIS'
	* def contract = 'AttachmentInbound'
	* def xsi_type = '&quot;#AttachmentInbound(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	And print corrospondenceid
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	And print response
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid	
	And match response == read('../data/upload_DocumentInbound_expected.xml')	
	
	
	#Verify that the document is uploaded by using TryGetByMetadataSearch
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentInbound.xml')
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/repository = repository
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/sourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/CorrespondenceID = corrid
	* print TryGetByMetadataSearch
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByMetadataSearch_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByMetadataSearch'
	Then status 200	
	* def created_date = get response /Envelope/Header/TFL-Created
	* def modified_date = get response /Envelope/Header/TFL-Modified
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_AttachmentInbound_expected.xml')
	* set TryGetByMetadataSearch/Envelope/Header/TFL-CorrespondenceID = corrid
	* set TryGetByMetadataSearch/Envelope/Header/TFL-DocumentID = docid
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Created = created_date
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Modified = modified_date
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Repository = repository
	* set TryGetByMetadataSearch/Envelope/Header/TFL-SourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Header/TFL-SourceSystem = contract
	And match response == read('../data/TryGetByMetadataSearch_AttachmentInbound_expected.xml')
	And print response
	
	#Verify that the document is uploaded by using GetByCorrespondenceId
	* def GetByCorrespondenceId = read('../data/GetByCorrespondenceId.xml')
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/sourceSystem = sourcesystem
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/CorrespondenceID = corrid
	* print GetByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByCorrespondenceId'
	Then status 200	
	* def created_date = get response /Envelope/Header/TFL-Created
	* def modified_date = get response /Envelope/Header/TFL-Modified
	* def GetByCorrespondenceId = read('../data/GetByCorrespondenceId_expected.xml')
	* set GetByCorrespondenceId/Envelope/Header/TFL-CorrespondenceID = corrid
	* set GetByCorrespondenceId/Envelope/Header/TFL-DocumentID = docid
	* set GetByCorrespondenceId/Envelope/Header/TFL-Created = created_date
	* set GetByCorrespondenceId/Envelope/Header/TFL-Modified = modified_date
	* set GetByCorrespondenceId/Envelope/Header/TFL-Repository = repository
	* set GetByCorrespondenceId/Envelope/Header/TFL-SourceSystem = sourcesystem
	* set GetByCorrespondenceId/Envelope/Header/TFL-SourceSystem = contract
	And match response == read('../data/GetByCorrespondenceId_expected.xml')
	And print response
	
	#Verify that the document is uploaded by using GetByCorrespondenceId with non-existing corrospondenceid
	* def GetByCorrespondenceId = read('../data/GetByCorrespondenceId_notexisting.xml')
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/sourceSystem = sourcesystem
	* print GetByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByCorrespondenceId_notexisting.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByCorrespondenceId'
	#Then status 400
  Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Document does not exist. Correspondence ID: abcddzz1249 Source System: CDI'
	And match response /Envelope/Body/Fault/detail contains 'Message: Document does not exist. Correspondence ID: abcddzz1249 Source System: CDIS Event ID'
	
	#Verify that the document is uploaded by using GetByCorrespondenceId with no authentication header
	* def GetByCorrespondenceId = read('../data/GetByCorrespondenceId.xml')
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/sourceSystem = sourcesystem
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/CorrespondenceID = corrid
	* print GetByCorrespondenceId
	Given request read('../data/GetByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByCorrespondenceId'
	Then status 401
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login'
	
	#Verify that the document is uploaded by using GetByCorrespondenceId with missing corrospondenceid
	* def GetByCorrespondenceId = read('../data/GetByCorrespondenceIdNoCorrid.xml')
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/sourceSystem = sourcesystem
	#* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/CorrespondenceID = corrid
	* print GetByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByCorrespondenceIdNoCorrid.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByCorrespondenceId'
	#Then status 400
  Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: correspondenceId'
	And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: correspondenceId Event ID'
	
	#Verify that the document is uploaded by using GetByCorrespondenceId with invalid corrospondenceid
	* def GetByCorrespondenceId = read('../data/GetByCorrespondenceId.xml')
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/sourceSystem = sourcesystem
	* def corrid = 'abc$$$##'
	* set GetByCorrespondenceId/Envelope/Body/GetByCorrespondenceId/CorrespondenceID = corrid
	* print GetByCorrespondenceId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByCorrespondenceId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByCorrespondenceId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Correspondance Identifier: abc$$$##'
	And match response /Envelope/Body/Fault/detail contains 'Reason : Must use only characters 0 to 9, a to z and A to Z or the following: $ - _ . + ! * ( )'
	
	#Verify that the document is uploaded by using GetByDocumentId with non-existing corrospondenceid
	* def GetByDocumentId = read('../data/GetByDocumentId_notexisting.xml')
	* set GetByDocumentId/Envelope/Body/GetByDocumentId/sourceSystem = sourcesystem
	#* set GetByDocumentId/Envelope/Body/GetByDocumentId/CorrespondenceID = 'BOPS202006130ACC-122'
	* print GetByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByDocumentId_notexisting.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Document does not exist. Document ID: BOPS202006130ACC-122'
	And match response /Envelope/Body/Fault/detail contains 'Message: Document does not exist. Document ID: BOPS202006130ACC-122 Event ID'
	
	#Verify that the document is uploaded by using GetByDocumentId with no authentication header
	* def GetByDocumentId = read('../data/GetByDocumentId.xml')
	#* set GetByDocumentId/Envelope/Body/GetByDocumentId/sourceSystem = sourcesystem
	* set GetByDocumentId/Envelope/Body/GetByDocumentId/documentId = docid
	* print GetByDocumentId
	Given request read('../data/GetByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByDocumentId'
	Then status 401
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login ! Correlation ID'
	
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
	
	#Verify that the document is uploaded by using GetByDocumentId with missing documentId
	* def GetByDocumentId = read('../data/GetByDocumentIdNodocid.xml')
	#* set GetByDocumentId/Envelope/Body/GetByDocumentId/sourceSystem = sourcesystem
	#* set GetByDocumentId/Envelope/Body/GetByDocumentId/CorrespondenceID = corrid
	* print GetByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByDocumentIdNodocid.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: documentId'
	And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: documentId Event ID'	
	
	
	#Verify that the document is uploaded by using GetByDocumentId with invalid documentid
	* def GetByDocumentId = read('../data/GetByDocumentId.xml')
	#* set GetByDocumentId/Envelope/Body/GetByDocumentId/sourceSystem = sourcesystem
	* def docid = 'BOP202006130ACC-777147517'
	* set GetByDocumentId/Envelope/Body/GetByDocumentId/documentId = docid
	* print GetByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByDocumentId'
	#Then status 400
  Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Document Identifier: BOP202006130ACC-777147517'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid Document Identifier: BOP202006130ACC-777147517 Event ID'

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
	#* def upload_EpticaArticle_expected = read('../data/upload_DocumentInbound_expected.xml')
	#* set upload_EpticaArticle_expected/Envelope/Body/UploadResponse/UploadResult = docid	
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'CDIS'
	* def contract = 'AttachmentInbound'
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	And print response
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	#* def created_date = get response /Envelope/Header/TFL-Created
	#* def modified_date = get response /Envelope/Header/TFL-Modified
	And match response == read('../data/upload_DocumentInbound_expected.xml')	
	
	
	#Verify document can be updated using UpdateByDocumentId
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId.xml')
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	#* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	And print UpdateByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	Then print response
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId_expected.xml')
	* set UpdateByDocumentId/Envelope/Header/TFL-CorrespondenceID = corrid
	#* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Header/TFL-Comment = comment
	* set UpdateByDocumentId/Envelope/Header/TFL-DocumentID = docid
	#* set UpdateByDocumentId/Envelope/Header/TFL-Created = created_date
	#* set UpdateByDocumentId/Envelope/Header/TFL-Modified = modified_date
	* set UpdateByDocumentId/Envelope/Header/TFL-Repository = repository
	* set UpdateByDocumentId/Envelope/Header/TFL-SourceSystem = 'CDIS'
	* set UpdateByDocumentId/Envelope/Header/TFL-contract = 'AttachmentInbound'
	* set UpdateByDocumentId/Envelope/Header/TFL-RelatedDocumentID = RelatedDocID
	Then print UpdateByDocumentId
	And match response == read('../data/UpdateByDocumentId_expected.xml')
	
	#Verify error when comment is not provided using UpdateByDocumentId
	* def UpdateByDocumentId = read('../data/UpdateByDocumentIdMissingcomments.xml')
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	#* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/RelatedDocumentID = RelatedDocID
	And print UpdateByDocumentId
	And header Authorization = "hcp " + token	
	Given request read('../data/UpdateByDocumentIdMissingcomments.xml')
#=======
#	And print UpdateByDocumentId
#	And header Authorization = "hcp " + token
#	Given request read('../data/UpdateByDocumentIdMissingcomments.xml')
#	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
#	Then print response
#	And match response /Envelope/Body/Fault/detail contains 'Update Failed. Mandatory Property Empty: Comment'
#	And match response /Envelope/Body/Fault/detail contains 'Message: Update Failed. Mandatory Property Empty: Comment Correlation ID'
#	
#	# Update document using UpdateByCorrespondenceId
#	
#	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceId.xml')
#	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem
#	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceId = corrid	
#	And print UpdateByCorrespondenceId
#	And header Authorization = "hcp " + token
#	Given request read('../data/UpdateByCorrespondenceId.xml')
#	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
#	Then print response
#	* def UpdateByCorrespondenceId_expected = read('../data/UpdateByCorrespondenceId_expected.xml')
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-CorrespondenceID = corrid
#	#* def comment = corrid
#	#* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Comment = comment
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-DocumentID = docid
#	#* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Created = created_date
#	#* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Modified = modified_date
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Repository = repository
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-SourceSystem = sourcesystem
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-SourceSystem = contract
#	And match response == read('../data/UpdateByCorrespondenceId_expected.xml')
#	
#	# Verify error message when no comments are provided
#	
#	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceIdNocomment.xml')
#	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem
#	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceId = corrid	
#	And print UpdateByCorrespondenceId
#	And header Authorization = "hcp " + token
#	Given request read('../data/UpdateByCorrespondenceIdNocomment.xml')
#	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
#	Then print response	
#	And match response /Envelope/Body/Fault/detail contains 'Update Failed. Mandatory Property Empty: Comment'
#	And match response /Envelope/Body/Fault/detail contains 'Message: Update Failed. Mandatory Property Empty: Comment Correlation ID'
#	
#	#Verify error by using UpdateByDocumentId with no authentication header
#	Given request read('../data/UpdateByDocumentId.xml')
#>>>>>>> 73d87234b5dc1b3c23af007d04c0ffcba3a4a39a
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	Then print response
	And match response /Envelope/Body/Fault/detail contains 'Update Failed. Mandatory Property Empty: Comment'
	And match response /Envelope/Body/Fault/detail contains 'Message: Update Failed. Mandatory Property Empty: Comment Correlation ID'
	#Verify the error by using UpdateByDocumentId with missing documentId
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* print UpdateByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId_nodocid.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: documentId'
	And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: documentId Event ID'	
	
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
	
	
	#Verify error by using GetByDocumentId with invalid documentid
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId.xml')
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	#* def comment = corrid
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* def docid = 'EOP202008070CDIS-50008'
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Document Identifier: EOP202008070CDIS-50008'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid Document Identifier: EOP202008070CDIS-50008 Event ID'
	
	#Verify error by using UpdateByDocumentId with non-existing documentId
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId.xml')
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* def docid = 'EOPS202008070CDIS-5000'
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Document does not exist. Document ID: EOPS202008070CDIS-5000'
	And match response /Envelope/Body/Fault/detail contains 'Message: Document does not exist. Document ID: EOPS202008070CDIS-5000 Event ID'

	

	
Scenario: Upload SourceSystem CDIS with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'CDIS'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: CDIS Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: CDIS Repository Knowledge Base Event'
	
Scenario: Upload SourceSystem Amdocs with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Amdocs Repository Enforcement Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Amdocs Repository Enforcement Operations Event'
	
Scenario: Upload the file name contains character # not support by the implementation
    * def corrospondenceid = read('../data/upload_AttachmentInbound_filename.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* def filename = 'file1#.jpg'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata/FileName = filename	
	Given request read('../data/upload_AttachmentInbound_filename.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Value invalid. Property: FileName Reason: Must not use the following characters: ~ " # %'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Value invalid. Property: FileName Reason: Must not use the following characters: ~ " # %'
	
Scenario: Upload the file name contains invalid format double . support by the implementation
    * def corrospondenceid = read('../data/upload_AttachmentInbound_filename.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* def filename = 'file1..jpg'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata/FileName = filename
	Given request read('../data/upload_AttachmentInbound_filename.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Value contains consecutive periods. Property: FileName'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Value contains consecutive periods. Property: FileName Correlation ID'

Scenario: Validate SOAP Fault - SOAP call parameter value array not of expected length, Upload the file with only 1 substring
    * def corrospondenceid = read('../data/upload_AttachmentInbound_1string.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound_1string.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Mandatory Array Out of Bounds. Expected Length: 2 Actual: 1 Property: SubCategory'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Mandatory Array Out of Bounds. Expected Length: 2 Actual: 1 Property: SubCategory Correlation ID'	
	
Scenario: Validate SOAP Fault - SOAP call parameter value array not of expected length, Upload the file with 3 substrings
    * def corrospondenceid = read('../data/upload_AttachmentInbound_3string.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound_3string.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	And print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Mandatory Array Out of Bounds. Expected Length: 2 Actual: 3 Property: SubCategory'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Mandatory Array Out of Bounds. Expected Length: 2 Actual: 3 Property: SubCategory Correlation ID'	
	
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
	# SOAP Fault : Validate error when Correspondence Id is not unique in the sourceSystem
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Ambigious Correspondence ID'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Ambigious Correspondence ID'
	
	
	
	#Verify the error by using UpdateByDocumentId with non-existing correspondenceId
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId.xml')	
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	* def corrid = '2554447242xy'
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid	
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* print UpdateByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Update Failed. Property Write-Once: CorrespondenceID'
	And match response /Envelope/Body/Fault/detail contains 'Message: Update Failed. Property Write-Once: CorrespondenceID Correlation ID:'
	
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
	
	
	# Verify error message when correspondenceId is greater than 256 characters
	* def corrid = '123456789012345678912345678901234567890123456789123456789123456789123456789012345678901234567890123456789012345678901234567890123456789012345678901234324234093843489320483084349482930483204834893204829408329048392048320948329043924893248204848093248329408333'
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Value too long. Property: CorrespondenceID Length: 258 Maximum: 255'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Value too long. Property: CorrespondenceID Length: 258 Maximum: 255 Correlation ID'
	
	#upload document with 255 character correspondenceId
	* def corrid = '123456789012345678912345678901234567890123456789123456789123456789123456789012345678901234567890123456789012345678901234567890123456789012345678901234324234093843489320483084349482930483204834893204829408329048392048320948329043924893248204848093248329409'
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
	
#<<<<<<< HEAD
#=======
	# SOAP Fault : Validate error when Correspondence Id is not unique in the sourceSystem
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Ambigious Correspondence ID'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Ambigious Correspondence ID'
	
	
	
	#Verify the error by using UpdateByDocumentId with non-existing correspondenceId
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId.xml')	
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	* def corrid = '2554447242xy'
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid	
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* print UpdateByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Update Failed. Property Write-Once: CorrespondenceID'
	And match response /Envelope/Body/Fault/detail contains 'Message: Update Failed. Property Write-Once: CorrespondenceID Correlation ID'
	
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
	
	
	# Verify error message when correspondenceId is greater than 256 characters
	* def corrid = '123456789012345678912345678901234567890123456789123456789123456789123456789012345678901234567890123456789012345678901234567890123456789012345678901234324234093843489320483084349482930483204834893204829408329048392048320948329043924893248204848093248329408333'
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Upload Failed. Value too long. Property: CorrespondenceID Length: 258 Maximum: 255'
	And match response /Envelope/Body/Fault/detail contains 'Message: Upload Failed. Value too long. Property: CorrespondenceID Length: 258 Maximum: 255 Correlation ID'
	
	#upload document with 255 character correspondenceId
	* def corrid = '123456789012345678912345678901234567890123456789123456789123456789123456789012345678901234567890123456789012345678901234567890123456789012345678901234324234093843489320483084349482930483204834893204829408329048392048320948329043924893248204848093248329409'
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_AttachmentInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_AttachmentInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_AttachmentInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
	And match response == read('../data/upload_DocumentInbound_expected.xml')
#	
#>>>>>>> 73d87234b5dc1b3c23af007d04c0ffcba3a4a39a
	# Delete above file	
	
	* def DeleteByDocumentId = read('../data/DeleteByDocumentId.xml')
	* set DeleteByDocumentId/Envelope/Body/DeleteByDocumentId/documentId = docid
	* print DeleteByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/DeleteByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/DeleteByDocumentId'
	Then status 200
	And print response
	And match response == read('../data/DeleteByDocumentId_expected.xml')
	
Scenario: Verify error on Uploading SourceSystem Amdocs with repository Business Operations when file size exeeds expected size
    * def corrospondenceid = read('../data/upload_AttachmentInbound_exceedsize.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound_exceedsize.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Data Exceeds Max Limit:'
	And match response /Envelope/Body/Fault/detail contains 'Message: Data Exceeds Max Limit:'


Scenario: Upload SourceSystem Amdocs with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Taranto'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Taranto'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: Articles'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: Articles Event'

Scenario: Upload SourceSystem Articles with repository Business Operations
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Articles Repository Business Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Articles Repository Business Operations Event'

Scenario: Upload SourceSystem Articles with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound.xml')
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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID

    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: DAR Material'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: DAR Material Event'
	# Update document using UpdateByCorrespondenceId
	
#	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceId.xml')
#	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem
#	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceId = corrid	
#	And print UpdateByCorrespondenceId
#	And header Authorization = "hcp " + token
#	Given request read('../data/UpdateByCorrespondenceId.xml')
#	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
#	Then print response
	
#	* def UpdateByCorrespondenceId_expected = read('../data/UpdateByCorrespondenceId_expected.xml')
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-CorrespondenceID = corrid
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-RelatedDocumentID = RelatedDocID
	
	#* def comment = corrid
	#* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Comment = comment
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-DocumentID = docid
	#* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Created = created_date
	#* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Modified = modified_date
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-Repository = repository
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-SourceSystem = sourcesystem
#	* set UpdateByCorrespondenceId_expected/Envelope/Header/TFL-SourceSystem = contract
#	Then print UpdateByCorrespondenceId_expected
#	And match response == read('../data/UpdateByCorrespondenceId_expected.xml')
	
	# Verify error message when no comments are provided
	
	* def UpdateByCorrespondenceId = read('../data/UpdateByCorrespondenceIdNocomment.xml')
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/sourceSystem = sourcesystem
	* set UpdateByCorrespondenceId/Envelope/Body/UpdateByCorrespondenceId/correspondenceId = corrid	
	And print UpdateByCorrespondenceId
	#Given request read('../data/UpdateByCorrespondenceIdNocomment.xml')
	#When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByCorrespondenceId'
	#Then print response	
	#And match response /Envelope/Body/Fault/detail contains 'Update Failed. Mandatory Property Empty: Comment'
	#And match response /Envelope/Body/Fault/detail contains 'Message: Update Failed. Mandatory Property Empty: Comment Correlation ID'
	
	#Verify error by using UpdateByDocumentId with no authentication header
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid credentials or token expired. Please re-login'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid credentials or token expired. Please re-login ! Correlation ID'
	
	#Verify the error by using UpdateByDocumentId with missing documentId
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	#* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	#* print UpdateByDocumentId
	#And header Authorization = "hcp " + token
	#Given request read('../data/UpdateByDocumentId_nodocid.xml')
	#When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    #Then print response	
	#And match response /Envelope/Body/Fault/detail contains 'Argument Null or Empty: documentId'
	#And match response /Envelope/Body/Fault/detail contains 'Message: Argument Null or Empty: documentId Event ID'	
	
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
	
	
	#Verify error by using GetByDocumentId with invalid documentid
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId.xml')
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	#* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* def docid = 'EOP202008070CDIS-50008'
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Invalid Document Identifier: EOP202008070CDIS-50008'
	And match response /Envelope/Body/Fault/detail contains 'Message: Invalid Document Identifier: EOP202008070CDIS-50008 Event ID'
	
	#Verify error by using UpdateByDocumentId with non-existing documentId
	* def UpdateByDocumentId = read('../data/UpdateByDocumentId.xml')
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/CorrespondenceID = corrid
	* def comment = corrid
	#* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/metadata/Comment = comment
	* def docid = 'EOPS202008070CDIS-5000'
	* set UpdateByDocumentId/Envelope/Body/UpdateByDocumentId/documentId = docid
	And header Authorization = "hcp " + token
	Given request read('../data/UpdateByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/UpdateByDocumentId'
	#Then status 400
    Then print response	
	And match response /Envelope/Body/Fault/detail contains 'Document does not exist. Document ID: EOPS202008070CDIS-5000'
	And match response /Envelope/Body/Fault/detail contains 'Message: Document does not exist. Document ID: EOPS202008070CDIS-5000 Event ID'
	

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
	* def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* def RelatedDocID = docid
	* set corrospondenceid/Envelope/Body/Upload/metadata/RelatedDocumentID = RelatedDocID
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	And header Authorization = "hcp " + token
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: DAR Material'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: DAR Material Event'
	
Scenario: Upload SourceSystem DAR Material with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_AttachmentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_AttachmentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: DAR Material Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: DAR Material Repository Knowledge Base Event'
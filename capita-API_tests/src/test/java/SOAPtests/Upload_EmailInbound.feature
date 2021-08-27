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

Scenario: Upload SourceSystem CDIS 
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'CDIS'
	* def contract = 'EmailInbound'
	* def xsi_type = '&quot;#EmailInbound(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid	
	And match response == read('../data/upload_DocumentInbound_expected.xml')	
	
	
	#Verify that the document is uploaded by using TryGetByMetadataSearch
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_EmailInbound.xml')
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/repository = repository
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/sourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Body/TryGetByMetadataSearch/CorrespondenceID = corrid
	* print TryGetByMetadataSearch
	And header Authorization = "hcp " + token
	Given request read('../data/TryGetByMetadataSearch_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/TryGetByMetadataSearch'
	Then status 200
	And print response
	* def created_date = get response /Envelope/Header/TFL-Created
	* def modified_date = get response /Envelope/Header/TFL-Modified
	* def TryGetByMetadataSearch = read('../data/TryGetByMetadataSearch_EmailInbound_expected.xml')
	* set TryGetByMetadataSearch/Envelope/Header/TFL-CorrespondenceID = corrid
	* set TryGetByMetadataSearch/Envelope/Header/TFL-DocumentID = docid
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Created = created_date
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Modified = modified_date
	* set TryGetByMetadataSearch/Envelope/Header/TFL-Repository = repository
	* set TryGetByMetadataSearch/Envelope/Header/TFL-SourceSystem = sourcesystem
	* set TryGetByMetadataSearch/Envelope/Header/TFL-SourceSystem = contract
	And match response == read('../data/TryGetByMetadataSearch_EmailInbound_expected.xml')	
	And print response
	
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'CDIS'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'CDIS'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: CDIS Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: CDIS Repository Knowledge Base Event'
	
Scenario: Upload SourceSystem Amdocs with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Amdocs Repository Enforcement Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Amdocs Repository Enforcement Operations Event'
	
Scenario: Upload SourceSystem Amdocs with repository Business Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
	
Scenario: Upload SourceSystem Amdocs with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Amdocs'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Amdocs Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Amdocs Repository Knowledge Base Event'

Scenario: Upload SourceSystem Email with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Email'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	#Then status 400
    And print response	
	#And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Email Repository Knowledge Base'
	#And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Email Repository Knowledge Base Event'
	
Scenario: Upload SourceSystem Eptica with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Eptica'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Eptica Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Eptica Repository Knowledge Base Event'	
	
Scenario: Upload SourceSystem TFL Online with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'TFL Online'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: TFL Online Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: TFL Online Repository Knowledge Base Event'	
	
Scenario: Upload SourceSystem Taranto with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Taranto'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	
	# Get the document id from response and replace in the response upload_EmailInbound_expected.xml and match response
	
	* def docid = get response /Envelope/Body/UploadResponse/UploadResult
	* def upload_EmailInbound_expected = read('../data/upload_DocumentInbound_expected.xml')
	* set upload_EmailInbound_expected/Envelope/Body/UploadResponse/UploadResult = docid
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
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Taranto'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Taranto Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Taranto Repository Knowledge Base Event'	
	
Scenario: Upload SourceSystem Articles with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: Articles'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: Articles Event'

Scenario: Upload SourceSystem Articles with repository Business Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Articles Repository Business Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Articles Repository Business Operations Event'

Scenario: Upload SourceSystem Articles with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'Articles'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: Articles Repository Enforcement Operations'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: Articles Repository Enforcement Operations Event'
	
Scenario: Upload SourceSystem DAR Material with repository Business Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: DAR Material'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: DAR Material Event'
	
Scenario: Upload SourceSystem DAR Material with repository Knowledge Base
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Enforcement Operations'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Content Type Name Not Exist in Source System: DAR Material'
	And match response /Envelope/Body/Fault/detail contains 'Message: Content Type Name Not Exist in Source System: DAR Material Event'
	
Scenario: Upload SourceSystem DAR Material with repository Enforcement Operations
    * def corrospondenceid = read('../data/upload_EmailInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Knowledge Base'
	* def sourcesystem = 'DAR Material'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	Given request read('../data/upload_EmailInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 400
    And print response	
	And match response /Envelope/Body/Fault/detail contains 'Source System Not Exist: DAR Material Repository Knowledge Base'
	And match response /Envelope/Body/Fault/detail contains 'Message: Source System Not Exist: DAR Material Repository Knowledge Base Event'
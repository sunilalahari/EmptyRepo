#@parallel=false
Feature: Upload SourceSystem CDIS and repository Business Operations

Background: hide Authorization
	* def baseurl = baseurl
	* url baseurl
	* header Authorization = "hcp " + token
	* def corrid = corrid
	* configure readTimeout = 60000000

Scenario: Upload Document
    * def corrospondenceid = read('../data/upload_DocumentInbound.xml')
	* set corrospondenceid/Envelope/Body/Upload/metadata/CorrespondenceID = corrid
	* def repository = 'Business Operations'
	* def sourcesystem = 'CDIS'
	* def contract = 'DocumentInbound'
	* def xsi_type = '&quot;#(contract)&quot'
	* set corrospondenceid/Envelope/Body/Upload/repository = repository
	* set corrospondenceid/Envelope/Body/Upload/sourceSystem = sourcesystem
	* set corrospondenceid/Envelope/Body/Upload/metadata = contract
	Given request read('../data/upload_DocumentInbound.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/Upload'
	Then status 200	
	

Scenario: Get uploaded document using GetByDocumentId
	* def GetByDocumentId = read('../data/GetByDocumentId.xml')
	* set GetByDocumentId/Envelope/Body/GetByDocumentId/documentId = docid
#	* print GetByDocumentId
	And header Authorization = "hcp " + token
	Given request read('../data/GetByDocumentId.xml')
	When soap action 'https://www.capita.co.uk/TfL/docstore/IServiceSoap/GetByDocumentId'
	Then status 200	
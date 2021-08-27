function fn() {
  var env = karate.env;
  var token = karate.properties['token'];
  var DocumentID = karate.properties['DocumentID'];
  var CorrespondenceID = karate.properties['CorrespondenceID'];
  var DocIDNotExist = karate.properties['DocIDNotExist'];
  var CorrIDNotExist = karate.properties['CorrIDNotExist']; 
  
  var apidata = read('../data/apidata.json');
  var rootdirectory = apidata[env] ["rootDirectory"];
  var common_path = apidata[env]["common_path"];
  var source_system1 = apidata[env]["source_system1"];
  var source_system2 = apidata[env]["source_system2"];
  var maximum_char = apidata[env]["maximum_char"];
  var beyond_maximum_char = apidata[env]["beyond_maximum_char"];
  var path1 = common_path+'/'+DocumentID;
  var path2 = common_path+source_system1+CorrespondenceID;
  var InvalidService = common_path+'/EPT1/'+CorrespondenceID;
  var path4 = common_path+source_system2+DocumentID;
  var path5 = common_path+source_system1+source_system2+CorrespondenceID;
  var RelDocIDNotExist= common_path+source_system2+DocIDNotExist;
  var RelCorIDNotExist= common_path+source_system1+source_system2+CorrIDNotExist;
  
  var InvalidRelatedCorrespondenceIDPath= common_path+'12'+source_system1+source_system2+CorrespondenceID;
  var InvalidRelatedService = common_path+source_system2+CorrespondenceID;
  var config = { 
		token: token,		
		DocumentID: DocumentID,
		common_path: common_path,
		CorrespondenceID: CorrespondenceID,
		baseurl: apidata[env]["url"],
		source_system2: source_system2,
		InvalidDocumentIDPath: common_path+'12/'+DocumentID,
		InvalidCorrespondenceIDPath: common_path+'12'+source_system1+CorrespondenceID,
		InvalidService: InvalidService,
		InvalidRelatedDocumentIDPath: common_path+'12'+source_system2+DocumentID,
		InvalidRelatedCorrespondenceIDPath: InvalidRelatedCorrespondenceIDPath,
		InvalidRelatedService: InvalidRelatedService,
		MaximumLimitDocumentID: common_path+'/'+maximum_char,
		beyond_maximum_charDocumentID: common_path+'/'+beyond_maximum_char,
		MaximumLimitCorrespondenceID: common_path+source_system1+maximum_char,
		beyond_maximum_charCorrespondenceID: common_path+source_system1+beyond_maximum_char,
		RelDocIDNotExist: RelDocIDNotExist,
		RelCorIDNotExist: RelCorIDNotExist,
	    path1: path1,
	    path2: path2,
	    path4: path4,
	    path5: path5
  };
   // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);
  return config;
}
function fn() {
  var env = karate.env;
  var token = karate.properties['token'];  
  var apidata = read('../data/apidata.json');
  var rootdirectory = apidata[env] ["rootDirectory"];
  var common_path = apidata[env]["common_path"];
  var source_system1 = apidata[env]["source_system1"];
  var source_system2 = apidata[env]["source_system2"];
    var corrid = "";
  var possible = "abcdefghijklmnopqrst123456789";  
  for (var i = 0; i < 6; i++)
     corrid += possible.charAt(Math.floor(Math.random() * possible.length));
  
 
  var config = { 
		token: token,
	    corrid: corrid,		
		source_system1: source_system1,
		common_path: common_path,
		baseurl: apidata[env]["url"],
		source_system2: source_system2,
  };
   // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);
  return config;
}
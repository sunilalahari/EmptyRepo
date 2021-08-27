function fn() {
  var env = karate.env;
  var token = karate.properties['token'];  
  var corrid = "";
  var possible = "abcdefghijklmnopqrst123456789";
  var env = karate.properties['karate.env'];
  var apidata = read('../data/apidata.json');  
  for (var i = 0; i < 6; i++)
     corrid += possible.charAt(Math.floor(Math.random() * possible.length));
  
 
  var config = {
		baseurl: apidata[env]["url"],
		token: token,
		corrid: corrid,
        	
  };
   // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);
  return config;
}
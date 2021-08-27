package SOAPtests

import scala.collection.JavaConverters._
import com.intuit.karate.gatling.PreDef._ 
import io.gatling.core.Predef._
import scala.concurrent.duration._

class UserSimulation extends Simulation {
    val token = "hcp "+ System.getProperty("token")
    val environment = System.getProperty("env")
    val user = System.getProperty("user")
    val rsp = System.getProperty("rsp")
    val time = System.getProperty("time")
	val duration = System.getProperty("duration")
    System.setProperty("karate.env", environment)
	System.setProperty("karate.token", token)
		
	val request = System.getProperty("request")
    System.setProperty("karate.request", request)
    
   if (request=="upload") {   
      val GetUser = scenario(scenarioName = "Upload Document").exec(karateFeature( name = "classpath:SOAPtests/Upload_DocumentInbound_gatling.feature" ))
      setUp(
        GetUser.inject(
        constantConcurrentUsers(Integer.parseInt(user)) during (Integer.parseInt(duration) minutes))
      )
   } else if (request=="get") {
     val GetUser = scenario(scenarioName = "Get uploaded document using GetByDocumentId").exec(karateFeature( name = "classpath:SOAPtests/Upload_DocumentInbound_gatling.feature" ))
     setUp(
        GetUser.inject(
        constantConcurrentUsers(Integer.parseInt(user)) during (Integer.parseInt(duration) minutes))
      )
   }
}
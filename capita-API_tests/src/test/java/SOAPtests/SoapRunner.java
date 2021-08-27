//ackage SOAPtests.soap;
package SOAPtests;
import com.intuit.karate.KarateOptions;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import cucumber.api.CucumberOptions;
import static org.junit.Assert.*;
import org.junit.Test;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import java.io.File;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import org.apache.commons.io.FileUtils;
import org.joda.time.LocalDate;
import com.intuit.karate.junit4.Karate;
import org.junit.runner.RunWith;

/**
 * @author achavan
 * This class is to run the API test cases parallel and generate the cucumber reports 
 */
public class SoapRunner {
	/**
	 * This function is to run the API test script parallel
	 * @throws ParseException 
	 */
	@Test
    public void testParallel() throws ParseException {
		String environment=System.getProperty("env");
		String token= System.getProperty("token");
		System.setProperty("karate.env", environment);
		System.setProperty("karate.token", token);
        Results results = Runner.parallel(getClass(),1);
        generateReport(results.getReportDir());
        System.out.println("Directory"+results.getReportDir());
        assertTrue(results.getErrorMessages(), results.getFailCount() == 0);     
    }	
	/**
     * This function is to generate the cucumber reports on report directory 'target'
     * @param karateOutputPath  location of the reports,
     */
    public static void generateReport(String karateOutputPath) {        
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] {"json"}, true);
        List<String> jsonPaths = new ArrayList<String>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "capita-API_UI_tests");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();        
    }
}

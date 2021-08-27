package RestAPItests;

import static org.junit.Assert.assertTrue;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.joda.time.LocalDate;
import org.junit.Test;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;

import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

public class RestAPIrunner {

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
		Long datetime= new Date().getTime();
		System.setProperty("datetime", datetime.toString());
			
		Long datetime1= datetime + 100;
		System.setProperty("datetime1", datetime1.toString());
		
		//current date
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String todays_date = dateFormat.format(date);

        //feature_retention_date
        String future_retention_date = LocalDate.parse(todays_date).plusDays(10).toString();
        System.setProperty("future_retention_date", future_retention_date);
        //expired_retention_date
        String expired_retention_date = LocalDate.parse(todays_date).minusDays(10).toString();
        System.setProperty("expired_retention_date", expired_retention_date);
        
        //feature_retention_date response header
        SimpleDateFormat sdfmt1 = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdfmt2= new SimpleDateFormat("MM/dd/yyyy KK:mm:ss");																																								
		java.util.Date dDate = sdfmt1.parse(future_retention_date);
		String future_retention_date_header = sdfmt2.format( dDate );
		System.setProperty("future_retention_date_header", future_retention_date_header);
		
		//expired_retention_date response header
        SimpleDateFormat sdfmt3 = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdfmt4= new SimpleDateFormat("MM/dd/yyyy KK:mm:ss");																																								
		java.util.Date dDate1 = sdfmt3.parse(expired_retention_date);
		String expired_retention_date_header = sdfmt4.format( dDate1 );
		System.setProperty("expired_retention_date_header", expired_retention_date_header);

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

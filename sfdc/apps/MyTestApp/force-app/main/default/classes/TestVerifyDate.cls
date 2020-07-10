@isTest
public class TestVerifyDate {
    
    @isTest static void TestDatePast(){
        Date todayDate = Date.today();
        Date pastDate = todayDate.addDays(-1);
        Date dateResult = VerifyDate.CheckDates(todayDate, pastDate);
        System.debug('The result is: ' + dateResult);
        System.assert(dateResult > todayDate);
    }    
    
    @isTest static void TestDateFuture(){
        Date testDate = Date.today();
        Date payDate = testDate.addDays(15);
        Date dateResult = VerifyDate.CheckDates(testDate, payDate);
        System.debug('The result is: ' +dateResult);
        System.assert(dateResult == payDate);
    }
  
}

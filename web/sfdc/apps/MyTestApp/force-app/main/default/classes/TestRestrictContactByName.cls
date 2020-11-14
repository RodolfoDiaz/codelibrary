@isTest
public class TestRestrictContactByName {
    
    @isTest static void TestUpsert(){
        // Test data setup
        Contact cnt = new Contact(FirstName='Rodolfo',LastName='INVALIDNAME');
        
        // Perform test
        // -- The test method contains the Test.startTest() and Test.stopTest() method pair, which delimits a block of code that gets a fresh set of governor limits. 
        //Test.startTest();
        Database.UpsertResult result = Database.upsert(cnt, false);
        //Test.stopTest();
        
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        String v1 = 'The Last Name "INVALIDNAME" is not allowed for DML';
        System.assertEquals(v1, result.getErrors()[0].getMessage());
    }
}

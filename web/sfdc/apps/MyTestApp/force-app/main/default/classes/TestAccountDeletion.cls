@isTest
private class TestAccountDeletion {
    @isTest static void TestDeleteAccountWithOneOpportunity() {
        // Test data setup
        // Create an account with an opportunity, and then try to delete it
        /*
          Account acct = new Account(Name='Test Account');
          insert acct;
          Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                        StageName='Prospecting',
                                        CloseDate=System.today().addMonths(1),
                                        AccountId=acct.Id);
          insert opp;
        */
        Account[] accts = TestDataFactory.createAccountsWithOpps(1,1);
        
        // Perform test
        Test.startTest();
        Database.DeleteResult result = Database.delete(accts[0], false);
        Test.stopTest();
        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Cannot delete account with related opportunities.',
                             result.getErrors()[0].getMessage());
    }

    @isTest static void TestDeleteAccountWithNoOpportunities() {
      // Test data setup
      // Create one account with no opportunities by calling a utility method
      Account[] accts = TestDataFactory.createAccountsWithOpps(1,0);
      
      // Perform test
      Test.startTest();
      Database.DeleteResult result = Database.delete(accts[0], false);
      Test.stopTest();
      // Verify that the deletion was successful
      System.assert(result.isSuccess());
  }
  
  @isTest static void TestDeleteBulkAccountsWithOneOpportunity() {
      // Test data setup
      // Create accounts with one opportunity each by calling a utility method
      Account[] accts = TestDataFactory.createAccountsWithOpps(200,1);
      
      // Perform test
      Test.startTest();
      Database.DeleteResult[] results = Database.delete(accts, false);
      Test.stopTest();
      // Verify for each record.
      // In this case the deletion should have been stopped by the trigger,
      // so check that we got back an error.
      for(Database.DeleteResult dr : results) {
          System.assert(!dr.isSuccess());
          System.assert(dr.getErrors().size() > 0);
          System.assertEquals('Cannot delete account with related opportunities.',
                               dr.getErrors()[0].getMessage());
      }
  }
  
  @isTest static void TestDeleteBulkAccountsWithNoOpportunities() {
      // Test data setup
      // Create accounts with no opportunities by calling a utility method
      Account[] accts = TestDataFactory.createAccountsWithOpps(200,0);
      
      // Perform test
      Test.startTest();
      Database.DeleteResult[] results = Database.delete(accts, false);
      Test.stopTest();
      // For each record, verify that the deletion was successful
      for(Database.DeleteResult dr : results) {
          System.assert(dr.isSuccess());
      }
  }
    
}

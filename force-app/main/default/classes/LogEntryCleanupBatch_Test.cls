@isTest
Public class LogEntryCleanupBatch_Test {
	@isTest
    static void execute_test() {    
           
        Log_Entry__c logs = new Log_Entry__c();
        List<Log_Entry__c> logsList = new List<Log_Entry__c>(); 
        
        logs.Context__c = 'test';
        logsList.add(logs);
        Database.Insert(logsList);
        
        Test.startTest();  
        Database.BatchableContext bc;
        LogEntryCleanupBatch batch = new LogEntryCleanupBatch();
        batch.start(bc);
        batch.execute(bc, logsList);
        batch.finish(bc); 
        Test.stopTest();
       
    }    
    
}
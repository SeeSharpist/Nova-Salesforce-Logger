/**
 * @description Unit test covering LogEntryCleanupBatch
 * @group Logger
 */
@isTest
public class LogEntryCleanupBatch_Test {
    /*
     * @description Test to ensure logs are appropriately cleaned up
     */
	@isTest
    public static void executeSuccessful() {    
        Test.startTest();
        // create some test logs
        Logger.info('LogEntryCleanupBatch_Test', 'Test for batch!');
        Logger.warn('LogEntryCleanupBatch_Test', 'Test for batch!');
        Logger.error('LogEntryCleanupBatch_Test', 'Test for batch!');
        Test.stopTest();
        
        // set time stamp back so they will be picked up by the batch
        List<Log_Entry__c> logsList = [SELECT Id FROM Log_Entry__c];
        DateTime old = DateTime.now().addDays(-31);
        for(Log_Entry__c entry: logsList){
            entry.Time_Stamp__c = old;
        }
        update logsList;
        
        // run the batch
        Database.BatchableContext bc;
        LogEntryCleanupBatch batch = new LogEntryCleanupBatch();
        batch.start(bc);
        batch.execute(bc, logsList);
        batch.finish(bc); 
        
        // repull what should be an empty list now
        logsList = [SELECT Id, Logging_Level__c FROM Log_Entry__c];
        System.assertEquals(0, logsList.size(), 'The batch should have deleted all logs, but was ' + logsList.size());
    }    
    
}
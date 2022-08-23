/**
 * @description Batch class to clean up old Log Entry records
 * @group Logger
 */
public with sharing class LogEntryCleanupBatch implements Database.Batchable<sObject> {
    /** Metadata Record containing the number of days into the past to delete logs from */
    private static Application_Configuration__mdt logRetentionConfig = Application_Configuration__mdt.getInstance('Log_Retention_Duration');
    /** Local count of all events deleted in the batches run */ 
    private static integer logCount = 0;
    /** 
	* @description Setup the collection of objects to be processed
	* @param bc (Database.BatchableContext) : Current batch context
	*/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id FROM Log_Entry__c WHERE Time_Stamp__c < LAST_N_DAYS:' + (logRetentionConfig != null ? String.valueOf(logRetentionConfig.Value__c) : '30');
        return Database.getQueryLocator(query);
    }
    /** 
	* @description Delete the given batch of Log Entry records
	* @param bc (Database.BatchableContext) : Current batch context
	* param logs (List<Log_Entry__c>) : The list of Log Event records passed into the batch context for processing
	*/
    public void execute(Database.BatchableContext bc, List<Log_Entry__c> logs) {
        // process collection of records and execute any logic to modify
        try {
            logCount += logs.size();
            Database.delete(logs);
        } catch(Exception e) {
            Logger.exception('LogEntryCleanupBatch', e);
        }
    }
    /**
	* @description Execute any post-processing operations
    * @param bc (Database.BatchableContext) : Current batch context
	*/
    public void finish(Database.BatchableContext bc) {
        Logger.info('LogEntryCleanupBatch', 'LogEntryCleanupBatch job completed! ' + logCount + ' logs purged.');
    }
    
}
/**
 * @description Batch class to clean up old Log Entry records
 */
global class LogEntryCleanupBatch implements Database.Batchable<sObject> {
    /** Metadata Record containing the number of days into the past to delete logs from */
    global static Application_Configuration__mdt logRetentionConfig = Application_Configuration__mdt.getInstance('Log_Retention_Duration');
    /** Local count of all events deleted in the batches run */ 
    private static integer logCount = 0;
    // Setup the collection of objects to be processed 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Log_Entry__c WHERE CreatedDate < LAST_N_DAYS:' + logRetentionConfig != null ? logRetentionConfig.Value__c : '30';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Log_Entry__c> logs) {
        // process collection of records and execute any logic to modify
        try {
            logCount += logs.size();
            Database.delete(logs);
        } catch(Exception e) {
            Logger.exception('LogEntryCleanupBatch', e);
        }
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
        Logger.info('LogEntryCleanupBatch', 'LogEntryCleanupBatch job completed! ' + logCount + ' logs purged.');
    }
    
}
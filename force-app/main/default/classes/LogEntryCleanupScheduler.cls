/**
 * @description Scheduleable class to clean up old Log Entry records on a set cadence
 */
global class LogEntryCleanupScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        LogEntryCleanupBatch deleteLogs = new LogEntryCleanupBatch();
        Id batchId = Database.executeBatch(deleteLogs, 2000);
 }
}
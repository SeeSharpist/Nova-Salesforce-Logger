trigger LogEntryEventTrigger on Log_Entry_Event__e (after insert) {
	List<Log_Entry__c> logs = new List<Log_Entry__c>();
    for(Log_Entry_Event__e event : trigger.new){
        Log_Entry__c log = new Log_Entry__c(Context__c = event.Context__c,
                                                Message__c = event.Message__c,
                                                Logging_Level__c = event.Logging_Level__c,
                                                Is_Error__c = event.Logging_Level__c == String.valueOf(LoggingLevel.ERROR),
                                                Is_Exception__c = String.isNotBlank(event.Stack_Trace__c),
                                                Stack_Trace__c = event.Stack_Trace__c,
                                                Context_User__c = event.User_Id__c,
                                                Time_Stamp__c = event.Time_Stamp__c);
        
        logs.add(log);
    }
    insert logs;
}
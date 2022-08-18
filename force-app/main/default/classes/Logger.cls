/**
 * @description Global class to durably log events and exception data
 */
global class Logger {
    /** standard exception data format string  */
    private static final String EXCEPTION_STACK_TRACE_MESSAGE = '[EXCEPTION TYPE]: {0} | [LINE NUMBER]: {1} | [STACK TRACE]: {2}';
    
    /**
     * @description Generate DEBUG level log without creating a log entry record
     * @param context (String): The apex class or process the event is being generated from
     * @param message (String): The message being logged 
     */
    global static void debug(String context, String message){
        publishLogEntryEvent(LoggingLevel.DEBUG, context, message);
    }
    
    /**
     * @description Generate INFO level log with a log entry event record
     * @param context (String): The apex class or process the event is being generated from
     * @param message (String): The message being logged 
     */
    global static void info(String context, String message){
        publishLogEntryEvent(LoggingLevel.INFO, context, message);
    }
    
    /**
     * @description Generate WARN level log with a log entry event record
     * @param context (String): The apex class or process the event is being generated from
     * @param message (String): The message being logged 
     */
    global static void warn(string context, string message){
        publishLogEntryEvent(LoggingLevel.WARN, context, message);
    }
    
    /**
     * @description Generate ERROR level log with a log entry event record. Use for non-exception error cases
     * @param context (String): The apex class or process the event is being generated from
     * @param message (String): The message being logged 
     */
    global static void error(String context, String message){
        publishLogEntryEvent(LoggingLevel.ERROR, context, message);
    }
    
    /**
     * @description Generate ERROR level exception log with a log entry event record and formatted exception data. Use in cases an explicit exception has been raised
     * @param context (String): The apex class or process the event is being generated from
     * @param message (String): The message being logged 
     */
    global static void exception(string context, Exception e){
        publishLogEntryEventBase(LoggingLevel.ERROR, context , '', e);
    }
    
    /**
     * @description Base method used to log non exception events
     * @param level (String): The apex LoggingLevel enum value, determining what type of log is published
     * @param context (String): The apex class or process the event is being generated from
     * @param message (String): The message being logged 
     */
    private static void publishLogEntryEvent(LoggingLevel level, string context, string message){
        publishLogEntryEventBase(level, context, message, null);
    }
    
    /**
     * @description Base method used to log explicit exception events
     * @param level (String): The apex LoggingLevel enum value, determining what type of log is published
     * @param context (String): The apex class or process the event is being generated from
     * @param message (String): The message being logged
     * @param e (Exception): The exception instance raised
     */
    private static void publishLogEntryEventBase(LoggingLevel level, string context, string message, Exception e){
        // instantiate log event
        Log_Entry_Event__e log = new Log_Entry_Event__e(Logging_Level__c = String.valueOf(level),
                                                Context__c = context,
                                                Message__c = e == null ? message : e.getMessage(),
                                                Stack_Trace__c = e == null ? '' : getFormattedExceptionStackTrace(e),
                                                User_Id__c = UserInfo.getUserId(),
                                                Time_Stamp__c = DateTime.now());
		// debug log each time
        System.debug(LoggingLevel.DEBUG, log);
        // publish log event unless the LoggingLevel is DEBUG
        if(level != LoggingLevel.DEBUG){
            EventBus.publish(log);
        }
    }
    
    /**
     * @description Base method used to log explicit exception events
     * @param e (Exception): The exception instance raised
     * @returns String formatted with exception data
     */
    private static String getFormattedExceptionStackTrace(Exception e){
        return String.format(EXCEPTION_STACK_TRACE_MESSAGE, new List<String>{e.getTypeName(), String.valueOf(e.getLineNumber()), e.getStackTraceString()});
    }
}
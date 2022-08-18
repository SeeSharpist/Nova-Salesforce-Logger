@isTest
public class Logger_Test {
    @isTest
    public static void debug_noLogEntry(){
        string testString = 'debug-test123';
        Test.startTest();
            Logger.debug('Logger_Test', testString);
        Test.stopTest();
        List<Log_Entry__c> logs = [SELECT Id FROM Log_Entry__c];
        System.assert(logs.isEmpty(), 'Should not have been any log entry records inserted.');
    }
	@isTest
    public static void info_singleLogEntry(){
        string testString = 'info-test123';
        Test.startTest();
            Logger.info('Logger_Test', testString);
        Test.stopTest();
        Log_Entry__c log = [SELECT Id, Logging_Level__c, Context__c, Message__c FROM Log_Entry__c LIMIT 1];
        System.assertEquals(LoggingLevel.INFO, LoggingLevel.valueOf(log.Logging_Level__c));
        System.assertEquals('Logger_Test', log.Context__c);
        System.assertEquals(testString, log.Message__c);
    }
    @isTest
    public static void warn_singleLogEntry(){
        string testString = 'warn-test123';
        Test.startTest();
            Logger.warn('Logger_Test', testString);
        Test.stopTest();
        Log_Entry__c log = [SELECT Id, Logging_Level__c, Context__c, Message__c FROM Log_Entry__c LIMIT 1];
        System.assertEquals(LoggingLevel.WARN, LoggingLevel.valueOf(log.Logging_Level__c));
        System.assertEquals('Logger_Test', log.Context__c);
        System.assertEquals(testString, log.Message__c);
    }
    @isTest
    public static void error_singleLogEntry(){        
        string testString = 'error-test123';
        Test.startTest();
            Logger.error('Logger_Test', testString);
        Test.stopTest();
        Log_Entry__c log = [SELECT Id, Logging_Level__c, Context__c, Message__c, Is_Error__c FROM Log_Entry__c LIMIT 1];
        System.assertEquals(LoggingLevel.ERROR, LoggingLevel.valueOf(log.Logging_Level__c));
        System.assertEquals('Logger_Test', log.Context__c);
        System.assertEquals(testString, log.Message__c);
        System.assert(log.Is_Error__c);
    }
    @isTest
    public static void exception_singleLogEntry(){        
        string testString = 'exception-test123';
        Test.startTest();
        try{
            throw new LoggerTestException(testString);
        }catch(LoggerTestException e){
            Logger.Exception('Logger_Test', e);
        }
        Test.stopTest();
        Log_Entry__c log = [SELECT Id, Logging_Level__c, Context__c, Message__c, Is_Error__c, Stack_Trace__c FROM Log_Entry__c LIMIT 1];
        System.assertEquals(LoggingLevel.ERROR, LoggingLevel.valueOf(log.Logging_Level__c));
        System.assertEquals('Logger_Test', log.Context__c);
        System.assertEquals(testString, log.Message__c);
        System.assert(log.Is_Error__c);
        System.assert(log.Stack_Trace__c != null);
    }

    public class LoggerTestException extends Exception { }
}
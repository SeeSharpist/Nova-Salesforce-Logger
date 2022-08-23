/**
 * @description Unit test covering LogEntryCleanupScheduler
 * @group Logger
 */
@isTest
public class LogEntryCleanupScheduler_Test {
    @isTest 
    public static void scheduleSuccessful(){
		Test.startTest();
        String cronExp = '0 0 23 * * ?';
        String jobId = System.schedule('Test', cronExp, new LogEntryCleanupScheduler());
		    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(cronExp, ct.CronExpression, 'Cron Expression mismatch.');
        System.assertEquals(0, ct.TimesTriggered, 'Should schedule but not trigger.');
        Test.stopTest();
	}
}
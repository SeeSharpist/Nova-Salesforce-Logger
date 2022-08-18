@isTest
private class LogEntryCleanupScheduler_Test {
    @isTest static void execute_scheduled(){
		Test.startTest();
        LogEntryCleanupScheduler syncMe = new LogEntryCleanupScheduler();
        String cronExp = '0 0 23 * * ?';
        System.schedule('Test', cronExp, syncMe);
        Test.stopTest();
	}
}
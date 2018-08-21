@isTest (seeAllData = true)
private class AutoCheckOutTestClass {
	@isTest
    public static void testScheduleApex()
    {
        Attendance__c a = new Attendance__c();
        a.Name = 'Test';
        a.Attendance_Date__c = Date.today();
        insert a;
        
        test.startTest();
        AutoCheckOut aco = new AutoCheckOut();
        Id  jobId = System.schedule('TestClass', '0 0 * * * ?', aco);
        
        test.stopTest();
    }
    
}
@isTest
private class InsertProcessAnswerInPostTest {
    @isTest
    private static void testTrigger()
    {
        ProcessAnswer__c p = new ProcessAnswer__c();
        //p.name = 'Test';
        insert p;
    }
}
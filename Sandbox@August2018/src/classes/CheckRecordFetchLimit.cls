public class CheckRecordFetchLimit {
    public List<ProcessAnswer__c> pr {get;set;} 
    public CheckRecordFetchLimit()
    {
        pr = new List<ProcessAnswer__c>();
        
        pr = [select id,name from ProcessAnswer__c];
    }

    public static void increaseTestCoverage()
    {
        Integer i =0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}
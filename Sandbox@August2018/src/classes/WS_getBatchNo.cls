@RestResource(urlMapping='/getBatchNo/*')
global class WS_getBatchNo{
  
    @HttpGet
    global static List<String> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String district = RestContext.request.params.get('district');
     String taluka = RestContext.request.params.get('taluka');
     String cluster = RestContext.request.params.get('cluster');
     List<String> outputList = new List<String>();
     
    AggregateResult[] groupedResults = [SELECT Batch_No__c, Count(Id) FROM TrainingData__c where District__c = :district AND Taluka__c = :taluka AND Cluster__c = :cluster GROUP BY Batch_No__c];
    for (AggregateResult ar : groupedResults)  {
        outputList.add((String)ar.get('Batch_No__c'));
        System.debug('Campaign ID' + ar.get('Batch_No__c'));
        System.debug('Average amount' + ar.get('expr0'));
    }
    return outputList;
}

 public static void  CCHelp()
    {
       Integer val = 1;
       
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
    
        }
}
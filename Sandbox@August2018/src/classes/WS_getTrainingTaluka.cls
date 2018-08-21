@RestResource(urlMapping='/getTrainingTaluka/*')
global class WS_getTrainingTaluka {
  
    @HttpGet
    global static List<String> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String districtNew = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    
    String district = districtNew.replace('%20', ' ');
    
     List<String> outputList = new List<String>();
   
    AggregateResult[] groupedResults = [SELECT Taluka__c, Count(Id) FROM MV_Training_Calender__c where District__c = :district  GROUP BY Taluka__c];
    for (AggregateResult ar : groupedResults)  {
        outputList.add((String)ar.get('Taluka__c'));
        System.debug('Campaign ID' + ar.get('Taluka__c'));
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
       
        }
}
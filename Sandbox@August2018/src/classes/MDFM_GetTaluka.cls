@RestResource(urlMapping='/MDFMGetTaluka/*')
global class MDFM_GetTaluka {
    @HttpGet
    global static List<String> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    List<String> outputList = new List<String>();
    String district = RestContext.request.params.get('district');
        
    AggregateResult[] groupedResults = [SELECT Taluka__c, Count(Id) FROM MDFM_Location__c where District__c =:district GROUP BY Taluka__c];
    for (AggregateResult ar : groupedResults)  {
        outputList.add((String)ar.get('Taluka__c'));
        System.debug('Campaign ID' + ar.get('Taluka__c'));
        System.debug('Average amount' + ar.get('expr0'));
    }
    return outputList;
}

}
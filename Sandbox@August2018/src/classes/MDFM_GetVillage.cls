@RestResource(urlMapping='/MDFMgetVillage/*')
global class MDFM_GetVillage {
    @HttpGet
    global static List<String> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String district = RestContext.request.params.get('district');
    String taluka = RestContext.request.params.get('taluka');
    List<String> outputList = new List<String>();
     
    AggregateResult[] groupedResults = [SELECT Village__c, Count(Id) FROM MDFM_Location__c where District__c = :district AND Taluka__c = :taluka GROUP BY Village__c];
    for (AggregateResult ar : groupedResults)  {
        outputList.add((String)ar.get('Village__c'));
        System.debug('Campaign ID' + ar.get('Village__c'));
        System.debug('Average amount' + ar.get('expr0'));
    }
    return outputList;
}
}
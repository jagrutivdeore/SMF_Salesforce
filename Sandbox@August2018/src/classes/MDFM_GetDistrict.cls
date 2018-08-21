@RestResource(urlMapping='/MDFMGetDistrict/*')
global class MDFM_GetDistrict {
      @HttpGet
    global static List<String> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    List<String> outputList = new List<String>();
     
    AggregateResult[] groupedResults = [SELECT District__c, Count(Id) FROM MDFM_Location__c GROUP BY District__c];
    for (AggregateResult ar : groupedResults)  {
        outputList.add((String)ar.get('District__c'));
        System.debug('Campaign ID' + ar.get('District__c'));
        System.debug('Average amount' + ar.get('expr0'));
    }
    return outputList;
}

}
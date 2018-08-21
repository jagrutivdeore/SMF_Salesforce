@RestResource(urlMapping='/MDFMgetAllLocation/*')
global class MDFMGetAllLocation {

    @HttpGet
    global static List<location_data> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
   
      List<location_data> outputList = new List<location_data>();
    
        List<MDFM_Location__c> groupedResults = [SELECT Id,State__c,District__c,Taluka__c,Village__c,isShramdan_Completed__c,createdDate from MDFM_Location__c];
     
   for (MDFM_Location__c ar : groupedResults)  {
       location_data data = new location_data ();
       data.State = (String)ar.State__c;
       data.District = (String)ar.District__c;
       data.Taluka = (String)ar.Taluka__c;
       data.Village = (String)ar.Village__c;
       data.Id= (String)ar.Id;
       data.createdDate =  String.valueOfGMT(ar.createdDate);
       outputList.add(data );
   }
     
    return outputList;
    
    }
    
    global class location_data{
    String Id;
    public String State;
    String District;
    String Taluka;
    String Village;
    String createdDate;
    }
    
    
}
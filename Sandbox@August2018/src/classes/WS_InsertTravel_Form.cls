@RestResource(urlMapping='/InsertTravel_Form/*')
global class WS_InsertTravel_Form {
    
    @HttpPost
    global static void InsertDaily_Travel_Meter_Reading(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);

        List<Travel_Form__c> compostPitsList = mCompostPits.listtaskanswerlist;
        
        try{
              Database.UpsertResult[] srList = Database.upsert(compostPitsList,true);
                mapResponse.put('Records', compostPitsList);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));

        }catch(Exception e){

            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
    }
    
   global class CompostPits{
        public list<Travel_Form__c> listtaskanswerlist {get;set;}
    }

}
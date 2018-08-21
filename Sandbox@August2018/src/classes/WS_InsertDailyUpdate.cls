@RestResource(urlMapping='/InsertDailyUpdate/*')
global class WS_InsertDailyUpdate {
    
    @HttpPost
    global static void InsertDailyUpdate(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);

        List<DailyUpdate__c> compostPitsList = mCompostPits.listtaskanswerlist;
        
        try{
              Database.UpsertResult[] srList = Database.upsert(compostPitsList,true);
                mapResponse.put('Records', compostPitsList);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));

        }catch(Exception e){

            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
    }
    
   global class CompostPits{
        public list<DailyUpdate__c> listtaskanswerlist {get;set;}
    }

}
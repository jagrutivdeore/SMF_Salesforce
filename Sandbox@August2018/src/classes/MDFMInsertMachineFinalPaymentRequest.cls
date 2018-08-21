@RestResource(urlMapping='/MDFMInsertMachineFinalPaymentRequest/*')
global class MDFMInsertMachineFinalPaymentRequest {
    
    @HttpPost
    global static void InsertMachineAdvancePaymentRequest(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);

        List<Machine_Final_Payment_Request__c> compostPitsList = mCompostPits.listtaskanswerlist;
        
        try{
              Database.UpsertResult[] srList = Database.upsert(compostPitsList,true);
                mapResponse.put('Records', compostPitsList);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));

        }catch(Exception e){

            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
    }
    
   global class CompostPits{
        public list<Machine_Final_Payment_Request__c> listtaskanswerlist {get;set;}
    }

}
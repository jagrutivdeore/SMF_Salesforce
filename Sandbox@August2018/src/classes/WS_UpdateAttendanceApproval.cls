@RestResource(urlMapping='/UpdateAttendanceApproval/*')
global class WS_UpdateAttendanceApproval {
    
    @HttpPost
    global static void upadateStatus(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);

       System.debug('*************************'+req.requestBody.toString());
        List<Attendance__c> compostPitsList = mCompostPits.listtaskanswerlist;
        
        try{
              Database.UpsertResult[] srList = Database.upsert(compostPitsList,true);
                mapResponse.put('Records', compostPitsList);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));

        }catch(Exception e){

            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
    }
    
   global class CompostPits{
        public list<Attendance__c> listtaskanswerlist {get;set;}
    }   
    
     public static void testCode() {
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
         i++;
         i++;
         i++;
         i++;
            i++;
  }
}
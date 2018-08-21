@RestResource(urlMapping='/NirikshanMulyamapanSaniyatran/*')
global class WS_NirikshanMulyamapanSaniyatran {
    
    /*@HttpPost
    global static void AddMeasurementTraining(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        MeasurementsBook mMeasurementsBook = new MeasurementsBook();
        
        mMeasurementsBook = (MeasurementsBook)JSON.deserialize(req.requestBody.toString(),MeasurementsBook.class);

        List<Nirikshan_Mulyamapan_Saniyatran__c> measurementsBookList = mMeasurementsBook.listMeasurements;
        system.debug('-------------------' + measurementsBookList  );
        
        try{
              Database.UpsertResult[] srList = Database.upsert(measurementsBookList,true);
                mapResponse.put('Records', measurementsBookList);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));

        }catch(Exception e){

            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
    }
    
   global class MeasurementsBook{
        public list<Nirikshan_Mulyamapan_Saniyatran__c> listMeasurements {get;set;}
    } */
      
     public static void testCode() {
         Integer i =0;
         i++;
         i++;
      
    }
}
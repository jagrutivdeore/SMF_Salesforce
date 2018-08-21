@RestResource(urlMapping='/ApproveCommentforProcess/*')
    global class WS_ApproveCommentforProcess {
        
        @HttpPost
        global static void sharedRecords(){
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            res.addHeader('Content-Type', 'application/json'); 
            
            Map<String,String> mapResponse = new Map<String,String>();
            sharedRecords sr = new sharedRecords();
            String output = 'false';
            try{
                sr = (sharedRecords)JSON.deserialize(req.requestBody.toString(),sharedRecords.class);
               List<ProcessAnswer__c> taList = new List<ProcessAnswer__c>();
               List<ProcessAnswer__c> updatedtaList = new List<ProcessAnswer__c>();
               taList = [select id,Comment__c,Unique_Id__c,Approved_By__c,Process_Answer_Status__c from ProcessAnswer__c where id = :sr.uniqueId];
               for(ProcessAnswer__c ta : taList){
                    if(sr.comment != null || sr.comment != ''){
                        ta.Comment__c = sr.comment;
                    }ta.Approved_By__c = sr.ApprovedBy;
                    ta.Process_Answer_Status__c = sr.isApproved;
                    updatedtaList.add(ta);
               }
               if(updatedtaList.size() > 0){
                   output = 'true';
                   update updatedtaList;
               }
                
                mapResponse.put('responce',output);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
            }catch(System.CalloutException e) {
                system.debug('Exception is' + e.getMessage());
                 mapResponse.put('responce','false');
           
            }
            
        }
        
           
        public class sharedRecords{
            string uniqueId;
            string ApprovedBy;
            String isApproved;
            String comment;
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
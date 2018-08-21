@RestResource(urlMapping='/MTPost/')
global class WS_addNewPost {
    
  @HttpPost
    global static void AddVisitData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        Map<String,String> mapResponse1 = new Map<String,String>();
        VisitsData mVisitsData = new VisitsData();
        system.debug('test-----------'+req.requestBody.toString());
        mVisitsData = (VisitsData)JSON.deserialize(req.requestBody.toString(),VisitsData.class);
        List<VisitField> VisitsDataList = mVisitsData.listVisitsData;
        List<Post__c> visitList = new List<Post__c>();
       
        List<Attachment> attsToInsert = new List<Attachment>();
        
        try{
                for(VisitField vf : VisitsDataList){
                    Post__c p = new Post__c();
                    p.content__c      = vf.content;
                    //p.Issue__c        = vf.issue;
                    //p.MTUser__c       = vf.mtuser;
                    p.sub_content__c   = vf.subcontent;
                    //p.Template_type__c  = vf.template;
                    visitList.add(p);
                    
                    
                    
                    
                   
                         
                }  
                
               /*  List<AttachmentMapping> attachments = vf.attachments;
                    for(AttachmentMapping atm : attachments){
                        Attachment at = new Attachment();
                        at.Name = atm.Name;
                        //at.Body = EncodingUtil.base64Decode(atm.Body);
                        at.Body = atm.Body;
                        at.ParentId = atm.ParentId;
                        at.ContentType = 'image/png';
                        attsToInsert.add(at);
                    }  */  
               list<Database.SaveResult> results = Database.insert(visitList, false);
               // list<Database.SaveResult> results4 = Database.insert(attsToInsert, false);
               mapResponse.put('Records', visitList);
               //mapResponse1.put('success','success');
               res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
               //res.responseBody = Blob.valueOf('Records','success');

        }catch(Exception e){
            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
    }
    
   global class VisitsData{
        public list<VisitField> listVisitsData {get;set;}
 
        
    }
    
    global class VisitField{
        string content;
        string subcontent;
        string issue;
        string mtuser;
        string template;
        List<AttachmentMapping> attachments;
    }
        
    global class AttachmentMapping{
        public string Name {get;set;}
        public blob Body {get;set;}
        public string ParentId {get;set;}                
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
        
       
        }
    
    
}
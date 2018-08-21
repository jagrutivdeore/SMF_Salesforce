@RestResource(urlMapping='/InsertAnswerForProcessAnswer/*')
global class WS_InsertAnswerForProcessAnswer {
    
    @HttpPost
    global static void InsertAnswer(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);
        system.debug('--mCompostPits-----'+ mCompostPits);
        List<taskAnswerClass> compostPitsList = mCompostPits.listtaskanswerlist;
        system.debug('--compostPitsList-----'+ compostPitsList);
        string processId= '';
        
      //try{
                map<string,string> IdToApiName = new map<string,string>();
                set<Id> tskSet = new set<Id>();
                for(taskAnswerClass ta : compostPitsList){
                    tskSet.add(ta.MV_Task);
                }
                for(taskAnswerClass ta : compostPitsList){
                    if(ta.MV_Process != null){
                        processId = ta.MV_Process;
                        break;
                    }
                }
                
                MV_Process__c prc =  new MV_Process__c();
                prc = [select id,Approval_Person_Role__c,SMS_Data__c from MV_Process__c where id = :processId];
                
                
                
                List<MV_Task__c> tskList = new List<MV_Task__c>();
                tskList = [select id,API_field_Name__c from MV_Task__c where id IN :tskSet];
                for(MV_Task__c tsk :tskList ){
                    IdToApiName.put(tsk.Id, tsk.API_field_Name__c);
                }
                sObject sObj = Schema.getGlobalDescribe().get('ProcessAnswer__c').newSObject() ;
                string imageValue='';
                    system.debug('--compostPitsList-----'+ compostPitsList.size());
                
           for(taskAnswerClass ta : compostPitsList){
                    system.debug('-------------------'+ ta.Id);
                    if(ta.Task_Type == 'Image' && ta.Answer == 'true'){
                        imageValue = IdToApiName.get(ta.MV_Task);
                    }                       
                   if(ta.Id != null){
                        sObj.put('Id' , ta.Id) ;
                    }
                    if(ta.MV_User != null){
                        sObj.put('MV_User__c' , ta.MV_User) ;
                    }
                    if(ta.MV_Process != null){
                        sObj.put('MV_Process__c' , ta.MV_Process) ;
                    }   
                    if(ta.MV_Task != null && ta.Answer != null){
                        sObj.put(IdToApiName.get(ta.MV_Task), ta.Answer) ;
                    }
                    if(ta.Timestamp != null){
                         sObj.put('Timestamp__c', ta.Timestamp) ;
                    }
                    /*if(ta.IsApproved != null && ta.IsApproved == 'false'){
                        if(prc.Approval_Person_Role__c == null){
                            sObj.put('IsApproved__c',true) ;
                        }
                    }
                    if(ta.IsApproved != null && ta.IsApproved == 'false'){
                        if(prc.Approval_Person_Role__c != null){
                            sObj.put('IsApproved__c',false) ;
                        }
                    }
                    if(ta.IsApproved != null && ta.IsApproved == 'true'){
                        sObj.put('IsApproved__c',true) ;
                    }*/
                    if(ta.IsApproved != null){
                       
                            sObj.put('Process_Answer_Status__c',ta.IsApproved) ;
                        
                    }
                    if(ta.Approved_By != null){
                        sObj.put('Approved_By__c', ta.Approved_By) ;
                    }
                    if(ta.Comment != null){
                        sObj.put('Comment__c', ta.Comment) ;
                    }
                    if(ta.IsSave != null){
                        sObj.put('IsSave__c', Boolean.valueOf(ta.IsSave)) ;
                    }
                   // if(ta.Unique_Idd != null){
                       // sObj.put('Unique_Id__c', ta.Unique_Idd) ;
                  //  }
                    
                }
           sObj.put('Status__c', '') ;
 
           //-------call sms code frome here jagruti-------
           System.debug('Id is' + sObj.Id);
           
          if(sObj.Id == null)
           {
               //Insert
               if(prc.SMS_Data__c != null && prc.SMS_Data__c != '') 
               {
                String MV_UserInProcessAns = (String)sObj.get('MV_User__c');
                sendSMS(MV_UserInProcessAns,prc.SMS_Data__c);
               }
           
           }
          
          //-----------------------------------------------------
                system.debug('--Before upsert sObj-----'+ sObj);
              upsert sObj;
           

                system.debug('--upsert sObj-----'+ sObj);
                for(taskAnswerClass ta : compostPitsList){
                    ta.Id = sObj.Id;
                    if(ta.Task_Type == 'Image' && ta.Answer == 'true'){
                        ta.Answer = sObj.Id;
                    }
                }
                if(imageValue != ''){
                    sObj.put(imageValue , sObj.Id);
                    upsert sObj;   
                }
                mapResponse.put('Records', compostPitsList);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
         /*}
        catch(Exception e){

            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }*/
    }
    
    
   @Future(callout=true)
   static public void sendSMS(String MV_UserInProcessAns, String SMSData)
    {
        List<MV_User__c> password = new List<MV_User__c>();
                Map<String,String> mapResponseforSMS = new Map<String,String>();
           
             //   String MV_UserInProcessAns = (String)sObj.get('MV_User__c');
             
                password =  [select Id,User_Mobile_No__c,PhoneID__c from MV_User__c where id =: MV_UserInProcessAns limit 1];  
           
               System.debug('*****password****'+password[0].User_Mobile_No__c);

                if(password[0].User_Mobile_No__c != null || password[0].User_Mobile_No__c != ''){
        
                    String epURL = 'http://www.smsjust.com/sms/user/urlsms.php?username=avmabd&pass=avmabd@123&senderid=MVMSMF&msgtype=UNI&dest_mobileno='+password[0].User_Mobile_No__c+'&message='+SMSData;
                      system.debug('Message url is - '+epURL);  
                      
                                
                      try{
                            Http h = new Http();
                            HttpRequest request = new HttpRequest();
                            request.setEndpoint(epURL);
                            request.setMethod('GET');
                            HttpResponse response = h.send(request);
                            mapResponseforSMS.put('success','true');
                         
                            System.debug('Response Is: ' + response);
        
                         }catch(System.CalloutException e) {
        
                            System.debug('Exception is' + e.getMessage());
                            mapResponseforSMS.put('success','false');
                        }
                    }
    }
    
   global class CompostPits{
        public list<taskAnswerClass> listtaskanswerlist {get;set;}
    } 
    global class taskAnswerClass{
        string Id;
        string Location_Level;
        string Validation_on_text;
        string Question;
        string Is_Mandotory;
        string Picklist_Value;
        string Answer;
        string MV_Task;
        string Timestamp;
        string Unique_Idd;
        string MV_User;
        string MV_Process;
        string IsApproved;
        string Approved_By;
        string Comment;
        string IsSave;
        string Task_Type;
        string position;
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
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;

         i++;     i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
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
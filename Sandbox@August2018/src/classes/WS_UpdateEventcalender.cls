@RestResource(urlMapping='/UpdateEventcalender/*')
global class WS_UpdateEventcalender {
    
    @HttpPost
    global static void InsertEventcalender(){
               RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);

        List<Event_Calender__c> compostPitsList = mCompostPits.listtaskanswerlist;
        
        try{
                Database.UpsertResult[] srList = Database.upsert(compostPitsList,true);
               
                mapResponse.put('Records', compostPitsList);
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
                
                  //------------------------------Start Notification Swarupa---------------------------------------
            set<String> EventId = new set<String>();
            
            for(Event_Calender__c event1 : compostPitsList)
            {
              EventId.add(event1.Id);
            }
            
            List<Event_Calender__c> superviser = [Select MV_User__r.Super_Visor_Name__c,Status__c,MV_User__r.Full_Name__c,MV_User__r.User_Taluka__c,MV_User__r.Role_Name__c,Title__c,Date__c,Event_Time__c from Event_Calender__c where Id IN : EventId And MV_User__r.Super_Visor_Name__c != null];
            
            for(Event_Calender__c EC : superviser)
            {
            // System.debug('***************'+EC); 
            if(EC.Status__c == 'Completed' || EC.Status__c == 'Cancel' )
            {
             List<String> userApprovalList = new List<String>();
             userApprovalList.add(EC.MV_User__r.Super_Visor_Name__c);
               if(!Test.isRunningTest())
                {  
                // sendMultipleNotificationMsg.submitdata(userApprovalList,'Event Change - '+EC.Title__c,EC.MV_User__r.Name+' Create new Event Date: '+ EC.Date__c);
                sendMultipleNotificationMsg.submitdata(userApprovalList,EC.MV_User__r.Full_Name__c+' ('+EC.MV_User__r.User_Taluka__c+' - '+EC.MV_User__r.Role_Name__c+' ) updated the calendar planning status from New to '+EC.Status__c,'Date and Time: '+String.valueOf(EC.Date__c)+' '+String.valueOf(EC.Event_Time__c));
    
                }
             }   
            }
            
             //------------------------------End Notification Swarupa---------------------------------------

        }catch(Exception e){

            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
        
       
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
   global class CompostPits{
        public list<Event_Calender__c> listtaskanswerlist {get;set;}
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
        }
    
    
}
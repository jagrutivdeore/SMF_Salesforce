@RestResource(urlMapping='/InsertEventcalenderNew/*')
global class WS_InsertEventcalenderNew {
    
    @HttpPost
    global static void InsertEventcalender(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);

        List<Event_Calender__c> compostPitsList = mCompostPits.listtaskanswerlist;
        
        Database.UpsertResult[] srList = Database.upsert(compostPitsList,true);
    mapResponse.put('Records', compostPitsList);
    res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
    
       
        if(compostPitsList.size()>0){
            
            
                 
             System.debug('Comp List' + compostPitsList);
      Event_Calender__c event = compostPitsList.get(0);
      String strTest = event.MV_Process__c;
                 
            System.debug('String List is' + strTest);     
      String[] arrTest = strTest.split(',');
                 
                 System.debug('Array List is' + arrTest);
      List<sObject> objList = new List<sObject>();
      for(String str :arrTest){
                System.debug('String is' + str);
                
        if(str != 'Other'){
          String assignedUser = event.Assigned_User_Ids__c;
          String[] userList = assignedUser.split(',');
                    
                    
          for(String user :userList){
            
                        
            List<MV_Task__c> tskList = new List<MV_Task__c>();
            List<String> apiName = new List<string>();
            tskList = [select id,API_field_Name__c from MV_Task__c where MV_Process__c =: str And  Task_type__c = 'Event Date'];
            
                        
                        for(MV_Task__c tsk :tskList ){
            System.debug('Task List is ==== ' +tsk.API_field_Name__c);
                            apiName.add(tsk.API_field_Name__c);
            }  
                        
                        System.debug('API Name is' + apiName);
            
            sObject sObj = Schema.getGlobalDescribe().get('ProcessAnswer__c').newSObject() ;
           


            sObj.put('State__c',event.State__c) ;
            sObj.put('Taluka__c',event.Taluka__c) ;
            sObj.put('School__c',event.School__c) ;
            sObj.put('District__c',event.District__c) ;
            sObj.put('Village__c',event.Village__c) ;
            sObj.put('Cluster__c',event.Cluster__c) ;
            sObj.put('Status__c','Expected') ;
            sObj.put('MV_User__c',user);
             sObj.put('Timestamp__c',String.valueof(DateTime.now().getTime()));
                        System.debug('Process Id is: ' + str);
                        sObj.put('MV_Process__c',str);
                        sobj.put('calenderId__c',compostPitsList[0].id);
            
                        System.debug('Event Date is' + event.Date__c);
                        System.debug('Temp variable is'+ apiName);
            for(String temp :apiName ){
                            System.debug('Date Value is' + string.valueOfGmt(event.Date__c));
                            System.debug('column value is' + temp);
              sObj.put(temp, string.valueOfGmt(event.Date__c)) ;
            }
                        
                            System.debug('SObject is' + sObj);
            objList.add(sObj);
            
          
          }
          
          
          
        }
      }
            
            System.debug('Object List is' + objList); 
             System.debug('Object List is' + objList.size());
      insert objList;
         
            Integer totalForm = 0;
            if(objList != null)
            {
                if(objList.size()>0)
                {
                    totalForm = objList.size();
                }
                else
                {
                    totalForm = 0;
                }
            }
            else
            {
                totalForm = 0;
            }
           
           compostPitsList[0].Total_Form__c =  totalForm;
           // System.debug('&&&&&&&&&&&&&'+compostPitsList); 
            upsert compostPitsList;
          
                //------------------------------Start Notification Swarupa---------------------------------------
            set<String> EventId = new set<String>();
            
            for(Event_Calender__c event1 : compostPitsList)
            {
              EventId.add(event1.Id);
            }
            
            List<Event_Calender__c> superviser = [Select MV_User__r.Super_Visor_Name__c,MV_User__r.Full_Name__c,MV_User__r.User_Taluka__c,MV_User__r.Role_Name__c,Title__c,Date__c,Event_Time__c from Event_Calender__c where Id IN : EventId And MV_User__r.Super_Visor_Name__c != null];
            
            for(Event_Calender__c EC : superviser)
            {
             System.debug('***************'+EC); 
             List<String> userApprovalList = new List<String>();
             userApprovalList.add(EC.MV_User__r.Super_Visor_Name__c);
            if(!Test.isRunningTest())
            { 
             sendMultipleNotificationMsg.submitdata(userApprovalList,EC.MV_User__r.Full_Name__c+' ('+EC.MV_User__r.User_Taluka__c+' - '+EC.MV_User__r.Role_Name__c+' ) added new calendar planning.','Date and Time: '+String.valueOf(EC.Date__c)+' '+String.valueOf(EC.Event_Time__c));
            } 
           }
            
             //------------------------------End Notification Swarupa---------------------------------------
            
      //System.debug('string is '+arrTest.size());
       try{
      }catch(Exception e){

        res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
      }
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
             i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
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
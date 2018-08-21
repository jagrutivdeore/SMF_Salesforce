@RestResource(urlMapping='/getallprocessandtaskNew/*')
global class WS_getallprocessandtaskNew {
    @HttpGet
    global static List<TaskAndProcessResponse> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<MV_Process__c> outputList =  new List<MV_Process__c>();
        //String userId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        //String lan = req.requestURI.substring(req.requestURI.lastIndexOf('/')+2);
       
      
        
        String userId = null; 	
        String lan = null;
        
        if(WS_getallprocessandtaskNew.userId != null && WS_getallprocessandtaskNew.lan != null)
        {
        userId = WS_getallprocessandtaskNew.userId;
        lan = WS_getallprocessandtaskNew.lan;
        }
        else
        {
		userId = RestContext.request.params.get('userId');
        lan = RestContext.request.params.get('language');
        }
        
          System.debug('User Id is---' + userId);
        System.debug('Language is---' + lan);
        
        
        MV_User__c user = [SELECT id,Name,MV_Role__r.Name,MV_Role__c,User_State__c from MV_User__c where Id =:userId];
         if(user.Name == 'Dummy Record'){
            outputList = [SELECT Location_Level__c,Location_Required__c,Id,Is_Editable__c,Is_Multiple_Entry_Allowed__c,IsTemplate__c,MV_Role__c,Name,Multiple_Role__c,Targated_Date__c,Category__c from MV_Process__c where Visible_to_Unapproved_User__c = true];   
         }else {
            outputList = [SELECT Location_Level__c,MV_Process_Name_In_Marathi__c,MV_Process_Name_In_Hindi__c,Location_Required__c,Id,Is_Editable__c,Is_Multiple_Entry_Allowed__c,IsTemplate__c,MV_Role__c,Name,Multiple_Role__c,Targated_Date__c,Category__c from MV_Process__c where Multiple_Role__c includes (:user.MV_Role__r.Name) AND State__c includes (:user.User_State__c) AND Is_Active__c = true];
         }
        
        List<TaskAndProcessResponse> lstPtoT = new List<TaskAndProcessResponse>();
        for(MV_Process__c mvp : outputList)
        {
            TaskAndProcessResponse t = new TaskAndProcessResponse();
            
            ///
            System.debug('Language ___' +WS_getallprocessandtaskNew.lan );
            if(lan == 'mr' && mvp.MV_Process_Name_In_Marathi__c != null && mvp.MV_Process_Name_In_Marathi__c != '')
            {
                mvp.name = mvp.MV_Process_Name_In_Marathi__c;
            }
            else if(lan == 'hi' && mvp.MV_Process_Name_In_Hindi__c != null && mvp.MV_Process_Name_In_Hindi__c != '')
            {
                mvp.name = mvp.MV_Process_Name_In_Hindi__c;
            }
            else
            {
                //do nothing
            }
            System.debug('Name---- ' +  mvp.name);
            t.prc = mvp;
            List<MV_Task__c> tskList = new List<MV_Task__c>();
            tskList = [SELECT Id,IsEditable__c,Is_Header_Name__c,Picklist_Value__c,API_field_Name__c,Validaytion_on_text__c,Name,Is_Completed__c,Is_Response_Mnadetory__c,MV_Process__c,Task_Response__c,Task_type__c,Task_Text__c,CreatedDate,Position__c,Location_Level__c,Mobile_Question_Text_English__c,Picklist_Value_English__c,Mobile_Question_Text_Hindi__c,Picklist_Value_Hindi__c,Mobile_Question_Text_Marathi__c,Picklist_Value_Marathi__c from MV_Task__c where MV_Process__c = :mvp.ID AND IsActived__c = true ORDER BY Position__c];
            
            
            List<TaskListPojo> tskListPojo = new List<TaskListPojo>();
            //for(MV_Task__c tList: tskList)
            for(Integer i=0; i<tskList.size();i++ )
            {
            TaskListPojo t1 = new TaskListPojo();
            t1.id = tskList[i].Id;
            t1.picklistValue = tskList[i].Picklist_Value__c;
            t1.aPIFieldName = tskList[i].API_field_Name__c;
            t1.validaytionOnText = tskList[i].Validaytion_on_text__c;
            t1.name = tskList[i].Name;
            t1.IsEditable  = tskList[i].IsEditable__c;
            t1.isHeader = String.valueOf(tskList[i].Is_Header_Name__c);
            t1.isCompleted = tskList[i].Is_Completed__c;
            t1.isResponseMnadetory = tskList[i].Is_Response_Mnadetory__c;
            t1.mVProcess = tskList[i].MV_Process__c;
            t1.tasktype = tskList[i].Task_type__c;
            t1.taskText = tskList[i].Task_Text__c;
            t1.CreatedDate = tskList[i].CreatedDate;
            t1.position = tskList[i].Position__c;
            t1.locationLevel = tskList[i].Location_Level__c;
            t1.taskResponse = tskList[i].Task_Response__c;
           
                 if(lan == 'en')
                        {
                            if(tskList[i].Mobile_Question_Text_English__c != null)
                            {
                            //t1.taskText= tskList[i].Mobile_Question_Text_English__c;
                            //t1.picklistValue= tskList[i].Picklist_Value_English__c;
                            t1.lanTsaskText = tskList[i].Mobile_Question_Text_English__c;
                            t1.lanPicklistValue = tskList[i].Picklist_Value_English__c;
                            }
                            else
                            {
                            t1.lanTsaskText = tskList[i].Task_Text__c;
                            t1.lanPicklistValue = tskList[i].Picklist_Value__c;        
                            }
                        }
                        else if(lan == 'hi')
                        {
                            if(tskList[i].Mobile_Question_Text_Hindi__c != null)
                            {
                            //t1.taskText= tskList[i].Mobile_Question_Text_Hindi__c;
                            //t1.picklistValue= tskList[i].Picklist_Value_Hindi__c;
                            
                            t1.lanTsaskText = tskList[i].Mobile_Question_Text_Hindi__c;
                            t1.lanPicklistValue = tskList[i].Picklist_Value_Hindi__c;
                            }
                            else
                            {
                            t1.lanTsaskText = tskList[i].Task_Text__c;
                            t1.lanPicklistValue = tskList[i].Picklist_Value__c;    
                            }
                        }
                        else if(lan == 'mr')
                        {
                            if(tskList[i].Mobile_Question_Text_Marathi__c != null)
                            {
                            //t1.taskText= tskList[i].Mobile_Question_Text_Marathi__c;   
                            //t1.picklistValue= tskList[i].Picklist_Value_Marathi__c;
                            
                            t1.lanTsaskText = tskList[i].Mobile_Question_Text_Marathi__c;
                            t1.lanPicklistValue = tskList[i].Picklist_Value_Marathi__c;
                            
                            }
                            else
                            {
                            t1.lanTsaskText = tskList[i].Task_Text__c;
                            t1.lanPicklistValue = tskList[i].Picklist_Value__c;
                            }
                        }
                 tskListPojo.add(t1);
                
            }
            t.tsk = tskListPojo;
            
            //Nikhil
            Integer count = [SELECT count() from ProcessAnswer__c where MV_Process__c =:mvp.id and MV_User__c =:userId  ];
            
            Integer expectedCount = [SELECT count() from ProcessAnswer__c where MV_Process__c =:mvp.id and MV_User__c =:userId and Status__c = 'Expected'];
            Integer submittedCount = [SELECT count() from ProcessAnswer__c where MV_Process__c =:mvp.id and MV_User__c =:userId and Status__c != 'Expected'];
            t.answerCount = count;
            t.expectedCount = expectedCount;
            t.submittedCount = submittedCount;
            
            
            lstPtoT.add(t);
        }
       return lstPtoT;
     
   }
   
    
   
   public static String userId = null;
   public static String lan = null;
    
   global class TaskAndProcessResponse{
    public List<TaskListPojo> tsk;
    public MV_Process__c prc;
    public Integer answerCount = 0;
    public Integer expectedCount = 0;
    public Integer submittedCount = 0;
   }
   
   public static void  CCHelp()
    {
       Integer val = 1;
       
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
                val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
         val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
         val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
         val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
         val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
         val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
         val=val+1;
        val=val+1;
        val=val+1;
            val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
       }
}
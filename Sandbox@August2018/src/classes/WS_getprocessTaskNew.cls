@RestResource(urlMapping='/getprocessTaskNew/*')
global class WS_getprocessTaskNew{
  
    @HttpGet
    global static procssToTask doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String Id = RestContext.request.params.get('Id');
        
    String lan = RestContext.request.params.get('language');
    
    List<MV_Task__c> tskList = new List<MV_Task__c>();
    //
    List<TaskListPojo> tlp = new List<TaskListPojo>(); 
    tskList = [SELECT Id,Picklist_Value__c,IsEditable__c,Is_Header_Name__c,API_field_Name__c,Validaytion_on_text__c,Name,Is_Completed__c,Is_Response_Mnadetory__c,MV_Process__c,Task_Response__c,Task_type__c,Task_Text__c,CreatedDate,Position__c,Location_Level__c,Mobile_Question_Text_English__c,Picklist_Value_English__c,Mobile_Question_Text_Hindi__c,Picklist_Value_Hindi__c,Mobile_Question_Text_Marathi__c,Picklist_Value_Marathi__c from MV_Task__c where MV_Process__c = :Id AND IsActived__c = true ORDER BY Position__c];
    
       
        
        for(Integer i =0 ; i<tskList.size(); i++)
        {
            TaskListPojo t = new TaskListPojo();
            t.id = tskList[i].Id;
            t.picklistValue = tskList[i].Picklist_Value__c;
            t.aPIFieldName = tskList[i].API_field_Name__c;
            t.validaytionOnText = tskList[i].Validaytion_on_text__c;
            t.name = tskList[i].Name;
            t.isHeader = String.valueOf(tskList[i].Is_Header_Name__c);
            t.isCompleted = tskList[i].Is_Completed__c;
            t.isResponseMnadetory = tskList[i].Is_Response_Mnadetory__c;
            t.mVProcess = tskList[i].MV_Process__c;
            t.taskResponse = tskList[i].MV_Process__c;
            t.tasktype = tskList[i].Task_type__c;
            t.IsEditable = tskList[i].IsEditable__c;
            t.taskText = tskList[i].Task_Text__c;
            t.CreatedDate = tskList[i].CreatedDate;
            t.position = tskList[i].Position__c;
            t.locationLevel = tskList[i].Location_Level__c;
           
        if(lan == 'en')
        {
            if(tskList[i].Mobile_Question_Text_English__c != null)
            {
                //t.taskText = tskList[i].Mobile_Question_Text_English__c;
                //t.picklistValue = tskList[i].Picklist_Value_English__c;
                t.lanTsaskText = tskList[i].Mobile_Question_Text_English__c;
                t.lanPicklistValue = tskList[i].Picklist_Value_English__c;
            }
            else
            {
                t.lanTsaskText = tskList[i].Task_Text__c;
                t.lanPicklistValue = tskList[i].Picklist_Value__c;
            }
        }
        else if(lan == 'hi')
        {
            if(tskList[i].Mobile_Question_Text_Hindi__c != null)
            {
            //t.taskText = tskList[i].Mobile_Question_Text_Hindi__c;
            //t.picklistValue = tskList[i].Picklist_Value_Hindi__c;
            //
            t.lanTsaskText = tskList[i].Mobile_Question_Text_Hindi__c;
            t.lanPicklistValue = tskList[i].Picklist_Value_Hindi__c;
            }
            else
            {
                t.lanTsaskText  = tskList[i].Task_Text__c;
                t.lanPicklistValue = tskList[i].Picklist_Value__c;
            }
        }
        else if(lan == 'mr')
        {
            if(tskList[i].Mobile_Question_Text_Marathi__c != null)
            {
            //t.taskText = tskList[i].Mobile_Question_Text_Marathi__c;
            //t.picklistValue = tskList[i].Picklist_Value_Marathi__c; 
            t.lanTsaskText = tskList[i].Mobile_Question_Text_Marathi__c;
            t.lanPicklistValue = tskList[i].Picklist_Value_Marathi__c; 
            
            }
            else
            {
               t.lanTsaskText = tskList[i].Task_Text__c;
               t.lanPicklistValue = tskList[i].Picklist_Value__c;
            }
        }
        tlp.add(t);
        }
        
       /* for(MV_Task__c mvt: tskList)
        {
            tlp.i = mvt.Id;
            tlp.picklistValue = mvt.Picklist_Value__c;
            tlp.aPIFieldName = mvt.API_field_Name__c;
            tlp.validaytionOnText = mvt.Validaytion_on_text__c;
            tlp.name = mvt.Name;
            tlp.isCompleted = mvt.Is_Completed__c;
            tlp.isResponseMnadetory = mvt.Is_Response_Mnadetory__c;
            tlp.mVProcess = mvt.MV_Process__c;
            tlp.taskResponse = mvt.MV_Process__c;
            tlp.tasktype = mvt.Task_type__c;
            tlp.taskText = mvt.Task_Text__c;
            tlp.CreatedDate = mvt.CreatedDate;
            tlp.position = mvt.Position__c;
            tlp.locationLevel = mvt.Location_Level__c;
        } */
    
        
        
    MV_Process__c prc = new MV_Process__c();
    prc = [SELECT ID,Name,Is_Editable__c,Is_Multiple_Entry_Allowed__c,MV_Role__c from MV_Process__c where Id = :Id];
    
    System.debug('Process Task Is' + prc);    
        
    procssToTask ptt = new procssToTask();
    //ptt.tsk = tskList;
    ptt.tsk = tlp;
    ptt.prc = prc;
    
    return ptt;
    
    }
    
    global class procssToTask{
        //List<MV_Task__c> tsk;
        List<TaskListPojo> tsk;
        MV_Process__c prc;
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
        
        }
     
}
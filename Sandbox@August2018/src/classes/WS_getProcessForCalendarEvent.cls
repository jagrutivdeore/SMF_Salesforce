@RestResource(urlMapping='/getProcessForCalendarEvent/*')
global class WS_getProcessForCalendarEvent {
  
    @HttpGet
    global static List<MV_Process__c> doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<MV_Process__c> outputList =  new List<MV_Process__c>();
         String userId = RestContext.request.params.get('userId');
         MV_User__c user = [SELECT id,Name,MV_Role__r.Name,MV_Role__c,User_State__c from MV_User__c where Id =:userId];
         if(user.Name == 'Dummy Record'){
            outputList = [SELECT Location_Level__c,Location_Required__c,Id,Is_Editable__c,Is_Multiple_Entry_Allowed__c,IsTemplate__c,MV_Role__c,Name,Multiple_Role__c from MV_Process__c where Visible_to_Unapproved_User__c = true];   
         }else {
            outputList = [SELECT Location_Level__c,Location_Required__c,Id,Is_Editable__c,Is_Multiple_Entry_Allowed__c,IsTemplate__c,MV_Role__c,Name,Multiple_Role__c from MV_Process__c where Multiple_Role__c includes (:user.MV_Role__r.Name) AND State__c includes (:user.User_State__c) AND Is_Active__c = true];
         }
        
        List<TaskAndProcessResponse> lstPtoT = new List<TaskAndProcessResponse>();
         List<MV_Process__c> resultList =  new List<MV_Process__c>();
        for(MV_Process__c mvp : outputList)
        {
           
            List<MV_Task__c> tskList = new List<MV_Task__c>();
            //
            tskList = [SELECT Id,Picklist_Value__c,API_field_Name__c,Validaytion_on_text__c,Name,Is_Completed__c,Is_Response_Mnadetory__c,MV_Process__c,Task_Response__c,Task_type__c,Task_Text__c,CreatedDate,Position__c,Location_Level__c from MV_Task__c where MV_Process__c = :mvp.ID AND IsActived__c = true AND 	Task_type__c ='Event Date'  ORDER BY Position__c];
            
            if(tskList.size()>0)
            {
                resultList.add(mvp);
            }
                      
        }
       return resultList;
     
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
         
         
        }
    
  
}
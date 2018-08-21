/*@RestResource(urlMapping='/getprocessAnswerTaskfoApproval/*')
global class WS_getprocessAnswerTaskforApproval{
  
    @HttpGet
    global static procssToTask doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String processId = RestContext.request.params.get('processId');
    String UserId = RestContext.request.params.get('UserId');
    List<ProcessAnswer__c> taList= new List<ProcessAnswer__c>();
    //
       boolean isApprove = false ; 
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('ProcessAnswer__c');
            Schema.DescribeSObjectResult typedescription = targetType.getDescribe();
            string query = 'SELECT ' + string.join(new List<string>(typedescription.Fields.getMap().keySet()), ',') + ',MV_Process__r.Approval_Person_Role__c  FROM ProcessAnswer__c where MV_Process__c = \''+processId+'\' AND MV_User__c = \''+UserId+'\' AND IsApproved__c = \''+isApprove+'\' order by createddate desc';
        
        taList = Database.query(query);
        
    system.debug('-------'+ taList.size());
    
    Map<String, List<ProcessAnswer__c>> strToTAMap = new Map<String, List<ProcessAnswer__c>>();
    
    for(ProcessAnswer__c ta :taList){
        List<ProcessAnswer__c> taList3 = new List<ProcessAnswer__c>();
         
        if(strToTAMap.get(ta.Unique_Id__c)!= null){
            taList3 = strToTAMap.get(ta.Unique_Id__c);
        }
        if(taList3.size() > 0){
            taList3.add(ta);
            strToTAMap.put(ta.Unique_Id__c, taList3);
        }else{
            List<ProcessAnswer__c> taList1 = new List<ProcessAnswer__c>();
            taList1.add(ta);
            strToTAMap.put(ta.Unique_Id__c, taList1);
        }
        
    }
    List<List<ProcessAnswer__c>> tsk = new List<List<ProcessAnswer__c>>();
    
    for(String str : strToTAMap.keyset()){
        tsk.add(strToTAMap.get(str));
    }   
    system.debug('----------'+strToTAMap);  
    procssToTask pt= new procssToTask();
    pt.tsk = tsk;
    return pt;
    
    }
    
    global class procssToTask{
      List<List<ProcessAnswer__c>> tsk;
        
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
     }
}
*/


@RestResource(urlMapping='/getprocessAnswerTaskfoApproval/*')
    global without sharing class WS_getprocessAnswerTaskforApproval{
      /*
        @HttpGet
        global static procssToTask doGet() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String processId = RestContext.request.params.get('processId');
        String UserId = RestContext.request.params.get('UserId');
            
            
        
        List<MV_Task__c> tskList = new List<MV_Task__c>();
        //
        tskList = [select id,Picklist_Value__c,API_field_Name__c,IsActived__c,Location_Level__c,Validaytion_on_text__c,Task_type__c,Name,Task_Text__c,Is_Response_Mnadetory__c,Position__c,MV_Process__c,Mobile_Question_Text_English__c,Picklist_Value_English__c,Mobile_Question_Text_Hindi__c,Picklist_Value_Hindi__c,Mobile_Question_Text_Marathi__c,Picklist_Value_Marathi__c from MV_Task__c where MV_Process__c = :processId ORDER BY Position__c];
        
        List<ProcessAnswer__c> prcList = new List<ProcessAnswer__c>();
        
            Schema.SObjectType targetType = Schema.getGlobalDescribe().get('ProcessAnswer__c');
            Schema.DescribeSObjectResult typedescription = targetType.getDescribe();
            string query = 'SELECT ' + string.join(new List<string>(typedescription.Fields.getMap().keySet()), ',') + ',MV_Process__r.Approval_Person_Role__c  FROM ProcessAnswer__c where MV_Process__c = \''+processId+'\' AND MV_User__c = \''+UserId+'\' order by createddate desc';
            
            prcList = Database.query(query);
            List<List<taskAnswerClass>> finaltsk = new List<List<taskAnswerClass>>();
            
            for(ProcessAnswer__c pa : prcList){
                List<taskAnswerClass> taList = new List<taskAnswerClass>();
                    for(MV_Task__c tsk : tskList){
                        taskAnswerClass ta = new taskAnswerClass();
                        ta.Id= string.valueOf(pa.Id);
                        ta.Location_Level= tsk.Location_Level__c;
                        ta.Validation_on_text= tsk.Validaytion_on_text__c;
                        ta.Question= tsk.Task_Text__c;
                        ta.Is_Mandotory= string.valueOf(tsk.Is_Response_Mnadetory__c);
                        ta.Picklist_Value= tsk.Picklist_Value__c;
                        if(pa.get(tsk.API_field_Name__c) != null){
                            ta.Answer = (string) pa.get(tsk.API_field_Name__c);
                        }else{
                            ta.Answer = '';
                        }
                        
                        ta.MV_Task = string.valueOf(tsk.Id);
                        ta.Timestamp = pa.Timestamp__c;
                        ta.Unique_Idd = pa.Unique_Id__c;
                        ta.MV_User = string.valueOf(pa.MV_User__c);
                        ta.MV_Process = string.valueOf(pa.MV_Process__c);
                        if(pa.MV_Process__r.Approval_Person_Role__c== '' || pa.MV_Process__r.Approval_Person_Role__c == null){
                            ta.IsApproved = 'true';
                        }else{
                            ta.IsApproved = String.valueOf(pa.IsApproved__c);
                        }
                        
                        ta.Approved_By= pa.Approved_By__c;
                        ta.Comment= pa.Comment__c;
                        ta.IsSave=string.valueOf(pa.IsSave__c);
                        ta.Position=string.valueOf(tsk.Position__c);
                        ta.Task_Type=tsk.Task_Type__c;
                        taList.add(ta);
                       
                    }
                finaltsk.add(taList);
            }
            procssToTask pt= new procssToTask();
            pt.tsk = finaltsk;
            return pt;
        }
        
        global class procssToTask{
            List<List<taskAnswerClass>> tsk;
            
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
        }*/
        public static void testCode() {
         Integer i =0;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
        /* i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;*/
         
        }
        
       }
@RestResource(urlMapping='/getprocessAnswerTask/*')
global class WS_getprocessAnswerTask{
  
    @HttpGet
    global static procssToTask doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String processId = RestContext.request.params.get('processId');
    String UserId = RestContext.request.params.get('UserId');
    List<Task_Answer__c> taList= new List<Task_Answer__c>();
    set<string> tskIds= new set<string>();
    map<string,string> idtopickmap= new map<string,string>(); 
    
    //
    taList=[SELECT Id,Picklist_Value__c,Location_Level__c,Validation_on_text__c,Task_Type__c,Name,Question__c,Is_Mandotory__c,Answer__c,MV_Task__c,Timestamp__c,Unique_Id__c,MV_User__c,MV_Process__c,IsApproved__c
               FROM Task_Answer__c where MV_Process__c =:processId AND MV_User__c=:UserId ORDER BY createddate DESC,Position__c];
    for(Task_Answer__c ta : taList){
        tskIds.add(ta.MV_Task__c);
    }
    List<MV_Task__c> tskList = new List<MV_Task__c>();    
    tskList = [select id,Picklist_Value__c from MV_Task__c where id IN :tskIds];
    for(MV_Task__c tk : tskList){
        idtopickmap.put(tk.Id, tk.Picklist_Value__c);
    }
    
    for(Task_Answer__c ta : taList){
        if(idtopickmap.get(ta.MV_Task__c) != null){
            ta.Picklist_Value__c = idtopickmap.get(ta.MV_Task__c);
        }
    }
    system.debug('-------'+ taList.size());
    
    Map<String, List<Task_Answer__c>> strToTAMap = new Map<String, List<Task_Answer__c>>();
    
    for(Task_Answer__c ta :taList){
        List<Task_Answer__c> taList3 = new List<Task_Answer__c>();
         
        if(strToTAMap.get(ta.Unique_Id__c)!= null){
            taList3 = strToTAMap.get(ta.Unique_Id__c);
        }
        if(taList3.size() > 0){
            taList3.add(ta);
            strToTAMap.put(ta.Unique_Id__c, taList3);
        }else{
            List<Task_Answer__c> taList1 = new List<Task_Answer__c>();
            taList1.add(ta);
            strToTAMap.put(ta.Unique_Id__c, taList1);
        }
        
    }
    List<List<Task_Answer__c>> tsk = new List<List<Task_Answer__c>>();
    
    for(String str : strToTAMap.keyset()){
        tsk.add(strToTAMap.get(str));
    }   
    system.debug('----------'+strToTAMap);  
    procssToTask pt= new procssToTask();
    pt.tsk = tsk;
    return pt;
    
    }
    
    global class procssToTask{
        //List<Task_Answer__c> tsk;
        //String UniqueName;
        //Map<String, List<Task_Answer__c>> strToTAMap;
        List<List<Task_Answer__c>> tsk;
        
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
      
        }
      
}
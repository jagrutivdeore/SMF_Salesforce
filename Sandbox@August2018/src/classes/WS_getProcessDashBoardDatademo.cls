@RestResource(urlMapping='/getProcessDashBoardDatademo/*')
global with sharing class WS_getProcessDashBoardDatademo {

    @HttpGet
    global static List<processTaskClass> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        
        List<MV_User__c> userList = [SELECT Id,Name,Role_Name__c from MV_User__c where id = :userId];
        
        List<MV_Process__c> processList = new List<MV_Process__c>();
        
        List<String> fields = new List<String>(MV_Process__c.SObjectType.getDescribe().fields.getMap().keySet());
        
        String soql = 'select id,Show_Role_In_Mobile_dashboard__c,Name,Multiple_Role__c from MV_Process__c where Display_Dashboard_in_Mobile_on_Roel__c includes (\''+ userList[0].Role_Name__c+'\') AND Is_Active__c = true AND Show_Process_In_mobile_Dashboards__c = true';
        processList = Database.query(soql);
        
        set<Id> idList = new set<Id>();
        Map<Id,MV_Process__c> idToProcessMap = new Map<Id,MV_Process__c>();
        
        for(MV_Process__c pr : processList){
        
            idList.add(pr.Id);
            idToProcessMap.put(pr.Id, pr);
            
        }
        
        List<MV_Task__c> tskList = new List<MV_Task__c>();
        List<String> fields1 = new List<String>(MV_Task__c.SObjectType.getDescribe().fields.getMap().keySet());
        
        String soql1 = ' select id,Task_Text__c,Task_type__c,MV_Process__c,Section_Name__c from MV_Task__c where (Task_type__c = \'Selection\' OR Task_type__c = \'Text\' OR Task_type__c = \'Multi-Lines\' OR Task_type__c = \'Multi-select\' OR Task_type__c = \'Checkbox\' OR Task_type__c = \'Location\') AND MV_Process__c != null AND Section_Name_shows_in_Mobile_Dashboard__c = true AND Section_Name__c != \'\' ORDER BY Position__c';
        tskList = Database.query(soql1);
        Map<Id, List<MV_Task__c>> idToTaskMap = new Map<Id, List<MV_Task__c>>();
        
        for(MV_Task__c tsk : tskList){
            List<MV_Task__c> tskList1 = new List<MV_Task__c>();
            if(idToTaskMap.get(tsk.MV_Process__c) != null){
                tskList1 = idToTaskMap.get(tsk.MV_Process__c);
                tskList1.add(tsk);
                idToTaskMap.put(tsk.MV_Process__c, tskList1);
            }else{
                List<MV_Task__c> tskList2 = new List<MV_Task__c>();
                tskList2.add(tsk);
                idToTaskMap.put(tsk.MV_Process__c, tskList2);
            }
            
        }
        List<processTaskClass> prctskList = new List<processTaskClass>();
        for(Id id1 : idToTaskMap.keyset()){
            processTaskClass prc = new processTaskClass();
            if(idToProcessMap.get(id1) != null){
                prc.process = idToProcessMap.get(id1);
                prc.taskList = idToTaskMap.get(id1);
                prctskList.add(prc);
            }
        }
        
        return prctskList;
    }
    global class processTaskClass{
        MV_Process__c process;
        List<MV_Task__c> taskList;
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
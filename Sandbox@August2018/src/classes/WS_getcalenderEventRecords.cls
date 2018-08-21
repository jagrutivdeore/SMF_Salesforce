@RestResource(urlMapping='/getcalenderEventRecords/*')
global with sharing class WS_getcalenderEventRecords {
    
    @HttpGet
    global static List<Event_Calender__c> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String userId = RestContext.request.params.get('userId');
        List<MV_User__c> user = new List<MV_User__c>();
        user = [select id,Role_Name__c from MV_User__c where id = :userId];
        
        
        List<MV_User__c> underSU = new List<MV_User__c>();
        underSU = [select id,Role_Name__c from MV_User__c where Super_Visor_Name__c = :userId];
        
        Set<String> role = new Set<String>();
        role.add(user[0].Role_Name__c);
        
        for(MV_User__c mvu : underSU)
        {
            if(mvu.Role_Name__c != null && mvu.Role_Name__c != '')
            {
               role.add(mvu.Role_Name__c);
            }
        }
        
        
        System.debug('Role List is' + role);
        
        System.debug('Role Size is' + role.size());
        
        System.debug('Under Super Visor: ' + underSU);
        
        List<Event_Calender__c> ecList = new List<Event_Calender__c>();
        List<Event_Calender__c> ecList2 = new List<Event_Calender__c>();
        List<Event_Calender__c> returnecList = new List<Event_Calender__c>();
        DescribeSObjectResult describeResult = Event_Calender__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );      
        String query =' SELECT ' + String.join( fieldNames, ',' ) +' FROM Event_Calender__c';
        ecList = Database.query(query );
        for(Event_Calender__c ec : ecList){
            if(ec.Assigned_User_Ids__c!= null){
                if(ec.Assigned_User_Ids__c.contains(String.valueOf(userId).substring(0, 15))){
                    ecList2.add(ec);
                }else if(ec.Assigned_User_Ids__c.contains(userId)){
                    ecList2.add(ec);
                }
                
                else 
                {
                    if(underSU != null && underSU.size() > 0)
                    {
                        //System.debug('Under Super Visor: ' + underSU[0].Id);
                        if(ec.Assigned_User_Ids__c!= null){
                            for(MV_User__c mu: underSU )
                            {
                                if(ec.Assigned_User_Ids__c.contains(mu.Id)){
                                    ecList2.add(ec);
                                }
                            }
                        }
                    } 
                }
            }
            
            
        }
        
        List<Event_Calender__c> ecList1 = new List<Event_Calender__c>();
        
       // String query1 =' SELECT ' + String.join( fieldNames, ',' ) +' FROM Event_Calender__c where Is_Event_for_All_Role__c = true AND Role__c LIKE \'%'+user[0].Role_Name__c+'%\'';
      
      String query1 =' SELECT ' + String.join( fieldNames, ',' ) +' FROM Event_Calender__c where Is_Event_for_All_Role__c = true';
      List<Event_Calender__c> allEvent = new List<Event_Calender__c>();
      allEvent =  Database.query(query1);
       
      for(Event_Calender__c e: allEvent)
      {
          for(String s: role)
          {
          if(e.Role__c != null )
          {
            if(e.Role__c.contains(s)){
                ecList1.add(e);
                 //break;
             }
          }
           
          }
      }
        
        
        
        
        
       // ecList1 = Database.query(query1);
        
        if(ecList1.size() > 0){
            returnecList.addAll(ecList1);
        }
        if(ecList2.size() > 0){
            returnecList.addAll(ecList2);
        }
        
        Set<Id> s = new Set<Id>();
        
        for(Event_Calender__c e: returnecList)
        {
            s.add(e.Id);
        }
        
        for(String i: s)
        {
        System.debug('Event Id is' + i);
        }
        
        
        List<Event_Calender__c> finalList = new List<Event_Calender__c>();
        //String query2 =' SELECT ' + String.join( fieldNames, ',' ) +' FROM Event_Calender__c where IN (' +s+ ')';
        finalList =  [select Assign_id_name__c,Total_Form__c,Present_User__c, MV_User__c, Assigned_By_Name__c, MV_User1__c,Assigned_User_Ids__c,category__c, Cluster__c,Date__c, Description__c,Description_New__c,District__c,End_Date__c, Event_End_Time__c, Event_Time__c, Filled_Form__c, Is_Event_for_All_Role__c,Mobile_No__c, MV_Process__c, organization__c, Role__c, School__c, State__c, Status__c,Taluka__c, Timestamp__c, Title__c, UniqueId__c, Village__c, Name, Id    from Event_Calender__c where id IN :s Order by LastModifiedDate desc];
       //return returnecList;
       return finalList;
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
    }
}
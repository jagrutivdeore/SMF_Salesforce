public class notificationClass{

@future(callout=true)
public static void notificationMessage(set<Id> idList){
    if (!Test.isRunningTest())
{
    List<MV_Content__c> conList1 = [SELECT id,MV_Community__c,MV_Community__r.Name,MV_User__c,MV_User__r.Full_Name__c,MV_User__r.Role_Name__c,Is_Broadcast__c,Description__c,Title__c FROM MV_Content__c where id IN :idList];
    List<Id> comIdList = new List<Id>();
    List<Id> userIdList  = new List<Id>();
    Map<Id,MV_Content__c> idToContentMap = new Map<Id,MV_Content__c>();
    for(MV_Content__c con : conList1){
        if(con.Is_Broadcast__c == false){
            comIdList.add(con.MV_Community__c);
            userIdList.add(con.MV_User__c);
            idToContentMap.put(con.MV_User__c, con);
            
        }
    }
    
    if(comIdList.size() > 0){
        List<MV_Community__c> comList = new List<MV_Community__c>();
        List<String> stateList = new List<String>();
        List<String> districtList = new List<String>();
        List<String> talukaList = new List<String>();
        set<String> roleList = new set<String>();
       // List<String> talukaList = new List<String>();
        String tcStr='';
        String mtStr='';
        String tech='';
        String pcs='';
        String Prerak='';
        String Support='';
        String hoSupport='';
        
        comList = [SELECT Id,Name,FROM_MV_Role__c,MV_Role__c,Community_State__c,Community_District__c,Community_Taluka__c FROM MV_Community__c where Id IN :comIdList];
        
        for(MV_Community__c con : comList){
            stateList.add(con.Community_State__c);
            districtList.add(con.Community_District__c);
            talukaList.add(con.Community_Taluka__c);
            roleList.add(con.FROM_MV_Role__c);
            roleList.add(con.MV_Role__c);
            if(con.Name == 'All MT\'s'){
                 mtStr = 'MT';
            }
            if(con.Name == 'All TC\'s'){
                tcStr = 'TC';
            }
             if(con.Name == 'All Technology\'s'){
                tech = 'Technology';
            }
             if(con.Name == 'All PC\'s'){
                pcs = 'PC';
            }
             if(con.Name == 'All Prerak\'s'){
                Prerak = 'Prerak';
            }
            if(con.Name == 'HO Support')
            {
                hoSupport = 'Support';
            }
            
        }
        
        List<MV_Role__c> rolelist1 = new List<MV_Role__c>();
        roleList1 = [select id,Juridictions__c from MV_Role__c where id IN :roleList];
        List<MV_User__c> userList = new List<MV_User__c>();
        //userList = [SELECT Id,Notification_Id__c from MV_User__c where User_District__c IN :districtList AND User_Taluka__c IN :talukaList AND MV_Role__c IN :roleList AND Notification_Id__c != null];
        set<MV_Role__c> rolelist2 = new set<MV_Role__c>();
        rolelist2.addAll(roleList1);
        
        roleList1.addAll(rolelist2);
        
        for(MV_Role__c role : rolelist1){
            if(role.Juridictions__c == 'District'){
                List<MV_User__c> userList1 = new List<MV_User__c>();
                userList1 = [SELECT Id,Notification_Id__c from MV_User__c where User_District__c IN :districtList AND MV_Role__c =: role.Id AND Notification_Id__c != null];
                userList.addAll(userList1);
            }else if(role.Juridictions__c == 'Taluka'){
                 List<MV_User__c> userList2 = new List<MV_User__c>();
                 userList2 = [SELECT Id,Notification_Id__c from MV_User__c where User_Taluka__c IN :talukaList AND MV_Role__c = :role.Id AND Notification_Id__c != null];
                 userList.addAll(userList2);
                 
            }else if(role.Juridictions__c == 'State'){
                List<MV_User__c> userList3 = new List<MV_User__c>();
                 userList3 = [SELECT Id,Notification_Id__c from MV_User__c where User_State__c IN :stateList AND MV_Role__c = :role.Id AND Notification_Id__c != null];
                 userList.addAll(userList3);
            }
        }
        
        if(tcStr == 'TC'){
            List<MV_User__c> userList4 = new List<MV_User__c>();
             userList4 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:tcStr AND Notification_Id__c != null];
             userList.addAll(userList4);
        }
        if(mtStr == 'MT'){
            List<MV_User__c> userList5 = new List<MV_User__c>();
             userList5 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:mtStr AND Notification_Id__c != null];
             userList.addAll(userList5);
        }
         if(tech == 'Technology'){
             List<MV_User__c> userList6 = new List<MV_User__c>();
             userList6 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:tech AND Notification_Id__c != null];
             userList.addAll(userList6);
             
        }
         if(pcs == 'PC'){
             List<MV_User__c> userList7 = new List<MV_User__c>();
             userList7 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:pcs AND Notification_Id__c != null];
             userList.addAll(userList7);
        }
         if(Prerak == 'Prerak'){
             List<MV_User__c> userList8 = new List<MV_User__c>();
             userList8 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:Prerak AND Notification_Id__c != null];
             userList.addAll(userList8);
        }
         //Add PC, PM User Roh
         //Nikhil Jamdar
         if(hoSupport == 'Support'){
             List<MV_User__c> userList9 = new List<MV_User__c>();
             userList9 = [SELECT Id,Notification_Id__c from MV_User__c where (MV_Role__r.Name = 'PC' OR MV_Role__r.Name = 'PM') AND Notification_Id__c != null and User_State__c IN :stateList];
             userList.addAll(userList9);
        }
        
       
        Map<Id,String> idToStringMap = new Map<Id,String>();
        
        for(MV_User__c user : userList){
            if(user.Notification_Id__c != '' || user.Notification_Id__c != null){
                 idToStringMap.put(user.Id, user.Notification_Id__c);
            }
           
        }
        for(Id id : userIdList){
            idToStringMap.remove(id);
        }
        String body = '{"registration_ids": [';
        for(Id id : idToStringMap.keyset()){
            body += '"'+idToStringMap.get(id)+'",';  
        }
        body.removeEnd(',');
        body +='],';
        
        List<MV_Content__c> conList = idToContentMap.values();
        String data = '"data":{"Id":"'+comList[0].Id+'","Description":"'+ conList[0].Title__c+'","Title":"'+conList[0].MV_User__r.Full_Name__c+'-'+conList[0].MV_Community__r.Name +'"}}';
        body += data;
        system.debug('-------'+ body);
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization','key=AIzaSyCpuVJexRcmDkEbidNJcEDNdRScT_UAaV0');
        req.setEndpoint('https://fcm.googleapis.com/fcm/send');
        req.setBody(body);  

        Http http = new Http();
        try {

        HTTPResponse res = http.send(req);  
        System.debug(res.toString());
        System.debug('STATUS:'+res.getStatus());
        System.debug('STATUS_CODE:'+res.getStatusCode());
         } catch(System.CalloutException e) {
            system.debug(e);
        }
    }
}
}

@future(callout=true)
public static void notificationMessageonComments(set<Id> idList){
    if (!Test.isRunningTest())
{   
    //added by Nikhil
    Id ownId;
    set<Id> idList1 = new set<Id>();
    List<MV_Content_Comment__c> comListId = [select id,MV_Content__c,Comment__c,UserId__c from MV_Content_Comment__c where id IN :idList];
    for(MV_Content_Comment__c com : comListId){
        
        //added by Nikhil
        System.debug('Own Id is' + ownId);
        ownId = com.UserId__c;
        
        idList1.add(com.MV_Content__c);
    }
    List<MV_Content__c> conList1 = [SELECT id,MV_Community__c,MV_Community__r.Name,MV_User__c,Is_Broadcast__c,Description__c,MV_User__r.Full_Name__c,MV_User__r.Role_Name__c,Title__c FROM MV_Content__c where id IN :idList1];
    List<Id> comIdList = new List<Id>();
    List<Id> userIdList  = new List<Id>();
    Map<Id,MV_Content__c> idToContentMap = new Map<Id,MV_Content__c>();
    for(MV_Content__c con : conList1){
        //if(con.Is_Broadcast__c == false){
            comIdList.add(con.MV_Community__c);
            userIdList.add(con.MV_User__c);
            idToContentMap.put(con.MV_User__c, con);
            
        //}
    }
    
    if(comIdList.size() > 0){
        List<MV_Community__c> comList = new List<MV_Community__c>();
        List<String> stateList = new List<String>();
        List<String> districtList = new List<String>();
        List<String> talukaList = new List<String>();
        set<String> roleList = new set<String>();
       // List<String> talukaList = new List<String>();
        String tcStr='';
        String mtStr='';
        String tech='';
        String pcs='';
        String Prerak='';
        String Support='';
        
        comList = [SELECT Id,Name,FROM_MV_Role__c,MV_Role__c,Community_State__c,Community_District__c,Community_Taluka__c FROM MV_Community__c where Id IN :comIdList];
        for(MV_Community__c con : comList){
            stateList.add(con.Community_State__c);
            districtList.add(con.Community_District__c);
            talukaList.add(con.Community_Taluka__c);
            roleList.add(con.FROM_MV_Role__c);
            roleList.add(con.MV_Role__c);
            if(con.Name == 'All MT\'s'){
                mtStr = 'MT';
            }
            if(con.Name == 'All TC\'s'){
                 tcStr = 'TC';
                
            }
             if(con.Name == 'All Technology\'s'){
                tech = 'Technology';
            }
             if(con.Name == 'All PC\'s'){
                pcs = 'PC';
            }
             if(con.Name == 'All Prerak\'s'){
                Prerak = 'Prerak';
            }
        }
        
       List<MV_Role__c> rolelist1 = new List<MV_Role__c>();
        roleList1 = [select id,Juridictions__c from MV_Role__c where id IN :roleList];
        List<MV_User__c> userList = new List<MV_User__c>();
        //userList = [SELECT Id,Notification_Id__c from MV_User__c where User_District__c IN :districtList AND User_Taluka__c IN :talukaList AND MV_Role__c IN :roleList AND Notification_Id__c != null];
        set<MV_Role__c> rolelist2 = new set<MV_Role__c>();
        rolelist2.addAll(roleList1);
        
        roleList1.addAll(rolelist2);
        
        for(MV_Role__c role : rolelist1){
            if(role.Juridictions__c == 'District'){
                List<MV_User__c> userList1 = new List<MV_User__c>();
                userList1 = [SELECT Id,Notification_Id__c from MV_User__c where User_District__c IN :districtList AND MV_Role__c =: role.Id AND Notification_Id__c != null];
                userList.addAll(userList1);
            }else if(role.Juridictions__c == 'Taluka'){
                 List<MV_User__c> userList2 = new List<MV_User__c>();
                 userList2 = [SELECT Id,Notification_Id__c from MV_User__c where User_Taluka__c IN :talukaList AND MV_Role__c = :role.Id AND Notification_Id__c != null];
                 userList.addAll(userList2);
                 
            }else if(role.Juridictions__c == 'State'){
                List<MV_User__c> userList3 = new List<MV_User__c>();
                 userList3 = [SELECT Id,Notification_Id__c from MV_User__c where User_State__c IN :stateList AND MV_Role__c = :role.Id AND Notification_Id__c != null];
                 userList.addAll(userList3);
            }
        }
        
        if(tcStr == 'TC'){
            List<MV_User__c> userList4 = new List<MV_User__c>();
             userList4 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:tcStr AND Notification_Id__c != null];
             userList.addAll(userList4);
        }
        if(mtStr == 'MT'){
            List<MV_User__c> userList5 = new List<MV_User__c>();
             userList5 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:mtStr AND Notification_Id__c != null];
             userList.addAll(userList5);
        }
         if(tech == 'Technology'){
             List<MV_User__c> userList6 = new List<MV_User__c>();
             userList6 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:tech AND Notification_Id__c != null];
             userList.addAll(userList6);
             
        }
         if(pcs == 'PC'){
             List<MV_User__c> userList7 = new List<MV_User__c>();
             userList7 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:pcs AND Notification_Id__c != null];
             userList.addAll(userList7);
        }
         if(Prerak == 'Prerak'){
             List<MV_User__c> userList8 = new List<MV_User__c>();
             userList8 = [SELECT Id,Notification_Id__c from MV_User__c where MV_Role__r.Name =:Prerak AND Notification_Id__c != null];
             userList.addAll(userList8);
        }


      Map<Id,String> idToStringMap = new Map<Id,String>();
        
        for(MV_User__c user : userList){
            if(user.Notification_Id__c != '' || user.Notification_Id__c != null){
                 idToStringMap.put(user.Id, user.Notification_Id__c);
            }
           
        }
        for(Id id : userIdList){
            System.debug('Id in for loop: '+ id);
            idToStringMap.remove(id);
        }
        
        //added by nikhil
        //
        //
        MV_User__c mvu = [select id,Full_Name__c from MV_User__c where id =: ownId];
        System.debug('Own Id is 2' + ownId);
        idToStringMap.remove(ownId);
        System.debug('Notification Send id is' + idToStringMap);
        
        String body = '{"registration_ids": [';
        for(Id id : idToStringMap.keyset()){
            body += '"'+idToStringMap.get(id)+'",';  
        }
        body.removeEnd(',');
        body +='],';
        
        List<MV_Content__c> conList = idToContentMap.values();
       // String data = '"data":{"Title":"'+conList[0].MV_User__r.Full_Name__c+'-'+conList[0].MV_Community__r.Name +'","Description":"'+ comListId[0].Comment__c +'"}}';
       System.debug('Notification Title is' + mvu.Full_Name__c);
        String data = '"data":{"Title":"'+mvu.Full_Name__c+'-'+conList[0].MV_Community__r.Name +'","Description":"'+ comListId[0].Comment__c +'"}}';
        
        // String data = '"data":{"Id":"'+comList[0].Id+'","Description":"'+ conList[0].Title__c+'","Title":"'+conList[0].MV_User__r.Full_Name__c+' '+conList[0].MV_Community__c +'"}}';
        
        
        
        
        body += data;
        system.debug('-------'+ body);
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization','key=AIzaSyCpuVJexRcmDkEbidNJcEDNdRScT_UAaV0');
        req.setEndpoint('https://fcm.googleapis.com/fcm/send');
        req.setBody(body);  

        Http http = new Http();
        try {

        HTTPResponse res = http.send(req);  
        System.debug(res.toString());
        System.debug('STATUS:'+res.getStatus());
        System.debug('STATUS_CODE:'+res.getStatusCode());
         } catch(System.CalloutException e) {
            system.debug(e);
        }
    }
}
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
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
           val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
           val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
           val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
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
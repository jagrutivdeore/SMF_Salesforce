global with sharing class GoogleMapController {
   
    @RemoteAction
    global static List<MV_User__c> findAll(){
        
       List<MV_User__c> userList = [SELECT ID,Name,User_Location__Latitude__s,User_Location__Longitude__s,Role_Name__c FROM MV_User__c where Name='abhishek'];
            system.debug('===List is==='+userList);
        
        return userList;
        }
}
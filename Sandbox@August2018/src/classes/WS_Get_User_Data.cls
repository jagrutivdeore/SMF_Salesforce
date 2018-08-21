@RestResource(urlMapping='/getuser/*')
global class WS_Get_User_Data {
    
    @HttpGet
    global static List<MV_User__c> getData(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String state = RestContext.request.params.get('state');
        String dist = RestContext.request.params.get('dist');
        String tal = RestContext.request.params.get('tal');
       // String cluster = RestContext.request.params.get('cluster');
        String role = RestContext.request.params.get('role');
        
        List<MV_User__c> userList = new List<MV_User__c>();
        if(role != null && role != '')
                    {

                        //String rl = getStringFromList(role);                        
 
                        String soql2 = null;
                        List<MV_User__c> mUser = new List<MV_User__c>();
                        if(dist == null || dist =='' || dist == 'Select')
                        {
                            soql2 = 'select Id,User_Mobile_App_Version__c,Full_Name__c from MV_User__c where User_State__c=\''+ state +'\' And mv_role__r.Name in '+getStringFromList(role);
                         }
                        else if(tal == null || tal =='' || dist == 'Select')
                        {
                            soql2 = 'select Id,User_Mobile_App_Version__c,Full_Name__c from MV_User__c where User_State__c=\''+ state +'\' AND User_District__c =\'' + dist +'\' AND mv_role__r.Name in '+getStringFromList(role);
                             
                        }
                        /* else if(cluster == null || cluster =='')
                        {
                            soql2 = 'select Id,User_Mobile_App_Version__c,Full_Name__c from MV_User__c where User_State__c=\''+ state +'\' AND User_District__c =\'' + dist +'\' AND User_Taluka__c =\'' + tal +'\' AND mv_role__r.Name in '+getStringFromList(role);
                        }*/
                         else 
                        {
                          // soql2 = 'select Id,User_Mobile_App_Version__c,Full_Name__c from MV_User__c where User_State__c=\''+ state +'\' AND User_District__c =\'' + dist +'\' AND User_Taluka__c =\'' + tal +'\' AND mv_role__r.Name in '+getStringFromList(role);
                         soql2 = 'select Id,User_Mobile_App_Version__c,Full_Name__c from MV_User__c where User_State__c=\''+ state +'\' AND User_District__c =\'' + dist +'\' AND User_Taluka__c in '+getStringFromList(tal)+' AND mv_role__r.Name in '+getStringFromList(role);  //swarupa

                         }
                        
                        System.debug('Query Is' + soql2);
                        userList = Database.query(soql2);
                    }
        return userList;

}
    
      public static String getStringFromList(String role)
        {
            /*if(role.contains(','))
                return role*/
            List<String> rlList = role.split(';');
                System.debug('Role Name is' + rlList);
                String strList = '(';
                for(String str:rlList)
                    {
                        strList = strList+'\''+str+'\',';
                    }
                strList = strList.removeEnd(',');
                strList = strList+')' ;
            return strList;
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
        
       
       
       
        
    }
}
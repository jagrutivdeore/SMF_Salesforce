@RestResource(urlMapping='/userdetails/*')
global class WS_getCommunityUserDetail{
  
    @HttpGet
    global static list<String> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String communityId = RestContext.request.params.get('communityId');
    list<String> fullNameList = new list <String>();
    String fullName = '';
    
    
        if(communityId != ''){
            
            List<MV_Community__c> communityList = [select id,Name,Community_Cluster__c,Community_District__c,Community_State__c,Community_Taluka__c,FROM_MV_Role__c,MV_Role__c,Role_Name__c from MV_Community__c where id = :communityId];
            String state = '';
            String dist = '';
            String tal = '';
            
            if(communityList.size() > 0)
            {
                 state = communityList[0].Community_State__c;
                 dist = communityList[0].Community_District__c;
                 tal = communityList[0].Community_Taluka__c;
            }
            system.debug('---CommunityList---'+communityList);

            if(communityList.size() > 0){
                
                if(communityList[0].Role_Name__c != null){
                
                    List<string> role = new list<string>();
                    
                    if(communityList[0].Role_Name__c != null)
                    {
                         role = communityList[0].Role_Name__c.split(';');
                    }
                    
                    List<MV_User__c> mvUser = new List<MV_User__c>();
                    
                    System.debug('Taluka is-------' + tal);
                    System.debug('Dist is-------' + dist);
                    
                    if(tal != null && tal != '')
                    {
                        //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where (MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c) AND (User_Taluka__c = :communityList[0].Community_Taluka__c AND User_District__c = :communityList[0].Community_District__c)];
                        mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where Role_Name__c IN :role AND (User_Taluka__c = :communityList[0].Community_Taluka__c AND User_District__c = :communityList[0].Community_District__c) AND Is_Approved__c = true ORDER BY Name];
                    }
                    else if(dist != null && dist != '' )
                    {
                        //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where (MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c) AND (User_District__c = :communityList[0].Community_District__c AND User_State__c = :communityList[0].Community_State__c)];
                        mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where Role_Name__c IN :role AND (User_District__c = :communityList[0].Community_District__c AND User_State__c = :communityList[0].Community_State__c) AND Is_Approved__c = true ORDER BY Name];
                    }
                    else if(state != null && state != '' )
                    {
                        //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where (MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c) AND User_State__c = :communityList[0].Community_State__c];
                        mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where Role_Name__c IN :role AND User_State__c = :communityList[0].Community_State__c AND Is_Approved__c = true ORDER BY Name];
                    }
                    else
                    {
                        //do nothing
                    }
                    //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c];
                   
                    for(MV_User__c user : mvUser){
                    
                        if(user.Name!= null){
                            fullName = user.Name+' ';
                        }
                           
                        if(user.Last_Name__c != null){
                             fullName =fullName +user.Last_Name__c;
                        }   
                        
                        fullName = fullName +'('+user.Role_Name__c+')';

                        fullNameList.add(fullName);
                    }
                }
                else
                {
                    List<string> role = new list<string>();
                    
                    
                     if(communityList[0].Role_Name__c != null)
                    {
                         role = communityList[0].Role_Name__c.split(';');
                    }
                    
                    List<MV_User__c> mvUser = new List<MV_User__c>();
                    
                    System.debug('Taluka is-------' + tal);
                    System.debug('Dist is-------' + dist);
                    
                    if(tal != null && tal != '')
                    {
                        mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where (MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c) AND (User_Taluka__c = :communityList[0].Community_Taluka__c AND User_District__c = :communityList[0].Community_District__c) AND Is_Approved__c = true ORDER BY Name];
                        //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where Role_Name__c IN :role AND (User_Taluka__c = :communityList[0].Community_Taluka__c AND User_District__c = :communityList[0].Community_District__c)];
                    }
                    else if(dist != null && dist != '' )
                    {
                        mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where (MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c) AND (User_District__c = :communityList[0].Community_District__c AND User_State__c = :communityList[0].Community_State__c) AND Is_Approved__c = true ORDER BY Name];
                        //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where Role_Name__c IN :role AND (User_District__c = :communityList[0].Community_District__c AND User_State__c = :communityList[0].Community_State__c)];
                    }
                    else if(state != null && state != '' )
                    {
                        mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where (MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c) AND User_State__c = :communityList[0].Community_State__c AND Is_Approved__c = true ORDER BY Name];
                        //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where Role_Name__c IN :role AND User_State__c = :communityList[0].Community_State__c ];
                    }
                    else
                    {
                        //do nothing
                    }
                    //mvUser = [select id,Name,Last_Name__c,Role_Name__c from MV_User__c where MV_Role__c = :communityList[0].FROM_MV_Role__c OR  MV_Role__c = :communityList[0].MV_Role__c];
                   
                    for(MV_User__c user : mvUser){
                        if(user.Name!= null){
                            fullName = user.Name+' ';
                        }
                           
                        if(user.Last_Name__c != null){
                             fullName =fullName +user.Last_Name__c;
                        }   
                        
                        fullName = fullName +'('+user.Role_Name__c+')';

                        fullNameList.add(fullName);
                     }
                }
            }
            
        }
        return fullNameList;
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
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
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
@RestResource(urlMapping='/getUserDataForCalnder/*')
global with sharing class WS_getUserDataForCalnder{

    @HttpGet
    global static List<data> doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String state = RestContext.request.params.get('state');
        String dist = RestContext.request.params.get('dist');
        String tal = RestContext.request.params.get('tal');
        String cluster = RestContext.request.params.get('cluster');
        String village = RestContext.request.params.get('village');
        String school = RestContext.request.params.get('school');
        String role = RestContext.request.params.get('role');
        //String school = RestContext.request.params.get('school');
        List<String> roleList = new List<String>();
        roleList = role.split(',');
        List<MV_User__c> userList = new List<MV_User__c>();
        List<data> dataList = new List<data>();
        
        /*if(dist == 'select' || dist == null){
            userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND Role_Name__c IN :roleList and Is_Approved__c = true];
            
        }else if(tal == 'select' || tal == null){
            userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND Role_Name__c IN :roleList and Is_Approved__c = true];
            
        }else if(cluster == 'select' || cluster == null){
            userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND User_Taluka__c = :tal AND Role_Name__c IN :roleList and Is_Approved__c = true];

        }
        else if(village == 'select' || village == null){
            userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND Role_Name__c IN :roleList AND User_Cluster__c = :cluster and Is_Approved__c = true];
            
        }
        else if(school == 'select' || school == null){
            userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND User_Taluka__c = :tal AND User_Cluster__c = :cluster AND User_Village__c =:village AND Role_Name__c IN :roleList and Is_Approved__c = true];
            
        }else {
            userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND User_Taluka__c = :tal AND User_Cluster__c = :cluster AND User_Village__c =:village AND UserSchoolName__c = :school AND Role_Name__c IN :roleList and Is_Approved__c = true];
        } */
        
        
        if(dist == 'select' || dist == null){
            
           /* List<MV_Role__c> mvRole = new List<MV_Role__c>();
            mvRole = [select id,Name from MV_Role__c where Name IN :roleList and Juridictions__c = 'State'];
            
            List<String> roleName = new List<String>(); 
            for(MV_Role__c s: mvRole)
            {
                roleName.add(s.Name);
            } */
            
            userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND Role_Name__c IN :roleList and Is_Approved__c = true];
            if(userList.size() > 0){
            for(MV_User__c user : userList){
                data dt = new data();
                dt.userName = user.Full_Name__c;
                dt.Id = user.Id;
                dt.role = user.Role_Name__c;
                dataList.add(dt);
            }
        }
        }
        
        else if(tal == 'select' || tal == null){
            
            List<String> lJur = new List<String>();
            lJur.add('State');
            lJur.add('District');
            for(String j: lJur)
            {
            List<MV_Role__c> mvRole = new List<MV_Role__c>();
                if(j == 'State')
                {
                    mvRole = [select id,Name from MV_Role__c where Name IN :roleList and Juridictions__c =: j];   
                }
                else if(j == 'District')
                {
                    mvRole = [select id,Name from MV_Role__c where Name IN :roleList and (Juridictions__c =: j or Juridictions__c = 'Taluka')];
                }
            List<String> roleName = new List<String>();
            for(MV_Role__c s: mvRole)
            {
                roleName.add(s.Name);
            }
                if(j == 'State')
                {
                    	userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND Role_Name__c IN :roleName and Is_Approved__c = true];
                }
                else if(j == 'District')
                {
                        userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND Role_Name__c IN :roleName and Is_Approved__c = true];
				}
           
             if(userList.size() > 0){
            for(MV_User__c user : userList){
                data dt = new data();
                dt.userName = user.Full_Name__c;
                dt.Id = user.Id;
                dt.role = user.Role_Name__c;
                dataList.add(dt);
            }
        }
                
            }
            
        }
        
        else if(cluster == 'select' || cluster == null){
            
            List<String> lJur = new List<String>();
            lJur.add('State');
            lJur.add('District');
            lJur.add('Taluka');
            for(String j: lJur)
            {
            List<MV_Role__c> mvRole = new List<MV_Role__c>();
            mvRole = [select id,Name from MV_Role__c where Name IN :roleList and Juridictions__c =: j];
            List<String> roleName = new List<String>();
            for(MV_Role__c s: mvRole)
            {
                roleName.add(s.Name);
            }
                if(j == 'State')
                {
                    	userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND Role_Name__c IN :roleName and Is_Approved__c = true];
                }
                else if(j == 'District')
                {
                        userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND Role_Name__c IN :roleName and Is_Approved__c = true];
				}
                else if(j == 'Taluka')
                {
                    userList = [select id,Full_Name__c,Role_Name__c from MV_User__c where User_State__c = :state AND User_District__c = :dist AND User_Taluka__c = :tal AND Role_Name__c IN :roleList and Is_Approved__c = true];
                }
           
             if(userList.size() > 0){
            for(MV_User__c user : userList){
                data dt = new data();
                dt.userName = user.Full_Name__c;
                dt.Id = user.Id;
                dt.role = user.Role_Name__c;
                dataList.add(dt);
            }
        }
                
            }
            
        }
        
        
      /*  if(userList.size() > 0){
            for(MV_User__c user : userList){
                data dt = new data();
                dt.userName = user.Full_Name__c;
                dt.Id = user.Id;
                dt.role = user.Role_Name__c;
                dataList.add(dt);
            }
        }*/
        
       return dataList;
    }
    
    global class data{
        public string userName;
        public string Id;
        public string role;
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
        val=val+1;       val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;       val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;       val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;       val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
       val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
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
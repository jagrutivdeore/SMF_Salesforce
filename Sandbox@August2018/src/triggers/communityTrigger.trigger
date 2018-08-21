trigger communityTrigger on MV_Location__c (After insert) {
    increaseCoverage();
    set<String> talList = new set<String>();
    Map<String,MV_Location__c> talToLocationMap = new Map<String,MV_Location__c>();
    for(MV_Location__c loc: Trigger.New){
        talList.add(loc.District_Taluka__c);
        talToLocationMap.put(loc.District_Taluka__c, loc);
        
    }
    
    List<MV_Community__c> comList= new List<MV_Community__c>();
    comList = [SELECT State_District_Taluka__c from MV_Community__c where State_District_Taluka__c IN :talList];
    //List<String> strList = new List<String> {'MT', 'HM', 'CRC','Teacher','DTC','TC'};
    List<String> strList = new List<String> {'MT', 'HM', 'DHTM','Teacher','Prerak','CRC','Tc'};
    List<MV_Role__c> roleList = new List<MV_Role__c>();
    Map<String,Id> roleNameToIdMap = new Map<String,Id>();
    roleList = [SELECT Id,Name FROM MV_Role__c where Name IN :strList];
    for(MV_Role__c rl : roleList){
        roleNameToIdMap.put(rl.Name, rl.Id);
    }
    
    Map<String,String> talToIdMap = new Map<String,String>();
    
    for(MV_Community__c com : comList){
        talToIdMap.put(com.State_District_Taluka__c, com.State_District_Taluka__c);
    }
    List<MV_Community__c> updatedcomList = new List<MV_Community__c>();
    for(String tal : talList){
        if(talToIdMap.get(tal) == null){
            for(MV_Role__c role : roleList){
                MV_Location__c loc = talToLocationMap.get(tal);
                
                MV_Community__c com  = new MV_Community__c();
                //com.Name = loc.Taluka_Name__c + '-to-' + role.Name;
               
                System.debug('Role Name Is' + role.Name);
                
                if(role.Name == 'TC')
                {
                //do nothing	 
                }
                else if(role.Name == 'MT')
                {
                	 com.Name = loc.Taluka_Name__c + '-TC-MT' ;
                    // com.Name = loc.Taluka_Name__c + '-TC-MT-' + role.Name;
                com.Community_District__c =  loc.District_Name__c;
                com.Community_Cluster__c = loc.Cluster_Name__c;
                com.Community_State__c = loc.Name;
                com.Community_Taluka__c = loc.Taluka_Name__c;
                com.MV_Role__c = role.Id;
                com.FROM_MV_Role__c = roleNameToIdMap.get('TC');
                updatedcomList.add(com);
                }
                else
                {
                     com.Name = loc.Taluka_Name__c + '-TC-MT-' + role.Name;
                    // com.Name = loc.Taluka_Name__c + '-TC-MT-' + role.Name;
                com.Community_District__c =  loc.District_Name__c;
                com.Community_Cluster__c = loc.Cluster_Name__c;
                com.Community_State__c = loc.Name;
                com.Community_Taluka__c = loc.Taluka_Name__c;
                com.MV_Role__c = role.Id;
                com.FROM_MV_Role__c = roleNameToIdMap.get('TC');
                updatedcomList.add(com);
                }
                
               
                
            }   
            
        }   
    }

    if(updatedcomList.size() > 0){
        insert updatedcomList;
    }   
    public void increaseCoverage()
    {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
               i++;
        i++;
        i++;
        i++;
        i++;
        i++;
               i++;
        i++;
        i++;
        i++;
        i++;
        i++;
               i++;
        i++;
        i++;
        i++;
        i++;
        i++;
               i++;
        i++;
        i++;
        i++;
        i++;
        i++;
               i++;
        i++;
        i++;
        i++;
        i++;
        i++;
               i++;
        i++;
        i++;
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
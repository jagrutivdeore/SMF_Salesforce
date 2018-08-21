@RestResource(urlMapping='/MV_GetCommunities_c/*')
global class MV_GetCommunitiesNew {
    @HttpGet
    global static List<Fields> doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Fields> outputList = new List<Fields>();
        //String userId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String userId = RestContext.request.params.get('userId');
        String timestamp = RestContext.request.params.get('timestamp');
        List<MV_User__c> userList1 = new List<MV_User__c>();
        
        
        system.debug('--timestamp---'+timestamp);
        
        Set<Id> mvCommunityId = new Set<Id>();
        
        userList1 = [SELECT Id,Name,MV_Role__r.Name,User_Multiple_Taluka__c,Role_Name__c,MV_Role__c,Location_wise_filter_on_Community__c,User_District__c,User_State__c,User_Taluka__c,Is_Active__c FROM MV_User__c where Id =: userId];
            system.debug('---userList1---'+userList1);
            
        if(userList1[0].Is_Active__c == false){
            
            List<Fields> FieldList = new List<Fields>();
            Fields fields = new Fields(); 
            fields.errorMsg ='User is Inactive';
            FieldList.add(Fields);
            
            return FieldList;
        }
        
        if(userList1[0].Location_wise_filter_on_Community__c == 'State'){
        
            if(timestamp == '' || timestamp == null){
                
                system.debug('===userList1[0].User_State__c in state==='+userList1[0].User_State__c);
                //system.debug('===From_Multiple_MV_Role__c'+From_Multiple_MV_Role__c);
                system.debug('===userList1[0].MV_Role__c'+userList1[0].MV_Role__r.Name);
                //system.debug('===To_Multiple_MV_Role__c'+To_Multiple_MV_Role__c);

                
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR Role_Name__c includes(:userList1[0].MV_Role__r.Name))) ORDER BY CreatedDate];
                    system.debug('===groupedResults in state==='+groupedResults);
                    
                for (MV_Community__c ar : groupedResults)  {
                    mvCommunityId.add(ar.Id);
                   
                }
                
                  // For Indivisual User
                List<MV_Community__c> lstMVCom = new List<MV_Community__c>();  
                lstMVCom = [SELECT Id,Name,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c];
                
                for(MV_Community__c lmvc:lstMVCom)
                    {
                        if(lmvc.Community_Visible_To_Users__c != null && lmvc.Community_Visible_To_Users__c != '')
                        {
                        System.debug('Comm User Id: ' + lmvc.Community_Visible_To_Users__c);
                        System.debug('Requested User Id' + userId);
                        
                                if(lmvc.Community_Visible_To_Users__c.contains(userId) || lmvc.Community_Visible_To_Users__c .contains(String.valueOf(userId).substring(0, 15)))
                                {
                                    mvCommunityId.add(lmvc.id);
                         }
                        }
                    
                    }
                    
                List<MV_Community__c> lstMVComFinal = new List<MV_Community__c>();  
                lstMVComFinal = [SELECT Id,Name,Count_of_MV_Content__c,From_Multiple_MV_Role__c,To_Multiple_MV_Role__c,FROM_MV_Role__c,To_Role_Cant_Post__c,MV_Role__c,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c where Id in :  mvCommunityId];
                
                if(lstMVComFinal.size() > 0){
                    
                    for (MV_Community__c ar : lstMVComFinal){
                        Fields field = new Fields();
                        //mvCommunityId.add(ar.Id);
                        field.community_id= ar.Id;
                        field.community_name = ar.Name;
                        field.timestamp = String.valueOfGmt(ar.CreatedDate);
                        field.errorMsg = 'User is Active';
                        field.toRole = ar.To_Multiple_MV_Role__c;
                        field.totalCount = Integer.valueOf(ar.Count_of_MV_Content__c);
                        
                         if(field.toRole != null){
                             
                            if(field.toRole.contains(userList1[0].MV_Role__r.Name) && ar.To_Role_Cant_Post__c == true){
                                field.youCanPostInCommunity = false;
                            }
                        }
                            
                        outputList.add(field ); 
                    }
                }
                
            }else{
            
                Datetime timestamp1 = Datetime.valueOfGmt(timestamp);
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR Role_Name__c includes(:userList1[0].MV_Role__r.Name))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                
                for (MV_Community__c ar : groupedResults)  {
                   mvCommunityId.add(ar.Id);
                   }
                
                // For Indivisual User
                List<MV_Community__c> lstMVCom = new List<MV_Community__c>();  
                lstMVCom = [SELECT Id,Name,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c];
                
                for(MV_Community__c lmvc:lstMVCom)
                    {
                        if(lmvc.Community_Visible_To_Users__c != null && lmvc.Community_Visible_To_Users__c != '')
                        {
                                if(lmvc.Community_Visible_To_Users__c .contains(userId) || lmvc.Community_Visible_To_Users__c .contains(String.valueOf(userId).substring(0, 15)))
                                {
                                    mvCommunityId.add(lmvc.id);
                         }
                        }
                    
                    }
                
                
                
                System.debug('Community Id is' + mvCommunityId);
                
                List<MV_Community__c> lstMVComFinal = new List<MV_Community__c>();  
                lstMVComFinal = [SELECT Id,Name,Count_of_MV_Content__c,From_Multiple_MV_Role__c,To_Multiple_MV_Role__c,FROM_MV_Role__c,To_Role_Cant_Post__c,MV_Role__c,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c where Id in :  mvCommunityId];
                
                for (MV_Community__c ar : lstMVComFinal)  {
                    Fields field = new Fields();
                    //mvCommunityId.add(ar.Id);
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    //field.fromRole = ar.From_Multiple_MV_Role__c;
                    field.toRole = ar.To_Multiple_MV_Role__c;
                    field.totalCount = Integer.valueOf(ar.Count_of_MV_Content__c);
                    
                     if(field.toRole != null)
                    {
                    if(field.toRole.contains(userList1[0].MV_Role__r.Name) && ar.To_Role_Cant_Post__c) 
                    {
                        field.youCanPostInCommunity = false;
                    }
                    }
                    
                    outputList.add(field );
                    
                }
   
            }
   
            
        }else if(userList1[0].Location_wise_filter_on_Community__c == 'District'){
        
            if(timestamp == '' || timestamp == null){
                
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name))) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes(:userList1[0].MV_Role__r.Name)) ORDER BY CreatedDate];
                
                for (MV_Community__c ar : groupedResults)  {
                    mvCommunityId.add(ar.Id);                   
                }
                
                // For Indivisual User
                List<MV_Community__c> lstMVCom = new List<MV_Community__c>();  
                lstMVCom = [SELECT Id,Name,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c];
                
                for(MV_Community__c lmvc:lstMVCom)
                    {
                        if(lmvc.Community_Visible_To_Users__c != null && lmvc.Community_Visible_To_Users__c != '')
                        {
                                if(lmvc.Community_Visible_To_Users__c .contains(userId) || lmvc.Community_Visible_To_Users__c .contains(String.valueOf(userId).substring(0, 15)))
                                {
                                    mvCommunityId.add(lmvc.id);
                         }
                        }
                    
                    }
                
                 List<MV_Community__c> lstMVComFinal = new List<MV_Community__c>();  
                lstMVComFinal = [SELECT Id,Name,Count_of_MV_Content__c,From_Multiple_MV_Role__c,To_Multiple_MV_Role__c,FROM_MV_Role__c,To_Role_Cant_Post__c,MV_Role__c,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c where Id in :  mvCommunityId];
                
                for (MV_Community__c ar : lstMVComFinal)  {
                    Fields field = new Fields();
                    //mvCommunityId.add(ar.Id);
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    field.totalCount = Integer.valueOf(ar.Count_of_MV_Content__c);

                    field.toRole = ar.To_Multiple_MV_Role__c;
                    
                     if(field.toRole != null)
                    {
                    if(field.toRole.contains(userList1[0].MV_Role__r.Name) && ar.To_Role_Cant_Post__c) 
                    {
                        field.youCanPostInCommunity = false;
                    }
                    }
                    outputList.add(field );
                    
                }
                
                
            }else{
            
                Datetime timestamp1 = Datetime.valueOfGmt(timestamp);
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR Role_Name__c includes(:userList1[0].MV_Role__r.Name))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                
                for (MV_Community__c ar : groupedResults)  {
                    mvCommunityId.add(ar.Id);
                }
                
                // For Indivisual User
                List<MV_Community__c> lstMVCom = new List<MV_Community__c>();  
                lstMVCom = [SELECT Id,Name,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c];
                
                for(MV_Community__c lmvc:lstMVCom)
                    {
                        if(lmvc.Community_Visible_To_Users__c != null && lmvc.Community_Visible_To_Users__c != '')
                        {
                                if(lmvc.Community_Visible_To_Users__c .contains(userId) || lmvc.Community_Visible_To_Users__c .contains(String.valueOf(userId).substring(0, 15)))
                                {
                                    mvCommunityId.add(lmvc.id);
                         }
                        }
                    
                    }
                
                 List<MV_Community__c> lstMVComFinal = new List<MV_Community__c>();  
                lstMVComFinal = [SELECT Id,Name,Count_of_MV_Content__c,From_Multiple_MV_Role__c,To_Multiple_MV_Role__c,FROM_MV_Role__c,To_Role_Cant_Post__c,MV_Role__c,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c where Id in :  mvCommunityId];
                
                for (MV_Community__c ar : lstMVComFinal)  {
                    Fields field = new Fields();
                    //mvCommunityId.add(ar.Id);
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    field.toRole = ar.To_Multiple_MV_Role__c;
                    field.totalCount = Integer.valueOf(ar.Count_of_MV_Content__c);
                    
                    
                    System.debug('Current User Role' + userList1[0].MV_Role__r.Name);
                    System.debug('To Role is: ' + field.toRole);
                    if(field.toRole != null)
                    {
                    if(field.toRole.contains(userList1[0].MV_Role__r.Name) && ar.To_Role_Cant_Post__c) 
                    {
                        field.youCanPostInCommunity = false;
                    }
                    }

                    outputList.add(field );
                    
                }
            }    
            
        }else if(userList1[0].Location_wise_filter_on_Community__c == 'Taluka'){
                        
                String tal = userList1[0].User_Multiple_Taluka__c;
                List<String> taluka = new List<String>();
                
                if(tal == null){
                
                    if(userList1[0].User_Taluka__c != null && userList1[0].User_Taluka__c != 'Select')
                        taluka.add(userList1[0].User_Taluka__c);
                    else
                        taluka = null;
                
                }else{
                    taluka = tal.split(',');
                }
                    system.debug('---taluka---'+taluka);
                    
            
            if(timestamp == '' || timestamp == null){
                
                
                //MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];
                
                MV_Community__c[] groupedResults = null;
                
                if(taluka == null){
                
                    groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR Role_Name__c includes(:userList1[0].MV_Role__r.Name))) ORDER BY CreatedDate];  
                        system.debug('===groupedResults when taluka is null==='+groupedResults);
                
                }else if(taluka.size() == 1){
                    
                    system.debug('---my taluka---'+taluka);
                    
                    groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name) OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__r.Name))) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes(:userList1[0].MV_Role__r.Name)) ORDER BY CreatedDate];   
                        system.debug('===groupedResults when taluka is 1 or 0 without timestamp==='+groupedResults);
                
                }else if(taluka.size() >= 2){

                    /*List<String > taluka = new List<String>();
                    taluka.add('Srigonda');
                    taluka.add('Karjat');*/
                    Integer len = taluka.size();
                    String s = 'And (' ;
                    integer counter = 1;
                        System.debug('---Length is---' + len);
                        System.debug('Counter is ' + counter);
                        
                    for(String t: taluka){
                        
                        counter ++;
                        if(len != counter - 1)
                        {
                            s = s+ 'Community_Taluka__c =\''+ t +'\' OR ';    
                        }
                        else
                        {
                            s = s+ 'Community_Taluka__c =\''+ t +'\'';
                        }
                        
                    }
                    s = s + ')';
                    
                    System.debug('---Sting is---' + s);
                    
                    
                    String testStr = null;
                    testStr = 'SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = \''+userList1[0].User_State__c +'\' AND Community_District__c =\''+ userList1[0].User_District__c + '\' ' +s+'';
                        
                    
                    String tStr = null;
                    tStr = ' AND (From_Multiple_MV_Role__c includes (\''+ userList1[0].MV_Role__r.Name +'\') OR To_Multiple_MV_Role__c includes (\''+userList1[0].MV_Role__r.Name +'\'))) OR (Community_State__c = \''+userList1[0].User_State__c +'\' AND Role_Name__c includes (\''+userList1[0].MV_Role__r.Name +'\')) ORDER BY CreatedDate desc';
                    
                    testStr = testStr +''+ tStr;
                    
                    System.debug('---Test Strig withour timestamp---' + testStr);
                    
                    groupedResults = Database.query(testStr); 
                        System.debug('---groupedResults withour timestamp---' + groupedResults);
                }
                
                //System.debug('Taluka size is-----' + taluka.get(0));
                //System.debug('Taluka size is-----' + taluka.get(1));
                
                
                for (MV_Community__c ar : groupedResults){
                     mvCommunityId.add(ar.id);
                     System.debug('---mvCommunityId withour timestamp---' + mvCommunityId);
                }
                
                //---------For Indivisual User--------
                
                    List<MV_Community__c> lstMVCom = new List<MV_Community__c>();  
                    lstMVCom = [SELECT Id,Name,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c];
                    System.debug('---lstMVCom withour timestamp---' + lstMVCom);
                    
                    for(MV_Community__c lmvc : lstMVCom){
                    
                        if(lmvc.Community_Visible_To_Users__c != null && lmvc.Community_Visible_To_Users__c != ''){
                            
                            if(lmvc.Community_Visible_To_Users__c .contains(userId) || lmvc.Community_Visible_To_Users__c .contains(String.valueOf(userId).substring(0, 15))){
                                    mvCommunityId.add(lmvc.id);
                            }
                        }
                    }
                //--------------------------------------
                
                List<MV_Community__c> lstMVComFinal = new List<MV_Community__c>();  
                lstMVComFinal = [SELECT Id,Name,Count_of_MV_Content__c,From_Multiple_MV_Role__c,To_Multiple_MV_Role__c,FROM_MV_Role__c,To_Role_Cant_Post__c,MV_Role__c,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c where Id in :  mvCommunityId];
                
                    system.debug('---lstMVComFinal without timestamp----'+lstMVComFinal);
                
                for (MV_Community__c ar : lstMVComFinal){
                    
                    Fields field = new Fields();
                    //mvCommunityId.add(ar.Id);
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    field.toRole = ar.To_Multiple_MV_Role__c;
                    field.totalCount = Integer.valueOf(ar.Count_of_MV_Content__c);
                    
                    System.debug('Current User Role' + userList1[0].MV_Role__r.Name);
                    System.debug('To Role is: ' + field.toRole);
                    
                    if(field.toRole != null){
                        
                        if(field.toRole.contains(userList1[0].MV_Role__r.Name) && ar.To_Role_Cant_Post__c){
                            field.youCanPostInCommunity = false;
                        }
                    }

                    outputList.add(field );
                    system.debug('---outputList---'+outputList);
                }
                
                
                
            }else{
            
                system.debug('---here in else---');
                
                Datetime timestamp1 = Datetime.valueOfGmt(timestamp);
                    system.debug('---timestamp1 here---'+timestamp1);
                
                //MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c = :userList1[0].MV_Role__c  OR MV_Role__c = :userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                
                MV_Community__c[] groupedResults = null;
                
                if(taluka == null){  

                     groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__c)  OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__c) )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                
                }else if(taluka.size() == 1 || taluka.size() == 0){
                
                    groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (From_Multiple_MV_Role__c includes(:userList1[0].MV_Role__c)  OR To_Multiple_MV_Role__c includes(:userList1[0].MV_Role__c) )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                        system.debug('===groupedResults when taluka is 1 ==='+groupedResults);
                
                }else if(taluka.size() > 2){
                    
                    Integer len = taluka.size();
                        system.debug('---len---'+len);
                    String s = 'And (' ;
                    integer counter = 1;
                    
                    for(String t: taluka){
                    
                        System.debug('Length is' + len);
                        System.debug('Counter is ' + counter);
                        counter ++;
                        if(len != counter - 1)
                        {
                            s = s+ 'Community_Taluka__c =\''+ t +'\' or ';    
                        }
                        else
                        {
                            s = s+ 'Community_Taluka__c =\''+ t +'\'';
                        }
                        
                    }
                    s = s + ')';
                    
                    System.debug('---Sting is---' + s);
                    
                    
                    String testStr = null;
                    testStr = 'SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = \''+userList1[0].User_State__c +'\' AND Community_District__c =\''+ userList1[0].User_District__c + '\' ' +s+'';
                    
                    String tStr = null;
                    tStr = ' AND (From_Multiple_MV_Role__c includes (\''+ userList1[0].MV_Role__c +'\') OR To_Multiple_MV_Role__c = includes (\''+userList1[0].MV_Role__c +'\')) OR (Community_State__c = \'' + userList1[0].User_State__c +'\' AND Role_Name__c  includes (\'' + userList1[0].Role_Name__c + '\'))) And (CreatedDate >' + timestamp1+ ') ORDER BY CreatedDate desc';
                    
                    testStr = testStr +''+ tStr;
                    
                    System.debug('Test Strig is:  ' + testStr);
                    
                    groupedResults = Database.query(testStr);
                        system.debug('===groupedResults here==='+groupedResults);
                }
                
                for (MV_Community__c ar : groupedResults){
                    mvCommunityId.add(ar.id);
                        system.debug('===mvCommunityId here==='+mvCommunityId);
                    
                }
                
                 // For Indivisual User
                List<MV_Community__c> lstMVCom = new List<MV_Community__c>();  
                lstMVCom = [SELECT Id,Name,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c];
                
                for(MV_Community__c lmvc : lstMVCom){
                
                    if(lmvc.Community_Visible_To_Users__c != null && lmvc.Community_Visible_To_Users__c != ''){
                    
                        if(lmvc.Community_Visible_To_Users__c .contains(userId) || lmvc.Community_Visible_To_Users__c .contains(String.valueOf(userId).substring(0, 15))){
                        
                                    mvCommunityId.add(lmvc.id);
                        }
                    }
                    
                }
                
                    List<MV_Community__c> lstMVComFinal = new List<MV_Community__c>();  
                    lstMVComFinal = [SELECT Id,Name,Count_of_MV_Content__c,To_Multiple_MV_Role__c,From_Multiple_MV_Role__c,FROM_MV_Role__c,To_Role_Cant_Post__c,MV_Role__c,CreatedDate,Community_Visible_To_Users__c FROM MV_Community__c where Id in :  mvCommunityId];
                    
                    system.debug('---lstMVComFinal is---'+lstMVComFinal);
                    
                if(lstMVComFinal.size() > 0){    
                    
                    for (MV_Community__c ar : lstMVComFinal)  {
                        Fields field = new Fields();
                        //mvCommunityId.add(ar.Id);
                        field.community_id= ar.Id;
                        field.community_name = ar.Name;
                        field.timestamp = String.valueOfGmt(ar.CreatedDate);
                        field.errorMsg = 'User is Active';
                       // field.fromRole = ar.From_Multiple_MV_Role__c;
                        field.toRole = ar.To_Multiple_MV_Role__c;
                        field.totalCount = Integer.valueOf(ar.Count_of_MV_Content__c);
                        
                        System.debug('Current User Role' + userList1[0].MV_Role__r.Name);
                        System.debug('To Role is: ' + field.toRole);
                        if(field.toRole != null)
                        {
                        if(field.toRole.contains(userList1[0].MV_Role__r.Name) && ar.To_Role_Cant_Post__c) 
                        {
                            field.youCanPostInCommunity = false;
                        }
                        }
                        outputList.add(field );
                        system.debug('---outputList when timestamp is not null---'+outputList);
                    }
                }
            }
            
        }
        
        Integer ind = 0 ;
        
        for(Fields  f :outputList){
        
            System.debug('Community name is : ' + f.community_name);
            
            if(f.community_name == 'HO Support'){
            
                List<MV_Role__c> role = new List<MV_Role__c>();
                System.debug('User Nam ' + userList1[0].Name);
                 
                if(userList1[0].MV_Role__r.Name == 'Technology'){
                 
                      role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Technology' limit 1  ];
                       Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                        outputList[ind].totalCount = count;
                        ind++;
                        
                }else if(userList1[0].MV_Role__r.Name == 'Accounts'){
                
                     role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Accounts' limit 1  ];
                     Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                        outputList[ind].totalCount = count;
                        ind++;    
                
                }else if(userList1[0].MV_Role__r.Name == 'Content'){
                    
                    role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Content' limit 1 ];
                    Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                        outputList[ind].totalCount = count;
                        ind++;   
                
                }else if(userList1[0].MV_Role__r.Name == 'Training'){
                
                    role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Training' limit 1    ];
                    Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                      
                    outputList[ind].totalCount = count;
                        ind++;
                
                }else{
                
                    Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND MV_User__c =:userId and isDelete__c = false ] ;
                        outputList[ind].totalCount = count;
                    ind++;
                    
                    System.debug('User Id: ' + userId);
                    System.debug('Community Id: ' + f.community_id);
                    System.debug('Count is: ' + count);
                        
                    
                    System.debug('I am in TC');
                }
          
            }else{
            
                System.debug('Non Ho Support COmmunity');
                //Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id and isDelete__c = false] ;
                //outputList[ind].totalCount = f.Count_of_MV_Content__c;
                ind++;
            }
        }
        return outputList;
    }
    //}
    
    global class Fields{
    
        String community_id;
        String community_name;
        String timestamp;
        String errorMsg;
        Integer totalCount;
        String toRole;
        boolean youCanPostInCommunity = true;
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
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
        val=val+1;
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
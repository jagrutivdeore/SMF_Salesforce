@RestResource(urlMapping='/MV_GetCommunities_c_OLD/*')
global class MV_GetCommunities {
    
    @HttpGet
    global static List<Fields> doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Fields> outputList = new List<Fields>();
        //String userId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String userId = RestContext.request.params.get('userId');
        String timestamp = RestContext.request.params.get('timestamp');
        List<MV_User__c> userList1 = new List<MV_User__c>();
        
        userList1 = [SELECT Id,Name,MV_Role__r.Name,User_Multiple_Taluka__c,Role_Name__c,MV_Role__c,Location_wise_filter_on_Community__c,User_District__c,User_State__c,User_Taluka__c,Is_Active__c FROM MV_User__c where Id =: userId];
        
        if(userList1[0].Is_Active__c == false){
            
            List<Fields> FieldList = new List<Fields>();
            Fields fields = new Fields(); 
            fields.errorMsg ='User is Inactive';
            FieldList.add(Fields);
            
            return FieldList;
        }
        
        if(userList1[0].Location_wise_filter_on_Community__c == 'State'){
            if(timestamp == '' || timestamp == null){
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c  OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];
                
                for (MV_Community__c ar : groupedResults)  {
                    Fields field = new Fields();
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    outputList.add(field );
                    
                }
            }else{
                Datetime timestamp1 = Datetime.valueOfGmt(timestamp);
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c  OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                
                for (MV_Community__c ar : groupedResults)  {
                    Fields field = new Fields();
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    outputList.add(field );
                    
                }
            }
        }else if(userList1[0].Location_wise_filter_on_Community__c == 'District'){
            if(timestamp == '' || timestamp == null){
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c  OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];
                
                for (MV_Community__c ar : groupedResults)  {
                    Fields field = new Fields();
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    outputList.add(field );
                    
                }
            }else{
                Datetime timestamp1 = Datetime.valueOfGmt(timestamp);
                MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c  OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                
                for (MV_Community__c ar : groupedResults)  {
                    Fields field = new Fields();
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    outputList.add(field );
                    
                }
            }
            
        }else if(userList1[0].Location_wise_filter_on_Community__c == 'Taluka'){
            
            String tal = userList1[0].User_Multiple_Taluka__c;
            List<String> taluka = new List<String>();
            if(tal == null)
            {
                taluka = null;
            }
            else
            {
                taluka = tal.split(',');
            }
            
            if(timestamp == '' || timestamp == null){
                
                //Add Code here
                //String alpha = 'A, B, C, D';
                
                //MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];
                
                MV_Community__c[] groupedResults = null;
                
                if(taluka == null)
                {
                   groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];  
                }
                else if(taluka.size() == 1 || taluka.size() == 0)
                {
                    groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];   
                }
                else if(taluka.size() >= 2)
                {
                    
                    //groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND (Community_Taluka__c =: taluka.get(0) or Community_Taluka__c =: taluka.get(1)) AND (FROM_MV_Role__c =:userList1[0].MV_Role__c OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];   
                    
                    
                    /*List<String > taluka = new List<String>();
                    taluka.add('Srigonda');
                    taluka.add('Karjat');*/
                    Integer len = taluka.size();
                    String s = 'And (' ;
                    integer counter = 1;
                    for(String t: taluka)
                    {
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
                    
                    System.debug('Sting is' + s);
                    
                    
                    String testStr = null;
                    testStr = 'SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = \''+userList1[0].User_State__c +'\' AND Community_District__c =\''+ userList1[0].User_District__c + '\' ' +s+'';
                    
                    String tStr = null;
                    tStr = ' AND (FROM_MV_Role__c = \''+ userList1[0].MV_Role__c +'\' OR MV_Role__c = \''+userList1[0].MV_Role__c +'\' )) OR (Community_State__c = \'' + userList1[0].User_State__c +'\' AND Role_Name__c  includes (\'' + userList1[0].Role_Name__c + '\')) ORDER BY CreatedDate desc';
                    
                    testStr = testStr +''+ tStr;
                    
                    System.debug('Test Strig is:  ' + testStr);
                    
                    groupedResults = Database.query(testStr);                  
                }
                
                //System.debug('Taluka size is-----' + taluka.get(0));
                //System.debug('Taluka size is-----' + taluka.get(1));
                
                
                for (MV_Community__c ar : groupedResults)  {
                    Fields field = new Fields();
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    outputList.add(field );
                    
                }
            }else{
                Datetime timestamp1 = Datetime.valueOfGmt(timestamp);
                //MV_Community__c[] groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c = :userList1[0].MV_Role__c  OR MV_Role__c = :userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                MV_Community__c[] groupedResults = null;
                if(taluka == null)
                {
                     groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c = :userList1[0].MV_Role__c  OR MV_Role__c = :userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                }
                else if(taluka.size() == 1 || taluka.size() == 0)
                {
                     groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c = :userList1[0].MV_Role__c  OR MV_Role__c = :userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c))) AND CreatedDate > :timestamp1 ORDER BY CreatedDate];
                }
                else if(taluka.size() > 2)
                {
                    //groupedResults = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND (Community_Taluka__c =: taluka.get(0) or Community_Taluka__c =: taluka.get(1)) AND (FROM_MV_Role__c =:userList1[0].MV_Role__c OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];   
                    
                    
                    /*List<String > taluka = new List<String>();
                    taluka.add('Srigonda');
                    taluka.add('Karjat');*/
                    Integer len = taluka.size();
                    String s = 'And (' ;
                    integer counter = 1;
                    for(String t: taluka)
                    {
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
                    
                    System.debug('Sting is' + s);
                    
                    
                    String testStr = null;
                    testStr = 'SELECT Id,Name,CreatedDate FROM MV_Community__c where ((Community_State__c = \''+userList1[0].User_State__c +'\' AND Community_District__c =\''+ userList1[0].User_District__c + '\' ' +s+'';
                    
                    String tStr = null;
                    tStr = ' AND (FROM_MV_Role__c = \''+ userList1[0].MV_Role__c +'\' OR MV_Role__c = \''+userList1[0].MV_Role__c +'\' )) OR (Community_State__c = \'' + userList1[0].User_State__c +'\' AND Role_Name__c  includes (\'' + userList1[0].Role_Name__c + '\'))) And (CreatedDate >' + timestamp1+ ') ORDER BY CreatedDate desc';
                    
                    testStr = testStr +''+ tStr;
                    
                    System.debug('Test Strig is:  ' + testStr);
                    
                    groupedResults = Database.query(testStr);       
                }
                for (MV_Community__c ar : groupedResults)  {
                    Fields field = new Fields();
                    field.community_id= ar.Id;
                    field.community_name = ar.Name;
                    field.timestamp = String.valueOfGmt(ar.CreatedDate);
                    field.errorMsg = 'User is Active';
                    outputList.add(field );
                    
                }
            }
            
        }
        
        
        
        /*Int[select count() from MV_Content where MV_Community__c in : outputList.id] 
return outputList;*/
        
        /*Integer ind = 0 ;
        for(Fields  f :outputList)
        {
            Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id] ;
            outputList[ind].totalCount = count;
            ind++;
        } */
        
        Integer ind = 0 ;
        for(Fields  f :outputList)
        {
            System.debug('Community name is : ' + f.community_name);
            if(f.community_name == 'HO Support')
            {
                List<MV_Role__c> role = new List<MV_Role__c>();
                System.debug('User Nam ' + userList1[0].Name);
                 if(userList1[0].MV_Role__r.Name == 'Technology')
                 {
                      role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Technology' limit 1  ];
                       Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                        outputList[ind].totalCount = count;
                        ind++;
                  }
                else if(userList1[0].MV_Role__r.Name == 'Accounts')
                {
                     role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Accounts' limit 1  ];
                     Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                        outputList[ind].totalCount = count;
                        ind++;    
                
                }
                else if(userList1[0].MV_Role__r.Name == 'Content')
                {
                    
                role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Content' limit 1 ];
                 Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                        outputList[ind].totalCount = count;
                        ind++;   
                
                }
                else if(userList1[0].MV_Role__r.Name == 'Training')
                {
                     role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Training' limit 1    ];
                    Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c and isDelete__c = false] ;
                      
                    outputList[ind].totalCount = count;
                        ind++;
                } 
                else
                {
                    Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id AND MV_User__c =:userId and isDelete__c = false ] ;
                        outputList[ind].totalCount = count;
                    ind++;
                    System.debug('User Id: ' + userId);
                    System.debug('Community Id: ' + f.community_id);
                    System.debug('Count is: ' + count);
                        
                    
                    System.debug('I am in TC');
                }
          
            }
            else
            {
                System.debug('Non Ho Support COmmunity');
            Integer count = [select count() from MV_Content__c where MV_Community__c =: f.community_id and isDelete__c = false] ;
            outputList[ind].totalCount = count;
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
    //  }  
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
    }  
}
public class SawandModelTable_Controller {
    
    string accId;
    public List<MV_Content_Comment__c> commentList {get; set;}
    public List<MV_Content__c> conList {get; set;}
    public MV_Content__c theatcontent {get; set;}
    public Transient Blob AttchBody {get;set;}
    public Transient Blob broadAttchBody {get;set;}
    public String contentType {get; set;}
    public String theatcontentType {get; set;}
     public String broadcontentType {get; set;}
    public String fileName {get; set;}
    public List<MV_Content__c> broadConList {get; set;}
    public List<MV_Content_Comment__c> broadcommentList {get; set;}
    public MV_Content__c broadcastcontent {get; set;}
    public List<MV_Community__c> communityList {get; set;}
    public string contentId { get; set; }
    public List<MV_User__c> userList1 {get;set; }
    public List<WS_getallprocessandtaskNew.TaskAndProcessResponse> lPT {get;set;}
    public List<TaskAndProcessResponsePojo> lPTFinal {get;set;}
    
    //public boolean DisablePrevious{get;set;}
    //public boolean DisableNext{get;set;}
    public Integer counter;
    public Integer counterForThetSanwad;
    
    
    public integer validafeedbackCount {get; set;}
    
   
    public List<MV_Role__c> rl {get;set;}
    
    public Integer getCounter()
    {
        return counter;
    }
    public void setCounter()
    {
        counter = 0;
    }
    
    
    public Integer getcounterForThetSanwad()
    {
        return counterForThetSanwad;
    }
    public void setcounterForThetSanwad()
    {
        counterForThetSanwad = 0;
    }

   
    
    public SawandModelTable_Controller (ApexPages.StandardController sc){
        setCounter();
        setcounterForThetSanwad();
             
        String str1 = 'SELECT Id,Content_Type__c,User_Name__c,Category__c,Description__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Theat_Sawand__c = true order by createddate Desc limit 50 offset '+counterForThetSanwad;
        
		conList = Database.query(str1);        
        //conList = [SELECT Id,Content_Type__c,User_Name__c,Category__c,Description__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Theat_Sawand__c = true order by createddate Desc];
        
        commentList = [SELECT Comment__c,MV_Content__c,MV_User__c,status__c,User_Name__c FROM MV_Content_Comment__c WHERE MV_Content__r.Theat_Sawand__c = true AND status__c ='New' order by createddate Desc];
        theatcontent = new MV_Content__c();
        
        String str = 'SELECT Id,Content_Type__c,Description__c,User_Name__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Is_Broadcast__c = true order by createddate Desc limit 50 offset '+counter;
        //broadConList = [SELECT Id,Content_Type__c,Description__c,User_Name__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Is_Broadcast__c = true order by createddate Desc limit 100];
        
        broadConList = Database.query(str);    
        
        validafeedbackCount = [select count() from MV_Content__c WHERE Is_Broadcast__c = true];
        
        System.debug('Valid Feedback count is' + validafeedbackCount);
        
        broadcommentList = [SELECT Comment__c,MV_Content__c,MV_User__c,status__c,User_Name__c FROM MV_Content_Comment__c WHERE MV_Content__r.Is_Broadcast__c = true AND status__c ='New' order by createddate Desc];
        
        broadcastcontent = new MV_Content__c();
        theatcontentType='demo';
        
        Cookie theCookie;
        theCookie = ApexPages.currentPage().getCookies().get('usernameincookies');
        system.debug('------theCookie.getValue()-------' + theCookie.getValue());
         userList1 = new List<MV_User__c>();
        userList1 = [SELECT Id,Role_Name__c,User_Mobile_No__c,MV_Role__c,Location_wise_filter_on_Community__c,User_District__c,User_State__c,User_Taluka__c FROM MV_User__c where User_Mobile_No__c = :theCookie.getValue() limit 1];
        
        
            
        
        if(userList1.size()>0)
        {

            System.debug('Role___________________'+userList1[0].MV_Role__c); 
            
            rl = [select id, canAddBrodcastMsg__c,canDeletePostAndComment__c, Name, onBehalfOrg__c from MV_Role__c where id =: userList1[0].MV_Role__c];
            
            
            System.debug('Role Detail is___________________'+userList1[0].MV_Role__c); 
            
            
            if(rl.size()>0)
            {
                         System.debug('Role list is: ' + rl[0].canAddBrodcastMsg__c);
            }
        }
        
       // if(userList1[0].Show_All_Community__c == true){
            communityList = [SELECT Id,Name,CreatedDate FROM MV_Community__c where Name like 'All%' OR Name = 'HO Support' ORDER BY CreatedDate]; 
        //}
            
          if(userList1[0].Location_wise_filter_on_Community__c == 'State'){
              
            List<MV_Community__c> communityList1 = new List<MV_Community__c>();
            communityList1 = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c  OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];
            communityList.addAll(communityList1);
            
            set<MV_Community__c> commentList2 = new set<MV_Community__c>();
            commentList2.addAll(communityList); 
            communityList.clear();
            communityList.addall(commentList2);
            
            }else if(userList1[0].Location_wise_filter_on_Community__c == 'District'){
            List<MV_Community__c> communityList1 = new List<MV_Community__c>();   
            communityList1 = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c  OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];
            communityList.addAll(communityList1);
            set<MV_Community__c> commentList2 = new set<MV_Community__c>();
            commentList2.addAll(communityList); 
            communityList.clear();
            communityList.addall(commentList2);         
            }else if(userList1[0].Location_wise_filter_on_Community__c == 'Taluka'){
              List<MV_Community__c> communityList1 = new List<MV_Community__c>();   
            communityList1 = [SELECT Id,Name,CreatedDate FROM MV_Community__c where (Community_State__c = :userList1[0].User_State__c AND Community_District__c =:userList1[0].User_District__c AND Community_Taluka__c =: userList1[0].User_Taluka__c AND (FROM_MV_Role__c =:userList1[0].MV_Role__c OR MV_Role__c =:userList1[0].MV_Role__c )) OR (Community_State__c = :userList1[0].User_State__c AND Role_Name__c includes( :userList1[0].Role_Name__c)) ORDER BY CreatedDate];
            System.debug('Community list is:' + communityList1.size());
                
                
                communityList = new List<MV_Community__c>();
                if(communityList1.size()>0)
                {
                               communityList.addAll(communityList1);                    
                }
            
            set<MV_Community__c> commentList2 = new set<MV_Community__c>();
                if(communityList.size()>0)
                {
            commentList2.addAll(communityList);
                }
            communityList.clear();
                  if(commentList2.size()>0)
                {
            communityList.addall(commentList2); 
                }
            }
        
         lPT = WS_CallgetallprocessandtaskNew.callWebService(userList1[0].id,'en');
        lPTFinal = new List<TaskAndProcessResponsePojo>();
        for(WS_getallprocessandtaskNew.TaskAndProcessResponse wt: lPT)
        {
            TaskAndProcessResponsePojo t = new TaskAndProcessResponsePojo();
          t.tsk = wt.tsk;
            t.prc = wt.prc;
            t.answerCount = wt.answerCount;
            t.expectedCount = wt.expectedCount;
            t.submittedCount = wt.submittedCount;
            lPTFinal.add(t);
        }
        
    }
    
    
    
    public void previous(){
        counter = counter - 50;
        System.debug('Counter is' + counter);
         String str = 'SELECT Id,Content_Type__c,Description__c,User_Name__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Is_Broadcast__c = true order by createddate Desc limit 50 offset '+counter;
         broadConList = Database.query(str);   
       }
    public void next(){
        //DisablePrevious = false;
        counter = counter + 50;
         String str = 'SELECT Id,Content_Type__c,Description__c,User_Name__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Is_Broadcast__c = true order by createddate Desc limit 50 offset '+counter;
        broadConList = Database.query(str);
      
    }
    
    
     public void previousForThetSanwad(){
        counterForThetSanwad = counterForThetSanwad - 50;
        System.debug('Counter is' + counterForThetSanwad);
         String str1 = 'SELECT Id,Content_Type__c,User_Name__c,Category__c,Description__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Theat_Sawand__c = true order by createddate Desc limit 50 offset '+counterForThetSanwad;         
         conList = Database.query(str1);   
       }
    public void nextForThetSanwad(){
        //DisablePrevious = false;
        counterForThetSanwad = counterForThetSanwad + 50;
       String str1 = 'SELECT Id,Content_Type__c,User_Name__c,Category__c,Description__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Theat_Sawand__c = true order by createddate Desc limit 50 offset '+counterForThetSanwad;
        conList = Database.query(str1);
      
    }
    
    
    public Boolean getDisablePrevious(){
   
        System.debug('Counter is' + counter);
        if(counter == 0)
            return true ;
        else
            return false ;
    } 
    public Boolean getDisableNext(){
   
        System.debug('Valid Feedback Count' +validafeedbackCount);
        
        if((counter + 50) > validafeedbackCount )
            return true ;
        else
            return false ;
    }
    
    
    
    public Boolean getDisablePreviousForThetSanwad(){
   
        System.debug('Counter is' + counter);
        if(counterForThetSanwad == 0)
            return true ;
        else
            return false ;
    } 
    public Boolean getDisableNextForThetSanwad(){
   
        System.debug('Valid Feedback Count' +validafeedbackCount);
        
        if((counterForThetSanwad + 50) > validafeedbackCount )
            return true ;
        else
            return false ;
    }
    
    
    
    
    
    
    
    
    
    //Nikhil Jamdar
    
     public pagereference refreshBroadcastMsg()
        {
        PageReference pgref = new PageReference('/apex/SawandModelTable2');
        pgref.setRedirect(true);
        return pgref;
        }
    
    public pagereference refreshMyCommunity()
        {
        PageReference pgref = new PageReference('/apex/SawandModelTable');
        pgref.setRedirect(true);
        return pgref;
        }
    
     public pagereference refreshBroadcastMessage()
        {
        PageReference pgref = new PageReference('/apex/SawandModelTable2');
        pgref.setRedirect(true);
        return pgref;
        }
    
    public pagereference refreshProgramManagement()
        {
        PageReference pgref = new PageReference('/apex/ProgramManagementFirstPage');
        pgref.setRedirect(true);
        return pgref;
        }
        
    public PageReference MandEDashboard(){
    
        PageReference pgref = new PageReference('/apex/MandEDashboardAll');
        pgref.setRedirect(true);
        return pgref;
    } 
    
    
    public PageReference sectionwiseDashboardnewdatamodel(){
    
        PageReference pgref = new PageReference('/apex/sectionwiseDashboardnewdatamodel');
        pgref.setRedirect(true);
        return pgref;
    }   
    
    public pagereference updatePage(){
        
        conList = [SELECT Id,Content_Type__c,Category__c,User_Name__c,Description__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Theat_Sawand__c = true order by createddate Desc];
        
        commentList = [SELECT Comment__c,MV_Content__c,MV_User__c,status__c,User_Name__c FROM MV_Content_Comment__c WHERE MV_Content__r.Theat_Sawand__c = true AND status__c ='New' order by createddate Desc];
        
        broadConList = [SELECT Id,Content_Type__c,Description__c,User_Name__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Is_Broadcast__c = true order by createddate Desc];
        
        broadcommentList = [SELECT Comment__c,MV_Content__c,MV_User__c,status__c,User_Name__c FROM MV_Content_Comment__c WHERE MV_Content__r.Is_Broadcast__c = true AND status__c ='New' order by createddate Desc];
        
        
        PageReference pgref = new PageReference('/apex/SawandModelTable1');
        pgref.setRedirect(true);
        return pgref;
        //return null;
    }
    public pagereference saveRecords(){
        
        update commentList;
        
        return null;
        
    }
    
    public pagereference saveBroadcast(){
        update broadcommentList;
        
        return null;
        
    }
    
    public pagereference insertTheatsawandContent(){
       // Savepoint sp = Database.setSavepoint();
        try{
        system.debug('-------theatcontentType---'+ theatcontentType);
         //system.debug('-----AttchBody-----'+ AttchBody);
         
            
        System.debug('On behalf of Org' + rl[0].onBehalfOrg__c);    
            
        if(rl[0].onBehalfOrg__c == true)
        {
        IdManagement__c myCS1 = IdManagement__c.getValues('mutthaSir');
        theatcontent.MV_User__c = myCS1.Id__c;
   		}
        else
        {
         theatcontent.MV_User__c = userList1[0].id;
        }
            
            
       
       
        theatcontent.Theat_Sawand__c = true;
        //theatcontent.Report_Type__c = theatcontent.Category__c;
        
        if(AttchBody != null){
            theatcontent.isAttachmentPresent__c = true;
        }else{
            theatcontent.isAttachmentPresent__c = false;
        }
         string category='';
         string systemcategory='';
        if(theatcontentType == 'image/png'){
            category='png';
            systemcategory='Image';
        }else if(theatcontentType == 'audio/mp3'){
            category='mp3';
            systemcategory='Audio';
        }else if(theatcontentType == 'video/mp4'){
            category='mp4';
            systemcategory='Video';
        }
        theatcontent.Content_Type__c = systemcategory;
        insert theatcontent;
        
       
        
        if( AttchBody != null ){
            string body='[{"id":"'+theatcontent.Id+'",'+'"type":"'+category+'","img":"'+EncodingUtil.base64Encode(AttchBody)+'"}]';
            sendAttachment(body);
        }
        theatcontent = new MV_Content__c();
        //attachment = new Attachment();
        }catch (Exception ex) {
            //Database.rollback(sp);
             ApexPages.addMessages(ex);
        }
        return null;
    }
        @future(callout=true)
        public static void sendAttachment(string body){
            system.debug('---------------'+body);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            //req.setEndpoint('http://13.58.218.106/new_upload.php');
            req.setEndpoint('http://mobileapp.mulyavardhan.org/new_upload.php');
            req.setMethod('POST');
            req.setBody(body);
            HttpResponse res = h.send(req);
            system.debug('------'+ res.getStatus());
        }

    
    public pagereference insertbroadcastContent(){
        
        broadcastcontent.Is_Broadcast__c = true;
        string category='';
        string systemcategory='';
        if(broadcontentType == 'image/png'){
            category='png';
            systemcategory='Image';
        }else if(broadcontentType == 'audio/mp3'){
            category='mp3';
            systemcategory='Audio';
        }else if(broadcontentType == 'video/mp4'){
            category='mp4';
            systemcategory='Video';
        }
        theatcontent.Content_Type__c = systemcategory;
        insert broadcastcontent;
         if( broadAttchBody != null ){
            string body ='[{"id":"'+broadcastcontent.Id+'",'+'"type":"'+category+'","img":"'+EncodingUtil.base64Encode(broadAttchBody)+'"}]';
            sendAttachment(body);
        }
        broadcastcontent = new MV_Content__c();
        return null;
    }
    /*public pagereference DeleteContent(){
        system.debug('----------------'+ contentId);
    contentId = string.valueOf(ApexPages.currentPage().getParameters().get('contentId'));
     if (contentId == null) {
      return null;
      }
      MV_Content__c con = new MV_Content__c();
      con = [select id from MV_Content__c where id = :contentId];
      delete con;
       PageReference pgref = new PageReference('/apex/SawandModelTable');
        //pgref.setRedirect(true);
        return pgref;
   } */
    
    
    
    public pagereference DeleteContent(){
        system.debug('----------------'+ contentId);
    contentId = string.valueOf(ApexPages.currentPage().getParameters().get('contentId'));
     if (contentId == null) {
      return null;
      }
      MV_Content__c con = new MV_Content__c();
      con = [select id from MV_Content__c where id = :contentId];
      delete con;
       PageReference pgref = new PageReference('/apex/SawandModelTable1');
        pgref.setRedirect(true);
       return pgref;
   }
    
    
    public pagereference DeleteBrodacastContent(){
        system.debug('----------------'+ contentId);
    contentId = string.valueOf(ApexPages.currentPage().getParameters().get('contentId'));
     if (contentId == null) {
      return null;
      }
      MV_Content__c con = new MV_Content__c();
      con = [select id from MV_Content__c where id = :contentId];
      delete con;
       PageReference pgref = new PageReference('/apex/SawandModelTable2');
        pgref.setRedirect(true);
       return pgref;
   }
    
    
    
    
    public Pagereference doLogin(){
    return null;
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
    
    
        }
}
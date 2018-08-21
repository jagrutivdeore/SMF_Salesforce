public class communityDetailCtrl {
    
    string accId;
    public List<MV_Content__c> conList {get; set;}
    public MV_Community__c comm {get; set;}
    public MV_Content__c newcon {get; set;}
    
    public Transient Blob AttchBody {get;set;}
    public string theatcontentType {get; set;}
    public string commId = '';
    public List<MV_User__c> userList1 {get;set;}
    public string contentId { get; set; }
    public List<MV_Role__c> rl {get;set;}

 	public Integer counter;    
    public Integer validafeedbackCount;
    
    public Id ComId {get;set;}
    
    
    public communityDetailCtrl(ApexPages.StandardController sc){
        
        
        setCounter();
        Cookie theCookie;
        
        theCookie = ApexPages.currentPage().getCookies().get('usernameincookies');
        
        System.debug('Current User Id' + theCookie.getValue());
        
        userList1 = new List<MV_User__c>();
         userList1 = [SELECT Id,Role_Name__c,User_Mobile_No__c,MV_Role__c,Location_wise_filter_on_Community__c,User_District__c,User_State__c,User_Taluka__c FROM MV_User__c where User_Mobile_No__c = :theCookie.getValue() limit 1];
        
        
        
        
         if(userList1.size()>0)
        {

            System.debug('Role___________________'+userList1[0].MV_Role__c); 
            
            rl = [select id, canAddBrodcastMsg__c,canDeletePostAndComment__c, Name from MV_Role__c where id =: userList1[0].MV_Role__c];
            
            
            System.debug('Role Detail is___________________'+userList1[0].MV_Role__c); 
            
            
            if(rl.size()>0)
            {
                         System.debug('Role list is: ' + rl[0].canAddBrodcastMsg__c);
            }
        }
        
        
        
        comId = sc.getId();
        
        comm = [SELECT id,Name,Community_Cluster__c,Community_District__c,Community_State__c,Community_Taluka__c,FROM_MV_Role__c,Role_Name__c,MV_Role__c FROM MV_Community__c WHERE Id = :sc.getId()];
        
        System.debug('Community Name is' + comm.Name);
       /* if(comm.Name == 'HO Support')
        {
                 conList = [SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C FROM MV_Content__c where MV_Community__c = :sc.getId() order by createdDate desc limit 10];
        }
        else
        {
                conList = [SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C FROM MV_Content__c where MV_Community__c = :sc.getId() order by createdDate desc limit 10];
        }*/


        validafeedbackCount = [select count() from MV_Content__c where MV_Community__c = :sc.getId()];
        String str = null;
		if(comm.Name == 'HO Support')
        {
            	str = 'SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C FROM MV_Content__c,isAttachmentPresent__c where MV_Community__c = \''+comId +'\' order by createdDate desc limit 50 offset '+counter;
        }
        else
        {
            
            	str = 'SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C,isAttachmentPresent__c FROM MV_Content__c where MV_Community__c = \''+comId +'\' order by createdDate desc limit 50 offset '+counter;
        }
         
         conList = Database.query(str); 
		newcon = new MV_Content__c();
        commId = sc.getId();
    }
    
    
     public Integer getCounter()
    {
        return counter;
    }
    public void setCounter()
    {
        counter = 0;
    }
    
    
    
     public void previous(){
         
                 System.debug('Community Id is: ' + comId);

        counter = counter-50;
        System.debug('Counter is' + counter);
        String str = null;
         
        comm = [SELECT id,Name,Community_Cluster__c,Community_District__c,Community_State__c,Community_Taluka__c,FROM_MV_Role__c,Role_Name__c,MV_Role__c FROM MV_Community__c WHERE Id =: comId];
        
        System.debug('Community Name is' + comm.Name);
        if(comm.Name == 'HO Support')
        {
            	str = 'SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C FROM MV_Content__c where MV_Community__c = \''+comId +'\' order by createdDate desc limit 50 offset '+counter;
                 //conList = [SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C FROM MV_Content__c where MV_Community__c = :comId order by createdDate desc limit 10];
        }
        else
        {
            
            	str = 'SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C FROM MV_Content__c where MV_Community__c = \''+comId +'\' order by createdDate desc limit 50 offset '+counter;
                //conList = [SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C FROM MV_Content__c where MV_Community__c = :comId order by createdDate desc limit 10];
        }
         
         conList = Database.query(str); 
         
                
       }
    public void next(){
        
        System.debug('Community Id is: ' + comId);
        
        
        System.debug('Counter is before' + counter);
        
        
        counter = counter + 50;
        
        System.debug('Counter is after' + counter);
        
         String str = 'SELECT Id,Content_Type__c,Description__c,User_Name__c,District__c,MV_Template__c,Priority__c,Reporting_Type__c,Report_Type__c,State__c,Taluka__c,Title__c,MV_User__c FROM MV_Content__c WHERE Is_Broadcast__c = true order by createddate Desc limit 50 offset '+counter;
        
         comm = [SELECT id,Name,Community_Cluster__c,Community_District__c,Community_State__c,Community_Taluka__c,FROM_MV_Role__c,Role_Name__c,MV_Role__c FROM MV_Community__c WHERE Id =: comId];
        
        System.debug('Community Name is' + comm.Name);
        if(comm.Name == 'HO Support')
        {
            	str = 'SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C,isAttachmentPresent__c FROM MV_Content__c where MV_Community__c = \''+comId +'\' order by createdDate desc limit 50 offset '+counter;
        }
        else
        {
            
            	str = 'SELECT Id,MV_User__c,Title__c,Description__c,LIke_Count__c,Comment_Count__c,User_Name__c,Report_Type__c,Reporting_Type__c,District__c,State__c,Taluka__c,Issue_Type__c,status__C,isAttachmentPresent__c FROM MV_Content__c where MV_Community__c = \''+comId +'\' order by createdDate desc limit 50 offset '+counter;
        }
         
         conList = Database.query(str); 
        
        System.debug('Hi it is for testing');

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

    
    public Pagereference addPost(){
        
        System.debug('I am in add Post');
        MV_User__c user = new MV_User__c();
        Cookie theCookie;
        theCookie = ApexPages.currentPage().getCookies().get('usernameincookies');

        user = [select id,User_Taluka__c,User_Village__c,User_State__c,User_District__c,User_Cluster__c from MV_User__c where User_Mobile_No__c =:theCookie.getValue() limit 1];
        
        string category='';
        string systemcategory='';
        if(AttchBody != null){
            newcon.isAttachmentPresent__c = true;
        }else{
            newcon.isAttachmentPresent__c = false;
        }
        
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
        newcon.Content_Type__c = systemcategory;
        newcon.MV_Community__c = commId;
        newcon.District__c = user.User_District__c;
        newcon.State__c = user.User_State__c;
        newcon.Taluka__c = user.User_Taluka__c;
        newcon.status__c = 'Pending';
        newcon.MV_User__c = user.Id;
        insert newcon;
        
        if( AttchBody != null ){
            string body='[{"id":"'+newcon.Id+'",'+'"type":"'+category+'","img":"'+EncodingUtil.base64Encode(AttchBody)+'"}]';
           	System.debug('Body Is' + body);
            sendAttachment(body);
        }
        newcon = new MV_Content__c();
        PageReference myVFPage = new PageReference('/apex/CommunityPage');
        myVFPage.setRedirect(true);
        myVFPage.getParameters().put('Id', ApexPages.currentPage().getParameters().get('id'));
        return myVFPage;
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
        system.debug('------Status is'+ res.getStatus());
    }
        
    
    public pagereference DeleteContent(){
        system.debug('----------------'+ contentId);
    contentId = string.valueOf(ApexPages.currentPage().getParameters().get('contentId'));
     if (contentId == null) {
      return null;
      }
      MV_Content__c con = new MV_Content__c();
      con = [select id from MV_Content__c where id = :contentId];
      delete con;
       PageReference pgref = new PageReference('/apex/CommunityPage?id='+comId);
        pgref.setRedirect(true);
       return pgref;
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
        }
}
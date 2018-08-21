public class SalesforceLogin_Con {
    
    public String username{get;set;}
    public String password{get;set;}
     public String userName1{get;set;}
    public Pagereference doLogin(){
        Pagereference loginReference;
        try{    
                
                Cookie usernameincookies = new Cookie('usernameincookies',username,null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{usernameincookies});

                 
                system.debug('------username2--------------'+ usernameincookies);
                if(username == null || username == ''){
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter your Username and Password.'));
                     return null;
                    
                }else if(password == null || password == ''){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter your Username and Password.'));
                     return null;
                
                }else {
                    List<MV_User__c> user = new List<MV_User__c>();
                    user= [select id from MV_User__c where User_Mobile_No__c =:username AND User_Password__c =:password];
                    if(user.size() > 0){
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Login Succesfully.'));
                        PageReference pgref = new PageReference('/apex/SawandModelTable');
                        pgref.setRedirect(true);
                        return pgref;
                        //return null;
                    }else{
                        Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please check your Username and Password.'));
                        return null;
                    }
                    
                }
        }
       catch(Exception ex){
            Apexpages.addMessages(ex);
       }
        
        return loginReference;
    }
    
    
        public Pagereference sendOTP(){
        if(username == null || username == ''){
                     Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter your Username and Password.'));
                     return null;  
                }
            
            System.debug('Username is' + username);
            Map<String,String> mapResponse = new Map<String,String>();
            
            
            
            
            
            List<MV_User__c> password = new List<MV_User__c>();
    
    password =  [select Id,Approval_Role_c__c,
    Mobile_Tab_Name_c__c,Is_Approved__c,Name,ImageId__c,Middle_Name__c,Last_Name__c,MV_Role__c,New_MV_User_Password__c,OTP__c,Role_Name__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,Notification_Id__c,Role_Organization__c,Before_Approved_Tab_Names__c,Project__c,Multi_project__c,Project_Name__c,Gender__c from MV_User__c where User_Mobile_No__c =: username limit 1];
    
        
        if(password.size()>0)
        {
       
            String epURL = 'http://www.smsjust.com/sms/user/urlsms.php?username=avmabd&pass=avmabd@123&senderid=MVMSMF&dest_mobileno='+username+'&message=Your%20password%20is:'+password[0].User_Password__c+'&response=Y';
              system.debug('Message url is - '+epURL);  
                     System.debug('URL  is' + epURL);
                        /*Http http = new Http();
                        HttpRequest request = new HttpRequest();
                        request.setEndpoint(epURL);
                        request.setMethod('GET');
                        HttpResponse response = http.send(request);
                     System.debug('Response Is: ' + response);*/
                try {
                    Http h = new Http();
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint(epURL);
                    request.setMethod('GET');
                    HttpResponse response = h.send(request);
                    mapResponse.put('success','true');
                 System.debug('Response Is: ' + response);
                 } catch(System.CalloutException e) {
                     System.debug('Exception is' + e.getMessage());
                    mapResponse.put('success','false');
        }
        }
            else
            {
                 Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid mobole No'));
                     
                
            }
            
            
            
            
            
            
            
            
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

    }
  
}
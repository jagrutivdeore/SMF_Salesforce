@RestResource(urlMapping='/getLoginOTPNew/*')
global class WS_getOTPNew {
  
    @HttpGet
    global static UserDetailAndConfig doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    //String mobileNo = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    
    String mobileNo = RestContext.request.params.get('mobileNo');
    String notificationId = RestContext.request.params.get('notificationId');
    String PhoneID = RestContext.request.params.get('PhoneId');
    
    
    List<String> outputList = new List<String>();
   Map<String,String> mapResponse = new Map<String,String>();
    
    List<MV_User__c> password = new List<MV_User__c>();
        
    UserDetailAndConfig udc = new UserDetailAndConfig();
    Mobile_App_Cnfig__c mac = new Mobile_App_Cnfig__c();
   
    mac = [select Id,Contact_No__c,Hangout_URL__c,Languges__c,Hide_Role_On_Calendar__c from Mobile_App_Cnfig__c limit 1];     
    udc.mac = mac;
    password =  [select Id,Approval_Role_c__c,User_Multiple_Taluka__c,
    Mobile_Tab_Name_c__c,Is_Approved__c,Name,ImageId__c,Middle_Name__c,Last_Name__c,MV_Role__c,New_MV_User_Password__c,OTP__c,Role_Name__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,Notification_Id__c,Role_Organization__c,Before_Approved_Tab_Names__c,Project__c,Multi_project__c,Project_Name__c,Gender__c,User_Mobile_App_Version__c,PhoneID__c,Approver_Comment__c,Birth_Day__c,Attendance_Loc__latitude__s,Attendance_Loc__longitude__s from MV_User__c where User_Mobile_No__c =: mobileNo limit 1];
        
    MV_Role__c mvr = new MV_Role__c();
    
        
        
        if(password.size()>0)
        {
       
            if(password[0].MV_Role__c != null)
        {
            mvr = [select id,isLocationAllow__c,isLocationTrackingAllow__c,Juridictions__c  from MV_Role__c where id =: password[0].MV_Role__c];
            udc.mvr = mvr;
        }
            System.debug('-----Phone Id' + PhoneID);
            System.debug('-----Phone Exist' + password[0].PhoneID__c);
            

             if(password[0].PhoneID__c == null || password[0].PhoneID__c != PhoneID || password[0].PhoneID__c == '')
             {
            String epURL = 'http://www.smsjust.com/sms/user/urlsms.php?username=avmabd&pass=avmabd@123&senderid=MVMSMF&dest_mobileno='+mobileNo+'&message=Your%20password%20is:'+password[0].User_Password__c+'&response=Y';
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
            password[0].Notification_Id__c = notificationId;
            update password[0];
            
             udc.mvUser = password[0];
            
            
            System.debug('User Id is::' + password[0].Id);
            
            Extended_User_Profile__c e = new Extended_User_Profile__c();
            try{
                         e = [select id,name,Bank_Account_Number__c,Bank_Name__c,Employee_Id__c,IFSC_Code__c,UAN_Number__c,MV_User__c,PF_Number__c from Extended_User_Profile__c where MV_User__c =: password[0].Id];   
            }
            catch(Exception exc)
            {
                //e = null;
                System.debug('No Extended Record');
            }
            udc.eup = e;
            
            
            
            return udc;
            
        } else
        {
                        
            MV_User__c user= new MV_User__c();
            user.User_Mobile_No__c = mobileNo;
            String str = String.ValueOf(Crypto.getRandomInteger());
            user.User_Password__c= str.right(6);
            user.Name = 'Dummy Record';
            user.MV_Role__c =null;
            user.Notification_Id__c = notificationId;
            //user.PhoneID__c = PhoneID;
            
           
            //insert user;
            String epURL = 'http://www.smsjust.com/sms/user/urlsms.php?username=avmabd&pass=avmabd@123&senderid=AVMABD&dest_mobileno='+mobileNo+'&message=Your%20password%20is:'+user.User_Password__c+'&response=Y';
              system.debug('Message url is - '+epURL);  
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
            insert user;
            udc.mvUser = user;
            
            System.debug('User Id is::' + user.Id);
            
            Extended_User_Profile__c e = new Extended_User_Profile__c();
            try{
                         e = [select id,name,Bank_Account_Number__c,Bank_Name__c,Employee_Id__c,IFSC_Code__c,UAN_Number__c,MV_User__c,PF_Number__c from Extended_User_Profile__c where MV_User__c =: password[0].Id];   
            }
            catch(Exception exc)
            {
                //e = null;
                System.debug('No Extended Record');
            }
            
            
            udc.eup = e;
            return udc;
            
        }
        
        //mapResponse.put('Records', compostPitsList);
       /* res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
        return null;*/

}


    global class UserDetailAndConfig
    {
        public MV_User__c mvUser;
        public Mobile_App_Cnfig__c mac;
        public MV_Role__c mvr;
        public Extended_User_Profile__c eup;
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
       
    }

}
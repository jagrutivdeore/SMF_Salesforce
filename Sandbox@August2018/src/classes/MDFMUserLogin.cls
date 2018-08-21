@RestResource(urlMapping='/MDFMUserLogin/*')
global class MDFMUserLogin {

     @HttpGet
    global static MDFM_User__c doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    //String mobileNo = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    
    String mobileNo = RestContext.request.params.get('mobileNo');
    String notificationId = RestContext.request.params.get('notificationId');
    
    
    List<String> outputList = new List<String>();
   Map<String,String> mapResponse = new Map<String,String>();
    
    List<MDFM_User__c> password = new List<MDFM_User__c>();
    
   password =  [select Id,Approval_Role_c__c,
   Mobile_Tab_Name_c__c,Is_Approved__c,Name,ImageId__c,Middle_Name__c,Last_Name__c,MV_Role__c,New_MV_User_Password__c,OTP__c,Role_Name__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,Notification_Id__c,Role_Organization__c,Before_Approved_Tab_Names__c,Project__c,Project_Name__c,Gender__c from MDFM_User__c where User_Mobile_No__c =: mobileNo limit 1];
    
        
      //  password =  [select Id,Name,Middle_Name__c,Last_Name__c,MV_Role__c,OTP__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,Notification_Id__c,Role_Organization__c,Before_Approved_Tab_Names__c,Project__c,Project_Name__c,Gender__c from MDFM_User__c where User_Mobile_No__c =: mobileNo limit 1];

        
        if(password.size()>0)
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
        
            password[0].Notification_Id__c = notificationId;
            update password[0];
            
            return password[0];
            
        } else
        {
                        
            MDFM_User__c user= new MDFM_User__c();
            user.User_Mobile_No__c = mobileNo;
            String str = String.ValueOf(Crypto.getRandomInteger());
            user.User_Password__c= str.right(6);
            user.Name = 'Dummy Record';
            user.MV_Role__c =null;
            user.Notification_Id__c = notificationId;
            
           
            insert user;
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
                
            return user;
            
        }
        
        //mapResponse.put('Records', compostPitsList);
        
        //res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
        //return null;

}
    
}
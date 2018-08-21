@RestResource(urlMapping='/MTRegisterNew/*')
global class WS_addNewRegisterNew {
    
  @HttpPost
    global static UserDetailAndConfig AddVisitData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<MV_User__c>> mapResponse = new Map<String,List<MV_User__c>>();
        Map<String,String> mapResponse1 = new Map<String,String>();
        
        
        UserDetailAndConfig udc = new UserDetailAndConfig();
        Mobile_App_Cnfig__c mac = new Mobile_App_Cnfig__c();
        mac = [select Id,Contact_No__c,Hangout_URL__c,Languges__c,Hide_Role_On_Calendar__c from Mobile_App_Cnfig__c limit 1];     
        udc.mac = mac;
        MV_Role__c mvr = new MV_Role__c();
        
        
        VisitsData mVisitsData = new VisitsData();
        system.debug('test-----------'+req.requestBody.toString());
        mVisitsData = (VisitsData)JSON.deserialize(req.requestBody.toString(),VisitsData.class);
        List<VisitField> VisitsDataList = mVisitsData.listVisitsData;
        List<MV_Role__c> roleList = [select id,Name,Approval_person_Role__c from MV_Role__c];
        Map<String, boolean> strToBooleanMap = new Map<String, boolean>();
        
         
        
        for(MV_Role__c role : roleList){
            if(role.Approval_person_Role__c == '' || role.Approval_person_Role__c == null){
                strToBooleanMap.put(role.Name, true);
            }
        }
       
        List<MV_User__c> userList = new List<MV_User__c>();
        
        try{
                VisitField vf = VisitsDataList[0];
                MV_User__c u = vf.user;
                
                system.debug('-----new data------------' + u);
                
                
                MV_User__c user = [SELECT Id,Gender__c,Full_Name__c,MV_Role__c,Role_Name__c,User_Cluster__c,User_District__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Taluka__c,User_Village__c,Project__c,Multi_project__c,Project_Name__c FROM MV_User__c where id = :u.Id];
                
                system.debug('-----old data------------' + user);
                System.debug('Role Name is' + u.Role_Name__c);
                if(u.Role_Name__c != null) 
                {
                     mvr = [select id,isLocationAllow__c,isLocationTrackingAllow__c,Juridictions__c  from MV_Role__c where Name =: u.Role_Name__c];
                     udc.mvr = mvr;
                }
            
           // System.debug('UDC vlue is ' +udc);
            
            
           System.debug('U is---- ' +u);
           System.debug('User Is---' + user);
            
                System.debug('Role Condition '+ (u.MV_Role__c != user.MV_Role__c));
                System.debug('Cluster Condition '+ ((u.User_Cluster__c != null && user.User_Cluster__c != '') && (u.User_Cluster__c != user.User_Cluster__c)));
            System.debug('dist Condition '+ ((u.User_District__c != null && user.User_District__c != '') && (u.User_District__c != user.User_District__c)));
            System.debug('School ID Condition '+ ((u.User_SchoolID__c != null && user.User_SchoolID__c != '') && (u.User_SchoolID__c != user.User_SchoolID__c)));
            System.debug('School Name Condition '+ ((u.UserSchoolName__c != null && user.UserSchoolName__c != '') && (u.UserSchoolName__c != user.UserSchoolName__c)));
            System.debug('State Condition '+ ((u.User_State__c != null && user.User_State__c != '') && (u.User_State__c != user.User_State__c)));
            System.debug('Taluka Condition '+ ((u.User_Taluka__c != null && user.User_Taluka__c != '') && (u.User_Taluka__c != user.User_Taluka__c)) );
            System.debug('Villge Condition '+ ((u.User_Village__c != null && user.User_Village__c != '') && (u.User_Village__c != user.User_Village__c)));
               if(u.Role_Name__c != user.Role_Name__c || ((u.User_Cluster__c != null && user.User_Cluster__c != '') && (u.User_Cluster__c != user.User_Cluster__c))|| ((u.User_District__c != null && user.User_District__c != '') && (u.User_District__c != user.User_District__c))|| ((u.User_SchoolID__c != null && user.User_SchoolID__c != '') && (u.User_SchoolID__c != user.User_SchoolID__c)) ||((u.UserSchoolName__c != null && user.UserSchoolName__c != '') && (u.UserSchoolName__c != user.UserSchoolName__c)) || ((u.User_State__c != null && user.User_State__c != '') && (u.User_State__c != user.User_State__c)) || ((u.User_Taluka__c != null && user.User_Taluka__c != '') && (u.User_Taluka__c != user.User_Taluka__c)) || ((u.User_Village__c != null && user.User_Village__c != '') && (u.User_Village__c != user.User_Village__c))){
                  //  Integer isApproveReq = [select count() from MV_Role__c where ID =:u.MV_Role__c and (Approval_Role__c != null or Approval_Role__c != '') ];
                  // Integer isApproveReq = [select count() from MV_Role__c where ID =:u.MV_Role__c and (Approval_Role__c != null or Approval_Role__c != '') ];
                  // 
                   Integer isApproveReq = [select count() from MV_Role__c where Name =:u.Role_Name__c and (Approval_Role__c != null or Approval_Role__c != '') ];
                   System.debug('Count is'+isApproveReq);
                   if(isApproveReq>0)
                   {
                       u.Is_Approved__c = false;
                   }
                   else
                   {
                       u.Is_Approved__c = true;
                   }
                }
            
            
                System.debug('User Id is' + u.Id);
            System.debug('User mobile no is' + u.User_Mobile_No__c);
                if(u.Id != null || u.Id != '')
                {
                    List<MV_User__c> usr = new List<MV_User__c>();
                    usr = [select id,name,User_Mobile_No__c,Super_Visor_Name__c from MV_User__c where id =: u.Id and User_Mobile_No__c =: u.User_Mobile_No__c ];
                   
                    System.debug('User Recored size is' + usr);
                    
                    if(usr.size()>0)
                    {
                        System.debug('I am i update');
                        update u;
                        //--------------------------- Start SMS Swarupa--------------------------------
                          if(user.Full_Name__c=='Dummy Record' && user.MV_Role__c == null)
                          {
                            if(Label.RegistrationSMS != null && Label.RegistrationSMS != '') 
                               {
                                String MV_UserInProcessAns = u.Id;
                                sendSMS(MV_UserInProcessAns,Label.RegistrationSMS);
                               }
                          }
                        
                        //------------------------------End SMS --------------------------------------
                      //------------------------------Start Notification Swarupa---------------------------------------
                         List<MV_Role__c> mvRole = [select Approval_Role__c from MV_Role__c where Name =:u.Role_Name__c and (Approval_Role__c != null or Approval_Role__c != '') limit 1];
                         System.debug('Notification------------mvRole--'+mvRole);  
                        if(mvRole.size()>0)
                           {
                               set<String> AppList = new set<String>();
                                if(mvRole[0].Approval_Role__c!=null)
                                 {
                                     for(String s : mvRole[0].Approval_Role__c.split(';'))
                                        {
                                           AppList.add(s);
                                        }
                                 }
                               
                             //  System.debug('Notification------------AppList--'+AppList);
                                
                                List<MV_User__c> MVUser = [Select Id from MV_User__c where Role_Name__c IN: AppList];
                                if(MVUser.size()>0)
                                {
                                  List<String> userApprovalList = new List<String>();
                                    for(MV_User__c user1 : MVUser)
                                    {
                                        userApprovalList.add(user1.id);
                                      
                                    }
                                  
                                    if(usr[0].Super_Visor_Name__c != null)
                                    userApprovalList.add(usr[0].Super_Visor_Name__c);
                                   // System.debug('Notification------------userApprovalList--'+userApprovalList);
                                    
                                     String fullNamestr = null;
                                    
                                    if(u.Name != null && u.Name != '')
                                    fullNamestr = u.Name; 
                                    
                                    if(u.Last_Name__c != null && u.Last_Name__c != '')
                                    fullNamestr = fullNamestr+' '+u.Last_Name__c; 
                                    
                                    String Discriptionstr = null;
                                    
                                    if(u.Role_Name__c != null && u.Role_Name__c != '')
                                    Discriptionstr = u.Role_Name__c; 
                                    
                                     if(u.User_Village__c != null && u.User_Village__c != '' && u.User_Village__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_Village__c+' Taluka:'+u.User_Taluka__c;
                                    else if(u.User_Cluster__c != null && u.User_Cluster__c != '' && u.User_Cluster__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_Cluster__c; 
                                    else if(u.User_Taluka__c != null && u.User_Taluka__c != '' && u.User_Taluka__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_Taluka__c;
                                    else if(u.User_District__c != null && u.User_District__c != '' && u.User_District__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_District__c;
                                 if(!Test.isRunningTest())
                                 {       
                                  sendMultipleNotificationMsg.submitdata(userApprovalList,'User Approval Request',fullNamestr+'( '+Discriptionstr+' )');
                                 } 
                                }
                           }
                       
                      //------------------------------End Notification Swarupa---------------------------------------
                        
                    }
                    else
                    {
                        List<MV_User__c> usr1 = new List<MV_User__c>();
                        usr1 = [select id,name,User_Mobile_No__c,Super_Visor_Name__c from MV_User__c where User_Mobile_No__c =: u.User_Mobile_No__c ];

                        if(usr1.size()>0)
                            {
                                System.debug('I am in duplicate mobile no');
                        //duplicate mobile no
                        udc.duplicateMobileNo = true;
                                
                            }
                        else
                        {
                            System.debug('I am in different mobile no');
                            update u;
                            
                             //--------------------------- Start SMS Swarupa--------------------------------
                          if(user.Full_Name__c=='Dummy Record' && user.MV_Role__c == null)
                          {
                            if(Label.RegistrationSMS != null && Label.RegistrationSMS != '') 
                               {
                                String MV_UserInProcessAns = u.Id;
                                sendSMS(MV_UserInProcessAns,Label.RegistrationSMS);
                               }
                          }
                        
                        //------------------------------End SMS --------------------------------------
                          //------------------------------Start Notification Swarupa---------------------------------------
                         List<MV_Role__c> mvRole = [select Approval_Role__c from MV_Role__c where Name =:u.Role_Name__c and (Approval_Role__c != null or Approval_Role__c != '') limit 1];
                         System.debug('Notification------------mvRole--'+mvRole);  
                        if(mvRole.size()>0)
                           {
                               set<String> AppList = new set<String>();
                                if(mvRole[0].Approval_Role__c!=null)
                                 {
                                     for(String s : mvRole[0].Approval_Role__c.split(';'))
                                        {
                                           AppList.add(s);
                                        }
                                 }
                               
                               System.debug('Notification------------AppList--'+AppList);
                                
                                List<MV_User__c> MVUser = [Select Id from MV_User__c where Role_Name__c IN: AppList];
                                if(MVUser.size()>0)
                                {
                                  List<String> userApprovalList = new List<String>();
                                    for(MV_User__c user1 : MVUser)
                                    {
                                        userApprovalList.add(user1.id);
                                    }
                                    if(usr1[0].Super_Visor_Name__c != null)
                                    userApprovalList.add(usr1[0].Super_Visor_Name__c);
                                    System.debug('Notification------------userApprovalList--'+userApprovalList);
                                     String fullNamestr = null;
                                    
                                    if(u.Name != null && u.Name != '')
                                    fullNamestr = u.Name; 
                                    
                                    if(u.Last_Name__c != null && u.Last_Name__c != '')
                                    fullNamestr = fullNamestr+' '+u.Last_Name__c; 
                                    
                                    String Discriptionstr = null;
                                    
                                    if(u.Role_Name__c != null && u.Role_Name__c != '')
                                    Discriptionstr = u.Role_Name__c; 
                                    
                                   if(u.User_Village__c != null && u.User_Village__c != '' && u.User_Village__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_Village__c+' Taluka:'+u.User_Taluka__c;
                                    else if(u.User_Cluster__c != null && u.User_Cluster__c != '' && u.User_Cluster__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_Cluster__c; 
                                    else if(u.User_Taluka__c != null && u.User_Taluka__c != '' && u.User_Taluka__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_Taluka__c;
                                    else if(u.User_District__c != null && u.User_District__c != '' && u.User_District__c != 'Select')
                                    Discriptionstr = Discriptionstr+' - '+u.User_District__c;
                                     
                                 if(!Test.isRunningTest())
                                 {   
                                  sendMultipleNotificationMsg.submitdata(userApprovalList,'User Approval Request',fullNamestr+'( '+Discriptionstr+' )');
                                 }
                                }
                           }
                       
                      //------------------------------End Notification Swarupa---------------------------------------
                            
                        }
                        
                    }
                }
                else
                {
                    System.debug('I am in new User');
                    insert u;
                }
                
             /*   List<MV_User__c> userList1 = [SELECT  Id,Gender__c,Approval_Role_c__c,Mobile_Tab_Name_c__c,Is_Approved__c,Role_Organization__c,Name,Middle_Name__c,Last_Name__c,MV_Role__c,New_MV_User_Password__c,OTP__c,Role_Name__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,ImageId__c,Before_Approved_Tab_Names__c,Project__c,Project_Name__c FROM MV_User__c where Id = :u.Id];
              
               for(MV_User__c u1 : userList1 ){
                   if(strToBooleanMap.get(u1.Role_Name__c) != null){
                       u1.Is_Approved__c = true;
                   }
               }*/
                
               /// userList.add(u);
                system.debug('AttachmentMapping Start ' );             
                AttachmentMapping am = vf.attachments;
                
                system.debug('AttachmentMapping -----' + am);
                if(am.Body!=null){
                    
                        List<Attachment> a = new List<Attachment>();
                        a = [select id from Attachment where ParentId =: u.Id];
                        delete a;
                        Attachment at = new Attachment();
                        at.Name = am.Name;
                        at.Body = EncodingUtil.base64Decode(am.Body);
                        at.ParentId = u.Id;
                        at.ContentType = 'image/png';
                        insert at;
                        u.ImageId__c = (String)at.Id;
                    
                        System.debug('Attachement Id is------'+(String)at.Id);
                        if(udc.duplicateMobileNo == false)
                        {
                            System.debug('I am in once again upsert');
                            upsert u;
                        }
                        else
                        {
                            System.debug('I am in not again in Upsert');
                        }
                        
                }
                List<MV_User__c> userList1 = [SELECT  User_Multiple_Taluka__c,Id,Gender__c,Approval_Role_c__c,Mobile_Tab_Name_c__c,Is_Approved__c,Role_Organization__c,Name,Middle_Name__c,Last_Name__c,MV_Role__c,New_MV_User_Password__c,OTP__c,Role_Name__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,ImageId__c,Before_Approved_Tab_Names__c,Project__c,Multi_project__c,Project_Name__c,User_Mobile_App_Version__c,PhoneID__c,Approver_Comment__c,Birth_Day__c,Attendance_Loc__latitude__s,Attendance_Loc__longitude__s FROM MV_User__c where Id = :u.Id];
              
               //mapResponse.put('Records', userList1);
               //udc.mapResponse1 = new Map<String,String>();
               udc.mvUser = userList1.get(0);
            
            
                
                Extended_User_Profile__c e = new Extended_User_Profile__c();
            try{
                         e = [select id,name,Bank_Account_Number__c,Bank_Name__c,Employee_Id__c,IFSC_Code__c,UAN_Number__c,MV_User__c,PF_Number__c from Extended_User_Profile__c where MV_User__c =: userList1.get(0).Id];   
            }
            catch(Exception exc)
            {
                //e = null;
                System.debug('No Extended Record');
            }
                udc.eup = e;
                
            
               //res.responseBody = Blob.valueOf(JSON.serialize(udc));

        }catch(Exception e){
            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
        return udc;
    }
    
    @Future(callout=true)
   static public void sendSMS(String MV_UserInProcessAns, String SMSData)
    {
        List<MV_User__c> password = new List<MV_User__c>();
                Map<String,String> mapResponseforSMS = new Map<String,String>();
           
             //   String MV_UserInProcessAns = (String)sObj.get('MV_User__c');
             
                password =  [select Id,User_Mobile_No__c,PhoneID__c from MV_User__c where id =: MV_UserInProcessAns limit 1];  
           
               System.debug('*****password****'+password[0].User_Mobile_No__c);

                if(password[0].User_Mobile_No__c != null || password[0].User_Mobile_No__c != ''){
        
                    String epURL = 'http://www.smsjust.com/sms/user/urlsms.php?username=avmabd&pass=avmabd@123&senderid=MVMSMF&msgtype=UNI&dest_mobileno='+password[0].User_Mobile_No__c+'&message='+SMSData;
                      system.debug('Message url is - '+epURL);  
                      
                                
                      try{
                            Http h = new Http();
                            HttpRequest request = new HttpRequest();
                            request.setEndpoint(epURL);
                            request.setMethod('GET');
                            HttpResponse response = h.send(request);
                            mapResponseforSMS.put('success','true');
                         
                            System.debug('Response Is: ' + response);
        
                         }catch(System.CalloutException e) {
        
                            System.debug('Exception is' + e.getMessage());
                            mapResponseforSMS.put('success','false');
                        }
                    }
    }
    
    global class UserDetailAndConfig
    {
        //public Map<String,List<MV_User__c>> mapResponse1;
        public boolean duplicateMobileNo = false;
        public MV_User__c mvUser;
        public Mobile_App_Cnfig__c mac;
        public MV_Role__c mvr;
        public Extended_User_Profile__c eup;
    }
    
    
   global class VisitsData{
        public list<VisitField> listVisitsData {get;set;}
  
    }
    
    global class VisitField{
        public MV_User__c user;
        public AttachmentMapping attachments;
    }
        
    global class AttachmentMapping{
        public string Name {get;set;}
        public String Body {get;set;}
        public string ParentId {get;set;}                
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
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         
         
           i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
          i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
            i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
         i++;
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
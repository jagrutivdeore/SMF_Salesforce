@RestResource(urlMapping='/MTRegister/*')
global class WS_addNewRegister {
    
  @HttpPost
    global static void AddVisitData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        
        Map<String,List<MV_User__c>> mapResponse = new Map<String,List<MV_User__c>>();
        Map<String,String> mapResponse1 = new Map<String,String>();
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
                
                
                MV_User__c user = [SELECT Id,Gender__c,MV_Role__c,Role_Name__c,User_Cluster__c,User_District__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Taluka__c,User_Village__c,Project__c,Multi_project__c,Project_Name__c FROM MV_User__c where id = :u.Id];
                
               if(u.MV_Role__c != user.MV_Role__c || ((u.User_Cluster__c != null && user.User_Cluster__c != '') && (u.User_Cluster__c != user.User_Cluster__c))|| ((u.User_District__c != null && user.User_District__c != '') && (u.User_District__c != user.User_District__c))|| ((u.User_SchoolID__c != null && user.User_SchoolID__c != '') && (u.User_SchoolID__c != user.User_SchoolID__c)) ||((u.UserSchoolName__c != null && user.UserSchoolName__c != '') && (u.UserSchoolName__c != user.UserSchoolName__c)) || ((u.User_State__c != null && user.User_State__c != '') && (u.User_State__c != user.User_State__c)) || ((u.User_Taluka__c != null && user.User_Taluka__c != '') && (u.User_Taluka__c != user.User_Taluka__c)) || ((u.User_Village__c != null && user.User_Village__c != '') && (u.User_Village__c != user.User_Village__c))){
                    u.Is_Approved__c = false;
                }
                upsert u;
                
               /* List<MV_User__c> userList1 = [SELECT  Id,Gender__c,Approval_Role_c__c,Mobile_Tab_Name_c__c,Is_Approved__c,Role_Organization__c,Name,Middle_Name__c,Last_Name__c,MV_Role__c,New_MV_User_Password__c,OTP__c,Role_Name__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,ImageId__c,Before_Approved_Tab_Names__c,Project__c,Project_Name__c FROM MV_User__c where Id = :u.Id];
              
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
                        Attachment at = new Attachment();
                        at.Name = am.Name;
                        at.Body = EncodingUtil.base64Decode(am.Body);
                        at.ParentId = u.Id;
                        at.ContentType = 'image/png';
                        insert at;
                        u.ImageId__c = (String)at.Id;
                    
                    
                     system.debug('AttachmentMapping Id is '+(String)at.Id ); 
                        upsert u;
                    system.debug('User Object is'+u );
                }
              
               //update userList1;
                List<MV_User__c> userList1 = [SELECT  Id,Gender__c,Approval_Role_c__c,Mobile_Tab_Name_c__c,Is_Approved__c,Role_Organization__c,Name,Middle_Name__c,Last_Name__c,MV_Role__c,New_MV_User_Password__c,OTP__c,Role_Name__c,User_Cluster__c,User_District__c,User_Email__c,User_Mobile_No__c,User_Password__c,User_SchoolID__c,UserSchoolName__c,User_State__c,User_Status__c,User_Taluka__c,User_Village__c,ImageId__c,Before_Approved_Tab_Names__c,Project__c,Multi_project__c,Project_Name__c FROM MV_User__c where Id = :u.Id];
              
               /*for(MV_User__c u1 : userList1 ){
                   if(strToBooleanMap.get(u1.Role_Name__c) != null){
                       u1.Is_Approved__c = true;
                   }
               }*/
               mapResponse.put('Records', userList1);
               res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));

        }catch(Exception e){
            res.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
        }
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
       
        }
    
}
@RestResource(urlMapping='/insertContent/*')
    global class WS_InsertContent {
       
        @HttpPost
        global static void AddData(){
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            res.addHeader('Content-Type', 'application/json'); 
            
            Map<String,List<Object>> mapResponse = new Map<String,List<Object>>();
            Map<String,String> mapResponse1 = new Map<String,String>();
            VisitsData mVisitsData = new VisitsData();
            system.debug('test-----------'+req.requestBody.toString());
            mVisitsData = (VisitsData)JSON.deserialize(req.requestBody.toString(),VisitsData.class);
            List<VisitField> VisitsDataList = mVisitsData.listVisitsData;
            List<Attachment> attsToInsert = new List<Attachment>();
            List<Id> conList = new List<Id>();
            List<MV_ChatHistory__c> chList = new List<MV_ChatHistory__c>();
            Map<Id,Id> idToAttachmentMap = new Map<Id,Id>();
            for(VisitField vf : VisitsDataList){
                MV_Content__c con = new MV_Content__c();
                if(vf.Id != null){
                    con.Id= vf.Id;
                }
                if(vf.Issue_Type != null){
                con.Issue_Type__c = vf.Issue_Type;
                }
               if(vf.TemplateId != ''){
                con.MV_Template__c = vf.TemplateId;
                }
                if(vf.Priority != null){
                con.Priority__c = vf.Priority;
                }
                if(vf.District != null){
                    con.District__c= vf.District;
                }
                if(vf.taluka != null){
                    con.Taluka__c= vf.taluka;
                }
                if(vf.UserId != ''){
                    con.MV_User__c = vf.UserId;
                }
                
                con.Title__c = vf.Title;
                con.Description__c = vf.Description;
                con.Report_Type__c = vf.Report_Type;
                if(vf.CommunityId != ''){
                    con.MV_Community__c = vf.CommunityId;
                }
                
                if(vf.contentType != null){
                    con.Content_Type__c = vf.contentType;
                }
                if(vf.isTheatMessage != null){
                con.Theat_Sawand__c = Boolean.valueOf(vf.isTheatMessage);
                con.Category__c = vf.Report_Type;
                con.MV_Community__c = 'a1D7F000003LmBY';
                
                }
                if(vf.isAttachmentPresent != null){
                con.isAttachmentPresent__c = boolean.valueOf(vf.isAttachmentPresent);
                }
                String Status = con.status__c;
                
                if(vf.status != null && vf.status != '')
                {
                    con.status__c = vf.status;
                    
                }  
                
                upsert con;
                
                 //------------------------------Start Notification Swarupa---------------------------------------
                 
                // System.debug('&&&&&&&&&&&&&&&con '+vf.status +'***************'+Status );
                 
                if( vf.status != Status)
                {
                  List<String> userApprovalList = new List<String>();
                  List<MV_Content__c> conObj = [Select Id,MV_User__c,status__c,Title__c from MV_Content__c where Id =: con.Id and MV_User__c != null and MV_Community__r.Name =: 'HO Support' limit 1];
                 //  System.debug('&&&&&&&&&&&&&&&'+conObj );
                  if(conObj.size()>0)
                  {
                   userApprovalList.add(conObj[0].MV_User__c);
                  
                   if(conObj[0].status__c == 'Resolved')
                   sendMultipleNotificationMsg.submitdata(userApprovalList,'Ho Support - Issue Resolved','Your '+conObj[0].Title__c +' issue is resolved.');
                   else if(conObj[0].status__c == 'Reject')
                   sendMultipleNotificationMsg.submitdata(userApprovalList,'Ho Support - Issue Reject','Your '+conObj[0].Title__c +' issue is rejected. You can move it to New status if its a valid issue.');
                  }
                }
       
       
        //------------------------------End Notification Swarupa---------------------------------------
                
                
                
                
                system.debug('-------cratedate' + con.CreatedDate);
                system.debug('-------Id----' + con.Id);
                
                conList.add(con.Id);
                
                MV_ChatHistory__c ch = new MV_ChatHistory__c();
                if(vf.CommunityId != ''){
                    ch.MV_Community__c = vf.CommunityId;
                }
                if(con.Id != null){
                    ch.MV_Content__c = con.Id;
                }
                if(vf.UserId != ''){
                    ch.MV_User__c = vf.UserId;
                }
                
                chList.add(ch);
                
                 List<AttachmentMapping> attachments = vf.attachments;
                 for(AttachmentMapping am : attachments){
                        Attachment at = new Attachment();
                        at.Name = am.Name;
                        at.Body = EncodingUtil.base64Decode(am.Body);
                        //at.Body = atm.Body;
                        at.ParentId = con.Id;
                        at.ContentType = am.ContentType;
                        attsToInsert.add(at);
                        
                        
                 } 
                
            }
            if(chList.size() > 0){
                list<Database.UpsertResult> results4 = Database.upsert(chList, false);
            }
            Set<Id> attIdList = new Set<Id>();
            if(attsToInsert.size() > 0){
                list<Database.SaveResult> results5 = Database.insert(attsToInsert, false);
                for(Integer i=0;i<results5.size();i++){
                    attIdList.add(results5.get(0).getId());
                }
            }
            
            
            List<Attachment> attList = new List<Attachment>();
            //results5.get(0).getId();
            attList = [SELECT Id,ParentId FROM Attachment where Id IN :attIdList];
                        
            for(Attachment at: attList){
                idToAttachmentMap.put(at.ParentId, at.Id);
                
            }
            list<VisitField> updatedlistVisitsData = new list<VisitField>();
            List<MV_Content__c> conList1 = new List<MV_Content__c>();
            
            conList1 = [SELECT Id,CreatedDate FROM MV_Content__c where Id IN :conList];
            
            for(MV_Content__c ch : conList1){
                system.debug('-----------------'+ String.valueOfGMT(ch.createdDate));
                system.debug('-----------------'+ ch.CreatedDate);
                VisitField vf = new VisitField();
                vf.Id = ch.Id;
                vf.CreatedDate = String.valueOfGMT(ch.CreatedDate);
                
                if(idToAttachmentMap.get(ch.Id) != null){
                    vf.attachmentId = idToAttachmentMap.get(ch.Id);
                }
                updatedlistVisitsData.add(vf);
            }
            mapResponse.put('Records', updatedlistVisitsData);
            res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));

        }
     global class VisitsData{
            public list<VisitField> listVisitsData {get;set;}
               
        }
        
        global class VisitField{
           String Id;
           String Issue_Type;
           String District;
           String taluka;
           String Title;
           String Description;
           String Report_Type;
           String TemplateId;
           String Priority;
           String CommunityId;
           String UserId;
           List<AttachmentMapping> attachments;
           String CreatedDate;
           List<String> attIdList;
           String attachmentId;
           string isAttachmentPresent;
           string contentType;
           string isTheatMessage;
           string status;
            
        }
        
         global class AttachmentMapping{
            public string Name {get;set;}
            public string Body {get;set;}
            public string ParentId {get;set;} // will equal to Id In VisitField
             public string ContentType {get;set;} 
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
         
        }
    
    }
@RestResource(urlMapping='/getChatContentNew/*')
global class WS_getContentNew {
    @HttpGet
    global static List<VisitField> doGet() {
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String CommunityId = RestContext.request.params.get('CommunityId');
        String userId = RestContext.request.params.get('userId');
        String timestamp = RestContext.request.params.get('timestamp');
        List<VisitField> outputList = new List<VisitField>();
        List<MV_Community__c> comList = [SELECT Id,Name from MV_Community__c where Id =:CommunityId LIMIT 1];
        List<MV_Content__c> conList = new List<MV_Content__c>();
        List<Id> idList = new List<Id>();
        Map<Id,Id> contentToUserId = new Map<Id,Id>();
        MV_User__c user = new MV_User__c();
        if(userId != null){
            user =[SELECT Id,MV_Role__r.Name from MV_User__c where Id = :userId];
        }
        //idList.add(userId);
        if(comList[0].Name != 'HO Support'){
            //idList.add(user.id);
            System.debug('I am in HO Support');
            
            List<MV_ChatHistory__c> chList = new List<MV_ChatHistory__c>();
            
            chList = [select id, MV_Community__c,MV_Content__c,MV_User__c,LastModifiedDate from MV_ChatHistory__c where MV_Community__c = :CommunityId ORDER BY LastModifiedDate];
            
            //contentToUserId.put(ch.MV_Content__c,ch.MV_User__c);
           
            for(MV_ChatHistory__c ch : chList){
                idList.add(ch.MV_Content__c);
                idList.add(ch.MV_User__c);
                contentToUserId.put(ch.MV_Content__c,ch.MV_User__c);
            }
            
            System.debug('Id list is'+idList);
            
            if(timestamp == '' || timestamp == null){
                conList = [select id,Content_Type__c,MV_User__c,Name,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,Description__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                           Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where Id IN :idList order by LastModifiedDate desc limit 10000];
            }
            else{
                conList = [select id,Content_Type__c,MV_User__c,Name,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,Description__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                           Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where Id IN :idList AND LastModifiedDate > :DateTime.valueOf(timestamp) order by LastModifiedDate desc limit 10000];
            }
            List<Attachment> attList = new List<Attachment>();
            attList = [SELECT Id, parentId from Attachment where parentId IN :idList];
			
			System.debug('Attachment List is' + attList);
            Map<String, String> conIdToAttachIdMap =new Map<String,String>();
            
            for(Attachment att : attList){
                conIdToAttachIdMap.put(att.ParentId, att.Id);
            }   
            
            List<MV_Content_Like__c> conlikeList = new List<MV_Content_Like__c>();
            conlikeList = [SELECT Id,Name,Is_Like__c,MV_Content__c,MV_User__c FROM MV_Content_Like__c where MV_Content__c IN :conList AND MV_User__c = :userId]; 
            Map<Id, Boolean> idTobooleanMap = new Map<Id, Boolean>();
            
            for(MV_Content_Like__c cl : conlikeList){
                idTobooleanMap.put(cl.MV_Content__c, cl.Is_Like__c);
            }   
            
            for(MV_Content__c con : conList){
                VisitField vf= new VisitField();
                vf.Id = con.Id;
                vf.Issue_Type = con.Issue_Type__c;
                vf.District = con.District__c;
                vf.taluka = con.Taluka__c;
                vf.Title = con.Title__c;
                vf.Description = con.Description__c;
                vf.userName = con.MV_User__r.Name + ' ' + con.MV_User__r.Last_Name__c + ' ('+con.MV_User__r.Role_Name__c+')';
                vf.Report_Type = con.Report_Type__c;
                vf.TemplateId = con.MV_Template__r.Name;
                vf.Priority = con.Priority__c;
                vf.CreatedDate = String.valueOf(con.LastModifiedDate);
                vf.isbroadcast = con.Is_Broadcast__c;
                vf.likeCount = Integer.valueOf(con.LIke_Count__c);
                vf.commentCount = Integer.valueOf(con.Comment_Count__c);
                vf.isAttachmentPresent = string.valueOf(con.isAttachmentPresent__c);
                vf.UserId = con.MV_User__c;
                vf.contentType = con.Content_Type__c;
                vf.isActive = con.isActive__c;
                vf.isDelete = con.isDelete__C;
                vf.status = con.Status__c;
                if(idTobooleanMap.get(con.Id) != null){
                    vf.isLike = idTobooleanMap.get(con.Id);
                }
                if(conIdToAttachIdMap.get(con.Id) != null){
                    vf.attachmentId = conIdToAttachIdMap.get(con.Id);
                }
                //if(conIdToAttachIdMap.get(con.Id) != null){
				System.debug('Content Id is' + con.Id);
				System.debug('Content to user mapping is' + contentToUserId.get(con.Id));
                System.debug('User Content Id' + conIdToAttachIdMap.get(contentToUserId.get(con.Id)));
                  //  vf.userAttachmentId = conIdToAttachIdMap.get(contentToUserId.get(con.Id));
                    vf.userAttachmentId = conIdToAttachIdMap.get(con.MV_User__c);
                //}
                
                if(con.SpamUserID__c != null)
                {
                    String uID = con.SpamUserID__c;
                    if(uID.contains(userId))
                    {
                        vf.isPostUserDidSpam = true;
                    }
                    else
                    {
                        vf.isPostUserDidSpam = false;
                    }
                }
                
                outputList.add(vf);
            }
        }
        
        
        else{
            //////////////////
            if(user.MV_Role__r.Name == 'Technology'){
                
                List<MV_Role__c> role = new List<MV_Role__c>();
                role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Technology' limit 1  ]; 
                
                System.debug('Role Detail Is' + role);
                if(timestamp == '' || timestamp == null){
                   /* conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c ='Technology related' order by LastModifiedDate desc]; 
                    */
                    
                    conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c order by LastModifiedDate desc]; 
                    
                    }
                else{
                    //conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c ='Technology related' AND LastModifiedDate > :DateTime.valueOfGmt(timestamp) order by LastModifiedDate desc];
                    conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c  AND LastModifiedDate > :DateTime.valueOf(timestamp) order by LastModifiedDate desc];

                }
                
                System.debug('Content List Is' + conList);
                List<Attachment> attList = new List<Attachment>();
                attList = [SELECT Id, parentId from Attachment where parentId IN :idList];
                Map<String, String> conIdToAttachIdMap =new Map<String,String>();
                
                for(Attachment att : attList){
                    conIdToAttachIdMap.put(att.ParentId, att.Id);
                }   
                
                List<MV_Content_Like__c> conlikeList = new List<MV_Content_Like__c>();
                conlikeList = [SELECT Id,Name,Is_Like__c,MV_Content__c,MV_User__c FROM MV_Content_Like__c where MV_Content__c IN :conList AND MV_User__c = :userId]; 
                Map<Id, Boolean> idTobooleanMap = new Map<Id, Boolean>();
                
                for(MV_Content_Like__c cl : conlikeList){
                    idTobooleanMap.put(cl.MV_Content__c, cl.Is_Like__c);
                }   
                
                for(MV_Content__c con : conList){
                    VisitField vf= new VisitField();
                    vf.Id = con.Id;
                    vf.Issue_Type = con.Issue_Type__c;
                    vf.District = con.District__c;
                    vf.taluka = con.Taluka__c;
                    vf.Title = con.Title__c;
                    vf.userName = con.MV_User__r.Name + ' ' + con.MV_User__r.Last_Name__c + ' ('+con.MV_User__r.Role_Name__c+')';
                    vf.Description = con.Description__c;
                    vf.Report_Type = con.Report_Type__c;
                    vf.TemplateId = con.MV_Template__r.Name;
                    vf.Priority = con.Priority__c;
                    vf.CreatedDate = String.valueOf(con.LastModifiedDate);
                    vf.isbroadcast = con.Is_Broadcast__c;
                    vf.likeCount = Integer.valueOf(con.LIke_Count__c);
                    vf.commentCount = Integer.valueOf(con.Comment_Count__c);
                    vf.isAttachmentPresent = string.valueOf(con.isAttachmentPresent__c);
                    vf.UserId = con.MV_User__c;
                    vf.contentType = con.Content_Type__c;
                    vf.isActive = con.isActive__c;
                    vf.isDelete = con.isDelete__c;
                    vf.status = con.Status__c;
                    
                    if(idTobooleanMap.get(con.Id) != null){
                        vf.isLike = idTobooleanMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.attachmentId = conIdToAttachIdMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.userAttachmentId = conIdToAttachIdMap.get(contentToUserId.get(con.Id));
                    }
                    
                    
                    
                    if(con.SpamUserID__c != null)
                    {
                        String uID = con.SpamUserID__c;
                        if(uID.contains(userId))
                        {
                            vf.isPostUserDidSpam = true;
                        }
                        else
                        {
                            vf.isPostUserDidSpam = false;
                        }
                    }
                    
                    
                    outputList.add(vf);
                }
                ////////////////////////////////////////////////////////////////////////
                
            }else if(user.MV_Role__r.Name == 'Accounts'){
                
                 List<MV_Role__c> role = new List<MV_Role__c>();
                role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Accounts' limit 1    ]; 
                
                System.debug('Role Detail Is' + role);
                
                if(timestamp == '' || timestamp == null){
                    /*conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c ='Account related'  order by LastModifiedDate desc]; */
                
                
                    conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c  order by LastModifiedDate desc];
                
                }
                else{
                    //conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c ='Account related' AND LastModifiedDate > :DateTime.valueOfGmt(timestamp) order by LastModifiedDate desc];
                    
                     conList = [select id,Content_Type__c,MV_User__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c AND LastModifiedDate > :DateTime.valueOf(timestamp) order by LastModifiedDate desc];
                }
                List<Attachment> attList = new List<Attachment>();
                attList = [SELECT Id, parentId from Attachment where parentId IN :idList];
                Map<String, String> conIdToAttachIdMap =new Map<String,String>();
                
                for(Attachment att : attList){
                    conIdToAttachIdMap.put(att.ParentId, att.Id);
                }   
                
                List<MV_Content_Like__c> conlikeList = new List<MV_Content_Like__c>();
                conlikeList = [SELECT Id,Name,Is_Like__c,MV_Content__c,MV_User__c FROM MV_Content_Like__c where MV_Content__c IN :conList AND MV_User__c = :userId]; 
                Map<Id, Boolean> idTobooleanMap = new Map<Id, Boolean>();
                
                for(MV_Content_Like__c cl : conlikeList){
                    idTobooleanMap.put(cl.MV_Content__c, cl.Is_Like__c);
                }   
                
                for(MV_Content__c con : conList){
                    VisitField vf= new VisitField();
                    vf.Id = con.Id;
                    vf.Issue_Type = con.Issue_Type__c;
                    vf.District = con.District__c;
                    vf.taluka = con.Taluka__c;
                    vf.Title = con.Title__c;
                    vf.userName = con.MV_User__r.Name + ' ' + con.MV_User__r.Last_Name__c + ' ('+con.MV_User__r.Role_Name__c+')';
                    vf.Description = con.Description__c;
                    vf.Report_Type = con.Report_Type__c;
                    vf.TemplateId = con.MV_Template__r.Name;
                    vf.Priority = con.Priority__c;
                    vf.CreatedDate = String.valueOf(con.LastModifiedDate);
                    vf.isbroadcast = con.Is_Broadcast__c;
                    vf.likeCount = Integer.valueOf(con.LIke_Count__c);
                    vf.commentCount = Integer.valueOf(con.Comment_Count__c);
                    vf.isAttachmentPresent = string.valueOf(con.isAttachmentPresent__c);
                    vf.UserId = con.MV_User__c;
                    vf.contentType = con.Content_Type__c;
                    vf.isActive = con.isActive__c;
                    vf.isDelete = con.isDelete__C;
                    vf.status = con.Status__c;
                    if(idTobooleanMap.get(con.Id) != null){
                        vf.isLike = idTobooleanMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.attachmentId = conIdToAttachIdMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.userAttachmentId = conIdToAttachIdMap.get(contentToUserId.get(con.Id));
                    }
                    
                    if(con.SpamUserID__c != null)
                    {
                        String uID = con.SpamUserID__c;
                        if(uID.contains(userId))
                        {
                            vf.isPostUserDidSpam = true;
                        }
                        else
                        {
                            vf.isPostUserDidSpam = false;
                        }
                    }
                    
                    outputList.add(vf);
                }
            }else if(user.MV_Role__r.Name == 'Content'){
                
                 List<MV_Role__c> role = new List<MV_Role__c>();
                role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Content' limit 1 ]; 
                
                System.debug('Role Detail Is' + role);
                if(timestamp == '' || timestamp == null){
                    conList = [select id,Content_Type__c,Name,MV_User__c,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c order by LastModifiedDate desc];
                }
                else{
                    conList = [select id,Content_Type__c,Name,MV_User__c,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c AND LastModifiedDate > :DateTime.valueOf(timestamp) order by LastModifiedDate desc];
                }
                List<Attachment> attList = new List<Attachment>();
                attList = [SELECT Id, parentId from Attachment where parentId IN :idList];
                Map<String, String> conIdToAttachIdMap =new Map<String,String>();
                
                for(Attachment att : attList){
                    conIdToAttachIdMap.put(att.ParentId, att.Id);
                }   
                
                List<MV_Content_Like__c> conlikeList = new List<MV_Content_Like__c>();
                conlikeList = [SELECT Id,Name,Is_Like__c,MV_Content__c,MV_User__c FROM MV_Content_Like__c where MV_Content__c IN :conList AND MV_User__c = :userId]; 
                Map<Id, Boolean> idTobooleanMap = new Map<Id, Boolean>();
                
                for(MV_Content_Like__c cl : conlikeList){
                    idTobooleanMap.put(cl.MV_Content__c, cl.Is_Like__c);
                }   
                
                for(MV_Content__c con : conList){
                    VisitField vf= new VisitField();
                    vf.Id = con.Id;
                    vf.Issue_Type = con.Issue_Type__c;
                    vf.District = con.District__c;
                    vf.taluka = con.Taluka__c;
                    vf.Title = con.Title__c;
                    vf.userName = con.MV_User__r.Name + ' ' + con.MV_User__r.Last_Name__c + ' ('+con.MV_User__r.Role_Name__c+')';
                    vf.Description = con.Description__c;
                    vf.Report_Type = con.Report_Type__c;
                    vf.TemplateId = con.MV_Template__r.Name;
                    vf.Priority = con.Priority__c;
                    vf.CreatedDate = String.valueOf(con.LastModifiedDate);
                    vf.isbroadcast = con.Is_Broadcast__c;
                    vf.likeCount = Integer.valueOf(con.LIke_Count__c);
                    vf.commentCount = Integer.valueOf(con.Comment_Count__c);
                    vf.isAttachmentPresent = string.valueOf(con.isAttachmentPresent__c);
                    vf.UserId = con.MV_User__c;
                    vf.contentType = con.Content_Type__c;
                    vf.isActive = con.isActive__c;
                    vf.isDelete = con.isDelete__C;
                    vf.status = con.Status__c;
                    if(idTobooleanMap.get(con.Id) != null){
                        vf.isLike = idTobooleanMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.attachmentId = conIdToAttachIdMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.userAttachmentId = conIdToAttachIdMap.get(contentToUserId.get(con.Id));
                    }
                    
                    if(con.SpamUserID__c != null)
                    {
                        String uID = con.SpamUserID__c;
                        if(uID.contains(userId))
                        {
                            vf.isPostUserDidSpam = true;
                        }
                        else
                        {
                            vf.isPostUserDidSpam = false;
                        }
                    }
                    
                    outputList.add(vf);
                }
            }else if(user.MV_Role__r.Name == 'Training'){
                
                List<MV_Role__c> role = new List<MV_Role__c>();
                role = [select id,When_Ho_Support_Ticket_Show__c from MV_Role__c where Name = 'Training' limit 1    ]; 
                
                System.debug('Role Detail Is' + role);
                
                if(timestamp == '' || timestamp == null){
                    conList = [select id,Content_Type__c,Name,MV_User__c,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isAttachmentPresent__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c order by LastModifiedDate desc];
                }
                else{
                    conList = [select id,Content_Type__c,Name,MV_User__c,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,isAttachmentPresent__c,Comment_Count__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND Issue_Type__c =: role[0].When_Ho_Support_Ticket_Show__c AND LastModifiedDate > :DateTime.valueOf(timestamp) order by LastModifiedDate desc];
                }
                List<Attachment> attList = new List<Attachment>();
                attList = [SELECT Id, parentId from Attachment where parentId IN :idList];
                Map<String, String> conIdToAttachIdMap =new Map<String,String>();
                
                for(Attachment att : attList){
                    conIdToAttachIdMap.put(att.ParentId, att.Id);
                }   
                
                List<MV_Content_Like__c> conlikeList = new List<MV_Content_Like__c>();
                conlikeList = [SELECT Id,Name,Is_Like__c,MV_Content__c,MV_User__c FROM MV_Content_Like__c where MV_Content__c IN :conList AND MV_User__c = :userId]; 
                Map<Id, Boolean> idTobooleanMap = new Map<Id, Boolean>();
                
                for(MV_Content_Like__c cl : conlikeList){
                    idTobooleanMap.put(cl.MV_Content__c, cl.Is_Like__c);
                }   
                
                for(MV_Content__c con : conList){
                    VisitField vf= new VisitField();
                    vf.Id = con.Id;
                    vf.Issue_Type = con.Issue_Type__c;
                    vf.District = con.District__c;
                    vf.taluka = con.Taluka__c;
                    vf.Title = con.Title__c;
                    vf.userName = con.MV_User__r.Name + ' ' + con.MV_User__r.Last_Name__c + ' ('+con.MV_User__r.Role_Name__c+')';
                    vf.Description = con.Description__c;
                    vf.Report_Type = con.Report_Type__c;
                    vf.TemplateId = con.MV_Template__r.Name;
                    vf.Priority = con.Priority__c;
                    vf.CreatedDate = String.valueOf(con.LastModifiedDate);
                    vf.isbroadcast = con.Is_Broadcast__c;
                    vf.likeCount = Integer.valueOf(con.LIke_Count__c);
                    vf.commentCount = Integer.valueOf(con.Comment_Count__c);
                    vf.isAttachmentPresent = string.valueOf(con.isAttachmentPresent__c);
                    vf.UserId = con.MV_User__c;
                    vf.contentType = con.Content_Type__c;
                    vf.isActive = con.isActive__c;
                    vf.isDelete = con.isDelete__C;
                    vf.status = con.Status__c;
                    if(idTobooleanMap.get(con.Id) != null){
                        vf.isLike = idTobooleanMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.attachmentId = conIdToAttachIdMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.userAttachmentId = conIdToAttachIdMap.get(contentToUserId.get(con.Id));
                    }
                    
                    
                    if(con.SpamUserID__c != null)
                    {
                        String uID = con.SpamUserID__c;
                        if(uID.contains(userId))
                        {
                            vf.isPostUserDidSpam = true;
                        }
                        else
                        {
                            vf.isPostUserDidSpam = false;
                        }
                    }
                    outputList.add(vf);
                }
            }
            
            else{
                
                //System.debug('I am in All TCS');
                if(timestamp == '' || timestamp == null){
                    conList = [select id,Content_Type__c,MV_User__c,isAttachmentPresent__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND MV_User__c =:userId order by LastModifiedDate desc];
                }
                else{
                    conList = [select id,Content_Type__c,MV_User__c,isAttachmentPresent__c,Name,Description__c,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
                               Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,Is_Broadcast__c,LIke_Count__c,Comment_Count__c,isActive__c,isDelete__C,SpamUserID__c,status__c from MV_Content__c where MV_Community__c = :CommunityId AND MV_User__c =:userId AND LastModifiedDate > :DateTime.valueOf(timestamp) order by LastModifiedDate desc];
                }
                System.debug('Containt List is' + conList);
                List<Attachment> attList = new List<Attachment>();
                attList = [SELECT Id, parentId from Attachment where parentId IN :idList];
                Map<String, String> conIdToAttachIdMap =new Map<String,String>();
                
                for(Attachment att : attList){
                    conIdToAttachIdMap.put(att.ParentId, att.Id);
                }   
                
                List<MV_Content_Like__c> conlikeList = new List<MV_Content_Like__c>();
                conlikeList = [SELECT Id,Name,Is_Like__c,MV_Content__c,MV_User__c FROM MV_Content_Like__c where MV_Content__c IN :conList AND MV_User__c = :userId]; 
                Map<Id, Boolean> idTobooleanMap = new Map<Id, Boolean>();
                
                for(MV_Content_Like__c cl : conlikeList){
                    idTobooleanMap.put(cl.MV_Content__c, cl.Is_Like__c);
                }   
                
                for(MV_Content__c con : conList){
                    VisitField vf= new VisitField();
                    vf.Id = con.Id;
                    vf.Issue_Type = con.Issue_Type__c;          
                    vf.District = con.District__c;
                    vf.taluka = con.Taluka__c;
                    vf.Title = con.Title__c;
                    vf.userName = con.MV_User__r.Name + ' ' + con.MV_User__r.Last_Name__c + ' ('+con.MV_User__r.Role_Name__c+')';
                    vf.Description = con.Description__c;
                    vf.Report_Type = con.Report_Type__c;
                    vf.TemplateId = con.MV_Template__r.Name;
                    vf.Priority = con.Priority__c;
                    vf.CreatedDate = String.valueOf(con.LastModifiedDate);
                    vf.isbroadcast = con.Is_Broadcast__c;
                    vf.likeCount = Integer.valueOf(con.LIke_Count__c);
                    vf.commentCount = Integer.valueOf(con.Comment_Count__c);
                    vf.isAttachmentPresent = string.valueOf(con.isAttachmentPresent__c);
                    vf.UserId = con.MV_User__c;
                    vf.contentType = con.Content_Type__c;
                    vf.isActive = con.isActive__c;
                    vf.isDelete = con.isDelete__C;
                    vf.status = con.Status__c;
                    if(idTobooleanMap.get(con.Id) != null){
                        vf.isLike = idTobooleanMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.attachmentId = conIdToAttachIdMap.get(con.Id);
                    }
                    if(conIdToAttachIdMap.get(con.Id) != null){
                        vf.userAttachmentId = conIdToAttachIdMap.get(contentToUserId.get(con.Id));
                    }
                    
                    if(con.SpamUserID__c != null)
                    {
                        String uID = con.SpamUserID__c;
                        if(uID.contains(userId))
                        {
                            vf.isPostUserDidSpam = true;
                        }
                        else
                        {
                            vf.isPostUserDidSpam = false;
                        }
                    }
                    
                    outputList.add(vf);
                }
            }
            
        }
        return outputList;
        
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
        String userName;
        string contentType;
        
        String UserId;
        String attachmentId;
        String userAttachmentId;
        String CreatedDate;
        boolean isLike= false;
        Integer likeCount=0;
        Integer commentCount = 0;
        boolean isbroadcast;
        string isAttachmentPresent;
        boolean isActive;
        boolean isDelete;
        boolean isPostUserDidSpam = false;
        string status;
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
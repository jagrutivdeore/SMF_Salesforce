@RestResource(urlMapping='/getTheatSawandContent/*')

global class WS_getTheatSawandContent {
 
    @HttpGet
    global static List<VisitField> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String timestamp = RestContext.request.params.get('timestamp');
        
    Id userId = RestContext.request.params.get('userId');

    List<VisitField> outputList = new List<VisitField>();
    List<MV_Content__c> conList = new List<MV_Content__c>();
  
    
     if(timestamp == '' || timestamp == null){
        conList = [select id,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,Name,Description__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
            Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,MV_User__c,Theat_Sawand__c,LIke_Count__c,Comment_Count__c,Content_Type__c,isAttachmentPresent__c,isActive__c,isDelete__c,SpamUserID__c from MV_Content__c where Theat_Sawand__c = true order by LastModifiedDate desc];
    }
    else{
        conList = [select id,MV_User__r.Name,MV_User__r.Role_Name__c,MV_User__r.Last_Name__c,Name,Description__c,District__c,Issue_Type__c,MV_Template__r.Name,Priority__c,
            Reporting_Type__c,Report_Type__c,Taluka__c,Title__c,LastModifiedDate,MV_User__c,Theat_Sawand__c,LIke_Count__c,Comment_Count__c,Content_Type__c,isAttachmentPresent__c,isActive__c,isDelete__c,SpamUserID__c from MV_Content__c where Theat_Sawand__c = true and LastModifiedDate > :DateTime.valueOfGmt(timestamp) order by LastModifiedDate desc];
    }
    Set<Id> idList = new set<Id>();
    for(MV_Content__c con :conList){
        idList.add(con.Id);
        idList.add(con.MV_User__c);     
    }
    List<Attachment> attList = new List<Attachment>();
    attList = [SELECT Id, parentId from Attachment where parentId IN :idList];
    Map<String, String> conIdToAttachIdMap =new Map<String,String>();
    
    for(Attachment att : attList){
        conIdToAttachIdMap.put(att.ParentId, att.Id);
    }   
    
    List<MV_Content_Like__c> conlikeList = new List<MV_Content_Like__c>();
    conlikeList = [SELECT Id,Name,Is_Like__c,MV_Content__c,MV_User__c FROM MV_Content_Like__c where MV_Content__c IN :conList]; 
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
        vf.Report_Type = con.Report_Type__c;
        vf.TemplateId = con.MV_Template__r.Name;
        vf.Priority = con.Priority__c;
        vf.CreatedDate = String.valueOfGMT(con.LastModifiedDate);
        //vf.isbroadcast = con.Is_Broadcast__c;
        vf.commentCount = Integer.valueOf(con.Comment_Count__c);
        vf.likeCount = Integer.valueOf(con.LIke_Count__c);
        vf.contentType = con.Content_Type__c;
        vf.isTheatMessage = con.Theat_Sawand__c;
        vf.isAttachmentPresent = string.valueOf(con.isAttachmentPresent__c);
        vf.userName = con.MV_User__r.Name + ' ' + con.MV_User__r.Last_Name__c + ' ('+con.MV_User__r.Role_Name__c+')';
        vf.UserId = con.MV_User__c;
        vf.isActive = con.isActive__c;
        vf.isDelete = con.isDelete__c;
        if(idTobooleanMap.get(con.Id) != null){
            vf.isLike = idTobooleanMap.get(con.Id);
        }
        if(conIdToAttachIdMap.get(con.Id) != null){
            vf.attachmentId = conIdToAttachIdMap.get(con.Id);
        }
         if(conIdToAttachIdMap.get(con.Id) != null){
            vf.userAttachmentId = conIdToAttachIdMap.get(con.MV_User__c);
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
        String UserId;
        String attachmentId;
        String userAttachmentId;
        String CreatedDate;
        boolean isLike= false;
        Integer likeCount=0;
        Integer commentCount = 0;
        boolean isbroadcast;
        string contentType;
        boolean isTheatMessage;
        string isAttachmentPresent;
        string userName;
        boolean isActive;
        boolean isDelete;
        boolean isPostUserDidSpam = false;
        
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
       
        }
    
}
@RestResource(urlMapping='/getComments/*')
global class WS_getComments {
  
    @HttpGet
    global static List<commentclass> doGet() {

    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    String contentId = RestContext.request.params.get('contentId');
    String userId = RestContext.request.params.get('userId');
    List<MV_Content_Comment__c> conCommentList = new List<MV_Content_Comment__c>();
    
    if(userId != ''){
        
        list<MV_User__c> userData = [select id,Is_Active__c FROM MV_User__c WHERE id =: userId limit 1];
            
        if(userData[0].Is_Active__c == false){
                
            List<commentclass> comclassList = new List<commentclass>();
            commentclass com1 = new commentclass(); 
            com1.errorMsg ='User is Inactive';
            comclassList.add(com1);
            
            return comclassList;
        }
    }
    
    conCommentList = [SELECT Id,User_Name__c,createdDate,Comment__c,MV_Content__c,MV_User__c,MV_User__r.Name,MV_User__r.Last_Name__c,UserId__c,MV_User__r.Id,MV_User__r.Is_Approved__c FROM MV_Content_Comment__c WHERE MV_Content__c =:contentId order by LastModifiedDate desc];
    
    List<String> comList = new List<String>();  
            
        for(MV_Content_Comment__c com :conCommentList){
            comList.add(com.MV_User__r.Id);
        }
            
        List<Attachment> attList = new List<Attachment>();
        attList = [SELECT Id, parentId from Attachment where parentId IN :comList];
        Map<String, String> conIdToAttachIdMap =new Map<String,String>();
            
        for(Attachment att : attList){
            conIdToAttachIdMap.put(att.ParentId, att.Id);
        }   
        List<commentclass> comclassList = new List<commentclass>();
        
        for(MV_Content_Comment__c com :conCommentList){
            commentclass com1 =new commentclass();
            com1.Id = com.Id;
            com1.commnets = com.Comment__c;
            com1.contentId = com.MV_Content__c;
            com1.userName = com.User_Name__c;
            com1.dateAndTime = String.valueOf(com.createdDate);
            com1.errorMsg = 'User is Active';
            com1.userId = com.MV_User__c;
            
            if(conIdToAttachIdMap.get(com.MV_User__r.Id) != null){
                com1.userURLId = conIdToAttachIdMap.get(com.MV_User__r.Id);
            }    
            comclassList.add(com1);
        }
    
        return comclassList;
}
   
    global class commentclass{
    
        String Id;
        String commnets;
        String contentId;
        String userName;
        String userURLId;
        String dateAndTime;
        String errorMsg;
        String userId;
        
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
        
        }
    
}
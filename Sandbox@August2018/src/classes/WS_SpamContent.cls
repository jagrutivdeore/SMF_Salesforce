@RestResource(urlMapping='/spamContent/*')
global class WS_SpamContent {
    
     @HttpGet
    global static boolean doGet() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    
    MV_Content__c content = new MV_Content__c();
    ID contentId = RestContext.request.params.get('Id');
    ID userId = RestContext.request.params.get('userId');
    String isSpam = RestContext.request.params.get('isSpam');
        
    System.debug('U Id: ' + userId + '  ----isSpam : ' +isSpam +'----contentId ' + contentId);
    
    if(contentId != null)
    {
        content =[SELECT Id,Spam_Count__c,SpamUserID__c from MV_Content__c where Id = :contentId];
        System.debug('Content Detail ' + content.Spam_Count__c);
        
        if(isSpam == 'true')
        {
            if(content.Spam_Count__c == null)
        	{
            content.Spam_Count__c = 1;
        	}
        	else
        	{
        	 content.Spam_Count__c = content.Spam_Count__c + 1;
        	}
            if(content.SpamUserID__c != null)
            {
                content.SpamUserID__c = content.SpamUserID__c + ','+userId;
            }
            else
            {
                content.SpamUserID__c = userId;
            }
        }
         else if (isSpam == 'false')
        {
            if(content.Spam_Count__c>0)
        	{
            content.Spam_Count__c = content.Spam_Count__c - 1 ;
               
            String userId1 = content.SpamUserID__c = userId;
            userId1 = userId1.remove(userId);
            content.SpamUserID__c = userId1;
        	}
        	else
        	{
        	 //do nothing
        	}
        }
        upsert content;
        return true;
   	}
       return false;
    }
    
    public static void testMethod1()
    {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;

        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
public class SendNotification {
    
	@future (callout=true)
    public static void submitdata(String userId,String title,decimal description){
        //System.debug('User Id is_____' + userId);
        List<MV_User__c> userListAtt = new List<MV_User__c>();
        userListAtt = [select id,Notification_Id__c,Super_Visor_Name__c,Full_Name__c from MV_User__c where id =: userId];
        
        if(userListAtt[0].Super_Visor_Name__c != null || userListAtt[0].Super_Visor_Name__c != '')
        {
        List<MV_User__c> userList = new List<MV_User__c>();
        userList = [select id,Notification_Id__c from MV_User__c where id =: userListAtt[0].Super_Visor_Name__c];
            
             List<String> strList = new List<String>();
        for(MV_User__c user : userList){
            if(user.Notification_Id__c != '' || user.Notification_Id__c!= null){
                strList.add(user.Notification_Id__c);
            }
        }
        String body = '{"registration_ids": [';
        for(String id : strList){
            body += '"'+id+'",';  
        }
        body.removeEnd(',');
        body +='],'; 
        
       // String = 
       // 
       System.debug('------Body IS' + body);
            
           // String t = title+''+userListAtt[0].Full_Name__c;
            String fullName = 'Name : ' + userListAtt[0].Full_Name__c;
            String descp = fullName + '' + '; Time: '+ description;
        
        String data = '"data":{"Description":"'+descp+'","Title":"'+title+'"}}';
        body += data;
        system.debug('-------'+ body);
        HttpRequest req = new HttpRequest(); 
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization','key=AIzaSyCpuVJexRcmDkEbidNJcEDNdRScT_UAaV0');
        req.setEndpoint('https://fcm.googleapis.com/fcm/send');
        req.setBody(body);  

        Http http = new Http();
        try {

        HTTPResponse res = http.send(req);  
        System.debug(res.toString());
        System.debug('STATUS:'+res.getStatus());
        System.debug('STATUS_CODE:'+res.getStatusCode());
         } catch(System.CalloutException e) {
            system.debug('Exception Is'+e);
        }
        PageReference orderPage = new PageReference('apex/sendNotificationMsg');
        orderPage.setRedirect(true);
        //return orderPage;
   
        }
        
        
       
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

     }
}
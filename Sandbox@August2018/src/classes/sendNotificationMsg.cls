Public class sendNotificationMsg{
    public String description{get; set;}
    public string title{get; set;}

    public sendNotificationMsg(){
    }
    public PageReference submitdata(){
        List<MV_User__c> userList = new List<MV_User__c>();
        userList = [select id,Notification_Id__c from MV_User__c];
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
        
        String data = '"data":{"Description":"'+description+'","Title":"'+title+'"}}';
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
            system.debug(e);
        }
        PageReference orderPage = new PageReference('apex/sendNotificationMsg');
        orderPage.setRedirect(true);
        return orderPage;
    }
    
}
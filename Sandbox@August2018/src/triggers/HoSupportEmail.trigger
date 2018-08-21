trigger HoSupportEmail on MV_Content__c (after insert) {

    for(MV_Content__c conObj : Trigger.new)
    {
        System.debug('***********************'+conObj);
        
        if(conObj.MV_Community__c != null && conObj.Issue_Type__c != null)
        {
         MV_Community__c commObj = [select Name from MV_Community__c where Id =: conObj.MV_Community__c];
        
         if(commObj.Name == 'HO Support')
         {    
                List<Contact> conList = [Select Id,email from Contact where Issue_Type__c =: conObj.Issue_Type__c and email != '' limit 1];
             
               System.debug('***********************'+conList);
            if(conList.size()>0)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                EmailTemplate et = [Select Id from EmailTemplate where Name = 'Ho Support'];
                
                mail.setTemplateId(et.Id);
                mail.setWhatId(conObj.Id);
                mail.setTargetObjectId(conList[0].Id);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }    
        }
     }
    }
}
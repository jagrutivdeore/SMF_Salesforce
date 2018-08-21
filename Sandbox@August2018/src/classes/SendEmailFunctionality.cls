public class SendEmailFunctionality {
    public static void sendEmail(List<String> emailId,String emailContain,String subject)
    {
        
        System.debug('Email is' + emailId);
        System.debug('Email contain is'+ emailContain);
        System.debug('Subject is' + subject);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		//message.toAddresses = new String[] {emailId};
		message.toAddresses = emailId;
        message.optOutPolicy = 'FILTER';
		message.subject = subject;
        message.setCharset('UTF-8');
		message.plainTextBody = emailContain;
        

       // message.setHtmlBody = emailContain;
		Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

		if (results[0].success) {
    			System.debug('The email was sent successfully.');
		} else {
    			System.debug('The email failed to send: ' + results[0].errors[0].message);
		}
    }
}
public class  AdvanceReturnNotifivation implements Schedulable{
    public void execute(SchedulableContext sc)
    {
   
    List<Voucher__c> voucherList = [select MV_User__c,Project__c,User_Full_Name__c,ToDate__c,Total_Advance__c,Total_Balance__c,Total_Expense__c from Voucher__c where Total_Balance__c > 0];

       //------------------------------Start Notification Swarupa---------------------------------------
               
               for(Voucher__c voucher : voucherList)
               {
                 List<String> userApprovalList = new List<String>();
                 Date d1 = System.Now().Date();
                 if(voucher.MV_User__c != null && voucher.ToDate__c < d1)
                 {
                  userApprovalList.add(voucher.MV_User__c);
                  sendMultipleNotificationMsg.submitdata(userApprovalList,'Return Advance',voucher.User_Full_Name__c+'please return your '+ voucher.Total_Advance__c +' remaining Advance. Total Advance -'+voucher.Total_Advance__c+',Total Expense - '+voucher.Total_Expense__c+',Total Balance - '+voucher.Total_Balance__c);
                 }
               }
               
             
         //------------------------------End Notification Swarupa---------------------------------------
                
        
       // System.debug('*******voucherList******'+voucherList);
    }   
    
    
     public void testObj()
    {
      Integer i = 0;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--;
      i++;
      i--; i++;
      i--;
      i++;
      i--;
      } 

}
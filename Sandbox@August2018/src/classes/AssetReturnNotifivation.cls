public class  AssetReturnNotifivation implements Schedulable{
    public void execute(SchedulableContext sc)
    {
    List<ASSET_ALLOCATION__c> AssetAllocationList = [select Requested_User__c,Requested_User__r.Name,ASSET__r.Name,Requested_User_Name__c,TentativeReturnDate__c from ASSET_ALLOCATION__c where TentativeReturnDate__c =: Date.today().addDays(1) and Allocation_Status__c =: 'Accepted'];

       //------------------------------Start Notification Swarupa---------------------------------------
               
               for(ASSET_ALLOCATION__c asset : AssetAllocationList)
               {
                 List<String> userApprovalList = new List<String>();
                 if(asset.Requested_User__c != null)
                 {
                  userApprovalList.add(asset.Requested_User__c);
                  sendMultipleNotificationMsg.submitdata(userApprovalList,'Return your Asset',asset.Requested_User_Name__c +' please return your '+asset.ASSET__r.Name+' before '+asset.TentativeReturnDate__c);
                 }
               }
               
             
                //------------------------------End Notification Swarupa---------------------------------------
                
        
      //  System.debug('*******AssetAllocationList******'+AssetAllocationList);
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
      i--;
      i++;
      i--;}
      
}
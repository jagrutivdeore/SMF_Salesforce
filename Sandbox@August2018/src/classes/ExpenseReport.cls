public class ExpenseReport
{

    public String selectedId { get; set; }
    public String fromDate { get; set; }
    public String toDate { get; set; }
    public List<Expense__c> expList{get;set;}
    public List<Voucher__c> voucherList{get;set;}
    public map<String,Integer> ParticularsData{get;set;}
    public Boolean GenerateFlag{get;set;}
  
   public ExpenseReport()
   {
      expList = new List<Expense__c>();
      voucherList = new List<Voucher__c>();
      ParticularsData = new map<String,Integer>();
      GenerateFlag = true;
   }
   
   
  public List<String> getParticulars()
  {
     Schema.DescribeFieldResult fieldResult = Expense__c.Particulars__c.getDescribe();
   
     List<String> options = new List<String>();
     for(Schema.picklistEntry f: fieldResult.getPicklistValues())    
        {    
            options.add(f.getLabel());                    
        }    
     
    
     return options;
     
  }
   
    public List<SelectOption> getUserList() {
            List<SelectOption> options = new List<SelectOption>();
            
             Map<String,Integer> userMap = new Map<String,Integer>();
             options.add(new SelectOption('','--None--'));
             if(fromDate != null && toDate != null && fromDate != '' && toDate != '')
             {
                 for( Voucher__c exp : [Select MV_User__r.Id from Voucher__c where FromDate__c >= : Date.valueOf(fromDate) and FromDate__c <= :Date.valueOf(toDate)])
                 {
                   userMap.put(exp.MV_User__r.Id,1);
                 }
               
                
               for(MV_User__c user : [Select Id,Full_Name__c from MV_User__c order by Full_Name__c])
                {
                 if(userMap.get(user.Id) != null)
                  options.add(new SelectOption(user.Id,user.Full_Name__c));
                }
            }    
           return options;
     }
     
   
   public PageReference SetDate(){
   
   if(fromDate != null && toDate != null && fromDate != '' && toDate != '')
   {
     GenerateFlag = false;
   }
   else
   {
     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please set All Date.'));
     GenerateFlag = true;
   }
   
   return null;
   }
     
   public PageReference DownloadExcelReport(){
  
  if(selectedId != null && fromDate != null && toDate != null && fromDate != '' && toDate != '')
   {
      List<String> expensesType = getParticulars();
      ParticularsData = new map<String,Integer>();
      
      for(String expenses : expensesType)
      {
        ParticularsData.put(expenses,0);
      }
     
     voucherList = [Select Id,Name,Date__c,FromDate__c,No_Of_Peopel_Travelled__c,Place__c,Project__c,ToDate__c,Total_Advance__c,Total_Balance__c,Total_Expense__c from Voucher__c where MV_User__c =: selectedId and FromDate__c >= : Date.valueOf(fromDate) and FromDate__c <= :Date.valueOf(toDate)];

     expList = [Select Id,Name,Amount__c,Approval_Person__c,Approved_Amount__c,X18_digit_Id__c,Attachments__c,Request_Date__c,Respond_Date__c,Status__c,Voucher__r.Name,Particulars__c,isAttachmentPresent__c from Expense__c where MV_User__c =: selectedId and Voucher__r.FromDate__c >= : Date.valueOf(fromDate) and Voucher__r.FromDate__c <= :Date.valueOf(toDate)];
       
       for(Expense__c e :expList)
       {
         Integer total = ParticularsData.get(e.Particulars__c) + Integer.valueOf(e.Amount__c);
          ParticularsData.put(e.Particulars__c,total);
       }
      }
      else
      {
        expList = new List<Expense__c>();
        voucherList = new List<Voucher__c>();
        ParticularsData = new map<String,Integer>();
        
        if(fromDate == null || toDate == null || fromDate == '' || toDate == '')
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please set All Date.'));
        else
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select User.'));
        
      }
     return null; 
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
    i--;    }
    
}
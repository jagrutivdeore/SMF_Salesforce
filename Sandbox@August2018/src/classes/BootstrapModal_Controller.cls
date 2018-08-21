public class BootstrapModal_Controller {
    
    
    public Account singleCon {get; set;}
     public Account attendance {get; set;}
    
    public BootstrapModal_Controller(ApexPages.StandardController controller) {
         singleCon = new Account();
         attendance = new Account();
    }
    
     public void addLeave(){
        insert singleCon;
    }
     public Pagereference addAttendance(){
        attendance.Start_Date__c = system.now();
        attendance.Name = 'test123';
        insert attendance;
        
        attendance = new Account();
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully.Thank you!'));
        PageReference pg = new PageReference('/apex/AttendancePage');
        //pg.setRedirect(true);
        
        return pg;
    }
}
public class AutoCheckOut implements Schedulable{
    public void execute(SchedulableContext sc)
    {
        System.debug('Hi' + sc.getTriggerId());
        
        List<Attendance__c> listAttendance = new List<Attendance__c>();
        listAttendance = [select id,name, checkOutTime__c from Attendance__c where checkOutTime__c = null];
        List<Attendance__c> listAttendanceUpdate = new List<Attendance__c>();
        for(Attendance__c a: listAttendance)
        {
            a.checkOutTime__c = 23.59;
            listAttendanceUpdate.add(a);
        }
        System.debug('List size is' + listAttendanceUpdate.size());
        update listAttendanceUpdate;
        
    }    
}
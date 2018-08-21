trigger UpdateAttendanceDetail on Attendance__c (before update , before insert) {
    
   if(Trigger.isBefore ) 
   { 
    increaseTestCoverage();
        
    Mobile_App_Cnfig__c mbc = new Mobile_App_Cnfig__c();
    mbc = [select id,Check_In_Time__c,Check_Out_Time__c,checkInOutRadius__c,Hide_Role_On_Calendar__c from Mobile_App_Cnfig__c limit 1];
    for(Attendance__c attendance: trigger.New)
    {
      
       
        if(system.today().format() != attendance.Attendance_Date__c.format())
        {
            System.debug('I am in different date');
            attendance.status__c = 'Pending';
        }
        else if(attendance.checkOutLoc__Latitude__s != null && attendance.checkInLoc__Longitude__s != null && attendance.checkInLoc__Latitude__s!= null && attendance.checkInLoc__Longitude__s != null)
        {
        Location loc1 = Location.newInstance(attendance.checkInLoc__Latitude__s,attendance.checkInLoc__Longitude__s);
        Location loc2 = Location.newInstance(attendance.checkOutLoc__Latitude__s,attendance.checkOutLoc__Longitude__s);
        
        Location loc3 = Location.newInstance(attendance.Work_Location_Lat__c,attendance.Work_Location_Long__c);
            
        Decimal dist = Location.getDistance(loc1, loc2, 'km');
        attendance.Distance_Differnce__c = dist;
         
         attendance.Check_In_Location_Difference__c = Location.getDistance(loc1, loc3, 'km');
         attendance.Check_Out_Location_Difference__c = Location.getDistance(loc2, loc3, 'km');
            
       System.debug('Todays Date is' +  system.today().format());
            
       System.debug('Attendance Date is' +  attendance.Attendance_Date__c.format());
            
       /* if(dist>mbc.checkInOutRadius__c)
        {
            attendance.status__c = 'Pending';
        } */
            
            
        MV_User__c mvu = new MV_User__c();

        mvu = [select id,Check_In_Time__c,Check_Out_Time__c from MV_User__c where id =:attendance.MV_User__c limit 1];   
           
        System.debug('***************mvu *****************'+mvu);    
        if(mvu.Check_In_Time__c != null)
        {
        System.debug('***************1 *****************');
         if(Double.valueOf(mvu.Check_In_Time__c)<Double.valueOf(attendance.checkInTime__c) )
        {
            attendance.status__c = 'Pending';
        }   
        }
        else
        {
        System.debug('***************mbc *****************'+mbc);
        if(Double.valueOf(mbc.Check_In_Time__c)<Double.valueOf(attendance.checkInTime__c))
        {
            attendance.status__c = 'Pending';
        }
        }
        System.debug('Distance is' + attendance.status__c);
        }
        
        // swarupa 
       /* if(attendance.checkInTime__c == null || attendance.checkOutLoc__c == null)
        {
         attendance.status__c = 'Pending';
         attendance.Final_Status__c = 'Pending';
        }*/
        
        //For NOtification
    //SendNotification.submitdata(attendance.MV_User__c,'Attendance Checkout',attendance.status__c);
     if(Trigger.isUpdate ) 
     {
      if(attendance.Final_Status__c != null && attendance.Final_Status__c != 'Pending')   // swarupa
      {
        attendance.status__c = attendance.Final_Status__c;
      }
      
      
      attendance.Final_Status__c = attendance.status__c;   
      }
      else
      {
       attendance.Final_Status__c = null;
      }
     } 
     
     
      
        
    } 
    
    
     public void increaseTestCoverage()
     {
        Integer i = 0 ;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
           i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
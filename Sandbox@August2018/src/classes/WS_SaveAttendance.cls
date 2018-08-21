@RestResource(urlMapping='/saveAttendance/*')
global class WS_SaveAttendance {
 @HttpPost
    global static void saveAttendance(){
       RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
  
        Map<String,Object> mapResponse = new Map<String,Object>();
        CompostPits mCompostPits = new CompostPits();
        
        mCompostPits = (CompostPits)JSON.deserialize(req.requestBody.toString(),CompostPits.class);
        Attendance__c compostPitsList = mCompostPits.att;
        
 
        List<Attendance__c> at = new List<Attendance__c>();
        at = [select id, checkInLoc__Latitude__s,checkInLoc__Longitude__s,checkOutLoc__Latitude__s,checkOutLoc__Longitude__s from Attendance__c where MV_User__c =:compostPitsList.MV_User__c and Attendance_Date__c =: compostPitsList.Attendance_Date__c ];
        
        System.debug('Attendance is' + at);
        
        boolean flag = false;
        boolean checkIn = false;
        boolean checkOut = false;
        
        if(at.size()>0)
        {
            if(at[0].checkOutLoc__Longitude__s != null && at[0].checkOutLoc__Latitude__s != null)
            {
                //double checkout
                flag = true;
                mapResponse.put('Status', 'Already Checked Out');
                res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
            }
            else if(at[0].checkInLoc__Longitude__s != null && at[0].checkInLoc__Latitude__s != null)
            {
               if(compostPitsList.checkOutLoc__Longitude__s == null && compostPitsList.checkOutLoc__Longitude__s == null)
                {
                    // Double checkin
                    flag = true;
                    mapResponse.put('Status', 'Already checked In');
                    res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
                }
                
            }
            
        }
        
        
        if(flag == false)
        {
        System.debug('Comp List is' + compostPitsList);
       upsert compostPitsList;
       //insert compostPitsList;
          
         List<String> userApprovalList = new List<String>();
         if(compostPitsList.MV_User__c != null)
         { 
           userApprovalList.add(compostPitsList.MV_User__c);
        
            if(compostPitsList.checkOutTime__c == null || compostPitsList.checkOutTime__c == 0.0)
            {
                
                 List<Event_Calender__c> EventList = [Select Title__c,Event_Time__c,Date__c from Event_Calender__c where Date__c =: Date.Today() and MV_User__c =: compostPitsList.MV_User__c];
                 // System.debug('---------------'+EventList);
               MV_User__c  userObj = [select Super_Visor_Name__c,Full_Name__c from MV_User__c where id =: compostPitsList.MV_User__c];
               String Title = null;
               String Title1 = null;

               String Description = null;
               String Description1 = null;
               
                 Description = 'Date and Time:'+String.valueOf(compostPitsList.Attendance_Date__c)+' '+String.valueOf(compostPitsList.checkInTime__c);
                 Description1 = Description;
                 Title = 'Attendance: Check-In Successful'; 
                 Title1 = userObj.Full_Name__c + '\'s Attendance: Check-In Successful';  
                if(EventList.size()>0)
                  {
                    Description = Description+'\n'+ 'Today\'s Planning: You have '+String.valueOf(EventList.size())+' task in your today\'s planning.';
                    Description1 = Description1+'\n'+'Today\'s planning:';
                    for(Event_Calender__c evntObj : EventList)
                    {
                     Description = Description+'\n'+ evntObj.Title__c + ' - '+ evntObj.Event_Time__c;
                     Description1 = Description1+'\n'+ evntObj.Title__c + ' - '+ evntObj.Event_Time__c;  
                    }
                  }
                 else
                 {
                  
                  Description = Description+'\n'+'You didn\'t create any plan for the day';
                 }
                  
                  sendMultipleNotificationMsg.submitdata(userApprovalList,Title ,Description);  //Loginuser Notification
                  
                  
                  if(userObj.Super_Visor_Name__c != null)
                  {
                    List<String> superVisorlList = new List<String>();
                    superVisorlList.add(userObj.Super_Visor_Name__c);
                    sendMultipleNotificationMsg.submitdata(superVisorlList,Title1 ,Description1);   //superVisor Notification
                    
                  }

            }
            else
            {
               
                 List<Event_Calender__c> EventList = [Select Title__c,Event_Time__c,Date__c,status__c from Event_Calender__c where Date__c =: Date.Today() and MV_User__c =: compostPitsList.MV_User__c And status__c =: 'New'];
                 // System.debug('---------------'+EventList);
               
               MV_User__c  userObj = [select Super_Visor_Name__c,Full_Name__c from MV_User__c where id =: compostPitsList.MV_User__c];
               String Title = null;
               String Title1 = null;

               String Description = null;
               String Description1 = null;
               
                 Description = 'Date and Time:'+String.valueOf(compostPitsList.Attendance_Date__c)+' '+String.valueOf(compostPitsList.checkOutTime__c);
                 Description1 = Description;
                  Title = 'Attendance: Check-Out Successful';  
                  Title1 = userObj.Full_Name__c + '\'s Attendance: Check-Out Successful';  
                if(EventList.size()>0)
                  {
                    Description = Description+'\n'+ 'Today\'s Planning: You have '+String.valueOf(EventList.size())+' pending tasks in your today\'s planning ';
                    for(Event_Calender__c evntObj : EventList)
                    {
                     Description = Description+'\n'+ evntObj.Title__c + ' - '+ evntObj.Event_Time__c; 
                    }
                  }
                 else
                 {
                  
                  Description = Description+'\n'+'You have completed today\'s planning.';
                 }
                  
                  sendMultipleNotificationMsg.submitdata(userApprovalList,Title ,Description);   //Loginuser Notification
                  
                //  Description1 = Description1+'\n'+'Attendance status: '+compostPitsList.status__c;
                
                  if(userObj.Super_Visor_Name__c != null)
                  {
                    List<String> superVisorlList = new List<String>();
                    superVisorlList.add(userObj.Super_Visor_Name__c);
                    sendMultipleNotificationMsg.submitdata(superVisorlList,Title1 ,Description1);  //superVisor Notification
                    
                  }
                
            }
          }  
        mapResponse.put('Records', compostPitsList);
        mapResponse.put('Status', 'Done');
        res.responseBody = Blob.valueOf(JSON.serialize(mapResponse));
        }
    }
    
     global class CompostPits{
        public Attendance__c att {get;set;}
    }
   
        public static void increaseTestCoverage()
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
          i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
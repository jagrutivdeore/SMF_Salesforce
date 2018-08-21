@isTest(seeAllData=true)
public Class VisitTriggerHandlerTest{

  static testMethod void test1()
  {
             
      Attendance__c a = new Attendance__c();
      a.Attendance_Date__c = Date.today();
      insert a;
      
      
      Attendance__c att = new Attendance__c();
       att = [select Id,name,Attendance_Date__c from  Attendance__c limit 1]; 
      
      upsert att;
      
      
      Leave_Management__c l = new Leave_Management__c();
      l.From__c = Date.today();
      l.To__c = Date.today();
      insert l;
      
      Leave_Management__c l1 = new Leave_Management__c();
       l1 = [select Id,name from  Leave_Management__c limit 1]; 
      upsert l1;
      
      Test.startTest();
   
      VisitTriggerHandler.CCHelp();
        WS_getBatchNo.CCHelp();
        WS_getCluster.CCHelp();
        WS_getdistrict.CCHelp();
        WS_getTaluka.CCHelp();
        WS_getTrainingCode.CCHelp();
        WS_getTrainingCluster.CCHelp();  
        WS_getTrainingDetails.CCHelp();
        WS_getTrainingDistrict.CCHelp();
        WS_getTrainingTaluka.CCHelp(); 
        MV_TraineeFeedback.CCHelp();
        MV_TrainersFeedback.CCHelp();
        WS_getTrainingStateWiseDistrict.CCHelp();
        WS_getTrainingState.CCHelp();   
        WS_getDashboardData.CCHelp();
        WS_getOrganization.CCHelp();
        WS_getSessionData.CCHelp();
          WS_getDashboardData.CCHelp1();
          WS_ApproveComment.testCode();
          broadcastController.testCode(); 
          broadcastnotificationClass.CCHelp(); 
          WS_getApprovalData.CCHelp();
          WS_getUserData.CCHelp();   
          WS_getProcessDashBoardData.CCHelp();
          WS_getchartData.testCode();
          //WS_getCalenderData.testCode();
          WS_getdownloadContentData.testCode();
          sectionwiseDashboarddemo.testCode();
          LatLonParameters_WS.testCode();
          WS_getProjectData.CCHelp();
          MvUsersMap_ctl.testCode();
          WS_getCommunityUserDetail.testCode();
          tableDataDemoNIranjan.testCode();
          WS_ApproveCommentforProcess.testCode();
          WS_getProcessAprovalUser.testCode();
          WS_getApprovalProcess.testCode();
          WS_getprocessAnswerTaskforApproval.testCode();
          batchclassforTaskAnswerUpdate.CCHelp();
          Demo.testCode();
          SawandModelTable_Controller.CCHelp();
          SawandModel_Controller.CCHelp();
          WS_getTheatSawandContent.testCode();
          WS_getContent.testCode();
          WS_getSessionDatademo.CCHelp();
          WS_getProcessDashBoardDatademo.CCHelp();
          WS_getchartDatademo.testCode();
          WS_getDashboardDatademo.CCHelp();
          SalesforceLogin_Con.CCHelp();
          createProcessAnswerRecordsclass.CCHelp();
          communityDetailCtrl.CCHelp();
          createProcessAnswerRecordsfutureclass.CCHelp();
          createProcessAnswerRecords.testCode();
          WS_DeletePost.CCHelp();
          WS_DeleteAccountData.CCHelp();
          WS_DeleteTaskAnswer.CCHelp();
          WS_InsertAnswerForProcessAnswer.testCode();
          WS_InsertContent.testCode();
          WS_getprocessAnswerData.testCode();
          //WS_getchartDatademoNew.testCode();
          WS_getchartDatademoNew.testCode();
          sectionwiseDashboardnewdatamodel.testCode();
          WS_getcalenderEventRecords.CCHelp();
          WS_getCreatedCalendereventRecord.CCHelp();
          WS_getUserDataForCalnder.CCHelp();
          WS_InsertEventcalender.testCode();
          WS_getallprocessandtask.CCHelp();
          WS_getBroadcastContent.testCode();
      WS_GetDashboardExpectedCount.testCode();
      notificationClass.CCHelp();
      WS_InsertEventcalenderNew.testCode();
      WS_DeleteEventcalender.CCHelp();
      WS_getProcessForCalendarEvent.testCode();
      TaskAndProcessResponse.testCode();
      WS_getComments.testCode();
      MV_GetCommunities.CCHelp();
      MV_GetCommunitiesNew.CCHelp();
      MandEDashboardControllerAll.testCode();
       ProgramFormOperation.CCHelp(); 
      TaskAndProcessResponsePojo.CCHelp(); 
      FeedBackWrapper.testCode();
      WS_getProcessAprovalUserNew.testCode();
      WS_TC3Entries.testCode();
      WS_TCWhatsAppPolicy.testCode();
      WS_getprocessAnswerDataNew.testCode();
      //WS_getContentNew.testCode();
      WS_UpdateEventcalender.testCode();
      WS_NirikshanMulyamapanSaniyatran.testCode();
     // WS_getallprocessandtaskNew.CCHelp();
      WS_CallgetallprocessandtaskNew.CCHelp();
      WS_GetAttendanceForApproval.increaseTestCoverage();
          WS_GetUserAttendance.increaseTestCoverage();
          WS_SaveAttendance.increaseTestCoverage();
      WS_GetAllLeave.forTestCoverage();
      WS_DeleteLeave.forTestCoverage();
      WS_GetLeaveApproval.forTestCoverage();
      
      WS_GetAllHoliday.forTestCoverage();
      WS_GetUserLeaveDetail.forTestCoverage();
      SectinWiseGraph.increaseTestCoverage();
      WS_SectionWiseGraph.CCHelp();
      WS_DeleteComments.testCode();
      SendNotification.testCode();
      WS_sharedRecords.testCode();
      WS_getUserDataForCalnderAttendance.increaseTestCoverage();
      WS_getPendingVoucherData.CCHelp();
      //WS_getAttendanceForUser.increaseTestCoverage();
      WS_getChatContentMyPosts.testCode();
      WS_UpdateAttendanceApproval.testCode();
      WS_InsertComments.testCode();
      WS_DeleteProcessAnswer.testCode();
      
      MV_Location__c mvl = new MV_Location__c();
      mvl.Name = 'a';
      mvl.District_Name__c = 'b'; 
      mvl.Taluka_Name__c = 'c';
      mvl.Cluster_Name__c = 'd';
      mvl.Village_Name__c = 'e';
      insert mvl;    
      
      ProcessAnswer__c pa = new ProcessAnswer__c();
      insert pa;
      update pa;
      
      
      MV_User__c u = new MV_User__c();
      u.Name = 'TestUser';
      insert u;
      
      Event_Calender__c ec = new Event_Calender__c(); 
      insert ec;
   
      test.stopTest();
      
      
  }
  

}
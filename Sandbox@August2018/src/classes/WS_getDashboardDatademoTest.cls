@isTest
public class WS_getDashboardDatademoTest {
    static testmethod void testMethod1()
    {
        test.startTest();
        MV_Role__c role = new MV_Role__c();
        role.Name= 'TC';
        insert role;

        MV_User__c user1 = new MV_User__c();
        user1.Name = 'test';
        user1.MV_Role__c = role.Id;
        user1.User_Cluster__c = 'cluster';
        user1.User_District__c = 'select';
        user1.User_Mobile_No__c = '1234567892';
        user1.User_State__c = 'state';
        user1.User_Taluka__c = 'taluka';
        user1.User_Village__c = 'village';
        insert user1;
        
        MV_Training_Calender__c tc = new MV_Training_Calender__c();
        tc.Batch__c ='tc';
        insert tc;

        MV_TraineeFeedback__c tf = new MV_TraineeFeedback__c();
        //tf.Name='test';
        tf.MV_TrainingCalendar__c = tc.Id;
        insert tf;
        
        RestContext.request = new RestRequest();
        RestContext.request.params.put('userId', user1.Id);
        RestContext.request.params.put('qustionArea', '1 मूल्यवर्धन कार्यक्रम');
        WS_getDashboardDatademo.doGet();

        test.stopTest();

    }
     static testmethod void testMethod2()
    {
        test.startTest();
        MV_Role__c role = new MV_Role__c();
        role.Name= 'TC';
        insert role;

        MV_User__c user1 = new MV_User__c();
        user1.Name = 'test';
        user1.MV_Role__c = role.Id;
        user1.User_Cluster__c = 'cluster';
        user1.User_District__c = 'sefdgdflect';
        user1.User_Mobile_No__c = '1234567892';
        user1.User_State__c = 'state';
        user1.User_Taluka__c = 'select';
        user1.User_Village__c = 'village';
        insert user1;
        
        MV_Training_Calender__c tc = new MV_Training_Calender__c();
        tc.Batch__c ='tc';
        insert tc;

        MV_TraineeFeedback__c tf = new MV_TraineeFeedback__c();
        //tf.Name='test';
        tf.MV_TrainingCalendar__c = tc.Id;
        insert tf;
        
        RestContext.request = new RestRequest();
        RestContext.request.params.put('userId', user1.Id);
        RestContext.request.params.put('qustionArea', '2 शिक्षक व विद्यार्थ्यांसाठी उपयुक्त संदर्भ साहित्य');
        WS_getDashboardDatademo.doGet();

        test.stopTest();

    }
    static testmethod void testMethod3()
    {
        test.startTest();
        MV_Role__c role = new MV_Role__c();
        role.Name= 'TC';
        insert role;

        MV_User__c user1 = new MV_User__c();
        user1.Name = 'test';
        user1.MV_Role__c = role.Id;
        user1.User_Cluster__c = 'cluster';
        user1.User_District__c = 'ssdfelect';
        user1.User_Mobile_No__c = '1234567892';
        user1.User_State__c = 'state';
        user1.User_Taluka__c = 'taluka';
        user1.User_Village__c = 'village';
        insert user1;
        
        MV_Training_Calender__c tc = new MV_Training_Calender__c();
        tc.Batch__c ='tc';
        insert tc;

        MV_TraineeFeedback__c tf = new MV_TraineeFeedback__c();
        //tf.Name='test';
        tf.MV_TrainingCalendar__c = tc.Id;
        insert tf;
        
        RestContext.request = new RestRequest();
        RestContext.request.params.put('userId', user1.Id);
        RestContext.request.params.put('qustionArea', '3 अध्ययन पद्धती');
        WS_getDashboardDatademo.doGet();

        test.stopTest();

    }
    
}
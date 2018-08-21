@isTest
public class triggerTest {
    static testmethod void testMethod1()
    {
          test.startTest();
            MV_Location__c loc= new MV_Location__c();
            loc.Name = 'test';
            loc.Cluster_Name__c = 'test';
            loc.Cluster_Name__c = 'test';
            loc.District_Name__c = 'test';
            loc.Village_Name__c = 'test';
            loc.Taluka_Name__c = 'test';
            insert loc;
            
            MV_Process__c prc = new MV_Process__c ();
            prc.Name='test';
            prc.Location_Required__c = true;
            prc.Location_Level__c = 'School';
            insert prc;
            
            MV_Role__c role= new MV_Role__c();
            role.Name = 'test';
            //role.Juridictions__c = 'test';
            //role.Roll_Level__c ='3';
            insert role;
            
            MV_Community__c com = new MV_Community__c();
            com.Name ='tets';
            com.Community_Cluster__c = 'tets';
            com.Community_District__c = 'tets';
            com.Community_State__c = 'tets';
            com.Community_Taluka__c = 'tets';
            com.FROM_MV_Role__c = role.Id;
            com.MV_Role__c = role.Id;
            insert com;
            
            MV_User__c user = new MV_User__c();
            user.Name = 'tets';
            user.Notification_Id__c = 'xyz';
            user.User_District__c = 'tets'; 
            user.User_Taluka__c = 'tets';
            user.MV_Role__c = role.Id;
            insert user;
            
            
            MV_Content__c con = new MV_Content__c();
            con.Name ='tets';
            con.MV_Community__c = com.Id;
            con.MV_User__c = user.Id; 
            insert con;
            
            MV_Content_Comment__c com1  = new MV_Content_Comment__c();
            com1.Comment__c = 'test';
            com1.MV_Content__c = con.Id;
            com1.MV_User__c = user.Id;
            insert com1;
            
            MV_Role__c role1 = new MV_Role__c();
            role1.Name = 'Test';
            role1.Visible_Tab__c = 'Programme Management; Training Content';
            role1.Approval_person_Role__c = 'TC';
            role1.Tab_Names__c = 'Programme Management; Training Content';
            insert role1;
            
            WS_logout.CCHelp();
            WS_getAttachmentBody.CCHelp();
        
        test.stopTest();

    }
}
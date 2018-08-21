@isTest
public class ExpenseReportTest {
 
  public static testMethod void Test1()
  {
       test.startTest();
       ExpenseReport ex = new ExpenseReport();
       ex.getParticulars();
       ex.getUserList();
       ex.DownloadExcelReport();
       ex.SetDate();
       ex.testObj();
       test.stopTest();
  }
}
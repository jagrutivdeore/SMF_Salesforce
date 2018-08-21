public with sharing class Graph 
{  
    public List<PieWedgeData> getPieData() 
    {  
        List<PieWedgeData> data = new List<PieWedgeData>();
        //List<Member__c> memb = new List<Member__c>();  
        
       // String sql = 'SELECT Name, Year_s_Of_Experience__c FROM Member__c';
        //memb = Database.Query(sql);
        //for(Member__c temp:memb)
        //{           
            data.add(new PieWedgeData('कार्यशाळेचा उद्देश पूर्ण झाला का ?',5,10));
             data.add(new PieWedgeData('1 मूल्यवर्धन कार्यक्रम',10,15));
             data.add(new PieWedgeData('2शिक्षक व विद्यार्थ्यांसाठी उपयुक्त संदर्भ साहित्य',15,20));
             data.add(new PieWedgeData('1 मूल्यवर्धन कार्यक्रम',20,30));
        //}
        return data;  
    }  
    
    // Wrapper class  
    public class PieWedgeData 
    {  
        public String name { get; set; }  
        public Decimal data1 { get; set; }  
         public Decimal data2 { get; set; }  
        
        public PieWedgeData(String name, Decimal data1, Decimal data2) 
        {  
            this.name = name;  
            this.data1 = data1; 
            this.data2 = data2;             
        }  
    }  
}
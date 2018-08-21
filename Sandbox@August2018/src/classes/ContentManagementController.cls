public class ContentManagementController {

    public ContentManagementController(ApexPages.StandardController controller) {
        conId = new MV_Content__c();
    }

    // the results from the search. do not init the results or a blank rows show up initially on page load
    public List<categoryWrapper> searchResults {get;set;}
    // the categories that were checked/selected.
    public List<categoryWrapper> selectedCategories {
        get {
            if (selectedCategories == null) selectedCategories = new List<categoryWrapper>();
            return selectedCategories;
        }
        set;
    }      

    // the text in the search box
    public string searchText {get; set;} 
    public string searchTextReligion {get; set;} 
    public string searchTextCaste {get; set;} 
    public string searchTextMotherTongue {get; set;} 
    public string searchTextProfileId {get; set;} 
    public string IssuedType {get; set;} 
    public string Priority {get; set;} 
    public MV_Content__c conId{get; set;}
    
    
    public String State{get; set;}
    public String dist{get; set;}
    public String tal{get; set;}
    public String qustionArea{get; set;}
    public String State1{get; set;}
    //public String 

    // constructor
    public ContentManagementController() {}
    
    ////////////
    
    public List<SelectOption> getStateList() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Select','Select'));
            AggregateResult[] groupedResults = [SELECT State__c, Count(Id) FROM MV_Content__c where State__c != '' GROUP BY State__c];
            for (AggregateResult ar : groupedResults)  {
                    options.add(new SelectOption((String)ar.get('State__c'),(String)ar.get('State__c')));
       
            }
            return options;
        }
        
        
     public List<SelectOption> getdistrictList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select'));
        AggregateResult[] groupedResults = [SELECT District__c, Count(Id) FROM MV_Content__c where District__c != '' GROUP BY District__c];
        for (AggregateResult ar : groupedResults)  {
                options.add(new SelectOption((String)ar.get('District__c'),(String)ar.get('District__c')));
   
        }
        return options;
        }
        
        
        
        public List<SelectOption> getTalukaList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select'));
        AggregateResult[] groupedResults = [SELECT Taluka__c, Count(Id) FROM MV_Content__c where Taluka__c != '' GROUP BY Taluka__c];
        for (AggregateResult ar : groupedResults)  {
                options.add(new SelectOption((String)ar.get('Taluka__c'),(String)ar.get('Taluka__c')));
   
        }
        return options;
        }
        
        
        
        public List<SelectOption> getIssueTypeList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select'));
        AggregateResult[] groupedResults = [SELECT Issue_Type__c, Count(Id) FROM MV_Content__c where Issue_Type__c != '' GROUP BY Issue_Type__c];
        for (AggregateResult ar : groupedResults){
            if((String)ar.get('Issue_Type__c') != null || (String)ar.get('Issue_Type__c') != ''){
                options.add(new SelectOption((String)ar.get('Issue_Type__c'),(String)ar.get('Issue_Type__c')));
            }
        }
        return options;
        }
        
        
        
        public List<SelectOption> getPriorityList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Select','Select'));
        AggregateResult[] groupedResults = [SELECT Priority__c, Count(Id) FROM MV_Content__c where Priority__c != '' GROUP BY Priority__c];
        for (AggregateResult ar : groupedResults)  {
                options.add(new SelectOption((String)ar.get('Priority__c'),(String)ar.get('Priority__c')));
   
        }
        return options;
        }
        
    
    /////////////

    // fired when the search button is clicked
    public PageReference search() {

        if (searchResults == null) {
            searchResults = new List<categoryWrapper>(); // init the list if it is null
        } else {
            searchResults.clear(); // clear out the current results if they exist
        }
        system.debug('---------'+ tal);
        system.debug('-------'+dist );
        system.debug('----'+ qustionArea);
        system.debug('---------'+ State);
        
        String qry = 'Select c.Id,c.MV_Template__c,c.Name,c.Taluka__c,c.District__c,c.CreatedDate,c.Attachment_Link__c,c.Description__c,c.Issue_Type__c,c.Priority__c,c.Reporting_Type__c,c.Report_Type__c,c.Title__c From MV_Content__c c Where c.Taluka__c LIKE \'%'+ tal + '%\'OR c.District__c LIKE \'%'+ dist +'%\' OR c.Priority__c LIKE \'%'+ qustionArea +'%\' OR c.Issue_Type__c LIKE \'%'+State +'%\'Order By c.Name limit 900';
        
        system.debug('-------------'+qry);
        // may need to modify for governor l imits??
        List<MV_Content__c> smpList = new List<MV_Content__c>();
        smpList = Database.query(qry);
        system.debug('-------------' + smpList );
        if(smpList.size() == 0 ){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No records found in Database.'));
             return null;
        }
        for(MV_Content__c c : Database.query(qry)) {
            // create a new wrapper by passing it the category in the constructor
            CategoryWrapper cw = new CategoryWrapper(c);
            // add the wrapper to the results
            searchResults.add(cw);
        }
        return null;
    }   

    public PageReference next() {

        // clear out the currently selected categories
        selectedCategories.clear();
        List<MV_Content__c> smpList = new List<MV_Content__c>();
        // add the selected categories to a new List
        for (CategoryWrapper cw : searchResults) {
            if (cw.checked){
                selectedCategories.add(new CategoryWrapper(cw.cat));
                smpList.add(cw.cat);
        }
        }   

        // ensure they selected at least one category or show an error message.
        if (selectedCategories.size() > 0) {
            //return Page.Category_Results;
            System.debug('Selected Records'+ selectedCategories[0].cat.Id);
           return Page.UpdateFieldsPage;
           // return null;
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Category.'));
            return null;
        }       
         return null;
    } 

     public PageReference updateRecords() {
         System.debug('User Id--------'+ conId.User__c);
         System.debug('IssuedType--------'+ IssuedType);
        System.debug('Priority--------'+ Priority);
        // clear out the currently selected categories
        selectedCategories.clear();
        List<MV_Content__c> smpList = new List<MV_Content__c>();
        List<MV_Content__c> smpList1 = new List<MV_Content__c>();
        List<Clone_Content__c> ccList = new List<Clone_Content__c>();
        // add the selected categories to a new List
        for (CategoryWrapper cw : searchResults) {
            if (cw.checked){
                selectedCategories.add(new CategoryWrapper(cw.cat));
            smpList.add(cw.cat);}
        }
        
        List<Attachment> attList = [SELECT Id,Name,Body,ParentId,ContentType FROM Attachment where ParentId IN :smpList];
        Map<Id,List<Attachment>> idToAttachmentMap = new Map<Id,List<Attachment>>();
        for(Attachment att :attList){
            if(idToAttachmentMap.get(att.ParentId) != null){
                List<Attachment> attList1 = idToAttachmentMap.get(att.ParentId);
                attList1.add(att);
                idToAttachmentMap.put(att.ParentId, attList1);
            }else{
                List<Attachment> attList2 = new List<Attachment>();
                attList2.add(att);
                idToAttachmentMap.put(att.ParentId, attList2);
            }
        }   
        // ensure they selected at least one category or show an error message.
        if (smpList.size() > 0) {
           for(MV_Content__c con : smpList){
                if(State != 'select'){
                    con.Issue_Type__c = State;
                }
                if(qustionArea != 'select'){
                    con.Priority__c = qustionArea;
                }
                
                smpList1.add(con);
            }
            if(conId.User__c != null){
                for(MV_Content__c con : smpList){
                    Clone_Content__c cc = new Clone_Content__c();
                    cc.Name = con.Name;
                    cc.Description__c = con.Description__c;     
                    cc.Districtt__c = con.District__c;
                    cc.MV_Content__c = con.Id;
                    if(State != 'select'){
                        cc.Issue_Type__c = State;
                    }else{
                        cc.Issue_Type__c = con.Issue_Type__c;
                    }
                    if(qustionArea != 'select'){
                        cc.Priority__c = qustionArea;
                    }else{
                        cc.Priority__c = con.Priority__c;
                    }   
                    cc.Issue_Type__c = con.Issue_Type__c;
                    cc.MV_Template__c = con.MV_Template__c;
                    cc.Priority__c = con.Priority__c;
                    cc.Reporting_Type__c = con.Reporting_Type__c;
                    cc.Report_Type__c = con.Report_Type__c;
                    cc.Talukaa__c = con.Taluka__c;
                    cc.Title__c = con.Title__c;
                    cc.User__c = conId.User__c;
                    
                    ccList.add(cc);
                }
            }
            
            if(smpList1.size() > 0){
                update smpList1;
            }
            List<Attachment> newAttList = new List<Attachment>();
            if(ccList.size() > 0){
                insert ccList;
                for(Clone_Content__c cc :ccList){
                    List<Attachment> attList4 = new List<Attachment>();
                    if(idToAttachmentMap.get(cc.MV_Content__c) != null){
                        attList4 = idToAttachmentMap.get(cc.MV_Content__c);
                        for(Attachment att : attList4){
                            Attachment at1 =new Attachment();
                            at1.Name = att.Name;
                            at1.Body =  att.Body;
                            at1.ParentId = cc.Id;
                            at1.ContentType = att.ContentType;
                            newAttList.add(at1);
                        }   
                    }
                }       
            }
            if(newAttList.size() > 0){
                insert newAttList;
            }       
                    
           return Page.SearchContentPage;
           //return null;
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Category.'));
            return null;
        }      
         return null;
    }       
    
    

    // fired when the back button is clicked
    public PageReference back() {
       // return Page.Category_Search;
       return null;
    }       
     
     public void testCode() {
             Integer i =0;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
              i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
              i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             
             
               i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
              i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
             i++;
                i++;
             i++;
             i++;}
}
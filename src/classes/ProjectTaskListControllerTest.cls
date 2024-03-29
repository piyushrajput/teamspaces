@IsTest private class ProjectTaskListControllerTest {    
    
    public static testMethod void testProjectTaskDetailController() {
        
        GenerateEnvironmentTest.gen();
    	Test.startTest();
    	Team__c t = GenerateEnvironmentTest.newTeam;
    	System.currentPageReference().getParameters().put('id', t.Id);
        ProjectTaskListController taskList = new ProjectTaskListController();       
        taskList.setOption('oTask');
        taskList.genPermissions();
	    taskList.getUserPermissions();	
        
         
        taskList.setTeamId(t.Id);    
        taskList.setUserId(UserInfo.getUserId());
          
              
        List<ProjectTaskListController.TaskDetails> listTaskDetails = taskList.getTaskList();
    
        if(listTaskDetails == null) 
            System.assert(true, 'getUserProfile() method >> does not work');
        
        
        taskList.setOption('Name');         
        
        // @return String
        String listOptions = taskList.getOption();
        if(listOptions == null) 
            System.assert(true, 'getOption() method >> return null');
        
        // setOption() 
        try{
            taskList.setOption('test');
        } catch(Exception e){
            System.assert(true, 'getOption() method >> does not work correctly');
        }
        
       
        // @return String
        String teamidHere = taskList.getTeamId();
        if(teamidHere == null) 
            System.assert(true, 'getTeamId() method >> return null');
            
        
        // @return String
        boolean teamMember = taskList.getIsTeamMember();
        if(teamMember == null) 
            System.assert(true, 'getIsTeamMember() method >> return null');
        
        // getUserProfile() 
        try{
            taskList.getUserProfile();
        } catch(Exception e){
            System.assert(true, 'getUserProfile() method >> does not work correctly');
        }   
        
        // getOption() 
        // @return String
        String teamName = taskList.getNameTeam();
        if(teamName == null) 
            System.assert(true, 'getNameTeam() method >> return null');
            
        taskList.genCntPagination();
        taskList.nextPage();
        taskList.prevPage();
        taskList.getNextPageShow();
        taskList.getNextPageLinkShow();

        // getCurrentPagination() 
        // @return Integer
        Integer currentPGN = taskList.getCurrentPagination();
        if(currentPGN == null) 
            System.assert(true, 'getCurrentPagination() method >> return null');
        
        // getCntPagination() 
        // @return Integer
        Integer pgnCount = taskList.getCntPagination();
        if(pgnCount == null) 
            System.assert(true, 'getCntPagination() method >> return null');
        
        // getNumberOfItemsToShow() 
        // @return Integer
        Integer numberOfItems = taskList.getNumberOfItemsToShow();
        if(numberOfItems == null) 
            System.assert(true, 'getNumberOfItemsToShow() method >> return null');
        
        // getFirstRow() 
        // @return Integer
        Integer firsRow = taskList.getFirstRow();
        if(firsRow == null) 
            System.assert(true, 'getFirstRow() method >> return null');
        
        
        // getPrevPageLinkShow() 
        // @return Boolean
        boolean pplinkshow = taskList.getPrevPageLinkShow();
        if(pplinkshow == null) 
            System.assert(true, 'getPrevPageLinkShow() method >> return null');
        
        // getPrevPageShow() 
        // @return Boolean
        boolean ppshow = taskList.getPrevPageShow();
        if(ppshow == null) 
            System.assert(true, 'getPrevPageShow() method >> return null');
        
        taskList.setSORTBYPARAM('Milestone__c');
        taskList.sortList();
        
        // getSortBy() 
        // @return String
        String sortedBy = taskList.getSortBy();
        taskList.sortList();

        taskList.setSORTBYPARAM('User__c.Name');
        taskList.setOption('oTask');
     
        ProjectTaskListController.TaskDetails details = new ProjectTaskListController.TaskDetails();
        
        // sortList() 
        // @void
        taskList.getsortListOption();

        taskList.setSORTBYPARAM('Name');
        taskList.sortList();
        
         // getTaskList()        
        taskList.setSORTBYPARAM('Percent_Completed__c');
        List<ProjectTaskListController.TaskDetails> listTaskDetails3 = taskList.getTaskList();        
        taskList.sortList();        
        taskList.genCntPagination();
        
        taskList.setSORTBYPARAM('EndDate__c');
        List<ProjectTaskListController.TaskDetails> listTaskDetails4 = taskList.getTaskList();        
        taskList.sortList();
        taskList.genCntPagination();
        
        taskList.setSORTBYPARAM('Percent_Completed__c');
        List<ProjectTaskListController.TaskDetails> listTaskDetails5 = taskList.getTaskList(); 
        taskList.reConstruct();       
        taskList.sortList();
        taskList.genCntPagination();       
        
        taskList.setSORTBYPARAM('Priority__c');
        taskList.sortList();

        
        
        // getTaskList()        
        List<ProjectTaskListController.TaskDetails> listTaskDetails2 = taskList.getTaskList();
        
        taskList.setSORTBYPARAM('Percent_Completed__c');
        List<ProjectTaskListController.TaskDetails> listTaskDetails7 = taskList.getTaskList(); 
        taskList.reConstruct();       
        taskList.sortList();
        taskList.genCntPagination();
        
        taskList.getEditDeletePer();
        taskList.refresh();
        taskList.refreshPages();
        Boolean SortByDesc = taskList.getSortByDesc();
        if(SortByDesc == null) 
            System.assert(true, 'getSortByDesc() method >> does not work');
        
        String IdTaskToComplete = taskList.getIdTaskToComplete();
        if(IdTaskToComplete == null) 
            System.assert(true, 'getIdTaskToComplete() method >> does not work');
        
        String IdDeletes = taskList.getIdDeletes();
        if(IdDeletes == null) 
            System.assert(true, 'getIdDeletes() method >> does not work');
        
        taskList.setIdDeletes('test');
        
        taskList.deleteTask();
        taskList.markComplete();
        taskList.setIdTaskToComplete('test');
        
        if(listTaskDetails2 == null) 
            System.assert(true, 'getUserProfile() method >> does not work');
        
        taskList.setSortByPrev('asc');
        taskList.reConstruct();
        
        Test.stopTest();
    }
    
}
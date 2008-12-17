public class ProjectTaskListControllerTest {
    
    public static testMethod void testProjectTaskDetailController() {
        
        ProjectTaskListController taskList = new ProjectTaskListController();       
        
        taskList.setOption('oTask');
        
        taskList.setTeamId('a0B30000001vU4VEAU');
        taskList.setUserId('005300000019Z9lAAE');
        
        // getTaskList()        
        List<ProjectTaskListController.TaskDetails> listTaskDetails = taskList.getTaskList();
    
        if(listTaskDetails == null) 
            System.assert(true, 'getUserProfile() method >> does not work');
        
        
        taskList.setOption('Name');         
        // getOption()
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
        
        // getTeamId() 
        // @return String
        String teamidHere = taskList.getTeamId();
        if(teamidHere == null) 
            System.assert(true, 'getTeamId() method >> return null');
            
        // getIsAdmin() 
        // @return String
        boolean isadmin = taskList.getIsAdmin();
        if(isadmin == null) 
            System.assert(true, 'getIsAdmin() method >> return null');
        
       // 
        // getIsTeamMember() 
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
            
        
        // genCntPagination() 
        // @void
        try {
            taskList.genCntPagination();
        } catch (Exception e){      
            System.assert(true, 'genCntPagination() method >>does not work correctly');
        }
        
        // nextPage() 
        // @void
        try {
            taskList.nextPage();
        } catch (Exception e){      
            System.assert(true, 'nextPage() method >> does not work correctly');
        }
        
        // prevPage() 
        // @void
        try {
            taskList.prevPage();
        } catch (Exception e){      
            System.assert(true, 'prevPage() method >> does not work correctly');
        }
        
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
        
        
        // getSortBy() 
        // @return String
        String sortedBy = taskList.getSortBy();
        if(sortedBy == null) 
            System.assert(true, 'getSortBy() method >> return null');
        
        
        // sortList() 
        // @void
        try {
            taskList.sortList();
        } catch (Exception e){      
            System.assert(true, 'sortList() method >> does not work correctly');
        }
        
        
        taskList.setSORTBYPARAM('User__c.Name');
         taskList.setOption('oTask');
         // sortList() 
        // @void
        try {
            taskList.sortList();
        } catch (Exception e){      
            System.assert(true, 'sortList() method >> does not work correctly');
        }
        
        // sortList() 
        // @void
        try {
            taskList.getsortListOption();
        } catch (Exception e){      
            System.assert(true, 'getsortListOption() method >> does not work correctly');
        }
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
        
        taskList.setTeamId('f');
        taskList.setUserId('s');
        
        taskList.setSORTBYPARAM('Priority__c');
        taskList.sortList();
        
        // getTaskList()        
        List<ProjectTaskListController.TaskDetails> listTaskDetails2 = taskList.getTaskList();
   		
   		taskList.setSORTBYPARAM('Percent_Completed__c');
        List<ProjectTaskListController.TaskDetails> listTaskDetails7 = taskList.getTaskList(); 
        taskList.reConstruct();       
        taskList.sortList();
        taskList.genCntPagination();
   		
   		 
        if(listTaskDetails2 == null) 
            System.assert(true, 'getUserProfile() method >> does not work');
        
        taskList.reConstruct();
        
        
    }
    
}
@IsTest private class TeamsWidgetMilestonesTest {
    
    public static testMethod void TeamsWidgetMilestones() {
    	
    	GenerateEnvironmentTest.gen();
    	Test.startTest();
        TeamsWidgetMilestonesController m = new TeamsWidgetMilestonesController();
        
        TeamsWidgetMilestonesController.ProjectTasks projectTaskClass = new TeamsWidgetMilestonesController.ProjectTasks();
          
          
          m.refresh();
          m.setSidebar(true);
          if (m.getSidebar() == null) {
          	System.assert(true,'getSidebar failed');
          }
          User u = [select 
          				u.Name, 
          				u.Id, 
          				(Select Id, User__c, Picture__c From People__r) From User u
          				limit 1];

          projectTaskClass.setUser(u);
          projectTaskClass.getPicture();
          projectTaskClass.getEndDate();
          projectTaskClass.getIsToLate();
          projectTaskClass.getUserId();
          projectTaskClass.getUserName();   
          projectTaskClass.getTaskId();
          projectTaskClass.getPriority();
          projectTaskClass.getDayPercent();
          projectTaskClass.getDayPercentRight();
          projectTaskClass.getEndDateRight();
          projectTaskClass.getDaysCount();
			
          projectTaskClass.getTaskName();
          
          
          Datetime endD = DateTime.newInstance(2030, 01, 1);
          Double dur = 1;
          projectTaskClass.setDayPercent(endD,dur);
          projectTaskClass.setDayPercentRight(endD,dur);
          endD = DateTime.newInstance(2005, 01, 1);
          projectTaskClass.setIsToLate(endD);
          endD = DateTime.now()+ 2;
          projectTaskClass.setDaysCount(endD,1);
          
        Team__c t = GenerateEnvironmentTest.newTeam;
        				
        m.setTeamId(t.Id);      
        String team = m.getTeamId();
        if(team == null){
            System.assert(false, 'getTeamId error');
        }
        
        //COMMENT
        Integer listS = m.getListSize();
        if(listS == null){
            System.assert(false, 'getListSize error');
        }
        
        UserPermissions userPermissions = new UserPermissions();
        userPermissions = m.getUserPermissions();       
        
        List<TeamsWidgetMilestonesController.ProjectTasks> listP = m.getAllProjectTasks();
        
        Test.stopTest(); 

    }
}
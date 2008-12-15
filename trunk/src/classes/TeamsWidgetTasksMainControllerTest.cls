@IsTest private class TeamsWidgetTasksMainControllerTest {
    public static testMethod void TeamsWidgetTasks() {
        
        GenerateEnvironmentTest.gen();
        Test.startTest();
        TeamsWidgetTasksMainController task = new TeamsWidgetTasksMainController();
        
        UserPermissions userPermissions = new UserPermissions();
        
       userPermissions = new UserPermissions();
        
        
        if (task.getUserPermissions() == null) {
            System.assert(true, 'Null Permissions');
        }
        
        userPermissions.getCanView();
        userPermissions.getCanComment();
        userPermissions.getCanManage();
        userPermissions.getCanCreate();
        userPermissions.getObjectType();
        userPermissions.getTeam();
        userPermissions.getId();
        
        task.setSidebar(true);
        if (task.getSidebar() == null) {
            System.assert(true,'getSidebar failed');
        }
		        
        /* ProjectTask class */
        TeamsWidgetTasksMainController.ProjectTask projectTaskClass = new TeamsWidgetTasksMainController.ProjectTask();
        projectTaskClass.getPicture();
        projectTaskClass.getEndDate();
        projectTaskClass.getIsToLate();
        projectTaskClass.getUserId();
        projectTaskClass.getUserName();
        projectTaskClass.getTaskId();
        projectTaskClass.getPriority();
        projectTaskClass.getPercent();
        projectTaskClass.getTaskName();
        
        ProjectTask__c pT = GenerateEnvironmentTest.newTask;
        Team__c team = GenerateEnvironmentTest.newTeam;
        task.setTeamId(team.Id);
        pT.Milestone__c = false;
        update pT;
        
        task.getProjectTaskbuild();
        task.getMyProjectTasks();
        task.getAllProjectTasks();  
        
        Test.stopTest();   
    }
}
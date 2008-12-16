@IsTest private class ProjectTaskDetailControllerTest {
    
    public static testMethod void testProjectTaskDetailController() {   
        
        GenerateEnvironmentTest.gen();
    	Test.startTest();
        
        ProjectTaskDetailController taskDetailController = new ProjectTaskDetailController();
        taskDetailController.setTaskId(GenerateEnvironmentTest.newTask.Id);
        ProjectTask__c newTask = [select id from ProjectTask__c limit 1];        
        taskDetailController.getTask(newTask.Id);
        taskDetailController.markComplete();                   
        
        ProjectTaskDetailController.TaskDetails a = taskDetailController.getTask();
         
        if(a.StartDate == null )
            System.assert(true, 'List has no rows assigned to project task'); 
        if(taskDetailController.getDetailsOk() == null)
            System.assert(true, 'boolean detailsok not defined'); 
        
        ProjectTaskDetailController.ProjectAssignee projectAss = new ProjectTaskDetailController.ProjectAssignee();
        
        if(projectAss.getId() == null) 
            System.assert(true, 'Project Assignee Class null var');     
        if(projectAss.getName() == null) 
            System.assert(true, 'Project Assignee Class null var');     
        if(projectAss.getPercent() == null) 
            System.assert(true, 'Project Assignee Class null var');     
        
        ProjectTaskDetailController.AttachmentInfo attchInfo = new ProjectTaskDetailController.AttachmentInfo();
        
        if(attchInfo.getId() == null) 
            System.assert(true, 'Attachment Info Class null var');  
        if(attchInfo.getName() == null) 
            System.assert(true, 'Attachment Info Class null var');  
        if(attchInfo.getAttachImage() == null) 
            System.assert(true, 'Attachment Info Class null var');  
                
    	Test.stopTest();
        
    }
}
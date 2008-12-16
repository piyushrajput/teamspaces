public class ProjectTaskDetailTest {

    public static testMethod void testProject() { 
    
        ProjectTaskDetailController project = new ProjectTaskDetailController();
        
        ProjectTaskDetailController.TaskDetails TaskDetail   = new ProjectTaskDetailController.TaskDetails();
        
        List<Team__c> t = [Select Id From Team__c where Name LIKE 'Sunshine'];
        
        System.assert(t.size() == 0,'no teams');
//
        if(t.size() > 0) 
        {
            Id tId = t[0].Id;
            
            List<Project2__c> p = [Select Id From Project2__c where Team__c =:  tId ];
            
            System.assert(p.size() == 0,'no porjects'); 
            
            if(p.size() > 0) 
            {
                
                Id pId = p[0].Id;
                
                List<ProjectTask__c> pt = [Select Id From ProjectTask__c where Team__c =: pId ];        
                System.assert(pt.size() == 0,'no tasks'); 
                
                List<ProjectTask__c> TD = [Select p.Id,
                                                            p.Team__c,
                                                            p.Team__r.Name, 
                                                            p.StartDate__c, 
                                                            p.Priority__c, 
                                                            p.ParentTask__c, 
                                                            p.Percent_Completed__c,
                                                            p.Name, 
                                                            p.Milestone__c, 
                                                            p.LastModifiedById, 
                                                            p.EndDate__c, 
                                                            p.Duration__c, 
                                                            p.Description__c, 
                                                            p.CreatedById, 
                                                            (Select Id, User__c From ProjectAssignee__r) 
                                                            From ProjectTask__c p where p.Id =:  pt[0].Id ];
                                                            
                                                            
                System.assert(TD.size() == 0,'El valor  no tiene nada');
                    
                TaskDetail.id = TD[0].Id;
                    
                    String id=TaskDetail.id;
                    
                    //TaskDetail.AsigneeName = TD.ProjectAssignee__r[0].User__c;
                    TaskDetail.Name = TD[0].Name;
                    String name=TaskDetail.Name;
                    
                    TaskDetail.TeamName = TD[0].Team__r.Name;
                    String teamName=TaskDetail.TeamName;
                    
                    TaskDetail.Priority = TD[0].Priority__c;
                    String priority=TaskDetail.Priority;
                    
                    TaskDetail.StartDate = ((TD[0].StartDate__c).format('MM/dd/yyyy'));
                    String startDate=TaskDetail.StartDate;
                    
                    TaskDetail.DueDate = ((TD[0].EndDate__c).format('MM/dd/yyyy'));
                    String dueDate=TaskDetail.DueDate;
                    
                    TaskDetail.Estimate = (TD[0].Duration__c).intValue();
                    Integer estimate=TaskDetail.Estimate;
                    
                    TaskDetail.Description = TD[0].Description__c;
                    String description=TaskDetail.Description;
                                    
                 
            }       
                
        }
            

            
    }
}
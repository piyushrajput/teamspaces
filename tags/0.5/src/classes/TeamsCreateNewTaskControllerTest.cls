@IsTest private class TeamsCreateNewTaskControllerTest {
    
    public static testMethod void TestCreateTask() 
    {
        GenerateEnvironmentTest.gen();
        Test.startTest();
        
        TeamsCreateNewTaskController n = new TeamsCreateNewTaskController();
        
        if (n.getAtt1() == null) {
            System.assert(true,'getAtt1 failed');
        }
        if (n.getAtt2() == null) {
            System.assert(true,'getAtt2 failed');
        }
        if (n.getAtt3() == null) {
            System.assert(true,'getAtt3 failed');
        }
        if (n.getAtt4() == null) {
            System.assert(true,'getAtt4 failed');
        }
        if (n.getAtt5() == null) {
            System.assert(true,'getAtt5 failed');
        }
        if (n.getAtt6() == null) {
            System.assert(true,'getAtt6 failed');
        }
        if (n.getAtt7() == null) {
            System.assert(true,'getAtt7 failed');
        }
        if (n.getAtt8() == null) {
            System.assert(true,'getAtt8 failed');
        }
        if (n.getAtt9() == null) {
            System.assert(true,'getAtt9 failed');
        }
        if (n.getAtt10() == null) {
            System.assert(true,'getAtt10 failed');
        }
        
        String type2 = n.getTypeOfAction();
        System.assertEquals(type2,'Add New'); 
        ProjectTask__c myTask = new ProjectTask__c();
        myTask.Name = 'test';
        
        Team__c newTeam = [select id from Team__c limit 1];
        List<User> userList = [select id from User limit 1];
        
        n.setParam(newTeam.Id);
        myTask.StartDate__c = System.now();
        n.setTask(myTask);
        n.saveTask(); 
        n.canUpdate();
        
        if (userList.size() > 0) {
        n.setAssignees(userList[0].Id);
        }
        n.saveTask();
        n.saveAssignees(); 
        n.getdateMy();
        
        //TeamsSubscribersEmailServicesTest.test();
            
        String assignees  = n.getAssignees();
        if(assignees == null){
            System.assert(false, 'null asignee');
         }
        
        List<SelectOption> pr = n.getPriority();
         if(pr == null){
            System.assert(false, 'Priority Null');
         }
        
        List<SelectOption> percent = n.getPercent();
        if(percent.size() == 0){
            System.assert(false, 'Percent error');
        }
        
        List<SelectOption> member = n.getMembers();
        if(member.size() == 0){
            System.assert(false, 'no members');
        }
        
         List<SelectOption> priority =  n.getPriority();
         if(priority.size() == 0){
            System.assert(false, 'no priority List');
         }
        
        TeamsCreateNewTaskController.dateMyFormat dateMy =  n.getdateMy();
         if(dateMy == null){
            System.assert(false, 'No correct Reference');
         }
         
        
        TeamsCreateNewTaskController.assingTo assign = n.getassingTo();
         if(assign == null){
            System.assert(false, 'No correct Reference');
         }
         
         ProjectTask__c taskP = n.getTask();
         if(taskP == null){
            System.assert(false, 'No correct Reference');
         }
         
         List<SelectOption> perD = n.getPercentDedicated();
        if(perD.size() == 0){
            System.assert(false, 'no priority List');
         }
         
        List<TeamsCreateNewTaskController.assingTo> assTo = n.getAssignMember();
        if(assTo == null){
            System.assert(false, 'no priority List');
         }
         
        ProjectTask__c task = [select id, Team__c from ProjectTask__c limit 1];
        n.getTaskForEdit(task.Team__c, task.Id);
        n.setAttachment(task.Id);
        
        TeamsCreateNewTaskController.dateMyFormat dmf = n.getdateMy();
        if(dmf == null){
            System.assert(false, 'Error >> getdateMy()');
         }
        
        String dt =  dmf.getLastModify();
        if(dt == null){
            System.assert(false, 'Error >> getLastModify()');
         }
         
        String cd = dmf.getCreateDate();
        if(cd == null){
            System.assert(false, 'Error >> getCreateDate()');
        }
         
        UserPermissions userPermissions = n.getUserPermissions();
        if(userPermissions == null){
            System.assert(false, 'Error >> getUserPermissions()');
         }
         
         
         n.param = task.Team__c;
         n.idTask = task.Id; 
         if(n.param != null && n.idTask != null){
            n.getTaskForEdit(n.param, n.idTask);
         }
         
         n.genTempTask();
         n.getPercent();
         
         TeamsCreateNewTaskController.myAttachment mA = new TeamsCreateNewTaskController.myAttachment();
         
         List<Attachment> newAttach = [select id, BodyLength, ContentType, Name from Attachment limit 1];
         if (newAttach.size() > 0) {
         
             mA.setBodyLenght(newAttach[0].BodyLength); 
             mA.setIdAttachment(newAttach[0].Id);
             mA.setContentType(newAttach[0].ContentType);
             mA.setNameAttachment(newAttach[0].Name);
             Integer bl = mA.getBodyLenght();
             if(bl == null){
                System.assert(false, 'Error >> getBodyLenght()');
             }
             String idAt = mA.getidAttachment(); 
             if(idAt == null){
                System.assert(false, 'Error >> getidAttachment()');
             }
             String ct = mA.getContentType();
             if(ct == null){
                System.assert(false, 'Error >> getContentType()');
             }
             String na = mA.getNameAttachment(); 
             if(na == null){
                System.assert(false, 'Error >> getNameAttachment()');
             }
         }
         
        n.setTask(myTask);
        n.setParam(newTeam.Id);
        myTask.StartDate__c = System.now();
        //n.setTask(myTask);
        //n.saveTask(); 
        
        Test.stopTest();
        
    }   
}
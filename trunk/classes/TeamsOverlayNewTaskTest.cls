@IsTest private class TeamsOverlayNewTaskTest {
	 public static testMethod void TeamsOverlayNewTaskTest(){
	 	
	 	GenerateEnvironmentTest.gen();   
    	Test.startTest();
	 	TeamsOverlayNewTaskController con =  new TeamsOverlayNewTaskController();
	 	if(con.getTask() == null)
            System.assert(true, 'getTask Failed');  
        if(con.getTeamMember() == null)
            System.assert(true, 'getTeamMember Failed');  
        if(con.getCurrentTeamId() == null)
            System.assert(true, 'getCurrentTeamId Failed');  
        if(con.getTeamMembers() == null)
            System.assert(true, 'getTeamMembers Failed');  

        ProjectTask__c pT = new ProjectTask__c();
        pT.Name = 'Test Task';
        
        Team__c t = [select Id, Name from Team__c limit 1];
        TeamMember__c tM = [select id, Name, User__c, Team__c from TeamMember__c where team__c =: t.id limit 1];
       	con.setTEAMID(t.Id);
        con.getCurrentProject();
        con.genPermissions();
        
        con.setTask(pT);
        con.setTeamMember(tM);
		con.refreshMethod();
		con.dummyRefresh();
		con.getTeamMembers();
		con.insertTask();
		
		Test.stopTest();
	 }
}
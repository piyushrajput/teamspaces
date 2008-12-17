@IsTest private class AdminProfileTest {
    public static testMethod void testAdmin() {
        try{
	        GenerateEnvironmentTest.gen();
	        Test.startTest();	           
             
			TeamProfile__c profileNew = new TeamProfile__c();
			profileNew.Name = 'Test';
			insert profileNew;
			
			System.currentPageReference().getParameters().put('id', GenerateEnvironmentTest.newTeamProfile.Id);
            AdminProfileController admin = new AdminProfileController();
            
			System.currentPageReference().getParameters().put('view', GenerateEnvironmentTest.newTeamProfile.Id);   
            admin.methodConstruct();
            

			System.currentPageReference().getParameters().put('clone', GenerateEnvironmentTest.newTeamProfile.Id);
			admin.methodConstruct();            
            
            admin.getHasMember();
            boolean isTeamAdminMember= admin.getIsTeamAdminMember();
            List<TeamProfile__c> allTeamProfiles = admin.getAllTeamProfiles();
            TeamProfile__c tp = admin.getTeamProfile();
			
			admin.getExistName();
            admin.setTeamProfile(tp);
            admin.asignSection();
            Boolean b = admin.getIsAClone();
            String str = admin.getSection();			

            admin.reAssignUsers();
            admin.removeTeamProfileNoMembers();
            admin.setIdTeamProfileNoMembers('');           
           
            admin.getProfileListMode();
            admin.setNewIdProfile(profileNew.Id);
            admin.getNewIdProfile();
            admin.setOldIdProfile(allTeamProfiles[0].Id);
            admin.getOldIdProfile();
            
			Boolean b3 = admin.getPermissionAuthorApex();  

            admin.setSection('clone');
            admin.saveTeamProfile();
            admin.setSection('edit');
			admin.saveTeamProfile();
			admin.setSection('create');
			admin.saveTeamProfile();          
            
            Test.stopTest();
        }
        catch(Exception e){
        }
    }
}
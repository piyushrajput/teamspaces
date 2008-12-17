@IsTest private class AdminMainSetupTest {
	
	/**
	* Test Admin Main Setup
	*/
	public static testMethod void testAdmin() {
		
        GenerateEnvironmentTest.gen();
        Test.startTest();		
		
		AdminMainSetupController admin = new AdminMainSetupController();
		 
		try{	
			TeamProfile__c profile = new TeamProfile__c();
			profile.Name = 'Test';
			insert profile;
			
			profile = [select Id, Name, CreatedById, CreatedDate from TeamProfile__c where id =: profile.Id limit 1];
			
			
			admin.getNewIdProfile();
			admin.setNewIdProfile(profile.Id);
			AdminMainSetupController.TeamProfile teamProfiles =  new AdminMainSetupController.TeamProfile(profile);		
			admin.getTeamTypes();
			
			TeamType__c teamType = new TeamType__c();
			teamType.Name = 'Test';
			insert teamType;
			
			teamType = [select Id, Name, CreatedById, CreatedDate from TeamType__c where id=: teamType.id limit 1];
			
			AdminMainSetupController.TeamTypes teamTypes=  new AdminMainSetupController.TeamTypes(teamType);
			teamTypes.getTeamType();
			teamTypes.getCreator();
			teamTypes.getCreatedDate();
			
			
			admin.getTeamProfiles();
			List<AdminMainSetupController.TeamProfile> profiles = admin.getProfiles(); 
			admin.setOldIdProfile(profiles[0].teamProfile.Id);
			admin.reAssignUsers();			
			admin.getAll();
			String oldid = admin.getOldIdProfile();
			List<AdminMainSetupController.TeamTypes> types = admin.getTypes();
			Boolean b = teamTypes.getHasTeams();
			Integer i = teamTypes.getTeams();
			
			AdminMainSetupController.TeamProfile newProfile = new AdminMainSetupController.TeamProfile(profile);
			profile = newProfile.getTeamProfile();
			User testuser = newProfile.getCreator();
			String dateTest = newProfile.getCreatedDate();
			newProfile.getCreatorName();			
			admin.getAll();
			
			Test.stopTest();
			
		} catch (DmlException e) {
			System.assert(false,'Data base error')	;
		}
		
	}
}
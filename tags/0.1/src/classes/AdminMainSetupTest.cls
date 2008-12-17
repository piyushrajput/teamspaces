public class AdminMainSetupTest {
	public static testMethod void testAdmin() {
		
		AdminMainSetupController admin = new AdminMainSetupController();
		
		try{	
			admin.getTeamTypes();
			TeamType__c teamType = [select Id, Name, CreatedDate, CreatedById from TeamType__c limit 1];
			AdminMainSetupController.TeamTypes teamTypes=  new AdminMainSetupController.TeamTypes(teamType);
			admin.getTeamProfiles();
			List<AdminMainSetupController.TeamProfile> profiles = admin.getProfiles(); 
			admin.setOldIdProfile(profiles[0].teamProfile.Id);
			admin.reAssignUsers ();
			admin.getAll();
			String oldid = admin.getOldIdProfile();
			List<AdminMainSetupController.TeamTypes> types = admin.getTypes();
			Boolean b = teamTypes.getHasTeams();
			Integer i = teamTypes.getTeams();
		} catch (DmlException e) {
			System.assert(false,'Data base error')	;
		}
		TeamProfile__c profile = [select Id, Name, CreatedDate, CreatedById from TeamProfile__c limit 1];
		AdminMainSetupController.TeamProfile teamProfiles=  new AdminMainSetupController.TeamProfile(profile);
	
	}
}
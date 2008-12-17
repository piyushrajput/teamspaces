public class AdminProfileTest {
	public static testMethod void testAdmin() {
		try{
			AdminProfileController admin = new AdminProfileController();
			boolean isTeamAdminMember= admin.getIsTeamAdminMember();
			List<TeamProfile__c> allTeamProfiles= admin.getAllTeamProfiles();
			TeamProfile__c tp = admin.getTeamProfile();
			admin.asignSection();
			Boolean b = admin.getIsAClone();
			String str = admin.getSection();
			Boolean b2 = admin.getExistName();
			admin.setSection('string');
			Boolean b3 = admin.getPermissionAuthorApex();
			Id ide = admin.getQueueGroupId();
		}
		catch(Exception e){
		}
	}
}
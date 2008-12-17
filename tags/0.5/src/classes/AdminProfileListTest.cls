@IsTest private class AdminProfileListTest {
    public static testMethod void testAdmin() {
        try
        {
            GenerateEnvironmentTest.gen();
             
            Test.startTest();
            
            AdminProfileListController admin = new AdminProfileListController();
            TeamProfile__c profile = [select t.Id, t.CreatedById, t.CreatedDate, 
						t.Name, (Select Id From TeamMember__r) from TeamProfile__c t order by t.CreatedDate desc limit 1];
            
            TeamMember__c member = profile.TeamMember__r[0];
            member.Name = 'Some name';
            update member;
            
            admin.setOldIdProfile(profile.Id);
            admin.getTeamProfiles();
            String TestinfGetoldProfile = admin.getOldIdProfile();

            AdminProfileListController.TeamProfile teamProfiles =  new AdminProfileListController.TeamProfile(profile);
           	teamProfiles.getTeamProfile();
           	teamProfiles.getCreatorName();
           
            List<AdminProfileListController.TeamProfile> tp2 = admin.getProfiles ();
            admin.setOldIdProfile(tp2[0].teamProfile.Id);
            User u = tp2[0].getCreator();
            admin.setNewIdProfile(tp2[0].teamProfile.Id);
            
            String str = tp2[0].getCreatedDate();
            String str2 = admin.getNewIdProfile();
            String str3 = admin.getOldIdProfile();
            admin.reAssignUsers();
			admin.setIdTeamProfileNoMembers(profile.Id);
			//admin.removeTeamProfileNoMembers();
			
			Test.stopTest();
			
        } catch (DmlException e) {
  
        }
    }
}
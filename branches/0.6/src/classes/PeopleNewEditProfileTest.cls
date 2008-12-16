@IsTest private class PeopleNewEditProfileTest {
    public static testMethod void testPeople() {
        try{
			GenerateEnvironmentPeopleTest.gen();
			Test.startTest();

            ApexPages.StandardController controller;
            PeopleNewEditProfileController people = new PeopleNewEditProfileController(controller);
            
            PeopleProfile__c newUserProfile = new PeopleProfile__c();
            List<PeopleProfile__c> userProfiles = [select id from PeopleProfile__c where User__c =:UserInfo.getUserId()];
            if(userProfiles.size() == 0) {
	            newUserProfile.User__c = UserInfo.getUserId();
	            newUserProfile.Name= 'foo';
				newUserProfile.YahooIM__c= 'foo';
				newUserProfile.Skype__c= 'foo';
				newUserProfile.HomePageUrl__c= 'foo';
				newUserProfile.Gtalk__c= 'foo';
				newUserProfile.Facebook__c= 'foo';
				newUserProfile.Delicious__c= 'foo';
				newUserProfile.Aol__c= 'foo';
				newUserProfile.AboutMe__c= 'foo';
				newUserProfile.Linkedin__c= 'foo';
				newUserProfile.changeHistory__c= 'foo';
				newUserProfile.changeHistoryDate__c = System.now();
	            upsert newUserProfile;
            }
            people.setParam(UserInfo.getUserId());
            people.getPeopleProfile();
            people.getPProfile();
            PeopleProfile__c peopleProfile = people.getMySidebarProfile();
            people.getStatus();
            people.getShowStatus(); 
            people.getMyPicture();
            people.getCurrentTime();
            people.findPeople();
            people.getPeopleSearchObj();
            people.getError();
            people.init();          
            people.savePeopleProfile();
            people.cancelProfile();
            people.getNewUser();
            people.forwardTo('/apex/teamsOverview');
            
            PeopleNewEditProfileController.PeopleSearch peopleSrch = new PeopleNewEditProfileController.PeopleSearch();
            peopleSrch.setKeyword('word');
            peopleSrch.getKeyword();
            
            PeopleNewEditProfileController.Status status= new PeopleNewEditProfileController.Status();
            DateTime now = System.now();
            status.setModified(now);
            status.setMessage('Some Message');
            status.getMessage();
            
			Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}
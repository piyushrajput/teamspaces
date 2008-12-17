@IsTest private class PeopleSidebarControllerTest {
    public static testMethod void testProjectTaskDetailController() {
        try{
            PeopleSidebarProfileController sidebar = new PeopleSidebarProfileController();
            
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
            
            sidebar.getCurrentTime();
            sidebar.getShowStatus();
            
            
            List<PeopleProfile__c> profiles = sidebar.getPeopleProfile();
            String s1 = sidebar.getCurrentTime();
            String s2 = sidebar.getMyPicture();
            PeopleProfile__c profile = sidebar.getMySidebarProfile();
            sidebar.subscriptionCounts();
            Integer n1 = sidebar.getCountImSubscribedTo();
            Integer n2 = sidebar.getCountSubscribedToMe();
            Boolean b1 = sidebar.getShowSubscribedPeople();
            
            //STATUS inner class
            PeopleSidebarProfileController.Status status = new PeopleSidebarProfileController.Status();
            status = sidebar.getStatus();
            status.getMessage();
            status.setModified(System.now());
            
            Datetime myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day(), System.now().hour(), System.now().minute() - 1, System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day(), System.now().hour(), System.now().minute() - 2, System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day(), System.now().hour() - 2, System.now().minute(), System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day() - 2, System.now().hour(), System.now().minute(), System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day() - 8, System.now().hour(), System.now().minute(), System.now().second());
            status.setModified(myDate);
            
            status.getModified();  
            
            sidebar.EditStatus();
            
        }catch(Exception e){
            throw e;
        }
    }
}
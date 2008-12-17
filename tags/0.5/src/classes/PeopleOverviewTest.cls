@IsTest private class PeopleOverviewTest { 
    public static testMethod void testPeople() {
        try{        
			GenerateEnvironmentPeopleTest.gen();
			Test.startTest();

            PeopleOverviewController overview = new PeopleOverviewController();
                
            String time = overview.getCurrentTime();
            PageReference page = overview.profileExist();
            
            List<PeopleProfile__c> profile = overview.getPeopleProfile();
            List<PeopleOverviewController.People> newFaces = overview.getNewFaces();
            List<PeopleOverviewController.CloudItems> clouds1 = overview.generateCloud('Employer');
            List<PeopleOverviewController.CloudItems> clouds2 = overview.generateCloud('School');
            List<PeopleOverviewController.CloudItems> clouds3 = overview.generateCloud('Competency');           
            List<PeopleOverviewController.CloudItems> competenciesCloud = overview.getCompetenciesCloud(); 
            List<PeopleOverviewController.CloudItems> formerCompaniesCloud = overview.getFormerCompaniesCloud();

            // PEOPLE inner class
            PeopleOverviewController.People peopleObject = new PeopleOverviewController.People();
            peopleObject.getUserId();
            peopleObject.getUsername();
            peopleObject.getDivision();
            peopleObject.getDepartment();
            peopleObject.getTitle();
            peopleObject.getImageId();
            
            
            // MINIFEED inner class
            PeopleOverviewController.minifeed minifeedObject = new PeopleOverviewController.minifeed();
            minifeedObject.getTypeOfFeed();
            minifeedObject.getName();
            minifeedObject.getUser();
            minifeedObject.getMessage();
            minifeedObject.getFeedDate();
            minifeedObject.getFeedDateString();
            minifeedObject.getFeedDateClass();
            
            // CLOUDITEMS inner class
            PeopleOverviewController.CloudItems cloudItemsObject = new PeopleOverviewController.CloudItems();
            cloudItemsObject.getName();
            cloudItemsObject.getLevel();
            cloudItemsObject.getCount();
            
            MiniFeed__c auxMiniFeed = new MiniFeed__c();
            auxMiniFeed.Message__c = 'is fooing';
            auxMiniFeed.Type__c = 'PeopleChangeStatus';
            auxMiniFeed.User__c = UserInfo.getUserId();
            insert auxMiniFeed;
            
            PeopleSubscription__c newPeopleSub = new PeopleSubscription__c();
            newPeopleSub.Subscriber__c = UserInfo.getUserId();
            newPeopleSub.Person__c = UserInfo.getUserId();	 
            insert newPeopleSub;
            
            List<PeopleOverviewController.miniFeed> feeds = overview.getMiniFeeds();
            String feedType = feeds[0].getTypeOfFeed();
            feeds[0].setTypeOfFeed('Some Type');
            feeds[0].setName('Some Name');
            String feedName = feeds[0].getName();
            String userName = feeds[0].getUser();
            feeds[0].setUser(UserInfo.getUserName());
            String message = feeds[0].getMessage();
            feeds[0].setMessage('Some Message');
            Datetime d = feeds[0].getFeedDate();
            feeds[0].setFeedDate(System.now());
            String dateStr = feeds[0].getFeedDateString();
            feeds[0].setFeedDateString(System.now().format('HH:mm:ss.SSS'));
            String dateClass = feeds[0].getFeedDateClass();
            feeds[0].setFeedDateClass(dateClass); 
            
			Test.stopTest();
        }catch(Exception e){
            throw e;
        }   
    }   
}
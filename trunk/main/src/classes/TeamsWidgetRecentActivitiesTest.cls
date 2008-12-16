@IsTest private class TeamsWidgetRecentActivitiesTest {

    public static testMethod void testTeam() {
        
        try{
            GenerateEnvironmentTest.gen();
            Test.startTest();              
            
            TeamsWidgetRecentActivitiesController team = new TeamsWidgetRecentActivitiesController();   
            List<TeamsWidgetRecentActivitiesController.miniFeed> feeds=team.getMiniFeeds(); 
            Team__c t = GenerateEnvironmentTest.newTeam;
            team.setTeamId(t.Id);
            
            //setting and getting sidebar
            team.setSidebar(true);
            team.getSidebar();
            
            TeamsWidgetRecentActivitiesController.miniFeed feed = new TeamsWidgetRecentActivitiesController.miniFeed();
            
            List<String> types = new List<String>();
            types.add('EducationHistory__c');
            types.add('UserCompetencies__c');
            types.add('DiscussionThread__c');
            types.add('EmploymentHistory__c');
            types.add('Announcement__c');
            types.add('TeamMember__c');
            
            Integer cant = types.size();
            for(Integer i = 0; i < cant ; i++){
                feed.setTypeOfFeed(types[i]);
                feed.getTypeOfFeed();
            }
            feed.setName('Name');
            feed.setUser('User');
            feed.setMessage('Message');
            Datetime myDateTime = Datetime.now();
            feed.setFeedDate(myDateTime);
            feed.setFeedDateString('DateTimestring');
            feed.setFeedDateClass('feedDateClass');
            
            String teamId = team.getTeamId();
            String name = feed.getName();
            String userName = feed.getUser();
            String message = feed.getMessage();
            Datetime d = feed.getFeedDate();
            String feedDate = feed.getFeedDateString();
            String feedClass = feed.getFeedDateClass();

            Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    
    }

}
@IsTest private class TriggersTest {

	public static testMethod void test() {
	 	GenerateEnvironmentTest.gen();
        Test.startTest();
    	// Create a new WikiRecentlyViewed Object
    	WikiPage__c newWiki = GenerateEnvironmentTest.newWiki;
    	WikiRecentlyViewed__c newWikiRecentlyViewed = new WikiRecentlyViewed__c();
    	newWikiRecentlyViewed.User__c = newWiki.PageCreatedBy__c;
    	newWikiRecentlyViewed.Name = newWiki.Name;
    	newWikiRecentlyViewed.Team__c = newWiki.Team__c;
    	newWikiRecentlyViewed.WikiPage__c = newWiki.Id;
    	upsert newWikiRecentlyViewed;
    	// Create a new WikiLink Object
    	WikiLink__c  newWikiLink = new WikiLink__c ();
    	newWikiLink.Name = newWiki.Name;
    	newWikiLink.Team__c = newWiki.Team__c;
    	newWikiLink.ToLink__c = newWiki.Id;
    	newWikiLink.FromLink__c = newWiki.Id;
    	upsert newWikiLink;
    	// Create a new ProjectTaskPred Object
    	ProjectTask__c newTask = GenerateEnvironmentTest.newTask;
    	
    	ProjectTaskPred__c newTaskPred = new ProjectTaskPred__c();
    	newTaskPred.Name = 'Foo Task Predecessor';
    	newTaskPred.Team__c = GenerateEnvironmentTest.newTeam.Id;
    	newTaskPred.Predecessor__c = newTask.Id;
    	newTaskPred.Parent__c = newTask.Id;
    	upsert newTaskPred;
    	
    	// Delete Project Task
    	delete newTask;
        
        Test.stopTest();	
	}
	
	public static testMethod void test2() {
		GenerateEnvironmentTest.gen();
        Test.startTest();
		// Update Employment History
    	Employer__c newEmployer = new Employer__c();
    	newEmployer.Name = 'Foo Employer';
    	newEmployer.City__c = 'Foo City';
    	newEmployer.Count__c = 1;
    	newEmployer.State__c = 'Foo State';
    	upsert newEmployer;
    	
    	EmploymentHistory__c newEH = new EmploymentHistory__c();
    	newEH.Name = 'Foo Name';
    	newEH.Employer__c = newEmployer.Id;
    	newEH.IsCurrentJob__c = true;
    	newEH.User__c = UserInfo.getUserId();
    	newEH.WorkedTo__c = System.today();
    	newEH.WorkedFrom__c = System.today();
    	// Set this boolean to TRUE for don't create MiniFeeds
    	TeamUtil.isTest = true;
    	upsert newEH;
    	
    	newEH.Name = 'Foo Employment History';
    	update newEH;
    	
    	TeamUtil.isTest = false;
        
        Test.stopTest();
	}
	
	public static testMethod void team() {
		
		TeamUtil.isTest = true;
		
		// Create a new Team Administrator Profile
		TeamProfile__c newTeamProfile = new TeamProfile__c();
		
		newTeamProfile.Name = 'Team Administrator';
		newTeamProfile.PostWikiComments__c = true; 
		newTeamProfile.PostDiscussionTopicReplies__c = true; 
		newTeamProfile.PostBookmarkComments__c = true; 
		newTeamProfile.PostBlogComments__c = true;  
		newTeamProfile.ManageWikis__c = true; 
		newTeamProfile.ManageTeams__c = true; 
		newTeamProfile.ManageProjectTasks__c = true; 
		newTeamProfile.ManageDiscussionForums__c = true; 
		newTeamProfile.ManageBookmarks__c = true; 
		newTeamProfile.ManageBlogs__c = true; 
		newTeamProfile.CreateWikiPages__c = true; 
		newTeamProfile.CreateProjectTasks__c = true; 
		newTeamProfile.CreateDiscussionTopics__c = true; 
		newTeamProfile.CreateBookmarks__c = true; 
		newTeamProfile.CreateBlogs__c = true;
		upsert newTeamProfile;
		
		Team__c team = new Team__c();
		
		// Create a new Team
		team.Name = 'Test class Team 2';
		team.NewMemberProfile__c = newTeamProfile.Id;
		upsert team;	
		
        Test.startTest();
		update team;
		delete team;
        	
        Test.stopTest();
	}
	
	public static testMethod void team2() {
		GenerateEnvironmentTest.gen();
        Test.startTest();
    
		TeamMember__c teamMember = [select id, Name from TeamMember__c limit 1];
		update teamMember;
		delete teamMember;
		
        Test.stopTest();
	}
	
	public static testMethod void team3() {
		GenerateEnvironmentTest.gen();
        Test.startTest();
		
		TeamProfile__c teamProfile = GenerateEnvironmentTest.newTeamProfile;
		update teamProfile;
		delete teamProfile;
    	
        Test.stopTest();
	}	
	
	public static testMethod void trigger1 () {
		GenerateEnvironmentTest.gen();
        Test.startTest();
		
		WikiPage__c sObjectRow = GenerateEnvironmentTest.newWiki;
		update sObjectRow;
		delete sObjectRow;
    	
        Test.stopTest();
	} 
	
	public static testMethod void trigger2 () {
		GenerateEnvironmentTest.gen();
        Test.startTest();
		
		ProjectTask__c sObjectRow = GenerateEnvironmentTest.newTask;
		update sObjectRow;
		delete sObjectRow;
    	
        Test.stopTest();
	} 
	
	public static testMethod void trigger3 () {
		GenerateEnvironmentTest.gen();
        Test.startTest();
		
		DiscussionMessage__c sObjectRow = GenerateEnvironmentTest.newMessage;
		update sObjectRow;
		delete sObjectRow;
    	
        Test.stopTest();
	}									
}
public class TeamsSubscribersEmailServicesTest {
    
    public static Boolean alreadyRun = false;
    
    public static testMethod void test(){
    	
    	if(!alreadyRun){
    		alreadyRun = true;
	    	GenerateEnvironmentTest.gen();
	    	Test.startTest();
	    	
	    	TeamsSubscribersEmailServices emailService = new TeamsSubscribersEmailServices();	
	    	
	    	Team__c team = [select Id, (select User__c from TeamMembers__r where User__c !=: UserInfo.getUserId()) from Team__c limit 1];
	    	
	    	TeamSubscription__c subscription = new TeamSubscription__c();
			subscription.WikiPageUpdated__c = true; 
			subscription.WikiNewPage__c = true; 
			subscription.WikiCreatedByMeUpdated__c = true; 
			subscription.TeamMemberStatusUpdated__c = true; 
			subscription.TeamMemberJoinLeave__c = true; 
			subscription.ProjectTaskDeleted__c = true; 
			subscription.ProjectTaskChanged__c = true; 
			subscription.ProjectTaskAssignedToMe__c = true; 
			subscription.ProjectTaskAssignToMeChanged__c = true;
			subscription.DiscussionReplyToMe__c = true; 
			subscription.DiscussionNewTopic__c = true; 
			subscription.DiscussionNewReply__c = true;
	    	subscription.Team__c = team.Id;
			subscription.User__c = team.TeamMembers__r[0].User__c;
			insert subscription;
			
	    	MiniFeed__c feed = new MiniFeed__c();
	    	feed.Name = 'Some name';
	    	feed.Message__c = 'Some Message';
	    	
	    	feed.Type__c = 'TeamMemberJoin';
	    	feed.User__c = team.TeamMembers__r[0].User__c;
	    	insert feed;
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');
	    	
	    	emailService.setIsTest(true);
	    	
	    	emailService.mf.Type__c = 'TeamMemberLeave';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');    	
	    	
	    	emailService.mf.Type__c = 'DiscussionNewTopic';
	    	DiscussionTopic__c auxTopic = [select id from DiscussionTopic__c order by createdDate desc limit 1];
	    	emailService.mf.Message__c = 'created new discussion topic <a href="/apex/DiscussionDetail?id=' + auxTopic.Id + '"/>Topic</a>';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');    	
	    	
	    	emailService.mf.Type__c = 'DiscussionNewReply';
	    	DiscussionMessage__c auxMessage = [select id from DiscussionMessage__c order by createdDate desc limit 1];
	    	emailService.mf.Message__c = '<span style="display:none;">' + auxMessage.Id + '</span>';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');     	
	    	
	    	
	    	ProjectTask__c auxTask = [select id from ProjectTask__c order by createdDate desc limit 1];
	    	emailService.mf.Type__c = 'TaskAssigned';
	    	emailService.mf.Message__c = '<span style="display:none;">' + auxTask.Id + '</span>';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');
	    	
	    	emailService.setIsTaskEdit(true);
	    	
	    	emailService.mf.Type__c = 'TaskAssignedDelete';
	    	emailService.mf.Message__c = '<span style="display:none;">' + auxTask.Id + '</span>';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');    	
	    	
	    	emailService.mf.Type__c = 'TaskEdited';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');
	
	    	emailService.mf.Type__c = 'TaskDelete';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');
	    	
	    	WikiPage__c wiki = [select Id from WikiPage__c limit 1];
	    	emailService.mf.Type__c = 'WikiEditPage';
	    	emailService.mf.Message__c = '<a href="/apex/WikiPage?idWP=' + wiki.Id + '">Link</a>';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');    	
	    	
	    	emailService.mf.Type__c = 'WikiNewPage';
	    	emailService.TeamsMembersSubscribers(team.Id, feed, 'Some string');     	
	    	
	    	emailService.mf.Type__c = 'PeopleChangeStatus';
	    	emailService.TeamsMembersSubscribers(null, feed, 'Some string');   
	    	
	    	Test.stopTest(); 
    	}	
    }	
}
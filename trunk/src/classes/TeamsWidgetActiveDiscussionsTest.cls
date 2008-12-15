@IsTest private class TeamsWidgetActiveDiscussionsTest {

	public static testMethod void testTeam() {
		try{
			GenerateEnvironmentTest.gen();
            Test.startTest();    			
			
			TeamsWidgetActiveDiscussionsController ad = new TeamsWidgetActiveDiscussionsController();
			Team__c team = GenerateEnvironmentTest.newTeam;
			ad.setTeamId(team.Id);
			ad.getTeamId();
			ad.getDiscussions();
			
			ad.setSidebar(true);
			ad.getSidebar();
			ad.getActiveDiscussionsSize();
			ad.refresh();
			List<DiscussionTopic__c> discussions = [select d.ViewCount__c, d.Subject__c, d.OwnerId, d.Name, d.MessageCount__c, 
										d.LastModifiedDate, d.LastModifiedById, d.Id, d.CreatedDate, d.CreatedById, d.PostedBy__c, 
										PostedBy__r.Name, LastPostedMessage__r.PostedBy__c, LastPostedMessage__r.PostedDate__c,
										LastPostedMessage__r.PostedBy__r.Name from DiscussionTopic__c d
								 		order by d.CreatedDate desc limit 1];
									
			TeamsWidgetActiveDiscussionsController.Discussion d = new TeamsWidgetActiveDiscussionsController.Discussion(discussions[0]);
			d.getDiscussion();
			d.getAuthor();
			d.getAuthorId();
			d.getLastPostDate();
			d.getLastReply();
			d.getLastReplyAuthorId();
			d.getLastReplyAuthor();
			d.getAuthorPicture();
			d.getViews();
			d.getReplies();
			d.formatDateToText(discussions[0].CreatedDate);
			d.formatDateToText(System.now());
			
			
			Test.stopTest();
		}catch(Exception e){
			throw e;
		}
	}
}
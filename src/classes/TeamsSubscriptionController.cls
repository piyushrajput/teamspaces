public class TeamsSubscriptionController {
	
	public String idTeam = System.currentPageReference().getParameters().get('id');
	
	Integer subscriptionCount;
	
	public Integer getSubscriptionCount () {
		return subscriptionCount;
	}
	
	public TeamSubscription__c subscription = new TeamSubscription__c();
	
	public TeamSubscription__c getSubscription () {
		return subscription;
	}
	
	public void setIdTeam (String idTeam) {
		this.idTeam = idTeam; 
	}
	
	public String getIdTeam () {
		return idTeam;
	}
	
	public TeamsSubscriptionController () {
		constructMethods(); 
	}
	
	public void constructMethods () {
		if (idTeam != null) {
			List<TeamSubscription__c> teamSubList = new List<TeamSubscription__c>();
			teamSubList = [select id,    
							TeamMemberStatusUpdated__c,
							TeamMemberJoinLeave__c, 
							DiscussionNewTopic__c,
							DiscussionNewReply__c,
							DiscussionReplyToMe__c,
							ProjectTaskAssignedToMe__c,
							ProjectTaskAssignToMeChanged__c,
							ProjectTaskChanged__c,
							ProjectTaskDeleted__c,
							WikiCreatedByMeUpdated__c,
							WikiNewPage__c,
							WikiPageUpdated__c,
							Team__c,
							User__c
						from TeamSubscription__c where User__c =:UserInfo.getUserId() and Team__c =: idTeam limit 1];
			if (teamSubList.size() > 0 ) {
				subscription = teamSubList[0];
			}	
			subscriptionCount = teamSubList.size();
		}
	}
	
	public PageReference saveSubscription () {
		if (subscriptionCount > 0) {
			update 	subscription;	
		}	
		else {
			subscription.Team__c = idTeam;
			subscription.User__c = UserInfo.getUserId();
			insert subscription;
		}
		PageReference pageRef = new PageReference('/apex/TeamsRedirect?id=' + idTeam);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	public PageReference cancelSubscription () {
		PageReference pageRef = new PageReference('/apex/TeamsRedirect?id=' + idTeam);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	public PageReference deleteSubscription () {
		if (subscription != null && subscriptionCount > 0 ) {
			delete subscription;
		}
		PageReference pageRef = new PageReference('/apex/TeamsRedirect?id=' + idTeam);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	
}
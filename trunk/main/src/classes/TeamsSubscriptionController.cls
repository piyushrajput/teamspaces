/**
*@author Juan Bessonart @ 09/22/2008
*/
public class TeamsSubscriptionController {
	
	public String idTeam = System.currentPageReference().getParameters().get('id');
	Integer subscriptionCount;

	/**
	* Constructor
	*/
	public TeamsSubscriptionController () {
		constructMethods(); 
	}
	
	/**
	*@return Integer
	*/
	public Integer getSubscriptionCount () {
		return subscriptionCount;
	}
	
	public TeamSubscription__c subscription = new TeamSubscription__c();
	
	/**
	*@return TeamSubscription__c
	*/
	public TeamSubscription__c getSubscription () {
		return subscription;
	}
	
	/**
	*@param String
	*/
	public void setIdTeam (String idTeam) {
		this.idTeam = idTeam; 
	}
	
	/**
	*@return String
	*/
	public String getIdTeam () {
		return idTeam;
	}

	/**
	* Execute on Construct
	*/
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
	
	/**
	* Save suscription
	*@return PageReference
	*/
	public PageReference saveSubscription () {
		if (subscriptionCount > 0) {
			update 	subscription;	
		}else {
			subscription.Team__c = idTeam;
			subscription.User__c = UserInfo.getUserId();
			insert subscription;
		}
		PageReference pageRef = Page.TeamsRedirect;
		pageRef.getParameters().put('id', idTeam);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	* Cancel suscription
	*@return PageReference
	*/
	public PageReference cancelSubscription () {
		PageReference pageRef = Page.TeamsRedirect;
		pageRef.getParameters().put('id', idTeam);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	* Delete suscription
	*@return PageReference
	*/
	public PageReference deleteSubscription () {
		if (subscription != null && subscriptionCount > 0 ) 
			delete subscription;
		
		PageReference pageRef = Page.TeamsRedirect;
		pageRef.getParameters().put('id', idTeam);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
}
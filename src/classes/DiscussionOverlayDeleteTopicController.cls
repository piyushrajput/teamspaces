/**
*@author: Bruno Fagundez @ 08-28-2008
*/
public without sharing class  DiscussionOverlayDeleteTopicController {
	
	/**
	* Construct
	*/
	public DiscussionOverlayDeleteTopicController (){}
	
	String topicId = '';
	/**
	* Get Topic Id
	*@return String
	*/
	public String getTopicId() {	
		return topicId;
	}
	
	/**
	* Set Topic Id
	*@param String
	*/
	public void setTopicId(String tID) {	
		topicId = tID;
	}
	
	/**
	* Delete Topic by Id
	*/
	public void deleteTopic(){
		DiscussionTopic__c topicToDelete = [select Id, LastPostedMessage__c, Team__c, MessageCount__c 
											from DiscussionTopic__c 
											where Id =: topicId];
		DiscussionForum__c discForum = [select Id, LastPostedMessage__c, Team__c, MessageCount__c 
										from DiscussionForum__c 
										where Team__c =: topicToDelete.Team__c];
		discForum.MessageCount__c = discForum.MessageCount__c - topicToDelete.MessageCount__c;
		update discForum;
		delete topicToDelete;
	}
}
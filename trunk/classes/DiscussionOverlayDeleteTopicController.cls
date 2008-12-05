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
		DiscussionTopic__c topicToDelete = [Select Id FROM DiscussionTopic__c where Id =: topicId];		
		delete topicToDelete;
	}
}
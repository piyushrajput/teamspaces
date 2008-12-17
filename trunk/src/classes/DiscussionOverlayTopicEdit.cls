/**
*@author: Bruno Fagundez @ 05-30-2008
*/
public without sharing class DiscussionOverlayTopicEdit {
	
	/**
	* Constructor
	*/
	public DiscussionOverlayTopicEdit () {}
	
	/**
	* Get Team__c Id
	*@return String
	*/
	public String getTeamId () {
		return TEAMID;
	}

	/**
	* Method for do Dummy refresh.
	*/
	public void dummyRefresh(){}
		
	public String TEAMID = System.currentPageReference().getParameters().get('id');
	public DiscussionForum__c forum = new DiscussionForum__c();

	/**
	* Get the forum data 
	*@return DiscussionForum__c
	*/	
	public DiscussionForum__c getForumData(){
   		if(TEAMID != null){
   			 try {
   			 	forum = [SELECT
   						Team__r.Name, 
   						Team__c,
   						Id 
   						FROM DiscussionForum__c WHERE Team__c =: TEAMID LIMIT 1];
   			 } catch (Exception e) {
   			 	throw e;
   			 }   			    			 
   		} else {
   			forum = null;
   		}
   		return forum;
   	}   	
   	
   	DiscussionTopic Topic = new DiscussionTopic(); 
   	/**
   	* Get DiscussionTopic Instance
   	*@return DiscussionTopic
   	*/
   	public DiscussionTopic getTopic(){
   		return Topic;
   	}
   	
   	/**
   	* Set DiscussionTopic instance
   	*@param DiscussionTopic
   	*/
   	public void setTopic (DiscussionTopic dt){
   		Topic = dt;
   	}
   	
   	/**
	* Read current Forum and Save the topic
	*/   	
   	public void saveTopic(){
   		//Read forum
   		getForumData();
   		// Build and Insert the Topic first
   		DiscussionTopic__c newTopic = new DiscussionTopic__c();
   		newTopic.Subject__c = Topic.Name;	
		newTopic.Team__c = TEAMID;
		newTopic.DiscussionForum__c = forum.Id;
   		insert newTopic;
   		// Build and insert First Message 
   		DiscussionMessage__c firstMessage = new DiscussionMessage__c();
   		firstMessage.Discussiontopic__c = newTopic.Id;
		firstMessage.Team__c = TEAMID;
		firstMessage.Message__c = Topic.Text;
   		insert firstMessage;
   	}

   	/**
	* Read current Forum and Update the topic
	*/   	
   	public void updateTopic(){
   		// Update the Topic 
   		DiscussionTopic__c topicToEdit = [Select Subject__c from DiscussionTopic__c where Id =: Topic.TopicIdToUpdate];
   		topicToEdit.Subject__c = Topic.Name;	
   		update topicToEdit;
   		// Update the topic First Message 
   		DiscussionMessage__c messageToUpdate = [ Select Message__c from DiscussionMessage__c where Id =: Topic.MessageIdToUpdate ];
   		messageToUpdate.Message__c = Topic.Text;			
   		update messageToUpdate;
   	}

	/**
	* DiscussionTopic class
	*@author Bruno Fagundez
	*/	
   	public class DiscussionTopic {   
   		public String TopicIdToUpdate {get; set;}	
   		public String MessageIdToUpdate {get; set;}
   		public String Name {get; set;}
   		public String Text {get; set;}
   	}
}
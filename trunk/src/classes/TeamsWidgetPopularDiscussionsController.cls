/**
*@author Martin Prado @ 08/07/2008 
*/
public class TeamsWidgetPopularDiscussionsController {
	
	Integer popdisSize;
	
	/**
	* Constructor
	*/
	public TeamsWidgetPopularDiscussionsController(){
		getDiscussions();
	}
	
	/**
	* Read last 5 viewed discussion topic
	*@return List<DiscussionTopic__c>
	*/
	public List<DiscussionTopic__c> getDiscussions(){ 
	    List<DiscussionTopic__c> discussions = new List<DiscussionTopic__c>();
		//QUERY BASED ON DiscussionWidgetMostReadController
		discussions =   [select Id, 
						Subject__c, 
						LastViewedDate__c 
						from DiscussionTopic__c 
						order by LastViewedDate__c 
						desc limit 5];
		popdisSize = discussions.size();
		
		return discussions;
	}	
	
	/**
	* Returns list size
	*@return Integer
	*/
	public Integer getPopularDiscussionsSize(){
		return popdisSize;
	}
	
}
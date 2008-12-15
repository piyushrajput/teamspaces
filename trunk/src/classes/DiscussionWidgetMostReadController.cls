/**
*@author Juan Bessonart @ 06/02/2008
*/
public class DiscussionWidgetMostReadController {
	
	/**
	* Get more readed topics
	*@return List<DiscussionTopic__c>
	*/
	public List<DiscussionTopic__c> getMostRead () {
		List<DiscussionTopic__c> mostRead = new List<DiscussionTopic__c>();
		mostRead = [select Id, Subject__c, ViewCount__c, LastViewedDate__c from DiscussionTopic__c order by LastViewedDate__c desc limit 5];
		return mostRead;
	}

}
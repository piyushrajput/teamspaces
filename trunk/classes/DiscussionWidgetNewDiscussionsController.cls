/**
*@author Marcos Solari @ 05/30/2008
*/
public class DiscussionWidgetNewDiscussionsController {

	/**
	* Class Topics
	*@author Marcos Solari
	*/
	public class Topics {
		String id;
 		String subject;
	
		/**
		* Get topic Id
		*@return String
		*/
		public String getId () {
        	return id;
        }  
        
        /**
        * Get topic subject
        *@return String
        */
        public String getSubject () {
        	return subject;
        }  
          
        /**
        * Set topic subject
        *@param String subject
        */
        public void setSubject(String subject) {
        	Integer subjectLength; 

        	if(subject != null && subject != '' ){
        		subjectLength = subject.length();
        		if(subjectLength > 20) {
        			this.subject = subject.substring(0, 19) + '...' ;
        		}else {
        			this.subject = subject;
        		}
        	}else {
        		this.subject = null;
        	} 	
        } 
        
		/**
		* Set topic Id
		*@param String Id
		*/
        public void setId (String Id) {
        	this.id = Id;
        }
	}
	
	List<Topics> topicsRes = new List<Topics>();
	
	/**
	* Constructor
	*/
	public DiscussionWidgetNewDiscussionsController () {
		List<DiscussionTopic__c> newDiscussionTopics = new List<DiscussionTopic__c>();
		
		newDiscussionTopics = [SELECT Subject__c, Id
			   			  FROM DiscussionTopic__c
			   			  ORDER BY PostedDate__c DESC
			              LIMIT 5];	

		for(DiscussionTopic__c item : newDiscussionTopics){
			Topics myTopic = new Topics();
			myTopic.setId(item.Id);	
			myTopic.setSubject(item.Subject__c);
			topicsRes.add(myTopic);
		}
	}
	
	/**
	* Returns new discussion topics list
	*@return List<Topics>
	*/
	public List<Topics> getNewDiscussionTopics() {
		return topicsRes;
	}
	
	/**
	* Return true if topic list size = 0
	*@return Boolean
	*/
	public Boolean getTopicListCount() {	
		return (topicsRes.size() == 0);
	}
}
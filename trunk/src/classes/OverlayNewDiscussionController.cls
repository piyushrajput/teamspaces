/**
*@author Martin Prado 06/20/2008
*/
public class OverlayNewDiscussionController {
	
	/**
	* Constructor
	*/
	public OverlayNewDiscussionController () {
		genPermissions();
	}
	
	public String TEAMID = System.currentPageReference().getParameters().get('id');
	
	/**
	* Get team Id
	*@return String Id
	*/
	public String getTeamId () {
		return TEAMID;
	}
	
	/**
	* Read discussion forum for current Team
	*@return DiscussionForum__c
	*@throws Exception
	*/
	public DiscussionForum__c getForumData(){
   		DiscussionForum__c team = new DiscussionForum__c();
   		if(TEAMID != null){
   			 try {
   			 	team = [SELECT
   						Team__r.Name, 
   						Team__c,
   						Id 
   						FROM DiscussionForum__c WHERE Team__c =: TEAMID LIMIT 1];
   						
   			 } catch (Exception e) {
   			 	throw e;
   			 }
   		} else {
   			team = null;
   		}
   		return team;
   	}  
   	
	/**
	* Class Topic
	*@author Martin Prado
	*/   
   	public class Topic {
   		public String content = '';
	   	public String id = '';
	   	public String subject = '';
	   	public String forum = '';
	   	
	   	/**
	   	* Returns topic name
	   	*@return String forum
	   	*/
	   	public String getForum () {
	   		return forum;
	   	}
	   	
	   	/**
	   	* Set topic name
	   	*@param String forum
	   	*/
	   	public void setForum (String forum) {
	   		this.forum = forum;
	   	}
	   		
	   	/**
	   	* Get topic Id
	   	*@return String Id
	   	*/
	   	public String getId() {
	   		return id;
	   	}
	   	
	   	/**
	   	* Set topic Id
	   	*@param String Id
	   	*/
	   	public void setId (String id) {
	   		this.id = id;
	   	}
	   	
	   	/**
	   	* Get topic content
	   	*@return String content
	   	*/
	   	public String getContent () {
	   		return content;
	   	}
	   	
	   	/**
	   	* Set topic content
	   	*@param String content
	   	*/
	   	public void setContent (String content) {
	   		this.content = content;
	   	}
	   	
	   	/**
	   	* Get topic subject
	   	*@return String subject
	   	*/
	   	public String getSubject () {
	   		return subject;
	   	}
	   	
	   	/**
	   	* Set topic subject
	   	*@param String subject
	   	*/
	   	public void setSubject (String subject) {
	   		this.subject = subject;
	   	}
   	}
   	
   	public Topic newTopic = new Topic();
   	
   	/**
   	* Get new topic instance
   	*@return Topic newTopic
   	*/
   	public Topic getNewTopic () {
   		return newTopic;	
   	}
   	
   	/**
   	* Set new topic
   	*@param Topic newTopic
   	*/
   	public void setNewTopic (Topic newTopic) {
   		this.newTopic = newTopic;
   	}
   	
	
	//Get loaded object copy from teamDetail
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	
	/**
	* Set permissions for current user
	*/
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(TEAMID);
		userPermissions.setObjectType('Discussion');
		userPermissions.setPermissions();		
	}
	
   	/**
   	* Save new topic
   	*/
   	public void saveNewTopic () {
   		if(!userPermissions.getCanCreate())
        	throw new CustomException('Insufficient Privileges');
        	
   		if (newTopic.subject != '' && newTopic.forum != '' && newTopic.content != '' && newTopic.content != '<p><br></p>' && newTopic.content != '<p></p>' && newTopic.content != '<p>&nbsp;</p> ') {
	   		DiscussionTopic__c newT = new DiscussionTopic__c();
	   		newT.Subject__c = newTopic.subject;
	   		newT.Team__c = TEAMID;
	   		newT.DiscussionForum__c = newTopic.forum;
	   		
	   		insert newT;
	   		
	   		DiscussionMessage__c firstMessageObj = new DiscussionMessage__c();
	   		firstMessageObj.Discussiontopic__c = newT.Id;
	   		firstMessageObj.Team__c = teamID;
	   		firstMessageObj.Message__c = newTopic.content;
	   		
	   		insert firstMessageObj;
	   		
	   		newT.LastPostedMessage__c = firstMessageObj.id;
	   		update newT;
	   		
	   		newTopic.subject = '';
	   		newTopic.id = '';
	   		newTopic.content = '';
	   		newTopic.forum = '';
   		}
   	}
}
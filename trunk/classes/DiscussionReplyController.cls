/**
*@author: Juan M. Bessonart @ 06-02-2008
*/
public without sharing class DiscussionReplyController {
	
    public UserPermissions userPermissions = new UserPermissions();
    /**
    * Load permissions for current User
    */
    public void genPermissions () {
        userPermissions.setId(UserInfo.getUserId());
        userPermissions.setTeam(TEAMID);
        userPermissions.setObjectType('Discussion');
        userPermissions.setPermissions();       
    }
   
 	/**
 	* Returns UserPermission instance
 	*@return UserPermissions
 	*/
    public UserPermissions getUserPermissions () {
        return userPermissions;
    }

	/**
	* Constructor
	*/
	public DiscussionReplyController(){
		constructorMethods();	
	} 

   	public Integer currentPagination = 1;
   	public Integer firstRow = 1;
	UserTopic topicUser = null;
	public boolean noForums;
	public String pageNumberParam = System.currentPageReference().getParameters().get('p');
	public String paramId = System.currentPageReference().getParameters().get('id');
	
	/**
	* Set current page number
	*@param String page num
	*/
	public void setPageNumberParam (String pageNumberParam) {
		this.pageNumberParam = pageNumberParam;
	}
	
	/**
	* Set DiscussionTopic__c Id
	*@param String param Id
	*/
	public void setParamId (String paramId) {
		this.paramId = paramId;
	}
	
	/**
	* Execute on construct for load data
	*/
	public void constructorMethods () {
		if (paramId != null) {
			getTopics();
			if(topicUser != null){
				totalItemsNumber = topicUser.replys.size();
			} else {
			    throw new CustomException('Insufficient Privileges');
			}
			if(totalItemsNumber == 0 ){
				noForums = true;
			} else {
				noForums = false; 
			}
			
			String pageNumber = pageNumberParam;
			if (pageNumber == '' || pageNumber == null) {
				currentPagination = 1;
				firstRow = 1;
			}else {
				currentPagination = Integer.valueOf(pageNumber);
				firstRow = (Integer.valueOf(pageNumber) - 1) * numberOfItemsToShow;
			}
			genCntPagination();
			genPermissions();	
		}
	}

	/**
	* Read topic for current paramId
	*/
	public void getTopics(){
		String param = paramId;
		this.getTopic(param);	
	}
	
	/**
	* Get UserTopic instance
	*@return UserTopic
	*/
	public UserTopic getTopicUser(){
		return topicUser;
	}
	
	public boolean isTopicAuthor = false;
	/**
	* Returns boolean User is a topic author
	*@return Boolean
	*/
	public boolean getIsTopicAuthor(){	
		return isTopicAuthor;
	}
	
	public Id TOPICID;
	
	/**
	* Returns topic Id
	*@return Id
	*/
	public Id getTopicId(){
		return TOPICID;
	}
	
	public DiscussionMessage__c firstMessage = new DiscussionMessage__c();
	
	public DiscussionMessage__c getFirstMessage(){
		return firstMessage;
	}
	
	/**
	* Get topic by Id
	*@param String param
	*/
	public void getTopic (String param){
		List<DiscussionTopic__c> topics = new List<DiscussionTopic__c>();
		List<DiscussionForum__c> forums = new List<DiscussionForum__c>();

		// The first message 
		topics = [Select d.Subject__c, d.OwnerId, d.Name, d.PostedBy__c, 
				 d.Id, d.DiscussionForum__c  ,d.PostedDate__c, 
				 (Select PostedBy__c, PostedDate__c, Message__c, Id From DiscussionTopic__r order by PostedDate__c desc limit 5) 
				 From DiscussionTopic__c d
				 where d.Id =: param];
		
		if(topics.size() > 0){
			forums = [Select  d.Team__c, d.Id, 
				  (Select MessageCount__c From DiscussionForum__r) 
				  From DiscussionForum__c d
				  where d.Id =: topics[0].DiscussionForum__c];
			TOPICID = topics[0].Id;
		}
		
		if(forums.size() > 0){
			TEAMID = forums[0].Team__c;			 
			firstMessage = [Select Id, Message__c, PostedDate__c, PostedBy__c, Team__c, DiscussionTopic__r.Subject__c From DiscussionMessage__c where DiscussionTopic__c =: param order by PostedDate__c asc Limit 1];
		}
		
		if(UserInfo.getUserId() == firstMessage.PostedBy__c){
			isTopicAuthor = true;
		}
		
		if(topics.size() > 0){
			topicUser = new UserTopic(getUserInfo(topics[0].PostedBy__c), firstMessage, forums[0], param);
		} 
	}
	
	/**
	* Returns boolean has forums
	*@return Boolean
	*/
	public boolean getNoForums(){
		return noForums;
	}
	
	/**
	* Get User instance by Id
	*@static
	*@param Id The User Id
	*@return User
	*/
	public static User getUserInfo (Id id){
		List<User> users = new List<User>();
		users = [Select u.Name, u.Title, u.Id, (Select Name, Picture__c From People__r) 
				From User u
				where u.Id =: id];
		if(users.size() > 0){
			return users[0];
		} else {
			return null;
		}
	}
	
	/**
	* Get Team by Id
	* @static
	*@param Id The Team Id
	*@return Team__c
	*/
	public static Team__c getTeam(Id id){
		List<Team__c> teams = new List<Team__c>();
		teams = [select t.Id, t.Name from Team__c t where t.Id =: id];
		return (teams.size() > 0) ? teams[0] : null;
	}
	
	public String topicIdParam;
	/**
	* Set Topic Id
	*@param String 
	*/
	public void setTopicIdParam (String topicIdParam) {
		this.topicIdParam = topicIdParam;
	}
	
	/**
	* Update number of views to one Topic
	*/
	public void updateReadCount () {
		String topicId;
		if (System.currentPageReference().getParameters().get('id') != null) {
			topicId = System.currentPageReference().getParameters().get('id');
		}else{
			topicId = topicIdParam;	
		}
		List<DiscussionTopic__c> topic = [select Id, ViewCount__c, LastViewedDate__c from DiscussionTopic__c where id =: topicId];
		if (topic != null) {
			topic[0].ViewCount__c = topic[0].ViewCount__c + 1;
			topic[0].LastViewedDate__c = System.now();
		}
	}
	
	/**
	* Class UserTopic
	*@author Juan Bessonart
	*/
	public class UserTopic {
		
		String param;
		User user = null;
		Team__c team = null;
		DiscussionMessage__c topicMessage = null;
		List<UserReplys> replys = new List<UserReplys>();
		String picture;
		String strdate = null;
		
		/**
		* Constructor
		*@param User
		*@param DiscussionMessage__c
		*@param DiscussionForum__c
		*@param String DiscussionTopic Id
		*/
		public UserTopic(User u, DiscussionMessage__c d, DiscussionForum__c f, String paramId){
			user = u;
			topicMessage = d;
			team = DiscussionReplyController.getTeam(f.Team__c);
			param = paramId;
			if(u != null){
				if(u.People__r.size() > 0 && u.People__r[0].Picture__c != null){
					picture = u.People__r[0].Picture__c;
				}else{
					picture = 'nopicture';
				}
			}
			List<DiscussionMessage__c> messageList = new List<DiscussionMessage__c>();
			messageList = [ Select 
							Team__c, 
							Name, 
							Message__c,
							PostedBy__c, 
							Id,
							ParentMessage__c,
							ParentMessage__r.Message__c,
							ParentMessage__r.PostedDate__c,
							ParentMessage__r.PostedBy__r.Name,
							// Header__c, 
							DiscussionTopic__c, 
							DiscussionTopic__r.DiscussionForum__c,
							PostedDate__c From DiscussionMessage__c where DiscussionTopic__c =: param order by PostedDate__c];			
			
			for (DiscussionMessage__c m : messageList){
				replys.add(new UserReplys(m));
			}
		}
		
		/**
		* Get picture
		*@return String
		*/
		public String getPicture(){
			return picture;
		}
		
		/**
		* Get User instance
		*@return User
		*/
		public User getUser(){
			return user;
		}
		
		/**
		* Get Team Instance
		*@return Team__c
		*/
		public Team__c getTeam(){
			return team;
		}
		
		/**
		* Get Topic
		*@return DiscussionMessage__c
		*/
		public DiscussionMessage__c getTopic (){
			return topicMessage;
		}
		
		/**
		* Get topic message
		*@return String
		*/
		public String getMessTopic(){
			return getTopic().Message__c; 
		}
			
		/**
		* Get formated date
		*@return String
		*/
		public String getStrdate(){
			return topicMessage.PostedDate__c.format('MMMM dd, yyyy HH:mm');
		}
		
		/**
		* Get topic replys
		*@return List<UserReplys>
		*/
		public List<UserReplys> getReplys (){
			return replys;
		} 
		
		/**
		* Get truncated user name if too long
		*@return String
		*/
		public String getShowShortUserName(){
	        String userName = user.Name;
			if(userName.length() > 15){
	           return userName.substring(0,15) + '...';            	
	        }else{
	        	return userName;
	        }
		}
		
		/**
		* Repalce topic subject
		*@return String
		*/
		public String getTopicNameReplaced(){
			String topicSubject = topicMessage.DiscussionTopic__r.Subject__c;
			return topicSubject;
		}

		/**
		* Get truncated topic name if too lomg
		*@return String
		*/
		public String getShowShortTopicName(){
			String topicSubject = topicMessage.DiscussionTopic__r.Subject__c;
			if(topicSubject.length() > 22){
	           return topicSubject.substring(0,22) + '...';            	
	        }else{
	        	return topicSubject;
	        }
		}
	}
	
	/**
	* Class for Replys
	*@author Juan Bessonart
	*/
	public class UserReplys {
		
		DiscussionMessage__c message = null;
		User user = null;
		String picture;
		String strdate = null;		
		//Quote
		String quote = null;
		String qtdate = null;
		String qtAuthor = null;
		boolean existqt = false;
		boolean isMessageAuthor = false;
		
		/**
		* Constructor
		*@param DiscussionMessage__c 
		*/
		public UserReplys (DiscussionMessage__c m){
			if ((m.ParentMessage__c != null)){
				quote = m.ParentMessage__r.Message__c;
				qtdate = (m.ParentMessage__r.PostedDate__c).format('MMMM dd, yyyy HH:mm');
				qtAuthor = m.ParentMessage__r.PostedBy__r.Name;
				existqt = true;
			} else {
				existqt = false;
			}
			message = m;	
			user = DiscussionReplyController.getUserInfo(message.PostedBy__c);
			if(message.PostedBy__c == Userinfo.getUserId()){
				isMessageAuthor = true;
			}
			if(user.People__r.size() > 0 &&
			   user.People__r[0].Picture__c != null && 
			   user.People__r[0].Picture__c != ''){
				picture = user.People__r[0].Picture__c;
			}else{
				picture = 'nopicture';
			}
		}
		
		/**
		* Return true if is meesage author
		*@return Boolean
		*/
		public Boolean getIsMessageAuthor(){
			return isMessageAuthor;
		}
		
		/**
		* Get quote author
		*@return String
		*/
		public String getQtAuthor(){
			return qtAuthor;
		}
		
		/**
		* Get quote
		*@return String
		*/
		public String getQuote(){
			return quote;
		}
		
		/**
		* Get quote date
		*@return String
		*/
		public String getQtdate(){
			return qtdate;
		}
		
		/**
		* Return true if exist quote
		*@return Boolean
		*/
		public boolean getExistqt(){
			return existqt;
		}
		
		/**
		* Get User instance
		*@return User
		*/
		public User getUser(){
			return user;
		}
		
		/**
		* Truncate User name
		*@return String
		*/
		public String getUserShortName(){
			String name = user.Name;
			if(name.length() > 16){
	           return name.substring(0,14) + '...';            	
	        }else{
	        	return name;
	        }
		}
		
		/**
		* Get message
		*@return DiscussionMessage__c
		*/
		public DiscussionMessage__c getMessage(){
			return message;
		}
		
		/**
		* Get picture
		*@return String
		*/
		public String getPicture(){
			return picture;
		}
		
		/**
		* Returns formated date
		*@return String
		*/
		public String getStrdate(){
			return message.PostedDate__c.format('MMMM dd, yyyy HH:mm');
		}
	}
	
    /* ### Pagination ###*/
    
    /**
   	* Set of Integers to control pagination
   	*/
   	public Integer totalItemsNumber;
   	public Integer numberOfItemsToShow = 10;
   	public Integer cntPagination;

   	/**
   	* Set of Booleans to show or not prev / next links
   	*/
   	public boolean prevPageLinkShow = false;
   	public boolean prevPageShow  = false;
   	public boolean nextPageLinkShow  = false;
   	public boolean nextPageShow  = false;
   	   	
   	/**
   	* Returns numbers of pages 
   	*/
   	public void genCntPagination () {
   		cntPagination = ((totalItemsNumber - 1) - (Math.mod((totalItemsNumber - 1), numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod((totalItemsNumber -1), numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		} 	
   	}
   	
   	/**
   	* Move to next page
   	*/
   	public void nextPage () {
   		currentPagination++;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	/**
   	* Move to previus page
   	*/
   	public void prevPage () {
   		currentPagination--;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}
   	
   	/**
   	* Pagination Integer Getters
   	*@return Integer
   	*/
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	/**
   	* Get pages count
   	*@return Integer
   	*/
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	/**
   	* Get num of item to show
   	*@return Integer
   	*/
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	/**
   	* Returns current first row
   	*@return Integer
   	*/
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
    /**
   	* Returns boolean show previus page link
   	*@return Boolean
   	*/
	public boolean getPrevPageLinkShow () {
		if(currentPagination == 1){
			prevPageLinkShow = false;		
		} else {
			prevPageLinkShow = true;}
   		return prevPageLinkShow;
   	}
   	
   	/**
   	* Returns boolean show previus page
   	*@return Boolean
   	*/
   	public boolean getPrevPageShow () {
   		if(currentPagination == 1){	
   			prevPageShow = true; 
   		} else {
   			prevPageShow = false;}
   		return prevPageShow;
   	}
   	
   	/**
   	* Returns boolean show next page link
   	*@return Boolean
   	*/
   	public boolean getNextPageLinkShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){	
   			nextPageLinkShow = false; 
		} else { 
			nextPageLinkShow = true;
		}   		
   		return nextPageLinkShow;
   	}
   	
	/**
	* Returns boolean show next page
	*@return Boolean
	*/       
   	public boolean getNextPageShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){ 
   			nextPageShow = true; 
		}else{ 
			nextPageShow = false;
		} 
   		return nextPageShow;
   	}
	
	public String TEAMID = System.currentPageReference().getParameters().get('id');
	/**
	* Set Team Id
	*@param String 
	*/
	public void setTEAMID(String value){
		TEAMID = value;
	}
	
	/**
	* Get Forum for current Team
	*@return DiscussionForum__c
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

	public String deleteReplyId = '';
	/**
   	* Set Reply Id to delete
   	*/	
	public void deleteReplyId(){
		this.deleteReplyId = System.currentPageReference().getParameters().get('idR');
	}
	
	/**
	* Delete Reply by Id
	*/
	public void deleteReply () {
		 List<DiscussionMessage__c> listDelMessage = [select Id, Message__c from  DiscussionMessage__c where Id =:deleteReplyId limit 1];
		 if (listDelMessage.size() > 0) {
			 delete listDelMessage[0];
		 }
		 getTopics();
	}

	/**
	* Returns boolean is Admin User
	*@return Boolean
	*/
	public boolean getIsTeamAdminMember(){
		List<User> teamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =: UserInfo.getUserId() limit 1];                    
        if(teamAdmin[0].Profile.PermissionsModifyAllData){
        	return true;
        }else{        	       
       	 	return false;
        }
	}
	
	/**
	* Save Reply
	*/
	public void saveReply (){
		getTopics();
		totalItemsNumber = topicUser.replys.size();
		if(totalItemsNumber == 0 ){
			cntPagination = 0;
			noForums = true;
		} else {
			noForums = false;
			genCntPagination(); 
		}
	}
	
	/**
	* Set new Reply to Topic
	*@author Juan Bessonart
	*/		
	public class replyMessage {
		public string Message {get; set;} 
		public string ParentMessage {get; set;} 
		public string MessageId {get; set;}
	}
	
	replyMessage topicReply = new replyMessage();
	/**
	* Get reply message
	*@return replyMessage
	*/
	public replyMessage getTopicReply(){
		return topicReply;
	}
	
	/**
	* Save Reply to current topic
	*/
	public void saveNewTopicReply(){
		if((topicReply.MessageId != '')&&(topicReply.MessageId != null)){
			DiscussionMessage__c editReply = [Select Message__c from  DiscussionMessage__c where id =: topicReply.MessageId];
			editReply.Message__c = topicReply.Message;
			update editReply;
		}else{
			DiscussionMessage__c newTopicReply = new DiscussionMessage__c();
			newTopicReply.DiscussionTopic__c = TOPICID;
			newTopicReply.Team__c =  TEAMID;
			newTopicReply.Message__c = topicReply.Message;	
			insert newTopicReply;
		}
	}
	
	replyMessage quoteReply = new replyMessage();
	/**
	* Get Quote for Reply
	*@return replyMessage
	*/
	public replyMessage getQuoteReply(){
		return quoteReply;
	}
	
	/**
	* Save Quote for Reply
	*/
	public void saveQuoteReply(){
		if((quoteReply.MessageId != '')||(quoteReply.MessageId != null)){
			List<DiscussionMessage__c> editReplies = [Select Id, Message__c from  DiscussionMessage__c where id =: quoteReply.MessageId];
			if(editReplies.size() > 0){
				DiscussionMessage__c editReply = editReplies[0];
				editReply.Message__c = quoteReply.Message;
				update editReply;
			} else {
				insertQuoteReply();
			}
		}else {
			// This is a New Quote
			insertQuoteReply();
		}
	}
	
	/**
	* Insert new Quote to Reply
	*/
	public void insertQuoteReply(){
		// Create a reply to quote!
		DiscussionMessage__c newQuoteReply = new DiscussionMessage__c();
		newQuoteReply.DiscussionTopic__c = TOPICID;		
		newQuoteReply.Team__c =  TEAMID;
		newQuoteReply.ParentMessage__c = quoteReply.ParentMessage;
		newQuoteReply.Message__c = quoteReply.Message;
		insert newQuoteReply;
	}
	
	/**
	* Delete Topic by Id
	*/
	public void deleteTopic(){
		List<DiscussionTopic__c> topicToDelete = [Select Id FROM DiscussionTopic__c where Id =: TOPICID];
		if (topicToDelete.size() > 0) {
			delete topicToDelete[0];
		}		
	}
	
}
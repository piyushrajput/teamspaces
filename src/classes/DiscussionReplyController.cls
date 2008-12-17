public class DiscussionReplyController {

   	public Integer currentPagination = 1;
   	public Integer firstRow = 1;
   	
	UserTopic topicUser = null;
	public boolean noForums;
	/*
	*@construct
	*/
	public DiscussionReplyController(){
		getTopics();
		totalItemsNumber = topicUser.replys.size();
		if(totalItemsNumber == 0 ){
			noForums = true;
		} else {
			noForums = false; 
		}
		
		String pageNumber = System.currentPageReference().getParameters().get('p');
		if (pageNumber == '' || pageNumber == null) {
			currentPagination = 1;
			firstRow = 1;
		}    
		else {
			currentPagination = Integer.valueOf(pageNumber);
			firstRow = (Integer.valueOf(pageNumber) - 1) * numberOfItemsToShow;
		}
    
		genCntPagination();

	}
	
	/*
	*@void
	*/
	
	public void getTopics(){
		String param = System.currentPageReference().getParameters().get('id');
		this.getTopic(param);	
	}
	
	/*
	* Getters
	*/
	public UserTopic getTopicUser(){
		return topicUser;
	}  
	
	/**
	*@void
	*/
	public void getTopic (String param){
		
		List<DiscussionTopic__c> topics = new List<DiscussionTopic__c>();
		
		List<DiscussionForum__c> forums = new List<DiscussionForum__c>();
		// The first message 
		DiscussionMessage__c firstMessage = new DiscussionMessage__c();
		
		topics = [Select d.Subject__c, d.OwnerId, d.Name, 
				 d.Id, d.DiscussionForum__c  ,d.PostedDate__c,
				 (Select PostedBy__c, PostedDate__c, Message__c, Id From DiscussionTopic__r order by PostedDate__c desc limit 5) 
				 From DiscussionTopic__c d
				 where d.Id =: param];
				 
		forums = [Select  d.Team__c, d.Id, 
			  (Select MessageCount__c From DiscussionForum__r) 
			  From DiscussionForum__c d
			  where d.Id =: topics[0].DiscussionForum__c];
			  				 
		// topicUser = new UserTopic(getUserInfo(topics[0].OwnerId), topics[0], forums[0]);
		
		firstMessage = [Select Message__c, PostedDate__c, Team__c, DiscussionTopic__r.Subject__c From DiscussionMessage__c where DiscussionTopic__c =: param order by PostedDate__c asc Limit 1];
		
		topicUser = new UserTopic(getUserInfo(topics[0].OwnerId), firstMessage, forums[0]);
			
	}
	
	public boolean getNoForums(){
		return noForums;
	}
	
	/*
	*@static
	*@return User
	*/
	public static User getUserInfo (Id id){
		List<User> users = new List<User>();
		users = [Select u.Name, u.Title, u.Id, (Select Name, Picture__c From People__r) 
				From User u
				where u.Id =: id];
		return users[0];
	}
	
	/*
	*@static
	*@return Team__c
	*/
	public static Team__c getTeam(Id id){
		List<Team__c> teams = new List<Team__c>();
		teams = [select t.Id, t.Name from Team__c t where t.Id =: id];
		return (teams.size() > 0) ? teams[0] : null;
	}
	
	
	
	public void updateReadCount () {
		String topicId = System.currentPageReference().getParameters().get('id');
		List<DiscussionTopic__c> topic = [select Id, ViewCount__c, LastViewedDate__c from DiscussionTopic__c where id =: topicId];
		if (topic != null) {
			topic[0].ViewCount__c = topic[0].ViewCount__c + 1;
			topic[0].LastViewedDate__c = System.now();
			upsert topic;
		}
	}
	
	/*
	*Topics Inner Class
	*/
	public class UserTopic {
		
		String param = System.currentPageReference().getParameters().get('id');
		User user = null;
		Team__c team = null;
		DiscussionMessage__c topicMessage = null;
		List<UserReplys> replys = new List<UserReplys>();
		String picture;
		String strdate = null;

		public UserTopic(User u, DiscussionMessage__c d, DiscussionForum__c f){
			user = u;
			topicMessage = d;
			team = DiscussionReplyController.getTeam(f.Team__c);
			if(u.People__r.size() > 0 &&
			   u.People__r[0].Picture__c != null && 
			   u.People__r[0].Picture__c != ''){
				picture = u.People__r[0].Picture__c;
			}
			else{
				picture = 'nopicture';
			}
			//picture = (u.People__r[0].Picture__c != null && u.People__r[0].Picture__c != '') ? u.People__r[0].Picture__c : '01530000000VO5s';
			
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
		
		public String getPicture(){
			return picture;
		}
		
		public User getUser(){
			return user;
		}
		
		public Team__c getTeam(){
			return team;
		}
		
		public DiscussionMessage__c getTopic (){
			return topicMessage;
		}
		
		public String getMessTopic(){
			return getTopic().Message__c; 
		}
			
		
		public String getStrdate(){
			return topicMessage.PostedDate__c.format('MMMM dd, yyyy HH:mm');
		}
		
		public List<UserReplys> getReplys (){
			return replys;
		} 
		
		public String getShowShortUserName(){
			String topicSubject = topicMessage.DiscussionTopic__r.Subject__c;
		
			if(topicSubject.length() > 22){
	           return topicSubject.substring(0,22) + '...';            	
	        }else{
	        	return topicSubject;
	        }
		}
		
		
		public String getTopicNameReplaced(){
			String topicSubject = topicMessage.DiscussionTopic__r.Subject__c;
			return topicSubject;
		}

		public String getShowShortTopicName(){
		String topicSubject = topicMessage.DiscussionTopic__r.Subject__c;
		
			if(topicSubject.length() > 22){
	           return topicSubject.substring(0,22) + '...';            	
	        }else{
	        	return topicSubject;
	        }
		}
	
	}
	
	/*
	*Replys Inner Class
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
			if(user.People__r.size() > 0 &&
			   user.People__r[0].Picture__c != null && 
			   user.People__r[0].Picture__c != ''){
				picture = user.People__r[0].Picture__c;
			}
			else{
				picture = 'nopicture';
			}
			//picture = (user.People__r[0].Picture__c != null && user.People__r[0].Picture__c != '') ? user.People__r[0].Picture__c : 'nopicture';			
		}
		
		public String getQtAuthor(){
			return qtAuthor;
		}
		
		public String getQuote(){
			return quote;
		}
		
		public String getQtdate(){
			return qtdate;
		}
		
		public boolean getExistqt(){
			return existqt;
		}
		
		public User getUser(){
			return user;
		}
		public String getUserShortName(){
			String name = user.Name;
		
			if(name.length() > 16){
	           return name.substring(0,14) + '...';            	
	        }else{
	        	return name;
	        }
		}
		
		public DiscussionMessage__c getMessage(){
			return message;
		}
		
		public String getPicture(){
			return picture;
		}		
		
		public String getStrdate(){
			return message.PostedDate__c.format('MMMM dd, yyyy HH:mm');
		}

	}
	
	/**
   	* Pagination
   	* ************
   	*/
   	
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
   	   	
   	public void genCntPagination () {
   		
   		cntPagination = ((totalItemsNumber - 1) - (Math.mod((totalItemsNumber - 1), numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod((totalItemsNumber -1), numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		} 	
   		
   	}
   	
   	public void nextPage () {
   		currentPagination++;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	public void prevPage () {
   		currentPagination--;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}
   	
   	/**
   	* Pagination Integer Getters
   	*/
   	
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
    	/**
   	* Pagination Boolean Getters
   	*/
   	
	public boolean getPrevPageLinkShow () {
		
		if(currentPagination == 1){ prevPageLinkShow = false;		
		} else {prevPageLinkShow = true;}
		
   		return prevPageLinkShow;
   	}
   	
   	public boolean getPrevPageShow () {
   		
   		if(currentPagination == 1){	prevPageShow = true; 
   		} else {prevPageShow = false;}
   		
   		return prevPageShow;
   	}
   	
   	public boolean getNextPageLinkShow () {
   		
   		if((currentPagination == cntPagination) || (cntPagination == 0)){	nextPageLinkShow = false; 
		} else { nextPageLinkShow = true;}   		
   		
   		return nextPageLinkShow;
   	}
   	
   	public boolean getNextPageShow () {
   		
   		if((currentPagination == cntPagination) || (cntPagination == 0)){ nextPageShow = true; 
		} else { nextPageShow = false;} 
   		
   		return nextPageShow;
   	}
	
   	public DiscussionForum__c getForumData(){
   		
   		DiscussionForum__c team = new DiscussionForum__c();
   		
   		String TEAMID = System.currentPageReference().getParameters().get('id');
   		
   		if(TEAMID != null){
   			 try {
   			 	team = [SELECT
   						Team__r.Name, 
   						Team__c,
   						Id 
   						FROM DiscussionForum__c WHERE Team__c =: TEAMID LIMIT 1];
   						
   			 } catch (Exception e) {
   			 	
   			 	System.Debug('\n ///////////////////////////// \n Error , no team assigned \n //////////////////////////// \n The Forum ID is :' + TEAMID + '\n //////////////////////////// \n');
   			 	
   			 }
   			    			 
   		} else {
   			team = null;
   		}
   		return team;
   	}   

	/**
   	* Delete Reply
   	* ************
   	*/
	public String deleteReplyId = '';
	
	public void deleteReplyId () {
		this.deleteReplyId = System.currentPageReference().getParameters().get('idR');
		System.debug('\n \n ////////////// \n GUARDE ESTE deleteReplyId: ' + deleteReplyId + '\n /////////////// \n ');
	}
	
	public void deleteReply () {
		 DiscussionMessage__c delMessage = [select Id, Message__c from  DiscussionMessage__c where Id =:deleteReplyId];
		 System.debug('\n \n ////////////// \n GUARDE ESTE deleteReply: ' + delMessage + '\n /////////////// \n ');
		 delete delMessage;
		 getTopics();
	}
	

		public Id getQueueGroupId(){

		Group teamAdmin = [SELECT Id FROM Group	WHERE Name = 'Team Admin'];
	
		return teamAdmin.Id;
	}

	public boolean getIsTeamAdminMember(){
		
		List<GroupMember> groupMember= [SELECT Id
                                        FROM GroupMember
                                        WHERE GroupId =: getQueueGroupId()
                                        AND UserOrGroupId =: UserInfo.getUserId()];
                                        
        if(groupMember.size() != 0){
        	return true;
        }
        else{        	       
       	 return false;
        }
	}
	
	/*
	/** Save Reply
	/**
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
}
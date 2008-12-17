/**
*@author Bruno Fagundez @ 05/26/2008
*/
public with sharing class DiscussionTopicsController {

	/**
	* Constructor
	*/
	public DiscussionTopicsController (){
		genPermissions();
		isManager = userPermissions.getcanManage();
		if(TEAMID != null){
			topicList = fillTopicList();
			totalItemsNumber = topicList.size();		
			if (topicList.size() == 0){
				cntPagination = 0;
				noTopics = true;
			} else {
				noTopics = false;
				genCntPagination();
			}			
		} 
	}    
    
    public UserPermissions userPermissions = new UserPermissions();
   	
   	/**
   	* Refresh topic list
   	*/
   	public void refreshList() {
   		if(TEAMID != null){
			topicList = fillTopicList();
			totalItemsNumber = topicList.size();		
			if (topicList.size() == 0){
				cntPagination = 0;
				noTopics = true;
			} else {
				noTopics = false;
				genCntPagination();
			}	
			if(currentPagination > cntPagination){
				prevPage();
			}			
		}
   	}

    /**
    * Get permissions for curren user
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
    
    public boolean isManager;
	public String TEAMID = System.currentPageReference().getParameters().get('id');
	public List<TopicList> topicList = new List<TopicList>();
	public String breadCrumb;
	public boolean noTopics = true;
	
	/**
	* Set Team Id
	*@param String
	*/
	public void setTEAMID (String s){
		TEAMID = s;
	}
	
	/**
	* Return true if hasn't topics
	*@return Boolean
	*/
	public boolean getNoTopics(){
		return noTopics;
	}
	
	/**
	* Return topic list
	*@return List<TopicList>
	*/
	public List<TopicList> getTopicList(){
		return topicList;
	}
	
	/**
	* Refresh paginator
	*/
	public void refreshPaginator(){
		List<TopicList> fauxResult = fillTopicList();
		refreshList();
	}
	
	/**
	* Fill topic list
	*@return List<TopicList> 
	*/
	public List<TopicList> fillTopicList(){
		List<DiscussionTopic__c> discussionTopicList = new List<DiscussionTopic__c>();
		List<TopicList> topicListAux = new List<TopicList>();
		List<PeopleProfile__c> peopleProfiles = new List<PeopleProfile__c>();
		discussionTopicList = [Select   Id,	ViewCount__c, 
										Team__c, Team__r.Name,
										Subject__c, Name, 
										MessageCount__c, PostedBy__r.Name,
										PostedBy__r.Id, LastPostedMessage__c, 
										DiscussionForum__c, 
										(Select	Id,PostedDate__c,DiscussionTopic__c,Subject__c,PostedBy__c,Message__c,ParentMessage__c,Team__c 
										 From DiscussionTopic__r  
										 order by PostedDate__c asc
										 limit 1)
								From DiscussionTopic__c d
								where Team__c =: TEAMID
								order by PostedDate__c desc];
								
		peopleProfiles = [Select Id, Picture__c, User__c From PeopleProfile__c];
		
		for(DiscussionTopic__c t : discussionTopicList){	
				TopicList topic = new TopicList();
				for(PeopleProfile__c p : peopleProfiles){
					if(p.User__c == t.PostedBy__r.Id){
						topic.setAuthorPicture(p.Picture__c);
					}
				}
				topic.setAuthorId(t.PostedBy__r.Id);
				topic.setNumberOfViews(t.ViewCount__c);
				topic.setId(t.Id);	
				topic.setName(t.Subject__c);						
				topic.setTeamId(t.Team__c);
				topic.setAuthorName(t.PostedBy__r.Name);
				topic.setTeamName(t.Team__r.Name);
				topic.setNumberOfMessages(t.MessageCount__c);				
				topic.setLastPostMessage(t.LastPostedMessage__c);
				
				if(t.DiscussionTopic__r.size() > 0){
					topic.setFirstMessageCreated(t.DiscussionTopic__r[0]);
				}
				topic.setEnableActions(t.PostedBy__r.Id, isManager);
				
				topicListAux.add(topic); 	
		}
		return topicListAux;							
	}
	
	/**
	* Inner Class to Update Topic Count.
	*@author Bruno Fagundez
	*/
	public without sharing class updateviewCount {
		
		public String topicId;
		
		/**
		* Set topic Id
		*@param String 
		*/
		public void setTopicId(String sTopic){
			topicId = sTopic;
		}
		
		/**
		* Get topic Id
		@return String
		*/
		public String getTopicId(){
			return topicId;
		}
		
		/**
		* Update view conut for Topic
		*/
		public void updateviewCountRedirect(){
			List<DiscussionTopic__c> topic = [select Id, ViewCount__c, LastViewedDate__c from DiscussionTopic__c where id =: topicId];
			if (topic.size() > 0) {
				topic[0].ViewCount__c = topic[0].ViewCount__c + 1;
				topic[0].LastViewedDate__c = System.now();
				upsert topic;
			}
		}
		
		/**
		* Geto topic detial page reference
		*@return PageReference
		*/
		public PageReference getTopicPage(){
			updateviewCountRedirect();
			PageReference dd = Page.DiscussionDetail;
			dd.getParameters().put('id', topicId);
			dd.setRedirect(true);
			return dd;
		}
	}
	
	/**
	* Update topic count and return detail page reference.
	*@return PageReference 
	*/
	public PageReference openTopic(){
		updateviewCount upd = new updateviewCount();
		upd.setTopicId(System.currentPageReference().getParameters().get('topicID'));
		return upd.getTopicPage();
	} 
	
	/**
	* Inner Class to show Discussion Topics.
	* @return String TeamName 
	* @return Integer NumberOfMessages 
	* @return Integer NumberOfViews
	* @return String LastPostMessage 
	*/
	public class TopicList {
		
		String AuthorPicture;
		String AuthorId;
		String AuthorName;
		String Name;
		String TeamName;
		String TeamId;
		String Id;
		Integer NumberOfMessages;
		Integer NumberOfViews;
		String LastPostMessage;	
		DiscussionMessage__c firstMessageCreated;	
		String userImg;
		boolean enableActions = false;
		
		/**
		* Setters 
		*/
		
		/**
		* Set topic Id
		*@param String
		*/
		public void setId(String sId){
       		Id = sId;
        }
		
		/**
		* Set author Id
		*@param String
		*/
		public void setAuthorId(String sAuthorId){
       		AuthorId = sAuthorId;
        }
		
		/**
		* Set author name
		*@param String
		*/
		public void setAuthorName(String sAuthorName){
           	AuthorName = sAuthorName;
        }
        
		/**
		* Set topic name
		*@param String
		*/
		public void setName(String sName){
			       	Name = sName;
        }
        
    	/**
    	* Set team name
    	*@param String
    	*/
    	public void setTeamName(String sTeamName){
        	TeamName = sTeamName;
        }
        
        /**
        * Set team Id
        *@param String
        */
        public void setTeamId(String sTeamId){
           	TeamId = sTeamId;
        }
                
        /**
        * Set number of meessges
        *@param Double
        */
        public void setNumberOfMessages(Double sNumberOfMessages){
        	NumberOfMessages = sNumberOfMessages.intValue() - 1;
        }

        /**
        * Set number of views
        *@param Double
        */
        public void setNumberOfViews(Double sNumberOfViews){
            NumberOfViews = sNumberOfViews.intValue();
        }
        
        /**
        * Set last post message
        *@param Id
        */
        public void setLastPostMessage(Id sLastPostMessage){
            LastPostMessage = lastPostInfoString(sLastPostMessage);
        }
        
        /**
        * Set the first message created
        *@param DiscussionMessage__c
        */
        public void setFirstMessageCreated(DiscussionMessage__c msg){  
        	firstMessageCreated = msg;
        }
        
        /**
        * Set the author pic
        *@param String
        */
        public void setAuthorPicture(String img){
        	userImg = img;
        }
        
        /**
        * Set enable actions if is a manager or owner
        *@param String author Id
        *@param Boolean is manager
        */
        public void setEnableActions(String sAuthorId, boolean isManager){        	
       		if(isManager){
				enableActions = true;
			} else {
				if(sAuthorId == UserInfo.getUserId()){
					enableActions = true;
				}
			}
        }
        /**
		* Getters 
		*/
		
		/**
		* Return true if enabled actions
		*@return Boolen
		*/
		public boolean getEnableActions() {
			return enableActions;
		}
		
		/**
		* Get author picture
		*@return String
		*/
		public String getAuthorPicture(){
			return userImg;
		}        
        
        /**
        * Return the first message created
        *@return String
        */
        public String getFirstMessageCreated(){
        	if(firstMessageCreated != null){
				return firstMessageCreated.Message__c;
			}else {
				return '';
			}
			
		}
		
		/**
		* Returns the first message Id
		*@return String
		*/
		public String getFirstMessageId(){
			if(firstMessageCreated != null){
				return firstMessageCreated.Id;
			}else {
				return '';
			}
			
		}
		
		/**
		* Return the topic Id
		*@return String
		*/
		public String getId() {					
            return Id;
		}
		
		/**
		* Get author Id
		*@return String
		*/
		public String getAuthorId() {					
            return AuthorId;
		}
		
		/**
		* Get the full author namne
		*@return String
		*/
		public String getFullAuthorName(){
			return AuthorName;
		}
		
		/**
		* Return truncated author name
		*@return String
		*/
		public String getAuthorName() {
            if(AuthorName != null){
	            Integer len = AuthorName.length();
				if (len > 20){
					return AuthorName.substring(0,20) + '...';
				}else{	
					return AuthorName.substring(0,len);
				} 	
			} else {
				return '';
			}			
		}
		
		/**
		* Get tipic name
		*@return String
		*/
		public String getName(){	
			return Name;
		}
		
		/**
		* Return short name 
		*@return String
		*/
		public String getShortName() {
			if(Name != null){
				return Name;
			}else {
				return '';
			}
		}	
		
        /**
        * Get team name
        *@return String
        */
        public String getTeamName() {
            return TeamName;
		}	
		
		/**
		* Get team Id
		*@return String
		*/
		public String getTeamId() {
            return TeamId;
		}	
		
		/**
		* Get num of messages
		*@return Integer
		*/
		public Integer getNumberOfMessages() {
            return NumberOfMessages;
		}
		
		/**
		* Get num of views
		*@return Integer
		*/
		public Integer getNumberOfViews() {
            return NumberOfViews;
		}	
		
		/**
		* Returns the las post message
		*@return String
		*/
		public String getLastPostMessage() {
			return LastPostMessage;
		}
		
		/**
		* Return true if is author
		*@return Boolean
		*/
		public boolean getIsAuthor(){
			if(AuthorId == userInfo.getUserId()){
				return true;
			}
			return false;
		}
		
		/**
		* Method to convert dates.
		* @return String datestring The string of the lastest reply. 
		*/
		public String lastPostInfoString(Id dm){
			String lastPostString;
			if (dm != null){				
				DiscussionMessage__c d = [ Select 
											LastModifiedDate, 
											DiscussionTopic__r.Subject__c, 
											DiscussionTopic__c,
											PostedBy__r.Name, 
											PostedBy__r.Id,
											PostedBy__c From DiscussionMessage__c where id =: dm];
				
				Integer today = (System.now()).day();
				String dateInfo;
				
				if(today == (d.LastModifiedDate).day()){
					dateInfo = 'Today, at ' + (d.LastModifiedDate).format('HH:mm') + ' ' + (d.LastModifiedDate).format('aa');	
				} else {
					dateInfo = '' + (d.LastModifiedDate).day() + ' of '+ (d.LastModifiedDate).format('MMMM') + ' at ' +(d.LastModifiedDate).format('HH:mm') + ' ' + (d.LastModifiedDate).format('aa');
				}	
		 		lastPostString = ' ' + dateInfo + ' by ' + d.PostedBy__r.Name;
			} else {
				lastPostString = 'This Forum has no messages yet.';
			}
			return lastPostString;
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
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	
   	/**
   	* Set of Booleans to show or not prev / next links
   	*/
   	public boolean prevPageLinkShow = false;
   	public boolean prevPageShow  = false;
   	public boolean nextPageLinkShow  = false;
   	public boolean nextPageShow  = false;
   	   	
   	/**
   	* Calculate total num of pages
   	*/
   	public void genCntPagination () {
   		cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
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
   	* Use to refresh
   	*/
   	public void refreshPages () {}
   	
   	/**
   	* Pagination Integer Getters
   	*/
   	
   	/**
   	* Get current page num
   	*@return Integer
   	*/
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	/**
   	* Get total num of pages
   	*@return Integer
   	*/
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	/**
   	* Get num of items to show
   	*@return Integer
   	*/
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	/**
   	* Returns first row num
   	*@return Integer
   	*/
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
   	/**
   	* Pagination Boolean Getters
   	*/
   	
	/**
	* Get true if should show previus page link
	*@return Boolean
	*/
	public boolean getPrevPageLinkShow () {
		if(currentPagination == 1){ 
			prevPageLinkShow = false;	
		} else {
			prevPageLinkShow = true;
		}
   		return prevPageLinkShow;
   	}
   	
   	/**
   	* Get true if should show previus page
   	*@return Boolean
   	*/
   	public boolean getPrevPageShow () {
   		if(currentPagination == 1){
   			prevPageShow = true; 
   		} else {
   			prevPageShow = false;
   		}
   		return prevPageShow;
   	}
   	
   	/**
   	* Get true if should show next page link
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
   	* Get true if should show next page
   	*@return Boolean
   	*/
   	public boolean getNextPageShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){ 
   			nextPageShow = true; 
		} else { 
			nextPageShow = false;
		} 
   		
   		return nextPageShow;
   	}
   	
   	
   	/**
   	* For bradcrum use
   	*@return String
   	*@throws Exception
   	*/
   	public String getForumData(){
   		DiscussionForum__c team = new DiscussionForum__c();
   		String teamName = null;
   		if(TEAMID != null){
   			 try {
   			 	team = [SELECT
   						Team__r.Name, 
   						Team__c,
   						Id 
   						FROM DiscussionForum__c WHERE Team__c =: TEAMID LIMIT 1];
   			 	teamName = team.Team__r.Name;
   			 } catch (Exception e) {
   			 	throw e;	
   			 }
   		} else {
   			team = null;
   		}
   		return teamName;
   	}   	
   	
   	/**
   	* Get forum data
   	*@return DiscussionForum__c
   	*@throws Exception
   	*/
   	public DiscussionForum__c getForum(){
   		DiscussionForum__c df = new DiscussionForum__c();
   		if(TEAMID != null){
   			 try {
   			 	df = [SELECT
   						Team__r.Name, 
   						Team__c,
   						Id 
   						FROM DiscussionForum__c WHERE Team__c =: TEAMID LIMIT 1];
   						
   			 } catch (Exception e) {
   			 	throw e;
   			 }
   		} else {
   			df = null;
   		}
   		return df;
   	}   	
   	
   	
	

	/** 
	* Save Topic
	*/
	public void saveTopic (){
		topicList = fillTopicList();
		totalItemsNumber = topicList.size();
		if (topicList.size() == 0){
			cntPagination = 0;
			noTopics = true;
		} else {
			noTopics = false;
			genCntPagination();	
		}	
	}	
	
	/**
	* Update view count
	*/
	public void updateReadCount () {
		String topicId = System.currentPageReference().getParameters().get('id');
		List<DiscussionTopic__c> topic = [select Id, ViewCount__c, LastViewedDate__c from DiscussionTopic__c where id =: topicId];
		if (topic.size() > 0) {
			topic[0].ViewCount__c = topic[0].ViewCount__c + 1;
			topic[0].LastViewedDate__c = System.now();
			upsert topic;
		}
	}
	
	/**
	* Get list of most readed
	*@return List<DiscussionTopic__c>
	*/
	public List<DiscussionTopic__c> getMostRead () {
		String topicId = System.currentPageReference().getParameters().get('id');
		List<DiscussionTopic__c> mostRead = new List<DiscussionTopic__c>();
		mostRead = [select Id, Subject__c, ViewCount__c, LastViewedDate__c from DiscussionTopic__c order by LastViewedDate__c desc limit 5];
		return mostRead;
	}
	
	/**
	* Get permission author apex
	*@return Boolean
	*/
	public boolean getPermissionAuthorApex(){
		User user = [Select u.Profile.Name, u.Profile.PermissionsAuthorApex, u.ProfileId, u.Name, u.Id From User u Where Id =: UserInfo.getUserId()];
		return user.Profile.PermissionsAuthorApex;
	}	
	
	/**
	* Get true if is Admin team member
	*@return Boolean
	*/
	public boolean getIsTeamAdminMember(){
		List<User> teamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =:UserInfo.getUserId() limit 1];
                                        
        if(getPermissionAuthorApex() && teamAdmin[0].Profile.PermissionsModifyAllData){
        	return true;
        }
		return false;
	}
	
	public Boolean sortByDesc = false;
	public String sortBy = 'PostedDate__c';
	
	/**
	* Returns order sense
	*@return Boolean
	*/
	public Boolean getSortByDesc () {
		return !sortByDesc;
	}
	
	/**
	* Set order sense
	*@param Boolean desc sense
	*/
	public void setSortByDesc(Boolean b){
		sortByDesc = b;
	}
	
	/**
	* Set sort by
	*@param String
	*/
	public void setSortBy(String s){
		sortBy = s;
	}
	
	/**
	* Returns current sort by
	*@return String
	*/
	public String getSortBy () {
		String sbCol = '';
		if (sortBy == null || sortBy == 'Name') {
			sbCol = 'topic';	
		}
		if (sortBy == 'PostedBy__r.Name') {
			sbCol = 'author';	
		}	
		if (sortBy == 'ViewCount__c') {
			sbCol = 'view';	
		}
		if (sortBy == 'MessageCount__c') {
			sbCol = 'replies';	
		}
		if (sortBy == 'LastPostedMessage__c') {
			sbCol = 'lastReplies';	
		}
		return sbCol; 
	}
	
	/**
	* Sort result list
	* This is a temporary method to cover us until dynamic apex is back.  This will use hard coded
	* SOQL statements in place of the dynamic statements
	*/
	public void sortList () {
		List<TopicList> topicsList = new List<TopicList>();

		if (sortBy == System.currentPageReference().getParameters().get('sb')) {
			sortByDesc = !sortByDesc;
		}else {
			sortByDesc = false;
		}
		
		if(System.currentPageReference().getParameters().get('sb') != null)
			sortBy = System.currentPageReference().getParameters().get('sb');
		
		List<DiscussionTopic__c> topicResultList = new List<DiscussionTopic__c>();
		List<PeopleProfile__c> peopleProfiles = new List<PeopleProfile__c>();
	
		if (sortByDesc) {
			if (sortBy == 'Name') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by Subject__c desc];
					
			}
			if (sortBy == 'PostedBy__r.Name') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by PostedBy__r.Name desc];					
			}	
			if (sortBy == 'ViewCount__c') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by ViewCount__c desc];
										   					
			}
			if (sortBy == 'MessageCount__c') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by MessageCount__c desc];
			}
			if (sortBy == 'LastPostedMessage__c') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by LastPostedMessage__c desc];					
			}			
			
		} else {
			
			if (sortBy == 'Name') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by Subject__c];
					
			}
			if (sortBy == 'PostedBy__r.Name') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by PostedBy__r.Name];					
			}	
			if (sortBy == 'ViewCount__c') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by ViewCount__c];
										   					
			}
			if (sortBy == 'MessageCount__c') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by MessageCount__c];
			}
			if (sortBy == 'LastPostedMessage__c') {
				topicResultList = [Select Id, 
										  ViewCount__c,
										  Team__c, 
										  Team__r.Name,
										  Subject__c,
										  Name, 
										  MessageCount__c, 
										  PostedBy__r.Name,
										  PostedBy__r.Id, 
										  LastPostedMessage__c,
										  DiscussionForum__c, 
										  (Select Id,
										  		  PostedDate__c,
										  		  DiscussionTopic__c,
										  		  Subject__c,
										  		  PostedBy__c,
										  		  Message__c,
										  		  ParentMessage__c,
										  		  Team__c From DiscussionTopic__r 
										  		  order by PostedDate__c asc limit 1)
										   From DiscussionTopic__c d	
										   where Team__c =: TEAMID
										   Order by LastPostedMessage__c ];					
			}			
			
		}
				
		peopleProfiles = [Select Id, Picture__c, User__c From PeopleProfile__c];
		
		if (!TeamUtil.isTest) {
			for (DiscussionTopic__c t: topicResultList) {
				TopicList topicItem = new TopicList();
				
				for(PeopleProfile__c p : peopleProfiles){
					if(p.User__c == t.PostedBy__r.Id){
						topicItem.setAuthorPicture(p.Picture__c);
					}
				}
				topicItem.setAuthorId(t.PostedBy__r.Id);
				topicItem.setNumberOfViews(t.ViewCount__c);
				topicItem.setId(t.Id);	
				topicItem.setName(t.Subject__c);						
				topicItem.setTeamId(t.Team__c);
				topicItem.setAuthorName(t.PostedBy__r.Name);
				topicItem.setTeamName(t.Team__r.Name);
				topicItem.setNumberOfMessages(t.MessageCount__c);				
				topicItem.setLastPostMessage(t.LastPostedMessage__c);
				if(t.DiscussionTopic__r.size() > 0)
				{
					topicItem.setFirstMessageCreated(t.DiscussionTopic__r[0]);
				}
					
				topicItem.setEnableActions(t.PostedBy__r.Id, isManager);
				topicsList.add(topicItem);
				
			}
		}
			
		totalItemsNumber = topicsList.size();
		if (totalItemsNumber == 0 ) {
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
		}else {
			firstRow = 0;
			currentPagination = 1;
			genCntPagination();	
		}
		topicList = topicsList;	
	}
}
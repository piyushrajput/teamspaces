/**
*@author Yuri Alvarez @ 04/30/2008
*/
public class PeopleActivityFeedController {
	
	/**
	* Get user avatar
	*@return String
	*/
	public String getMyPicture(){
		
		String MyPictureId;
		PeopleProfile__c temp = new PeopleProfile__c();
		
		try{
			temp = [SELECT Picture__c                                              
		                 FROM PeopleProfile__c
		             	 WHERE User__c =: UserInfo.getUserId()];
			if((temp.Picture__c == '') ||( temp.Picture__c == null )){ 
					MyPictureId = '01530000000VO5s';
			} else {
					MyPictureId = temp.Picture__c;
			} 
		} catch(Exception e) {
			MyPictureId = '01530000000VO5s';
		}
		return MyPictureId;
	}

	/**
	* Returns profile for current user
	*@return PeopleProfile__c mySidebarProfile
	*/
	public PeopleProfile__c getMySidebarProfile(){
		List<PeopleProfile__c> mySideBarProfileList = [SELECT Id,
 												User__c,
 												Status__c,
 												StatusLastModifiedDate__c,
 												User__r.Name,
                                                User__r.FirstName,
                                                User__r.LastName,
                                                User__r.Title,
                                                (Select Id From Attachments),
                                                CreatedDate                                                
                                        		FROM PeopleProfile__c
                                         		WHERE User__c =: UserInfo.getUserId()];
		PeopleProfile__c mySidebarProfile = new PeopleProfile__c();
		if (mySideBarProfileList.size() > 0) {
			mySideBarProfile = mySideBarProfileList[0]; 
		}                                         		
        return mySidebarProfile;      
	}

	// boolean to control showing or not the status
	boolean showStatus;	
	
	/**
	* Get show status
	*@return Boolean showStatus
	*/
	public boolean getShowStatus(){
		return showStatus;
	}
		
	/**
	* Get status instance
	*@return Status sObj;
	*/
	public Status getStatus() {
    	// Status Obj
    	Status sObj = new Status();
    	
    	if((p.Status__c != null) && (p.StatusLastModifiedDate__c != null)){
          	sObj.setMessage(p.Status__c);
			sObj.setModified(p.StatusLastModifiedDate__c);
    	}
		return sObj;       
	}
	
	/**
	* Class Status
	*@author Yuri Alvarez
	*/
	public class Status {
		
		String Message;
		String Modified = '';		
		
		/**
		* Set status message
		*@param String
		*/
		public void setMessage(String sMessage){                
            Message = sMessage;                
        }
        
        /**
        * Returns status message
        *@return String
        */
        public String getMessage() {
            return Message;
		}
		
		/**
		* Set status modified date
		*@param Datetime sModified
		*/
		public void setModified(Datetime sModified){
			// Get the current time
			DateTime now = System.now();
			
			String todayDateString = '' + now.day() + now.month() + now.year();
			
			Integer today = now.dayOfYear();
			Integer modifiedDay = sModified.dayOfYear();
			Integer temp = 0;
			String updateMessage = '';
			
			// Check if the update was today
			if(sModified.isSameDay(now)){
				// Check how many hours ago
				temp = now.hour() - sModified.hour();
				// Check if the timelapse is small than one hour
				// if that , get the minutes ago  
				if (temp <= 1 ){
					temp = now.minute() - sModified.minute();
					if(temp == 0){
						temp = now.second() - sModified.second();														
						updateMessage = 'Updated ' + temp + ' seconds ago';
					} else {		
						if(temp == 1){
							updateMessage = 'Updated ' + temp + ' minute ago';
						} else {
							updateMessage = 'Updated ' + temp + ' minutes ago';
						}
					}
				} else {						
						updateMessage = 'Updated ' + temp + ' hours ago';
				}				
			} else {
				Integer rest = today - modifiedDay;
				// if the update was in the last week
				if(rest <= 7){
					updateMessage = 'Updated on ' + sModified.format('EEEEEE');
				} else {
					updateMessage = 'expired';
				}
			}		
            Modified = updateMessage;
        }
        
        /**
        * Get status modified date
        *@return String Modifieds
        */
        public String getModified() {
        	return Modified;
		}
		
	}

	//Search Result Page 
    private static String PEOPLE_SEARCH_RESULTS_PAGE = '/apex/PeopleKeywordSearchResults';
    
    //Search Object Initialization
    PeopleSearch peopleSearchObj = new PeopleSearch();    
    
    /**
    * Get PeopleSearch instance
    *@return PeopleSearch peopleSearchObj
    */
    public PeopleSearch getPeopleSearchObj (){
    	return peopleSearchObj;
   	}
        
    /**
    * Forward to search result page
    *@return PegeReference pageRef
    */
    public PageReference findPeople() {
    	PageReference pageRef = new PageReference(PEOPLE_SEARCH_RESULTS_PAGE
                          							+ '?keyword=' + peopleSearchObj.getKeyword());
    	pageRef.setRedirect(true);
    	return pageRef;
    }
          
	/**
	* Class PeopleSearch
	*@author Yuri Alvarez
	*/
	public class PeopleSearch {
        String Keyword;       

        /**
        * Get keyword
        *@return String keyword
        */
        public String getKeyword() {
                return Keyword;
        }

        /**
        * Set keyword
        *@param String keyword
        */
        public void setKeyword(String Keyword) {
                this.Keyword = Keyword;
        }        
	}
	
	// User Id (to show all data)
	String USERID;
	
	// Profile Row
	PeopleProfile__c p = new PeopleProfile__c();
	public Integer miniFeedCount;
	
	/**
	* Constructor
	*/
	public PeopleActivityFeedController(){
		// Check if the user id is provided, if not, the current userid is used as default.
		if(System.currentPageReference().getParameters().get('id') == null){
			USERID = UserInfo.getUserId();			
		} else {
			USERID = System.currentPageReference().getParameters().get('id');
		}
		
		// Get Profile
		p = [SELECT Id,
 						User__c,
 						User__r.Name,
                        User__r.FirstName,
                        User__r.LastName,
                        User__r.Title,
                        User__r.Division,
                        User__r.Department,
                        User__r.Phone,
                        User__r.MobilePhone,
                        User__r.Fax,
                        User__r.Email,  
                        Picture__c,                                               
                        AboutMe__c,
                        Linkedin__c, 
                        Facebook__c, 
                        Delicious__c,
                        Status__c,
                        Aol__c,
                        YahooIM__c,
                        Skype__c,
                        Gtalk__c,
                        StatusLastModifiedDate__c,                                                
                        CreatedDate                                                
                        FROM PeopleProfile__c
                        WHERE User__c =: USERID limit 1];
	}
	
	/**
	* Get new profile
	*@return Profile profileObj
	*/
	public Profile getProfile(){
		Profile profileObj = new Profile();
		profileObj.setFirstName(p.User__r.FirstName);
		return profileObj;
	}
	
	/**
	* Class Profile
	*@author Yuri Alvarez
	*/
	public class Profile {
		Id Id;
		Id UserId;
		String FirstName;
		
	   	/**
	   	* Set profile Id 
	   	*@param Id sId
	   	*/
	   	public void setId(Id sId){
            Id = sId;
        }
        
        /**
        * Get profile Id
        *@return String Id
        */
        public String getId() {
            return Id;
		}
		
		/**
		* Set first name
		*@param String sFirstName
		*/
		public void setFirstName(String sFirstName){
            FirstName = sFirstName;
        }
        
        /**
        * Get first name
        *@return String FirstName
        */
        public String getFirstName() {
            return FirstName;
		}
	}

	/**
	* Get mini feeds list
	*@return List<miniFeed> miniFeeds
	*/
	public List<miniFeed> getMiniFeeds() {
       	// Feed Dates 
		boolean TodayShow = false;
	   	boolean YesterdayShow = false ;
	    boolean monthShow = false ;
	    DateTime now = System.now();
	    String dateAlreadyShown = '';
	    String FeedParsedDate = '';
	    Datetime FeedDateIterator;
	    String typeFilterObj = System.currentPageReference().getParameters().get('mfTypeObj');
	    String typeFilterStr = System.currentPageReference().getParameters().get('mfTypeStr');
	    
	    List<miniFeed> miniFeeds = new List<miniFeed>();

     	if (miniFeeds.size() < 1) {
     		
			List<MiniFeed__c> feeds;
			
			if(((typeFilterObj != '') && (typeFilterObj != null)) || ((typeFilterStr != '') && (typeFilterStr != null))){
				feeds =  [Select
								m.User__c,
								m.User__r.Name, 
								m.Type__c, 
								m.Message__c,
								m.CreatedDate 
								From MiniFeed__c m 				
								WHERE m.User__c =: USERID
								AND (m.Type__c =: typeFilterObj OR m.Type__c like :(typeFilterStr + '%'))
								ORDER BY m.CreatedDate DESC LIMIT 30];
			}else{	
				feeds =  [Select
								m.User__c,
								m.User__r.Name, 
								m.Type__c, 
								m.Message__c,
								m.CreatedDate 
								From MiniFeed__c m 				
								WHERE m.User__c =: USERID
								ORDER BY m.CreatedDate DESC LIMIT 30];
			}
				
				
			for(Integer i = 0; i < feeds.size() ; i++){
				miniFeed miniFeed = new miniFeed();
				miniFeed.setUser(feeds[i].User__c);
                miniFeed.setName(feeds[i].User__r.Name);
                miniFeed.setMessage(feeds[i].Message__c);
                miniFeed.setTypeOfFeed(feeds[i].Type__c);
                miniFeed.setFeedDate(feeds[i].CreatedDate);
         
                // Set the Date Message 
				FeedDateIterator = feeds[i].CreatedDate;
				FeedParsedDate = 'Date' + FeedDateIterator.day() + FeedDateIterator.month() + FeedDateIterator.year();	        		
               	
        		// Check if today is the day
        		if( ( FeedDateIterator.day() == now.day() ) && ( !TodayShow )){
        			TodayShow = true;
        			miniFeed.setFeedDateClass('miniFeedDate');
        			miniFeed.setFeedDateString('Today');						        			       
        						
        		} else {
        			// Yesterday 
        			if ((FeedDateIterator.day() == ( now.day() - 1 )) && (!YesterdayShow )) {
        				YesterdayShow = true;
        				miniFeed.setFeedDateClass('miniFeedDate');
        				miniFeed.setFeedDateString('Yesterday');	        				
        				
        			} else {
        				if ( FeedDateIterator.day() == now.day()){
        					miniFeed.setFeedDateClass('miniFeedDate_empty');
        					miniFeed.setFeedDateString(' ');
        					
        				} else {					        			
	        				if ( dateAlreadyShown != FeedParsedDate ){      					
	        					String Month;
	        					if( FeedDateIterator.month() == 1)
									Month = 'January '; 
	        					if( FeedDateIterator.month() == 2) 
									Month = 'February '; 
	        					if( FeedDateIterator.month() == 3)  
	        						Month = 'March  ';
	        					if( FeedDateIterator.month() == 4) 
	        						Month = 'April ';
	        					if( FeedDateIterator.month() == 5) 
	        						Month = 'May ';
	        					if( FeedDateIterator.month() == 6) 
	        						Month = 'June ';
	        					if( FeedDateIterator.month() == 7) 
	        						Month = 'July ';
	        					if( FeedDateIterator.month() == 8) 
	        						Month = 'August ';
	        					if( FeedDateIterator.month() == 9) 
	        						Month = 'September ';
	        					if( FeedDateIterator.month() == 10) 
	        						Month = 'October ';
	        					if( FeedDateIterator.month() == 11) 
	        						Month = 'November ';
	        					if( FeedDateIterator.month() == 12) 
	        						Month = 'December ';
	        					
	        					dateAlreadyShown = 'Date' + FeedDateIterator.day() + FeedDateIterator.month() + FeedDateIterator.year();
	        					String tempDate = Month + FeedDateIterator.day() + ', ' + FeedDateIterator.year();
	        					miniFeed.setFeedDateClass('miniFeedDate');
	        					miniFeed.setFeedDateString(tempDate);
	        					
	        				} else {
	        					miniFeed.setFeedDateClass('miniFeedDate_empty');
	        					miniFeed.setFeedDateString('');
	        				}
        				}
        			}  		
        		}    
                miniFeeds.add(miniFeed);    					
			}    					
 		}
 		miniFeedCount = miniFeeds.size();
    	return miniFeeds;
    } 
    
	/**
	* Returns minifeeds count
	*@return Integer
	*/
	public Integer getMiniFeedCount(){
    	return miniFeedCount;
    }
	        
    /**
    * Set minifeeds count
    *@param Integer count
    */
    public void setMiniFeedCount(Integer count){
    	miniFeedCount = count;
    }
	       
	/**
	* Class MiniFeed
	*@author Yuri Alvarez
	*/
	public class miniFeed {
		
		public String User;
		public String Name;
        public String TypeOfFeed;
        public String Message;
        public String FeedDateString;
        public String FeedDateClass;
        public Datetime FeedDate;  
              
      	/**
      	* Constructor
      	*/
      	public miniFeed(){}
      	
      	/**
      	* Returns icon for feed type
      	*@return String TypeOfFeed
      	*/
        public String getTypeOfFeed() {
			if(TypeOfFeed == 'EducationHistory__c') 
				TypeOfFeed = 'education'; 
    		if(TypeOfFeed == 'UserCompetencies__c') 
    			TypeOfFeed = 'competency';
    		if(TypeOfFeed == 'DiscussionThread__c') 
    			TypeOfFeed = 'discussion';
    		if(TypeOfFeed == 'EmploymentHistory__c') 
    			TypeOfFeed = 'employment';
    		if(TypeOfFeed == 'Announcement__c') 
    			TypeOfFeed = 'announcement';
    		if(TypeOfFeed == 'TeamspaceMember__c') 
    			TypeOfFeed = 'teamspace';
    		return TypeOfFeed;
		}
		
		/**
		* Set type of feed
		*@param String sTypeOfFeed
		*/
		public void setTypeOfFeed(String sTypeOfFeed){
            TypeOfFeed = sTypeOfFeed;
        }
  
      	/**
      	* Return user name
      	*@return String name
      	*/
      	public String getName() {
            return Name;
        }
        
        /**
        * Set user name
        *@param String sName
        */
        public void setName(String sName){
            Name = sName;
        }
        
        /**
        * Get User Id
        *@return String User
        */
        public String getUser() {
            return User;
        }
        
        /**
        * Set User id
        *@param String sUser
        */
        public void setUser(String sUser){
            User = sUser;
        }
        
        /**
        * Get feed message
        *@return String message
        */
        public String getMessage() {
            return Message;
        }
        
        /**
        * Set feed message
        *@param String message
        */
        public void setMessage(String sMessage){
            Message = sMessage;
        }
       	
		/**
		* Returns feed date
		*@return Datetime FeedDate
		*/       
        public Datetime getFeedDate() {
    		return FeedDate;
        }
        
        /**
        * Set feed date
        *@param Datetime sFeedDate
        */
        public void setFeedDate(Datetime sFeedDate){
            FeedDate = sFeedDate;
        }  
        
       	/**
       	* Returns formated feed date
       	*@return String FeedDateString
       	*/
       	public String getFeedDateString() {
        	return FeedDateString;
        }
        
        /**
        * Set formated feed date
        *@param String sFeedDateString
        */
        public void setFeedDateString(String sFeedDateString){
            FeedDateString = sFeedDateString;
        }  
        
        /**
        * Get feed date class
        *@return String FeedDateClass 
        */
        public String getFeedDateClass() {
        	return FeedDateClass;		        		       
        }
        
        /**
        * Set feed date class
        *@param String sFeedDateClass
        */
        public void setFeedDateClass(String sFeedDateClass){
            FeedDateClass = sFeedDateClass;
        }       

	}

}
/**
*@author Yuri Alvarez @ 04/30/2008
*/
public class PeopleOverviewController {
	
	/**
	* Constructor
	*/
	public PeopleOverviewController(){}	
	
	/**
    *Get current time (aprox)
    *@return String current time
    */			
	public String getCurrentTime(){
		Datetime now = (System.now()).addHours(7);
		String s1 = now.format('yyyy-MM-dd');
		String s2 = now.format('HH:mm:ss.SSS');
		String dateString = s1 + 'T' + s2 + 'Z';
		return dateString;
	}

	/**
	*Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 

	/**
	*Check if people profile exist for current user
	*@return PageReference
	*/
	public PageReference profileExist(){
		PageReference pr = null;
		List<PeopleProfile__c> profiles = new List<PeopleProfile__c>();
		profiles = getPeopleProfile();
		if(profiles.size() == 0){
			PeopleProfile__c profile = new PeopleProfile__c();
			profile.User__c = UserInfo.getUserId();
			profile.Name = UserInfo.getName();
			insert profile;
		}
		return pr;
	}
	
	/**
	*Get people profile for current user
	*@return List<PeopleProfile__c>
	*/
	public List<PeopleProfile__c> getPeopleProfile(){
		List<PeopleProfile__c> profiles = new List<PeopleProfile__c>();			
		profiles = [SELECT Id,  Status__c, Picture__c, StatusLastModifiedDate__c
		     		FROM PeopleProfile__c
		     		WHERE User__c =: UserInfo.getUserId()];
		return profiles;	
	}
	
	/**
	*Get the 5 newest Faces
	*@return List<People>
	*/
	public List<People> getNewFaces(){
 		List<PeopleProfile__c> tempList = [SELECT Id,
 												User__c,
                                                User__r.Name,
                                                User__r.Division,
                                                User__r.Department,                                                
                                                User__r.Title,
                                                Picture__c,                                               
                                                CreatedDate                                                
                                        		FROM PeopleProfile__c
                                         		ORDER BY User__r.CreatedDate DESC LIMIT 5 ];
                                         		
        List<People> newPeopleList = new List<People>();
		for(PeopleProfile__c p: tempList){
			People person = new People();
			person.setUserId(p.User__c);
			person.setUsername(p.User__r.Name);
			person.setDivision(p.User__r.Division);
			person.setDepartment(p.User__r.Department);
			person.setTitle(p.User__r.Title);
			if((p.Picture__c == '') || (p.Picture__c == null)){
				person.setImageId('');
			} else{
				person.setImageId(p.Picture__c);
			}
			newPeopleList.add(person);
		}
		return newPeopleList;
	}
	
	
	/**
	*Class People
	*@author Yuri Alvarez
	*/
	public class People {
		String UserId;
        String Username;
        String Division;
        String Department;
        String Title;
        String ImageId;	
		
		
		/**
		*Get user id
		*@return String
		*/
		public String getUserId() {
            return UserId;
        }
        
        /**
		*Set user id
		*@param String
		*/
        public void setUserId(String UserId) {
            this.UserId = UserId;
        }		
		
		/**
		*Get user name
		*@return String
		*/
        public String getUsername() {
            return Username;
        }
        
        /**
		*Set user name
		*@param String
		*/
        public void setUsername(String Username) {
            this.Username = Username;
        }
        
        /**
		*Get division
		*@return String
		*/
        public String getDivision() {
            return Division;
        }
        
        /**
		*Set division
		*@param String
		*/
        public void setDivision(String Division) {
            this.Division = Division;
        }
        
        /**
		*Get department
		*@return String
		*/
        public String getDepartment() {
            return Department;
        }
        
        /**
		*Set department
		*@param String
		*/
        public void setDepartment(String Department) {
            this.Department = Department;
        }
        
        /**
		*Get title
		*@return String
		*/
        public String getTitle() {
            return Title;
        }
        
        /**
		*Set title
		*@param String
		*/
        public void setTitle(String Title) {
            this.Title = Title;
        }
		
		/**
		*Get image's id
		*@return String
		*/
		public String getImageId() {
            return ImageId;
        }
        
        /**
		*Set image's id
		*@param String
		*/
        public void setImageId(String ImageId) {
            this.ImageId = ImageId;
        }
		
    }
    
    /** 
   	* Profile picture attachment methods
   	*/	  	  
	
	public Attachment peopleAttach = new Attachment();
	public Integer AttachmentSize { get; set;}
	
	/**
	*Set Attachment
	*@param Attachment
	*/
	public void setPeopleAttach (Attachment attach) {
		this.peopleAttach = attach;
	}
	
	/**
	*Get Attachment
	*@return Attachment
	*/
	public Attachment getPeopleAttach () {     
		return peopleAttach;
	}

	/**
	*Create a page reference to profile gallery
	*@return PageReference
	*/
	public PageReference profileGallery (){
		PageReference pageRef = Page.peoplephotogallery;
		pageRef.getParameters().put('pid', gallerypid);
		pageRef.setRedirect(true);
		return pageRef;
	}
	

	public String gallerypid = System.currentPageReference().getParameters().get('pid');
	
	/**
	*Get the uploads count
	*@return Integer
	*/
	public Integer getCountUploads(){
		Integer countuploads = 0;
		if(System.currentPageReference().getParameters().get('upc') != '' && System.currentPageReference().getParameters().get('upc') != null){
			countuploads = Integer.valueOf(System.currentPageReference().getParameters().get('upc'));
		}
		return countuploads;
	}
	
	/**
	*Save attachment
	*@return PageReference
	*/
	public PageReference savePeopleAttach(){
		if((AttachmentSize > 5240000) || !(checkMimeType()) ){			
			peopleAttach = new Attachment();
			PageReference pageRef = Page.PeopleUploadPicture;
			pageRef.getParameters().put('pid', System.currentPageReference().getParameters().get('pid'));
			pageRef.getParameters().put('upstate', 'false');
			pageRef.getParameters().put('upc', ''+this.getCountUploads());
			pageRef.setRedirect(true);
			return pageRef;
		} else {
			peopleAttach.ParentId = System.currentPageReference().getParameters().get('pid');
			PageReference pageRef = Page.PeopleUploadPicture;
			pageRef.getParameters().put('pid', peopleAttach.ParentId);
			pageRef.getParameters().put('upstate', 'true');
			pageRef.getParameters().put('upc', ''+(this.getCountUploads()+1));
			pageRef.setRedirect(true);
			insert peopleAttach;
			return pageRef;
		}				
				
	} 
	
	public String ContentType { get; set;}
	
	/**
	*Returns true if ContentType corresponds to an image mime type.
	*@return Boolean
	*/
	public Boolean checkMimeType(){		
		Map<String, String> typesMime = new Map<String, String>{
       			'image/jpeg' => 'images.gif', 
       			'image/pjpeg' => 'images.gif', 
       			'image/png' => 'images.gif', 
       			'image/x-png' => 'images.gif', 
       			'image/gif' => 'images.gif', 
       			'image/bmp' => 'images.gif'       			
   			};
		if(typesMime.containsKey(ContentType)){
			return true;
		} else {
			return false;
		}	
	}
	
	public boolean displayError {get; set;} 
	
	public boolean successMessage { get; set; }
	
	
	/**
	*Initialize check for attachment
	*/
	public void initAttachmentCheck(){
		displayError = false;
		//Check if the parameter are there
		if(System.currentPageReference().getParameters().get('upstate') == 'false'){
			displayError = true;		
		} else if (System.currentPageReference().getParameters().get('upstate') == 'true'){
			successMessage = true;
		}
	}

	
	//####################################//
	// People Keyword Search 
	//####################################//
	
	//Search Result Page 
    private static PageReference PEOPLE_SEARCH_RESULTS_PAGE = Page.PeopleKeywordSearchResults;
    
    //Search Object Initialization
    PeopleSearch peopleSearchObj = new PeopleSearch();    
    
    /**
    *Get peopleSearchObj
    *@return PeopleSearch
    */
    public PeopleSearch getPeopleSearchObj (){
        return peopleSearchObj;
   	}
    
    /**
    *Forward to searhc result page
    *@return PageReference
    */
    public PageReference findPeople() {
        PageReference pageRef = PEOPLE_SEARCH_RESULTS_PAGE;
        pageRef.getParameters().put('key', peopleSearchObj.getKeyword());
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
	
	//####################################//
	// Tag Clouds 
	//####################################//
	
	/**
	*Get Competencies Cloud
	*@return List<CloudItems>
	*/ 
	public List<CloudItems> getCompetenciesCloud(){
		List<CloudItems> competencyCloud = generateCloud('Competency');
		return competencyCloud;	
	}
		
	/**
	*Generates Companies Cloud
	*@return List<CloudItems>
	*/
	public List<CloudItems> getFormerCompaniesCloud(){
		List<CloudItems> competencyCloud = generateCloud('Employer');
		return competencyCloud;		
	}
	
	/**
	*Generates Colleges Cloud
	*@return List<CloudItems>
	*/
	public List<CloudItems> getCollegesCloud(){
		List<CloudItems> competencyCloud = generateCloud('School');
		return competencyCloud;
	}
	
	/**
	*Get Clouds for Employer, School or Competency
	*@param CloudType set could type
	*@return List<CloudItems>
	*/
	public List<CloudItems> generateCloud(String CloudType){
		// Build the list 
		List<CloudItems> queryResults = new List<CloudItems>(); 
		
		if(CloudType == 'Employer'){
			List<Employer__c> l = new List<Employer__c>();
			// Select the values from database
			l = [Select Name, Count__c From Employer__c ORDER BY Count__c DESC LIMIT 15];
			for(Employer__c e: l){
				CloudItems c = new CloudItems();
				c.setName(e.Name);
				c.setCount(e.Count__c);
				queryResults.add(c);
			}
		}
		if(CloudType == 'School'){
			List<School__c> l = new List<School__c>();
			// Select the values from database
			l = [Select Name, Count__c From School__c ORDER BY Count__c DESC LIMIT 15];
			for(School__c e: l){
				CloudItems c = new CloudItems();
				c.setName(e.Name);
				c.setCount(e.Count__c);
				queryResults.add(c);
			}
		}
		if(CloudType == 'Competency'){
			List<Competency__c> l = new List<Competency__c>();
			// Select the values from database
			l = [Select Name, Count__c From Competency__c ORDER BY Count__c DESC LIMIT 15];
			for(Competency__c e: l){
				CloudItems c = new CloudItems();
				c.setName(e.Name);
				c.setCount(e.Count__c);
				queryResults.add(c);
			}
		}
		if(queryResults.size() == 0) return queryResults;
				
		// Get the highest rated item     
		Double maxRating = queryResults[0].Count;
		
		// Get the fraction
		Double base = maxRating / 10;
		
		// Level build
		Double level_1 = base ;
		Double level_2 = base * 2;
		Double level_3 = base * 3;
		Double level_4 = base * 4;
		Double level_5 = base * 5;
		Double level_6 = base * 6;
		Double level_7 = base * 7;
		Double level_8 = base * 8;
		Double level_9 = base * 9;
		Double level_10 = base * 10;
		
		// Build list
		List<CloudItems> result = new List<CloudItems>(); 
		
		for(CloudItems e: queryResults){
				CloudItems item = new CloudItems();
		     	item.setName(e.Name);		     	
		     	if (e.Count < level_1) 
		     		item.setLevel(1);
		     	if (e.Count >= level_1 && e.Count < level_2) 
		     		item.setLevel(2);
		     	if (e.Count >= level_2 && e.Count < level_3) 
		     		item.setLevel(3);
		     	if (e.Count >= level_3 && e.Count < level_4) 
		     		item.setLevel(4);
		     	if (e.Count >= level_4 && e.Count < level_5) 
		     		item.setLevel(5);
		     	if (e.Count >= level_5 && e.Count < level_6) 
		     		item.setLevel(6);
		     	if (e.Count >= level_6 && e.Count < level_7) 
		     		item.setLevel(7);
		     	if (e.Count >= level_7 && e.Count < level_8) 
		     		item.setLevel(8);
		     	if (e.Count >= level_8 && e.Count < level_9) 
		     		item.setLevel(9);
		     	if (e.Count >= level_9 && e.Count < level_10) 
		     		item.setLevel(10);
		     	result.add(item);		     	
		}
		
		// Shuffle
		Integer resultSize = result.size() - 1;
	    Integer i;	    
	  
	    for (i = 0; i <= resultSize; i++) {
	        Integer alea = Integer.valueOf(String.valueOf(Math.roundToLong(Math.ceil(Math.random() * resultSize))));
	        CloudItems item;
	 		item = result.get(i);
	 		result.set(i, result.get(alea));
	 		result.set(alea, item); 
	    	}
		return result; 
	}
	
	/**
	*Class Cloud Items
	*@author Yuri Alvarez
	*/
	public class CloudItems { 		
 		String Name;
 		Integer Level;
 		Double Count;

		/**
		*Get cloud name
		*@return String
		*/
        public String getName () {
        	return Name;       	
        } 
        
        /**
		*Set cloud name
		*@param String
		*/ 
        public void setName (String Name) {
        	this.Name = Name;
        }
        
        /**
		*Get cloud level
		*@return Integer
		*/
        public Integer getLevel () {
        	return Level;
        }   
        
        /**
        *Set cloud level
        *@param Integer
        */
        public void setLevel (Integer Level) {
        	this.Level = Level;
        }       	
        
        
        /**
        *Get Count 
        *@return Double
        */
        public double getCount () {
        	return Count;
        }   
        
        /**
        *Set Count
        *@param double
        */
        public void setCount (double Count) {
        	this.Count = Count;
        }    
 	}

    boolean showFeeds = true;
	
	/**
	*Returns true if should show feeds
	*@return Boolean
	*/
	public boolean getShowFeeds(){
	    	return showFeeds;
	}
	 
	 /**
	 *Get Mini Feeds
	 *@return List<miniFeed>
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
	    
     	List<miniFeed> miniFeeds = new List<miniFeed>();
     	
     	if (miniFeeds.size() < 1) {
			List<MiniFeed__c> feeds;
			List<String> subscribedList = new List<String>();
			List<PeopleSubscription__c> subsAux = new List<PeopleSubscription__c>();
			
			subsAux = [Select p.Subscriber__c, p.Person__c, p.Person__r.Id From PeopleSubscription__c p where p.Subscriber__c =: UserInfo.getUserId()];
			
			if(subsAux.size() > 0){
				showFeeds = true;
				for(PeopleSubscription__c ps: subsAux){
					subscribedList.add(ps.Person__r.Id);
				} 	
			} 
			if(subscribedList.size() > 0){
				feeds =  [Select
									m.User__c,
									m.User__r.Name, 
									m.Type__c, 
									m.Message__c,
									m.CreatedDate 
									From MiniFeed__c m  				
									WHERE User__c IN: subscribedList ORDER BY m.CreatedDate DESC LIMIT 10];
									
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
		                                
 		}
    	return miniFeeds;
    } 
    
    
    /**
    *Class miniFeed
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
        *Constructor
        */        
      	public miniFeed(){	
      		
      	}
      	
      	/**
      	*Return the current type of feed
      	*@return String
      	*/
        public String getTypeOfFeed() {
    			if (TypeOfFeed == 'EducationHistory__c') 
    				TypeOfFeed = 'education'; 
        		if (TypeOfFeed == 'UserCompetencies__c') 
        			TypeOfFeed = 'competency';
        		if (TypeOfFeed == 'DiscussionThread__c') 
        			TypeOfFeed = 'discussion';
        		if (TypeOfFeed == 'EmploymentHistory__c') 
        			TypeOfFeed = 'employment';
        		if (TypeOfFeed == 'Announcement__c') 
        			TypeOfFeed = 'announcement';
        		if (TypeOfFeed == 'TeamspaceMember__c') 
        			TypeOfFeed = 'teamspace';
        		
        		return TypeOfFeed;
		}
		
		
		/**
      	*Set type of feed
      	*@param String
      	*/
		public void setTypeOfFeed(String sTypeOfFeed){
            TypeOfFeed = sTypeOfFeed;
        }
  		
  		/**
  		*Get name
  		*@return String
  		*/
      	public String getName() {
            return Name;
        }
        
        /**
        *Set name 
        *@param String
        */
        public void setName(String sName){
            Name = sName;
        }
        
        /**
        *Get user
        *@return String
        */
        public String getUser() {
            return User;
        }
        
        /**
        *Set user
        *@param String
        */
        public void setUser(String sUser){
            User = sUser;
        }
        
        /**
        *Get message
        *@return String
        */
        public String getMessage() {
        	return Message;
        }
        
        /**
        *Set message
        *@param String
        */
        public void setMessage(String sMessage){
            Message = sMessage;
        }
       	
       	/**
        *Get feed Date
        *@return Datetime
        */
        public Datetime getFeedDate() {
        	return FeedDate;
	        		       
        }
        
        /**
        *Set feed Date
        *@param Datetime
        */
        public void setFeedDate(Datetime sFeedDate){
            FeedDate = sFeedDate;
        }  
        
        /**
        *Get feed Date as String
        *@return formated feed date
        */
       	public String getFeedDateString() {
        	return FeedDateString;
	        		       
        }
        
        /**
        *Set feed Date as String
        *@param Datetime
        */
        public void setFeedDateString(String sFeedDateString){
            FeedDateString = sFeedDateString;
        }  
        
        /**
        *Get feed date class
        *@return String
        */
        public String getFeedDateClass() {
        	return FeedDateClass;
        }
        
        /**
        *Set feed date class
        *@param String
        */
        public void setFeedDateClass(String sFeedDateClass){
            FeedDateClass = sFeedDateClass;
        }  
	}	
}
/**
*@author Nicolas Gunther @ 6-13-2008
*/
public with sharing class TeamsActivityFeedController {
	
	/**
	* Constructor
	*/
    public TeamsActivityFeedController(){
    	getMiniFeeds();
    }
    
    public Integer miniFeedCount = 0;
	public String[] listFilter = new String[]{};
    
    //Filters 
	Boolean filterStatus = false;
	
	/**
	*@param Boolean
	*/
    public void setFilterStatus (Boolean b){
    	filterStatus = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterStatus (){
    	return filterStatus;
    }
    
   	Boolean filterFollow = false; 
   	
	/**
	*@param Boolean
	*/
    public void setFilterFollow (Boolean b){
    	filterFollow = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterFollow (){
    	return filterFollow;
    }
    
    Boolean filterEducation = false; 
    
	/**
	*@param Boolean
	*/
    public void setFilterEducation (Boolean b){
    	filterEducation = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterEducation (){
    	return filterEducation;
    }  
	
	Boolean filterCompetencies = false; 
	
	/**
	*@param Boolean
	*/
    public void setFilterCompetencies (Boolean b){
    	filterCompetencies = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterCompetencies (){
    	return filterCompetencies;
    }
    
    Boolean filterMember = false; 
    
	/**
	*@param Boolean
	*/
    public void setFilterMember (Boolean b){
    	filterMember = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterMember (){
    	return filterMember;
    }

    Boolean filterDiscussion = false; 
    
	/**
	*@param Boolean
	*/
    public void setFilterDiscussion (Boolean b){
    	filterDiscussion = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterDiscussion (){
    	return filterDiscussion;
    }
    
    Boolean filterAnnoncements = false; 
    
	/**
	*@param Boolean
	*/
    public void setFilterAnnoncements (Boolean b){
    	filterAnnoncements = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterAnnoncements (){
    	return filterAnnoncements;
    }
    
    Boolean filterProject = false; 
    
	/**
	*@param Boolean
	*/
    public void setFilterProject (Boolean b){
    	filterProject = b;
    }
    
	/**
	*@return Boolean
	*/
    public Boolean getFilterProject (){
    	return filterProject;
    }    
    
    List<miniFeed> feedsList = new List<miniFeed>();
    
	/**
	*@return List<miniFeed>
	*/
    public List<miniFeed> getFeedsList (){
    	return feedsList;
    }
    
    /**
    * Get minifeeds list
    *@void
    */
    public void getMiniFeeds() {
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
	    
     	feedsList.clear();
     	if (feedsList.size() < 1) {
			List<MiniFeed__c> feeds;
			List<String> filters = new List<String>();
			
			Boolean hasWhere = false;
			//Status filter
			if(filterStatus){
				filters.add('PeopleChangeStatus');
				hasWhere = true;
			}
			
			//People Follow filter
			if(filterFollow){				
				filters.add('PeopleFollow');
				hasWhere = true;				
			}
			
			//People Competency filter
			if(filterCompetencies){
				filters.add('PeopleCompetencyChange');
				hasWhere = true;				
			}
			
			//FilterMember filter
			if(filterMember){				
				filters.add('TeamMemberAdd');
				filters.add('TeamMemberLeave'); 
				filters.add('TeamMemberJoin');
				filters.add('TeamMemberAttachmentAdd');
				hasWhere = true;				
			}
			
			//FilterDiscussion filter
			if(filterDiscussion){				
				filters.add('DiscussionNewTopic');
				filters.add('DiscussionNewReply');			
				hasWhere = true;				
			}
			
			//FilterAnnoncements filter
			if(filterAnnoncements){				
				filters.add('BlogPublished');
				filters.add('BlogNewComment');			
				hasWhere = true;				
			}
			
			//FilterProject filter
			if(filterProject){
				filters.add('TaskNew');
				filters.add('TaskAssigned'); 
				filters.add('TaskEdited');
				filters.add('TaskCompleted');				
				hasWhere = true;
				
			}										
			
		    if(hasWhere)
				feeds = [Select m.User__c, 
								m.User__r.Name, 
								m.Type__c, 
								m.Message__c, 
								m.CreatedDate 
						 from MiniFeed__c m
						 WHERE Type__c IN: filters
						 ORDER BY m.CreatedDate DESC LIMIT 30];
			else
				feeds = [Select m.User__c, 
								m.User__r.Name, 
								m.Type__c, 
								m.Message__c, 
								m.CreatedDate 
						 from MiniFeed__c m
						 ORDER BY m.CreatedDate DESC LIMIT 30];
				
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
        		if((FeedDateIterator.day() == now.day()) && (!TodayShow)){
        			TodayShow = true;
        			miniFeed.setFeedDateClass('miniFeedDate');
        			miniFeed.setFeedDateString('Today');						        			       
        		}else {
        			// Yesterday 
        			if ((FeedDateIterator.day() == ( now.day() - 1 )) && (!YesterdayShow )) {
        				YesterdayShow = true;
        				miniFeed.setFeedDateClass('miniFeedDate');
        				miniFeed.setFeedDateString('Yesterday');	        				
        			}else {
        				if ( FeedDateIterator.day() == now.day()){
        					miniFeed.setFeedDateClass('miniFeedDate_empty');
        					miniFeed.setFeedDateString(' ');
        				}else {					        			
	        				if ( dateAlreadyShown != FeedParsedDate ){      					
	        					String Month;
	        					if( FeedDateIterator.month() == 1)  { Month = 'January '; }
	        					if( FeedDateIterator.month() == 2)  { Month = 'February '; }
	        					if( FeedDateIterator.month() == 3)  { Month = 'March  '; }
	        					if( FeedDateIterator.month() == 4)  { Month = 'April '; }
	        					if( FeedDateIterator.month() == 5)  { Month = 'May '; }
	        					if( FeedDateIterator.month() == 6)  { Month = 'June '; }
	        					if( FeedDateIterator.month() == 7)  { Month = 'July '; }
	        					if( FeedDateIterator.month() == 8)  { Month = 'August '; }
	        					if( FeedDateIterator.month() == 9)  { Month = 'September '; }
	        					if( FeedDateIterator.month() == 10)  { Month = 'October '; }
	        					if( FeedDateIterator.month() == 11)  { Month = 'November '; }
	        					if( FeedDateIterator.month() == 12)  { Month = 'December '; }
	        					
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
                feedsList.add(miniFeed);    					
			}    					
 		}
    }
    
    /**
    *@return Integer
    */
    public Integer getMiniFeedCount(){
		return miniFeedCount;
	}
	
    /**
    *@param Integer
    */
    public void setMiniFeedCount(Integer count){
    	miniFeedCount = count;
    }
    
    /**
    * Inner class for miniFeed type
    *@class
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
        *@constructor
        */
      	public miniFeed(){	
      		
      	}
      	
      	/**
      	* Icon of the current type
      	*@return String
      	*/
        public String getTypeOfFeed() {
        	return TypeOfFeed;
		}
		
      	/**
      	* Icon of the current type
      	*@param String Type
      	*/
		public void setTypeOfFeed(String sTypeOfFeed){
            TypeOfFeed = sTypeOfFeed;
        }
		
		/**
		*@return String
		*/
      	public String getName() {
            return Name;
        }
        
		/**
		*@param String Name
		*/
        public void setName(String sName){
            Name = sName;
        }
        
		/**
		*@return String ID
		*/
        public String getUser() {
            return User;
        }
        
		/**
		*@param String ID
		*/
        public void setUser(String sUser){
            User = sUser;
        }
        
		/**
		*@return String
		*/
        public String getMessage() {
            return Message;
        }
        
		/**
		*@param String Message
		*/
        public void setMessage(String sMessage){
            Message = sMessage;
        }
       	
		/**
		*@return Datetime
		*/
        public Datetime getFeedDate() {
        	return FeedDate;
        }
        
		/**
		*@param Datetime
		*/
        public void setFeedDate(Datetime sFeedDate){
            FeedDate = sFeedDate;
        }  
        
		/**
		*@return Datetime
		*/
       	public String getFeedDateString() {
        	return FeedDateString;
	        		       
        }
        
		/**
		*@param String
		*/
        public void setFeedDateString(String sFeedDateString){
            FeedDateString = sFeedDateString;
        }  
        
		/**
		*@return String
		*/
        public String getFeedDateClass() {
        	return FeedDateClass;		        		       
        }
        
		/**
		*@param String
		*/
        public void setFeedDateClass(String sFeedDateClass){
            FeedDateClass = sFeedDateClass;
        }  
	}     

}
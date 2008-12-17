/**
*@author Yuri Alvarez @ 04/30/2008
*/
public class PeopleNewEditProfileController {

	public static PageReference PAGE_PROFILE = Page.PeopleProfileDisplay;

	public String param = System.currentPageReference().getParameters().get('id');

	/**
	*Constructor
	*@param ApexPages.StandardController controller
	*/
	public  PeopleNewEditProfileController(ApexPages.StandardController controller){
    	// Get Status		
		List<PeopleProfile__c> pList = [SELECT Id,  Status__c, StatusLastModifiedDate__c
                                        		FROM PeopleProfile__c
                                         		WHERE User__c =: UserInfo.getUserId()];
                                         		
		PeopleProfile__c p = new PeopleProfile__c();
		if (pList.size() > 0) {
			p = pList[0]; 
		}                       		
        if((p.Status__c != null) && (p.Status__c != '')){
        	showStatus = true;     
        } else {
         	showStatus = false;	
        }   
    }
	
	/**
    *Set parameter
    *@param String
    */
	public void setParam (String s){
		param = s;
	}

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
	
	// Profile Row
	PeopleProfile__c p = new PeopleProfile__c();
	
	
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
	*Get the profile picture
	*@return String picture
	*/
	public String getMyPicture(){
		String MyPictureId;
		PeopleProfile__c temp = new PeopleProfile__c();
		try{
			temp = [SELECT Picture__c                                              
                             FROM PeopleProfile__c
                         	 WHERE User__c =: UserInfo.getUserId()];
			 
		    if((temp.Picture__c == '') ||( temp.Picture__c == null )){ 
				MyPictureId = '';
			} else{
				MyPictureId = temp.Picture__c;
			} 
		} catch(Exception e) {
			MyPictureId = '';
		}
		return MyPictureId;
	}
	
	/**
	* Get the profile for current user
	*@return PeopleProfile__c user profile
	*/
	public PeopleProfile__c getMySidebarProfile(){
		
			PeopleProfile__c mySidebarProfile = [SELECT Id,
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
                                         		WHERE User__c =: UserInfo.getUserId() limit 1];
         	return mySidebarProfile;      
	}
	
	// boolean to control showing or not the status
	boolean showStatus;	
	
	
	/**
	* Return true if should show status
	*@return Boolean
	*/
	public boolean getShowStatus(){
		return showStatus;
	}
	
	/**
	*Get status
	*@return Status status
	*/
	public Status getStatus() {
    	Status sObj = new Status();
    	if((p.Status__c != null) && (p.StatusLastModifiedDate__c != null)){
          	sObj.setMessage(p.Status__c);
			sObj.setModified(p.StatusLastModifiedDate__c);
    	}
		return sObj;       
	}
	
	/**
	*Class Status
	*@author Yuri Alvarez
	*/
	public class Status {
		String Message;
		String Modified = '';		
		
		/**
		*Set status message
		*@param String message
		*/
		public void setMessage(String sMessage){                
                Message = sMessage;                
        }
        
        /**
		*Get status message
		*@return String message
		*/
        public String getMessage() {
	            return Message;
		}
		
		/**
		*Set message's modification date
		*@param Datetime
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
        *Return a String containing the time since the last status modification
        *@return String
        */
        public String getModified() {
			return Modified;
		}
	}
	
 	// Error string to show the mistake.
    public String error = '';
    
    
    /**
    *Return error message
    *@return String error message
    */
    public String getError(){
        return error;
    }
    
    PeopleProfile__c pProfile = null;
    
    /**
    *Get profile
    *@return PeopleProfile__c
    */
    public PeopleProfile__c getPProfile(){
    	if((pProfile.Facebook__c == null) || (pProfile.Facebook__c == ' ')){
    		pProfile.Facebook__c = 'http://www.new.facebook.com/profile.php?id=';
    	}
    	if((pProfile.Delicious__c == null) || (pProfile.Delicious__c == ' ')){
    		pProfile.Delicious__c = 'http://delicious.com';
    	}
    	if((pProfile.Linkedin__c == null) || (pProfile.Linkedin__c == ' ')){
    		pProfile.Linkedin__c = 'http://www.linkedin.com/in/';
    	}
    	return pProfile;
    }
      
    /**
    *Edit people profile
    */
    public void getPeopleProfile() {
	        newUser = [Select Id, 
	        					Name,
	        					Street,
	        					State, 
	        					PostalCode, 
	        					Phone,
	        					MobilePhone, 
	        					LastName,
	        					Title,
	 							FirstName, 
	 							Fax,  
	 							Email, 
	 							Division, 
	 							Department, 
	 							Country,
	 							City,		(SELECT Id,
						                        Name,
						                        YahooIM__c,
						                        Skype__c,
						                      	Messages__c,
						                        HomePageUrl__c,
						                        Gtalk__c,
						                        Facebook__c,
								  				Delicious__c,
								  				Aol__c,
								  				AboutMe__c,
								  				Linkedin__c,
								  				changeHistory__c,
								  				changeHistoryDate__c
	                FROM People__r) From User u
	                WHERE u.Id =: param];
	    			pProfile = newUser.People__r[0];               
	}  
	        
	                    
    /**
    *Save the new Profile
    *@return PageReference
    */
    public PageReference savePeopleProfile() {
		if (UserInfo.getUserId() == newUser.Id){
			upsert pProfile;
			PAGE_PROFILE.setRedirect(true);
			return PAGE_PROFILE;
		}else{
			getPeopleProfile();   
			error = 'You do not have permission to modify the data of Profile'; 
			return null;    	 	
		}
    }

    /**
    *Cancel the new Profile
    *@return PageReference
    */ 
    public PageReference cancelProfile() {
     	getPeopleProfile();     	 
        return null;
    }
	
 	User newUser;
	
	/**
 	*Set New User 
 	*/
   	public void init() {
        newUser = [
                SELECT Id,
                Name, Email,
                LastName, FirstName,
                Title, CompanyName,
                Department, Division,
                Street, State, Phone,
                City, MobilePhone,
                Country, PostalCode
                FROM User
                WHERE Id =:param];                           
    }
                
	/**
    *Get user for show details
    *@return User
    */
    public User getNewUser() {
        return newUser;
    }
    
     /**
	*Redirect to url
	*@param String url
	*@return PageReference 
	*/
    public PageReference forwardTo (String url) {
		PageReference page1 = new pageReference(url);
		page1.setRedirect(true);
		return page1;
	}
    
}
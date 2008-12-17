/**
*@author Martin Prado @ 08/06/2008
*/
public class TeamsSidebarProfileController {
	
	PeopleProfile__c profile = null;
	
	// Status Obj
    Status sObj = new Status();
        	
	/**
	* Costructor
	*/
	public TeamsSidebarProfileController(){}

	/**
	* Get people profile for current user
	*@return PeopleProfile__c
	*/
	public PeopleProfile__c getPeopleProfile(){
		if(profile == null) {
			List<PeopleProfile__c> profileList = [SELECT 	Id,
									 						User__c,
									 						Status__c,
									 						StatusLastModifiedDate__c,
									 						User__r.Name,
									                    	User__r.FirstName,
									                    	User__r.LastName,
									                        User__r.Title,
									                        Picture__c,
									                        (Select Id From Attachments),
									                        CreatedDate                                                
									                        FROM PeopleProfile__c
									                        WHERE User__c =: UserInfo.getUserId()];
		    if(profileList.size() > 0) 
		    	profile = profileList[0];
		    else
		    	profile = new PeopleProfile__c();
		}
		return profile;	
	}
		
	/**
	*@return String time
	*/	
	public String getCurrentTime(){
		Datetime now = (System.now()).addHours(7);
		String s1 = now.format('yyyy-MM-dd');
		String s2 = now.format('HH:mm:ss.SSS');
		String dateString = s1 + 'T' + s2 + 'Z';
		return dateString;
	}
	
	/**
	* Edit user status
	*/
	public void EditStatus(){
		List<PeopleProfile__c> p = [SELECT 	Id, 
											User__c,	
											Status__c, 
											StatusLastModifiedDate__c
                        			FROM PeopleProfile__c
                        			WHERE User__c =: UserInfo.getUserId()];
        if (p.size() > 0) {
			p[0].Status__c = sObj.Message;
			p[0].StatusLastModifiedDate__c = System.now();
			update p[0];
			profile = p[0];
        }
	}
	
	/**
	* Returns user current avatar
	*@return String
	*/
	public String getMyPicture(){
		String MyPictureId;
		PeopleProfile__c p = null;
		try{
			p = getPeopleProfile();
		    if((p.Picture__c == '') ||( p.Picture__c == null )){ 
				MyPictureId = null;
			} else{
				MyPictureId = p.Picture__c;
			} 
		} catch(Exception e) {
			MyPictureId = null;
		}
		return MyPictureId;
	}
	
	/**
	* Retruns profile for current user
	*@return PeopleProfile__c
	*/
	public PeopleProfile__c getMySidebarProfile(){
        return getPeopleProfile();       
	}
	

	/**
	*@return Boolean
	*/
	public boolean getShowStatus(){		
		PeopleProfile__c p = getPeopleProfile();
		if((p.Status__c != null) && (p.Status__c != '')){
			return true;     
		}else{
			return false;	
		}
	}
		
	/**
	* Returns status for current user profile
	*@return Status
	*/
	public Status getStatus() {
	    PeopleProfile__c p = getPeopleProfile();
	    
    	if((p.Status__c != null) && (p.StatusLastModifiedDate__c != null)){
          	sObj.setMessage(p.Status__c);
			sObj.setModified(p.StatusLastModifiedDate__c);
    	}else if ((p.Status__c == null)){
    		sObj.setMessage('is ');        		
    	}
		return sObj;       
	}
	
	/**
	* Class Status
	*/
	public class Status {
		
		String Message;
		String Modified = '';		
		
		/**
		*@param String message
		*/
		public void setMessage(String sMessage){                
            Message = sMessage;                
        }
        
        /**
        *@return String
        */
        public String getMessage() {
            return Message;
		}
		
		/**
		*@param Datetime modified
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
							if(temp < 60){
								updateMessage = 'Updated right now';
							}													
						} else {			
							if(temp == 1){
								updateMessage = 'Updated ' + temp + ' minute ago';
							}else if(temp < 0){
								updateMessage = 'Updated ' + (60 - (temp*-1)) + ' minutes ago';
							}else{
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
        *@return String modified
        */
        public String getModified() {
        	return Modified;
		}
	}
	
	// Get people subscriptions Info 
    public Integer countImSubscribedTo = 0;
    public Integer countSubscribedToMe = 0;
    
    /**
    * Returns show suscribe
    *@return Boolean
    */
    public boolean getShowSubscribedPeople(){
    	if(getCountSubscribedToMe() > 0 || getCountImSubscribedTo() > 0)
    		return true;
    	else
    		return false;
    }    
    
    /**
    *@return Integer
    */
    public Integer getCountSubscribedToMe(){
    	List<PeopleSubscription__c> subscriptionInfo = new List<PeopleSubscription__c>();
    	subscriptionInfo = [Select p.Id, p.Subscriber__c, p.Person__c From PeopleSubscription__c p where p.Person__c =: UserInfo.getUserId()];
    	countSubscribedToMe = subscriptionInfo.size();
    	return countSubscribedToMe;
    }
    
    /**
    *@return Integer
    */
    public Integer getCountImSubscribedTo(){
    	List<PeopleSubscription__c> subscriptionInfo = new List<PeopleSubscription__c>();    	
    	subscriptionInfo = [Select p.Id, p.Subscriber__c, p.Person__c From PeopleSubscription__c p where p.Subscriber__c =: UserInfo.getUserId()];
    	countImSubscribedTo = subscriptionInfo.size();
    	return countImSubscribedTo;
    }
    
}
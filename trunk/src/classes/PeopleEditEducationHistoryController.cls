/**
*@author Martin Prado @ 06/24/2008
*/
public class PeopleEditEducationHistoryController {
	
	//Search Result Page 
    private static PageReference PEOPLE_SEARCH_RESULTS_PAGE = Page.PeopleKeywordSearchResults;
    
    //Search Object Initialization
    PeopleSearch peopleSearchObj = new PeopleSearch();    
    
	/**
	* Constructor
	*/
	public PeopleEditEducationHistoryController(){
		// If id is not empty
    	if (param != null){
    		isNewRecord = false;
    		getEducationHistory(param);
    	} else {
    		isNewRecord = true;    		
    		ed = new EducationItemObj();
    		School = new School__c();
    	}
    	
	}    
    
    /**
    * Get PeopleSearch instance
    *@return PeopleSearch peopleSearchObj
    */
    public PeopleSearch getPeopleSearchObj (){
        return peopleSearchObj;
   	}
        
    /**
    * Forward to search result page
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
	*@author Martin Prado
	*/
	public class PeopleSearch {
        String Keyword;       

        /**
        *@return keyword
        */
        public String getKeyword() {
                return Keyword;
        }

        /**
        *@param Keyword key
        */
        public void setKeyword(String Keyword) {
                this.Keyword = Keyword;
        }        
	}
	
	// Profile Row
	PeopleProfile__c p = new PeopleProfile__c();
	
	/**
	* Get current time (apox)
	*@return String dateString
	*/	
	public String getCurrentTime(){
		Datetime now = (System.now()).addHours(7);
		String s1 = now.format('yyyy-MM-dd');
		String s2 = now.format('HH:mm:ss.SSS');
		String dateString = s1 + 'T' + s2 + 'Z';
		return dateString;
	}
	
	/**
	* Get my picture
	*@return String
	*/
	public String getMyPicture(){
		String MyPictureId;
        if(p.Picture__c == '' || p.Picture__c == null){                	                                          	 
	     			MyPictureId = '';
		} else{
			MyPictureId = p.Picture__c;
		} 
		return MyPictureId;
	}
	
	/**
	* Get people profile for current user
	*@return PeopleProfile__c profile
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
	*@return Boolean
	*/
	public boolean getShowStatus(){
		return showStatus;
	}
		
	/**
	* Get user status
	*@return Status
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
	*@author Martin Prado
	*/
	public class Status {
		
		String Message;
		String Modified = '';		
		
		/**
		* Set status message
		*@param String message
		*/
		public void setMessage(String sMessage){                
            Message = sMessage;                
        }
        
        /**
        * Get status message
        *@return String
        */
        public String getMessage() {
            return Message;
		}
		
		/**
		* Set status modify
		*@param Datetime date modify
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
				If (temp <= 1 ){
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
        * Get status date modify
        *@return String date
        */
        public String getModified() {
        	return Modified;
		}
		
	}
	
    // Error display    
    String error = '';
    
    /**
    * Returns error message
    *@return String
    */
    public String getError(){
    	return error;
    } 
    
    // Get id from work experience item
    String param = System.currentPageReference().getParameters().get('id');
    
    /**
    * Set work exp item id
    *@param String param
    */
    public void setParam(String p){
    	param = p;
    }
    
    // employer Row
    School__c School;
    
    // Employment History Item row
    EducationHistory__c educationItem = new EducationHistory__c();
    
    // Custom object 
    EducationItemObj ed;
    
    /**
    * Returns education history item
    *@return EducationItemObj
    */
    public EducationItemObj getEd(){
    	return ed;
    }
    
    /**
    * Set education history item
    *@param EducationItemObj
    */
    public void setEd(EducationItemObj e){
    	ed = e;
    } 
    
    /**
    * Set eudaction item
    *@param EducationHistory__c ed item
    */
    public void setEducationItem(EducationHistory__c eh){
    	educationItem = eh;
    }
    
    // Boolean to look if the record is new    
    public boolean isNewRecord;
    
    /**
    * Get bool is new work exp item
    *@return Boolean isNewRecord
    */
    public boolean getIsNewRecord(){
    	return isNewRecord;
    }
    
    /**
    * Set bool is new work exp item
    *@param Boolean b
    */    
    public void setIsNewRecord(Boolean b){
    	isNewRecord = b;
    } 
    
    /**
    * Get school item
    *@return School__c
    */
    public School__c getSchool(){
    	return School;
    }
    
	/**
	* Read education history item by id
	*@param String education item id
	*/
	public void getEducationHistory(String p){
    	  	educationItem = [Select 
    	  						Id,
	    	  					School__c, 
	    	  					School__r.Name,
	    	  					School__r.Count__c,
	    	  					FieldsOfStudy__c, 
	    	  					Degree__c, 
	    	  					DateAttendedTo__c, 
	    	  					DateAttendedFrom__c, 
	    	  					AdditionalNotes__c, 
	    	  					User__c,
	    	  					Activities__c From EducationHistory__c Where Id =: p];
	        
	        School = [select Name, Count__c,
									Id from School__c 
									where Id =: educationItem.School__c];
			
			ed = new EducationItemObj();
			ed.setSchool(educationItem.School__r.Name);
	   		ed.setFieldsOfStudy(educationItem.FieldsOfStudy__c);
	   		ed.setDegree(educationItem.Degree__c);
	   		ed.setAdditionalNotes(educationItem.AdditionalNotes__c);
	   		ed.setActivities(educationItem.Activities__c);
	   		ed.setAttendedTo(educationItem.DateAttendedTo__c);
	   		ed.setAttendedFrom(educationItem.DateAttendedFrom__c);	
	}
	
	
	/**
	* Do all the magic to set count and things like these
	*@return Boolean
	*/
	public boolean getDbOperation() {
		
		School__c auxSchool;	
		// Check if the School exists exists
		if(ed.School != educationItem.School__r.Name){
			// Get the list of matching Employers 
			List<School__c> el = [select Name, Count__c,
									Id from School__c 
									where Name =: ed.School];
			if(el.size() == 0){
				// Create new School and set first count
				auxSchool = new School__c();
				auxSchool.Name = ed.School;
				auxSchool.City__c = ed.SchoolLocationCity;
				auxSchool.State__c = ed.SchoolLocationState;
				auxSchool.Count__c = 1;
				
				insert auxSchool;
				
				//Check if is new kid on the block
				if(!isNewRecord){
					// Decrease the count of the other employer 
					School__c oldSchool = [select Name, Count__c,
										Id from School__c 
										where Id =: School.Id];
										
					Double oldCount = oldSchool.Count__c;
					oldSchool.Count__c = oldCount - 1;
					upsert oldSchool;
				}
			} else {
				// If the record is new, and the school exists , increase the count
				if(isNewRecord){
					auxSchool = [select Name, Count__c,
									Id from School__c 
									where Id =: el[0].Id];
					
					Double auxCount = auxSchool.Count__c;
					auxSchool.Count__c = auxCount + 1;
					upsert auxSchool; 
				}			
			}
		} else {
			// Set the aux with the old record		
			auxSchool = School;
		}
		
		String fakeDateTo = String.valueOf(ed.AttendedTo)+ '.0';
		String fakeDateFrom = String.valueOf(ed.AttendedFrom)+ '.0';
		
		// set te new values
		educationItem.School__c = auxSchool.Id;
		educationItem.FieldsOfStudy__c = ed.FieldsOfStudy;
		educationItem.Degree__c = ed.Degree; 
		educationItem.AdditionalNotes__c = ed.AdditionalNotes;
		educationItem.Activities__c = ed.Activities;
		educationItem.DateAttendedTo__c = Double.valueOf(fakeDateTo);
		educationItem.DateAttendedFrom__c = Double.valueOf(fakeDateFrom);
		
		return true;
	}
	
	
	/**
	* Save education history
	*@return PageReference pageRef
	*/
	public PageReference save() {	
		// Check if the user are the owner of the record
		boolean isCurrentUser;
		
		if(isNewRecord){	
			educationItem.User__c = UserInfo.getUserId();
			isCurrentUser = true;
		} else {
			if(educationItem.User__c == UserInfo.getUserId()){
				educationItem.User__c = UserInfo.getUserId();
				isCurrentUser = true;
			} else {				
				isCurrentUser = false;
			}
		}
		String URL;
		
		PageReference pageRef = Page.PeopleProfileDisplay;
		pageRef.setRedirect(true);
		
		if(isCurrentUser){
			getDbOperation();
			
			if(isNewRecord){			
				insert educationItem;
			} else {
				upsert educationItem;
			}
			return pageRef;
		} else {
			error = 'You are not the owner of this Education History Item '; 
			return null;
		}
	}
	
	/**
	* Delete education history
	*@return PageReference
	*/
	public PageReference remove(){		
		boolean isCurrentUser;
		
		if(educationItem.User__c == UserInfo.getUserId()){
			educationItem.User__c = UserInfo.getUserId();
			isCurrentUser = true;
		} else {				
			isCurrentUser = false;
		}
	
		if(isCurrentUser){
		
			delete educationItem;
			Double oldCount = School.Count__c;
			School.Count__c = oldCount - 1;
			upsert School;
			
			PageReference URL = Page.PeopleProfileDisplay;
			URL.setRedirect(true);
					
			return URL;
		} else {
			error = 'You are not the owner of this Education History Item '; 
			return null;
		}		
	}
	
	/**
	* Save and add Another
	*@return PageReference
	*/
	public PageReference saveAndAddAnother() {
		// Check if the user are the owner of the record
		boolean isCurrentUser;
		
		if(isNewRecord){	
			educationItem.User__c = UserInfo.getUserId();
			isCurrentUser = true;
		} else {
			if(educationItem.User__c == UserInfo.getUserId()){
				educationItem.User__c = UserInfo.getUserId();
				isCurrentUser = true;
			} else {				
				isCurrentUser = false;
			}
		}		
		PageReference pageRef = Page.PeopleEditEducationHistory;
		pageRef.setRedirect(true);
		
		if(isCurrentUser){
			getDbOperation();
			
			if(isNewRecord){
				insert educationItem;
			} else {
				upsert educationItem;
			}
			return pageRef;
		} else {
			error = 'You are not the owner of this Education History Item '; 
			return null;
		}				
	}	
	
    /**
    * Cancel link forward to profile view
    *@return PageReference
    */
    public PageReference cancel(){
		PageReference page1 = Page.PeopleProfileDisplay;
		page1.setRedirect(true);		
		return page1;
	}
	
	/**
	* Class EducationItemObj
	*@author Martin Prado
	*/
    public class EducationItemObj {
    	
    	String FieldsOfStudy;
    	String Degree;
    	String AdditionalNotes;
    	String Activities;
    	// School Data
    	String School;
    	String SchoolLocationCity;
    	String SchoolLocationState;
    	// dates
    	Integer AttendedTo;
    	Integer AttendedFrom;
     
	 	// Getters / setters 
	 	
	 	/**
	 	* Get school location state
	 	*@return String
	 	*/
	 	public String getSchoolLocationState() {
	  		return SchoolLocationState;
	  	}
	  	
	  	/**
	  	* Set school location state
	  	*@param String
	  	*/
	  	public void setSchoolLocationState(String SchoolLocationState) {
	  	 	this.SchoolLocationState = SchoolLocationState;
	  	} 	
	  	
	 	/**
	 	* Get school location city
	 	*@return String
	 	*/
	 	public String getSchoolLocationCity() {
	  		return SchoolLocationCity;
	  	}
	  	
	  	/**
	  	* Set school location city
	  	*@param String location city
	  	*/
	  	public void setSchoolLocationCity(String SchoolLocationCity) {
	  	 	this.SchoolLocationCity = SchoolLocationCity;
	  	} 	
	 	
	 	/**
	 	* Get school name
	 	*@return String
	 	*/
	 	public String getSchool() {
	  		return School;
	  	}
	  	
	  	/**
	  	* Set school name
	  	*@param String
	  	*/
	  	public void setSchool(String School) {
	  	 	this.School = School;
	  	} 	  	
	  	
	  	/**
	  	* Get fields of study
	  	*@return String
	  	*/	 	
	 	public String getFieldsOfStudy() {
	  		return FieldsOfStudy;
	  	}
	  	
	  	/**
	  	* Set fields of study
	  	*@param String
	  	*/	  	
	  	public void setFieldsOfStudy(String FieldsOfStudy) {
	  	 	this.FieldsOfStudy = FieldsOfStudy;
	  	} 
	  	
	  	/**
	  	* Get degree
	  	*@return String
	  	*/
	  	public String getDegree() {
	  		return Degree;
	  	}
	  	
	  	/**
	  	* Set degree
	  	*@param String degree
	  	*/
	  	public void setDegree(String Degree) {
	  	 	this.Degree = Degree;
	  	} 
	  	
	  	/**
	  	* Get additional notes
	  	*@return String
	  	*/	  	
	  	public String getAdditionalNotes() {
	  		return AdditionalNotes;
	  	}
	  	
	  	/**
	  	* Set additional notes
	  	*@param String AdditionalNotes
	  	*/	  	
	  	public void setAdditionalNotes(String AdditionalNotes) {
	  	 	this.AdditionalNotes = AdditionalNotes;
	  	} 
	  	
	  	/**
	  	* Get activities
	  	*@return String activities
	  	*/	  	
	  	public String getActivities() {
	  		return Activities;
	  	}
	  	
	  	/**
	  	* Set activities
	  	*@param String activities
	  	*/
	  	public void setActivities(String Activities) {
	  	 	this.Activities = Activities;
	  	} 
	  	
	  	/**
	  	* Get attended to
	  	*@return Integer attended to
	  	*/
	  	public Integer getAttendedTo() {
	  		return AttendedTo;
	  	}
	  	
	  	/**
	  	* Set attended to
	  	*@param Double attended to
	  	*/	  	
	  	public void setAttendedTo(Double AttendedTo) {
	  	 	if(AttendedTo != null) {
	  	 		this.AttendedTo = AttendedTo.intValue();
	  	 	}
	  	} 
	  	
	  	/**
	  	* Get attended from
	  	*@return Integer attended from
	  	*/	  	
	  	public Integer getAttendedFrom() {
	  		return AttendedFrom;
	  	}
	  	
	  	/**
	  	* Set attended from
	  	*@param Double attended from
	  	*/	  	
	  	public void setAttendedFrom(Double AttendedFrom) {
	  	 	if (AttendedFrom != null) {
	  	 		this.AttendedFrom = AttendedFrom.intValue();
	  	 	}
	  	}    	
    }
    

	/**
	* Get states
	*@return List<SelectOption> states list
	*/    
    public List<SelectOption> getStates() {
  	 	List<SelectOption> options = new List<SelectOption>();
  	 	options.add(new SelectOption('ST','ST'));
  	 	options.add(new SelectOption('NY','NY'));
  	 	options.add(new SelectOption('DC','DC'));
  	 	options.add(new SelectOption('OK','OK'));
  	 	options.add(new SelectOption('EC','EC'));
  	 	options.add(new SelectOption('RC','RC'));  	 	
  	 	return options;
   	}	
    
    /**
    * Forward to
    *@param String url
    *@return PageReference page
    */
    public PageReference forwardTo (String url) {
		PageReference page = new pageReference(url);
		page.setRedirect(true);
		return page;
	}
	
}
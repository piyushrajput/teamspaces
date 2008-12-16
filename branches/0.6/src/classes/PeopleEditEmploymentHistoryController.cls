/**
*@author Yuri Alvarez @ 04-30-2008
*/
public class PeopleEditEmploymentHistoryController {
	
    private static PageReference PEOPLE_SEARCH_RESULTS_PAGE = Page.PeopleKeywordSearchResults;
    
    PeopleSearch peopleSearchObj = new PeopleSearch();    

	/**
	* Constructor
	*/
	public PeopleEditEmploymentHistoryController(){
		// If id is not empty
    	if (param != null){
    		isNewRecord = false;
			getEmploymentHistory(param);
    	} else {
    		isNewRecord = true;
    		em = new EmploymentItemObj();
    		Employer = new Employer__c();
    	}
	}
    
    /**
    * Get peopleSearchObj
    *@return PeopleSearch
    */
    public PeopleSearch getPeopleSearchObj (){
        return peopleSearchObj;
   	}
        
    /**
    * Forward to searhc result page
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
	
	PeopleProfile__c p = new PeopleProfile__c();
	
	/**
    * Get current time (aprox)
    *@return String current time
    */
	public String getCurrentTime(){
		Datetime now = (System.now()).addHours(7);
		String s1 = now.format('yyyy-MM-dd');
		String s2 = now.format('HH:mm:ss.SSS');
		String dateString = s1 + 'T' + s2 + 'Z';
		return dateString;
	}
	
	//####################################//
	// My Profile At Sidebar
	//####################################//
	
	/**
	* Get the profile picture
	*@return String picture
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
	* Get the profile for current user
	*@return PeopleProfile__c user profile
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

	//####################################//
	// My Sidebar Status
	//####################################//
	
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
	* Get status
	*@return Status status
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
        *Return a String containing the time since the last status modification
        *@return String
        */
        public String getModified() {
			return Modified;
		}		
	}
	
	//####################################//
	// WORK EXPERIENCE 
    //####################################//  
    
    
    String error = '';
    
    /**
    *Return error message
    *@return String error message
    */
    public String getError(){
    	return error;
    }
    
    // Get id from work experience item
    String param = System.currentPageReference().getParameters().get('id');
    
    /**
    *Set parameter
    *@param String
    */
    public void setParam(String p){
    	param = p;
    }
    
    // employer Row
    Employer__c Employer;
    
    // Employment History Item row
    EmploymentHistory__c employmentItem = new EmploymentHistory__c();
    
    // Custom object 
    EmploymentItemObj em;
    
    /**
    *Get Employment item
    *@return EmploymentItemObj
    */
    public EmploymentItemObj getEm(){
    	return em;
    }
    
    /**
    *Set Employment item
    *@param EmploymentHistory__c
    */
    public void setEmploymentItem(EmploymentHistory__c e){
    	employmentItem = e;
    } 
    
    // Boolean to look if the record is new
    public boolean isNewRecord;
    
    /**
    *Return true if record is new
    *@return Boolean
    */
    public boolean getIsNewRecord(){
    	return isNewRecord;
    }
    
    /**
    *Returns Employer Data
    *@return Employer__c
    */
    public Employer__c getEmployer(){
    	return Employer;
    }
    
    /**
    *Get month name
    *@param Integer month's number
    *@return String month's name
    */
	public String getMonthName(Integer monthNumber){
		String m;
		if(monthNumber == 1) 
			m = 'Jan';
		if(monthNumber == 2) 
			m = 'Feb';
		if(monthNumber == 3)
			m = 'Mar';
		if(monthNumber == 4) 
			m = 'Apr';
		if(monthNumber == 5)
			m = 'May';
		if(monthNumber == 6) 
			m = 'Jun';
		if(monthNumber == 7) 
			m = 'Jul';
		if(monthNumber == 8) 
			m = 'Aug';
		if(monthNumber == 9) 
			m = 'Sep';
		if(monthNumber == 10) 
			m = 'Oct';
		if(monthNumber == 11) 
			m = 'Nov';
		if(monthNumber == 12) 
			m = 'Dec';
		return m;
	}
	
	/**
    *Get month number
    *@param String month's name
    *@return Integer month's number
    */
	public Integer getMonthNumber(String monthName){
		Integer m;
		if(monthName == 'Jan') 
			m = 01;
		if(monthName == 'Feb') 
			m = 02;
		if(monthName == 'Mar') 
			m = 03;
		if(monthName == 'Apr') 
			m = 04;
		if(monthName == 'May') 
			m = 05;
		if(monthName == 'Jun') 
			m = 06;
		if(monthName == 'Jul') 
			m = 07;
		if(monthName == 'Aug') 
			m = 08;
		if(monthName == 'Sep') 
			m = 09;
		if(monthName == 'Oct') 
			m = 10;
		if(monthName == 'Nov') 
			m = 11;
		if(monthName == 'Dec') 
			m = 12;
		return m;
	}

	
	/**
	*Get Employment history 
	*@param String employment id
	*/
	public void getEmploymentHistory(String p){
	  	employmentItem = [Select 
  							Id,
	  						WorkedTo__c, 
	  						WorkedFrom__c, 
	  						User__c, 
	  						Position__c, 
	  						IsCurrentJob__c, 
	  						Employer__c,
	  						Employer__r.Name,
	  						Description__c 
	  						From EmploymentHistory__c 
							WHERE Id =: p];

        Employer = [select Name, Count__c,
								Id from Employer__c 
								where Id =: employmentItem.Employer__c];
		
		em = new EmploymentItemObj();
   		em.setEmployer(EmploymentItem.Employer__r.Name);
    	em.setTitle(EmploymentItem.Position__c);
    	em.setCurrentJob(EmploymentItem.IsCurrentJob__c); 
    	em.setDescription(EmploymentItem.Description__c);
    	em.setYearFrom((employmentItem.WorkedFrom__c).year());
    	em.setYearTo((employmentItem.WorkedTo__c).year());
    	em.setWorkedFromMonth(getMonthName((employmentItem.WorkedFrom__c).month()));
    	em.setWorkedToMonth(getMonthName((employmentItem.WorkedTo__c).month()));
	}
	
	
	
	/**
	*cancel command
	*@return PageReference reference to the redirected page
	*/
	public PageReference cancel(){
		PageReference page1 = Page.PeopleProfileDisplay;
		page1.setRedirect(true);		
		return page1;
	}
	
	// Save and add Another
	
	public boolean addAnother = false;
	
	/**
	*Remove an employment item
	*@return PageReference 
	*/
	public PageReference remove(){
		boolean isCurrentUser;
		if(employmentItem.User__c == UserInfo.getUserId()){
			employmentItem.User__c = UserInfo.getUserId();
			isCurrentUser = true;
		} else {				
			isCurrentUser = false;
		}
		if(isCurrentUser){
			delete employmentItem;
			Double oldCount = Employer.Count__c;
			Employer.Count__c = oldCount - 1;
			upsert Employer;
			PageReference URL = Page.PeopleProfileDisplay;
			URL.setRedirect(true);
			return URL;
		} else {
			error = 'You are not the owner of this Employment History Item '; 
			return null;
		}		
	}
	
	/**
	*if Employer exists then updates else create new Employer
	*@return Boolean
	*/
	public boolean getDbOperation(){
		Employer__c auxEmp;
		// Check if the employer exists
		if(em.Employer != EmploymentItem.Employer__r.Name){
			// Get the list of matching Employers 
			List<Employer__c> el = [select Name, Count__c,
									Id from Employer__c 
									where Name =: em.Employer];
			if(el.size() == 0){
				// Create new employer and set first count
				auxEmp = new Employer__c();
				auxEmp.City__c = em.EmployerLocationCity;
    			auxEmp.State__c = em.EmployerLocationState;
				auxEmp.Name = em.Employer;
				auxEmp.Count__c = 1;
				insert auxEmp;
				
				//Check if is new kid on the block
				if(!isNewRecord){
					// Decrease the count of the other employer 
					Employer__c oldEmp = [select Name, Count__c,
										Id from Employer__c 
										where Id =: Employer.Id];
										
					Double oldCount = oldEmp.Count__c;
					oldEmp.Count__c = oldCount - 1;
					upsert oldEmp;
				}
								
			} else {
				// If the record is new, and the employer exists , increase the count
				auxEmp = [select Name, Count__c,
									Id from Employer__c 
									where Id =: el[0].Id];
					
				if(isNewRecord){
					Double auxCount = auxEmp.Count__c;
					auxEmp.Count__c = auxCount + 1;
					upsert auxEmp;
				}			
			}
		} else {
			// Set the aux with the old record		
			auxEmp = Employer;
		}
		
		// Build dates to insert
		String wfs = em.YearFrom + '-' + getMonthNumber(em.WorkedFromMonth) + '-01 12:00:00';
		String wts = em.YearTo + '-' + getMonthNumber(em.WorkedToMonth) + '-01 12:00:00';
		
		// String to date
		Date workedFrom = Date.valueOf(wfs);
		Date workedTo = Date.valueOf(wts);
		
		// Check the Current Job
		if(em.CurrentJob){
			// first clean all the other checkboxes
			List<EmploymentHistory__c> employerChecks = [Select Id, IsCurrentJob__c From EmploymentHistory__c 
									WHERE IsCurrentJob__c = true];
			if(employerChecks.size() != 0 ){
				for(EmploymentHistory__c bool: employerChecks){
					bool.IsCurrentJob__c = false;
					upsert bool;
				}
			}
			User companySet = [Select CompanyName From User where Id =: UserInfo.getUserId()];
			companySet.CompanyName = em.Employer;
		}
		
		// set te new values
		//search me
		employmentItem.Position__c = em.Title;
		employmentItem.IsCurrentJob__c = em.CurrentJob;		
		employmentItem.Employer__c = auxEmp.Id;
		employmentItem.Description__c = em.Description;
		employmentItem.WorkedFrom__c = workedFrom;
		employmentItem.WorkedTo__c = workedTo;
		
		return true;
	}
	
	
	/**
	*Save current record and add new employment item
	*@return PageReference
	*/
	public PageReference saveAndAddAnother() {
		// Check if the user are the owner of the record
		boolean isCurrentUser;
		
		if(isNewRecord){	
			employmentItem.User__c = UserInfo.getUserId();
			isCurrentUser = true;
		} else {
			if(employmentItem.User__c == UserInfo.getUserId()){
				employmentItem.User__c = UserInfo.getUserId();
				isCurrentUser = true;
			} else {				
				isCurrentUser = false;
			}
		}
		
		PageReference URL = Page.PeopleEditEmploymentHistory;
		if(isCurrentUser){
			getDbOperation();
			
			if(isNewRecord){			
				insert employmentItem;
			} else {
				upsert employmentItem;
			}			
			URL.setRedirect(true);
			return URL;
		} else {
			error = 'You are not the owner of this Employment History Item '; 
			return null;
		}
	}	
	
	/**
	*Save command
	*@return PageReference
	*/
	public PageReference save() {	
		// Check if the user are the owner of the record
		boolean isCurrentUser;
		
		if(isNewRecord){	
			employmentItem.User__c = UserInfo.getUserId();
			isCurrentUser = true;
		} else {
			if(employmentItem.User__c == UserInfo.getUserId()){
				employmentItem.User__c = UserInfo.getUserId();
				isCurrentUser = true;
			} else {				
				isCurrentUser = false;
			}
		}
				
		PageReference URL = Page.PeopleProfileDisplay;
		
		if(isCurrentUser){
			getDbOperation();
			
			if(isNewRecord){			
				insert employmentItem;
			} else {
				upsert employmentItem;
			}
			URL.setRedirect(true);
			return URL;
		} else {
			error = 'You are not the owner of this Employment History Item '; 
			return null;
		}
	}
	
	
	/**
	*Redirect to url
	*@param String url
	*@return PageReference 
	*/
    public PageReference forwardTo (String url) {
		PageReference page = new pageReference(url);
		page.setRedirect(true);
		return page;
	}
	
	/**
	*Get months in a combo box
	*@return List<SelectOption>
	*/
	public List<SelectOption> getMonths() {
  	 	List<SelectOption> options = new List<SelectOption>();
  	 	options.add(new SelectOption('Jan','Jan'));
  	 	options.add(new SelectOption('Feb','Feb'));
  	 	options.add(new SelectOption('Mar','Mar'));
  	 	options.add(new SelectOption('Apr','Apr'));
  	 	options.add(new SelectOption('May','May'));
  	 	options.add(new SelectOption('Jun','Jun'));
  	 	options.add(new SelectOption('Jul','Jul'));
  	 	options.add(new SelectOption('Aug','Aug'));
  	 	options.add(new SelectOption('Sep','Sep'));
  	 	options.add(new SelectOption('Oct','Oct'));
  	 	options.add(new SelectOption('Nov','Nov'));
  	 	options.add(new SelectOption('Dec','Dec'));
  	 	return options;
   	}	
    
    /**
	*Class EmploymentItemObj
	*@author Yuri Alvarez
	*/
    public class EmploymentItemObj {
    	String Title;
    	Boolean CurrentJob; 
    	String Description;
    	Date workedTo;
    	Date workedFrom;
    	// Employer Data
    	String Employer;
    	String EmployerLocationCity;
    	String EmployerLocationState;
    	// Months
    	String WorkedFromMonth;
    	String WorkedToMonth;
    	// Year 
    	Integer YearFrom;
    	Integer YearTo;
	 
	 	/**
		*Get Employer location city
		*@return String
		*/
	 	public String getEmployerLocationCity() {
	  		return EmployerLocationCity;
	  	}
	  	
	  	/**
		*Set Employer location city
		*@param String
		*/
	  	public void setEmployerLocationCity(String EmployerLocationCity) {
	  	 	this.EmployerLocationCity = EmployerLocationCity;
	  	} 
	 	
	 	/**
		*Get Employer location state
		*@return String
		*/
	 	public String getEmployerLocationState() {
	  		return EmployerLocationState;
	  	}
	  	
	  	/**
		*Set Employer location state
		*@param String
		*/
	  	public void setEmployerLocationState(String EmployerLocationState) {
	  	 	this.EmployerLocationState = EmployerLocationState;
	  	} 
	 	
	 	/**
		*Get year from
		*@return Integer
		*/
	 	public Integer getYearFrom() {
	  		return YearFrom;
	  	}
	  	
	  	/**
		*Set year from
		*@param Integer
		*/
	  	public void setYearFrom(Integer YearFrom) {
	  	 	this.YearFrom = YearFrom;
	  	} 
	  	
	  	
	  	/**
		*Get year to
		*@return Integer
		*/
	  	public Integer getYearTo() {
	  		return YearTo;
	  	}
	  	
	  	/**
		*Set year to
		*@param Integer
		*/
	  	public void setYearTo(Integer YearTo) {
	  	 	this.YearTo = YearTo;
	  	} 
	 	
	 	/**
		*Get worked from month
		*@return String month
		*/
	  	public String getWorkedFromMonth() {
	  		return WorkedFromMonth;
	  	}
	  	
	  	
	  	/**
		*Set worked from month
		*@param String month
		*/
	  	public void setWorkedFromMonth(String WorkedFromMonth) {
	  	 	this.WorkedFromMonth = WorkedFromMonth;
	  	} 	
	  	
	  	/**
		*Get worked to month
		*@return String month
		*/
	  	public String getWorkedToMonth() {
	  		return WorkedToMonth;
	  	}
	  	
	  	/**
		*Set worked to month
		*@param String month
		*/  	
	  	public void setWorkedToMonth(String WorkedToMonth) {
	  	 	this.WorkedToMonth = WorkedToMonth;
	  	}  	
    	
    	/**
		*Set worked to date
		*@param Date
		*/
    	public void setworkedTo(Date sworkedTo){ 
                workedTo = sworkedTo;                
        }
        
        /**
		*Get worked to date
		*@return Date
		*/
        public Date getworkedTo() {
	            return workedTo;
		}
		
		/**
		*Set worked from date
		*@param Date
		*/
		public void setworkedFrom(Date sworkedFrom){                
                workedFrom = sworkedFrom;                
        }
        
         /**
		*Get worked from date
		*@return Date
		*/
        public Date getworkedFrom() {
	            return workedFrom;
		}
		
		/**
		*Set description
		*@param String description
		*/
    	public void setDescription(String sDescription){                
                Description = sDescription;                
        }
        
        /**
		*Get description
		*@return String
		*/
        public String getDescription() {
	            return Description;
		}
		
		
		/**
		*Set employer
		*@param String
		*/
		public void setEmployer(String sEmployer){                
                Employer = sEmployer;                
        }
        
        /**
		*Get employer
		*@return String
		*/
        public String getEmployer() {
	            return Employer;
		}
		
		/**
		*Set title
		*@param String
		*/
		public void setTitle(String sTitle){                
                Title = sTitle;                
        }
        
        /**
		*Get title
		*@return String
		*/
        public String getTitle() {
	            return Title;
		}
		
		/**
		*Set current job
		*@param Boolean is current job
		*/
		public void setCurrentJob(boolean sCurrentJob){                
                CurrentJob = sCurrentJob;                
        }
        
        /**
		*Get current job
		*@return Boolean is current job
		*/
        public boolean getCurrentJob() {
	            return CurrentJob;
		}
    }
    
    /**
    *Get states in a combo box
    *@return List<SelectOption> states
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
}
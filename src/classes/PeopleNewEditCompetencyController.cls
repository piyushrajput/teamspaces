/**
*@author Bruno Fagundez @ 06/09/2008
*/
public class PeopleNewEditCompetencyController {

	/**
	*Constructor
	*@param ApexPages.StandardController controller
	*/
	public  PeopleNewEditCompetencyController(ApexPages.StandardController controller){
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
	*@author Bruno Fagundez
	*/          
	public class PeopleSearch {
        String Keyword;       
		
		
		/**
        *Get keyword
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
	*@author Bruno Fagundez
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
	
    public static PageReference PAGE_PROFILE = Page.PeopleProfileDisplay;
    	
 	// Error string to show the mistake.
    public String error = '';
    
    
    /**
    *Return error message
    *@return String error message
    */
    public String getError(){
        return error;
    }
     
 	String userId = System.currentPageReference().getParameters().get('id');
 	
 	/**
 	*Set User id
 	*@param String 
 	*/
 	public void setUserId(String s){
 		userId = s;
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
                        WHERE id =: userId];                           
        }
                
    /**
    *Get New user for show details
    *@return User
    */
    public User getNewUser() {
        return newUser;
    }
    
    //############################################//   
  	//   USER COMPETENCIES
   	//############################################//
   	
   	// Boolean to look if the record is new
    
    public boolean isNewRecord;
    
    
    /**
    *Return true if record is new
    *@return Boolean
    */
    public boolean getIsNewRecord(){
    	return isNewRecord;
    }
        
    Competency__c newCompetency;
    
    
    /**
    *Create a new competency for user
    *@return Competency__c
    */
    public Competency__c getNewCompetency() {
   		if(newCompetency == null) 
   			newCompetency = new Competency__c();
    	return newCompetency;      
    }
    
    /**
    *Set new competency
    *@param Competency__c
    */
    public void setNewCompetency(Competency__c c){
    	newCompetency = c;
    }    
   	
    public String nameCompetency = '';
    
    
    /**
    *Get competency's name
    *@return String
    */
    public String getNameCompetency(){
        return nameCompetency;
    }
    
    /**
    *Set competency's name
    *@param String
    */
    public void setNameCompetency(String s){
    	nameCompetency = s;
    }
    
    public String returnRating = '';
    
    /**
    *Get return rating
    *@return String
    */
    public String getReturnRating(){
        return returnRating;
    }
    
  
    UserCompetencies__c newUserCompetency;
    
    /**
    *Return the user competency for show details
    *@return UserCompetencies
    */
    public UserCompetencies__c getNewUserCompetency() {
    	if(newUserCompetency == null) 
    		newUserCompetency = new UserCompetencies__c();       
		return newUserCompetency;
    }
    
    /**
    *Set user competency
    *@param UserCompetencies__c
    */    
    public void setNewUserCompetency(UserCompetencies__c uc){
    	newUserCompetency = uc;	
    }
    
    /**
    *Edit a competency
    */
    public void getCompetency() {
    	String param = System.currentPageReference().getParameters().get('id');
    	if (param == null){
    		newUserCompetency = null;
    		newCompetency = null;
    		nameCompetency = '';
    		isNewRecord = true;
    		returnRating = '5';	    		
    	}else{
    		isNewRecord = false;
    	  	newUserCompetency = [Select Name, Competency__c, Id, Rating__c,User__c, 
    	  						InterestedInProvidingAssistance__c, InterestedInLearning__c
								From UserCompetencies__c c
								WHERE c.Id =: param];
	        
	        returnRating = String.valueOf(newUserCompetency.Rating__c);
			newCompetency = [select Name, Count__c, 
									Id from Competency__c 
									where Id =: newUserCompetency.Competency__c];
									
			nameCompetency = newCompetency.Name;
    	}
    }
    
    public static PageReference EDIT_COMPETENCY = Page.PeopleEditCompetency;
    
    
    /**
	*Save current record and add new competency
	*@return PageReference
	*/
    public PageReference saveAndNewCompetency() {
		PAGE_PROFILE = EDIT_COMPETENCY;
		saveCompetency();
		return EDIT_COMPETENCY;
	}
        
   	
   	/**
	*Save the new competency
	*@return PageReference
	*/
    public PageReference saveCompetency() {
    	Savepoint sp = Database.setSavepoint();
		// try catch		
		try {	
			// check if exist a competency whith the name edited
			List<Competency__c>  auxCompetency ;
			auxCompetency  =  [Select c.SystemModstamp, 
									c.Scale__c, 
									c.OwnerId, 
									c.Name,									
									c.LastModifiedDate, 
									c.LastModifiedById,									
									c.IsDeleted, 
									c.CreatedDate, 
									c.CreatedById, 
									c.Count__c From Competency__c c
									 where Name =: newCompetency.Name];
			// if not exist
			if (auxCompetency.size() == 0){
				//create a new competency whith the new name
				Competency__c newComp = new Competency__c() ;
				newComp.Name = newCompetency.Name;			
				newComp.Count__c = 1;
				insert newComp;
				if(nameCompetency != ''){
					if (UserInfo.getUserId() == newUserCompetency.User__c){
						// -1 count old competency
						newCompetency.Count__c = newCompetency.Count__c - 1;
						newCompetency.Name = nameCompetency; 
						upsert newCompetency;	
					}
				}
				//set the id of the new competency			
				newUserCompetency.Competency__c = newComp.Id;
				newUserCompetency.User__c = UserInfo.getUserId();
				upsert newUserCompetency;	
					
			}else{
				if(nameCompetency != ''){
					if (UserInfo.getUserId() == newUserCompetency.User__c){							
						// if the id of the competencies are the same just upsert
						if(auxCompetency[0].Id == newCompetency.Id){
							upsert newUserCompetency;	
						}else{ 
							// if the id of the competencies are differents
							// -1 count old competency
							newCompetency.Count__c = newCompetency.Count__c - 1;		
							newCompetency.Name = nameCompetency;							
							upsert newCompetency;		
							//set the count + 1 of the new competency
							auxCompetency[0].Count__c = auxCompetency[0].Count__c + 1;
							upsert auxCompetency[0];	
							// check if exist a UserCompetency of the User whith the same Competency
							List<UserCompetencies__c>  auxUserCompetency ;
							auxUserCompetency  =   [Select Name, Competency__c, Id, Rating__c
									From UserCompetencies__c c
									WHERE User__c =: UserInfo.getUserId() and Competency__c =: auxCompetency[0].Id];
							// if not exist				
							if (auxUserCompetency.size() == 0){
						
								newUserCompetency.Competency__c = auxCompetency[0].Id;
								upsert newUserCompetency;	
							}else{
								Database.rollback(sp);	
								error = ' The User already have a competency with that name '; 
								return null;
							}
						}
					}else{
						Database.rollback(sp);	
					 	error = 'You do not have permission to modify the data of competency'; 
					 	return null;
					}	
				}else{
					//set the count + 1 of the new competency
					auxCompetency[0].Count__c = auxCompetency[0].Count__c + 1;
					upsert auxCompetency[0];	
					// check if exist a UserCompetency of the User whith the same Competency
					List<UserCompetencies__c>  auxUserCompetency ;
					auxUserCompetency  =   [Select Name, Competency__c, Id, Rating__c
							From UserCompetencies__c c
							WHERE User__c =: UserInfo.getUserId() and Competency__c =: auxCompetency[0].Id];
					// if not exist	
					if (auxUserCompetency.size() == 0){
						//create a newuserCompetency						
						UserCompetencies__c newUserComp = new UserCompetencies__c() ;
						newUserComp.Rating__c = newUserCompetency.Rating__c;
						newUserComp.Competency__c = auxCompetency[0].Id; 
						newUserComp.User__c = UserInfo.getUserId();
						newUserComp.InterestedInProvidingAssistance__c = newUserCompetency.InterestedInProvidingAssistance__c;										
						newUserComp.InterestedInLearning__c = newUserCompetency.InterestedInLearning__c;										
						insert newUserComp;	
					}else{ 
					 	Database.rollback(sp);	
					 	error = ' The User already have a competency with that name '; 
					 	return null;
					}														
				}
			}
			PAGE_PROFILE.setRedirect(true);
			return PAGE_PROFILE;
		}catch (Exception e){	
		   	Database.rollback(sp);	
		    getCompetency();	
		 	error = ' Rating must be a number between 0 and 10'; 
			return null;			
		}
    }

    /**
    *Cancel the new competency
    *@return PageReference
    */ 
    public PageReference cancelCompetency() {
		error = '';       
 	  	getCompetency();      
        return null;
    }

	String userCompId = System.currentPageReference().getParameters().get('id');
	
	
	/**
	*Set user's competency id
	*@param String competency id
	*/
	public void setUserCompId(String s){
		userCompId = s;
	}
	
	/**
	*Delete competency
	*@return PageReference
	*/
    public PageReference deleteCompetency() {
    	// try catch		
		try {	
	   		if (UserInfo.getUserId() == newUserCompetency.User__c){
				String idComp;
		        UserCompetencies__c temp = [SELECT Id ,Competency__c
		                                                FROM UserCompetencies__c
		                                                WHERE Id =: userCompId];
		        idComp = temp.Competency__c;
		        delete temp;   
		       	//the count of the competency -1
		       	Competency__c newTempCompetency = [select Name, Count__c, 
											Id from Competency__c 
											where Id =: idComp];
				newTempCompetency.Count__c = newTempCompetency.Count__c - 1;
				upsert newTempCompetency;
				PAGE_PROFILE.setRedirect(true);
		       return PAGE_PROFILE;
	   		}else{
   				error = 'You do not have permission to modify the data of competency'; 
				return null;
	   		}	   		
	    } catch (Exception e) {
			error = ' The Competency cannot  be deleted'; 
			return null;
		}
    }	
    
    /**
    *cancel command
    *@return PageReference
    */
	public PageReference cancel(){
		PageReference page1 = Page.PeopleProfileDisplay;
		page1.setRedirect(true);
		return page1;
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
/**
*@author Sebastian Duclosson @ 9-11-2008
*/
public with sharing class PeopleProfileTeamWidgetController {
	// User Id (to show all data)
	Id USERID;
	
	/**
	*@Constructor
	*/
	public PeopleProfileTeamWidgetController(){
		if(System.currentPageReference().getParameters().get('id') == null){
			USERID = UserInfo.getUserId();			
		} else {
			USERID = System.currentPageReference().getParameters().get('id');
		}
	}

	/**
	*@param String UserId
	*/
	public void setProfileUserId(string sUserid){
		USERID = sUserid;
	}
	
	/**
	*@return Id
	*/
	public Id getProfileUserId(){
		return USERID;
	}
	
	
	/**
	*@return String name
	*/
	public String getProfileUserName(){
		List<User> temp;
		temp = [SELECT Name from User WHERE Id =: USERID];
		return temp[0].Name;
	}
	
	//####################################//
	// Return list of teamspaces of this user
    //####################################//
    
    public String teamsBullet = '';
    
	/**
	*@return String bullet
	*/
    public String getTeamsBullet(){
        return teamsBullet;
    }
    
    Integer teamspacesSize = 0;
    
    /**
    *Size of teamspaces list
    *@return Integer
    */
    public Integer getTeamspacesSize(){
    	return teamspacesSize;
    }	
    
	/**
	* Return a list of Teamspaces
	*@return List<TeamMember>
	*@exception
	*/
    public List<TeamMember> getTeamspaces() {
    	
    	List<TeamMember__c> temp = new List<TeamMember__c>(); 
    	List<TeamMember> TeamspaceMembers = new List<TeamMember>();
    	
    	try{
	    	temp =  [Select s.Team__r.Id, s.Team__r.Name,
		    			Team__r.Description__c, Team__r.CreatedDate 
		                From TeamMember__c s
		                WHERE s.User__c =: USERID and s.Team__r.Name != '' LIMIT 5];
    	
    		for(TeamMember__c TeamspaceMember : temp){
	    		TeamMember TeamspaceMemberObj = new TeamMember();
	    		TeamspaceMemberObj.setId(TeamspaceMember.Team__r.Id);
			 	TeamspaceMemberObj.setName(TeamspaceMember.Team__r.Name);			 
			 	TeamspaceMemberObj.setDescription(TeamspaceMember.Team__r.Description__c);
				TeamspaceMemberObj.setCreatedDate(TeamspaceMember.Team__r.CreatedDate);
				TeamspaceMembers.add(TeamspaceMemberObj);		
    		}
        
        	teamspacesSize = temp.size();
        	
	        if(temp.size() > 1){        	
	        	teamsBullet = ' - ';
	        	return TeamspaceMembers;
	        }else{ 
	         	return TeamspaceMembers; 
	        }
	        
    	} catch(Exception e){
    		return null;
    	}
    }
    
    /**
    * Inner class for TeamMember type
    *@class
    */
    public class TeamMember {
    	
    	Id Id;
    	String Name;
    	String Description;
    	DateTime CreatedDate;
       	String CreatedDateCorrectFormat;
       	String monthString;
        
		/**
		*@param Id
		*/
    	public void setId(Id sId){
        	Id = sId;
        }
        
		/**
		*@return String
		*/
        public String getId() {
	    	return Id;
		}
		
		/**
		*@param String
		*/
		public void setName(String sName){
        	Name = sName;
        }
        
		/**
		*@return String
		*/
        public String getName() {
	    	return Name;
		}
		
		/**
		*@param String
		*/
		public void setDescription(String sDescription){
            Description = sDescription;
        }
        
		/**
		*@return String
		*/
        public String getDescription() {
            return Description;
		}
		
		/**
		* Create a string width the date of created
		*@param DateTime CreatedDate
		*/
		public void setCreatedDate(DateTime sCreatedDate){
			Integer day = sCreatedDate.day();
		 	Integer month = sCreatedDate.month();
		 	Integer year = sCreatedDate.year();
		 	
		 	if (month == 1){
	 			monthString = 'Jan';
		 	}
		 	if (month == 2){
	 			monthString = 'Feb';
		 	}
		 	if (month == 3){
	 			monthString = 'Mar';
		 	}
		 	if (month == 4){ 
	 			monthString = 'Apr';
		 	}	
		 	if (month == 5){
	 			monthString = 'May';
		 	}	
		 	if (month == 6){
	 			monthString = 'Jun';
		 	}	
		 	if (month == 7){
	 			monthString = 'Jul';
		 	}	
		 	if (month == 8){
	 			monthString = 'Aug';
		 	}	
		 	if (month == 9){
	 			monthString = 'Sep';
		 	}	
		 	if (month == 10){
	 			monthString = 'Oct';
		 	}	
		 	if (month == 11){
	 			monthString = 'Nov';
		 	}	
		 	if (month == 12){
	 			monthString = 'Dec';
		 	}	
		 	
		 	CreatedDateCorrectFormat = '' + monthString + ' ' + year;			 	
   		}
   		
		/**
		*@return String
		*/
   		public String getCreatedDate() {
            return CreatedDateCorrectFormat;
		}
     
    }
	
}
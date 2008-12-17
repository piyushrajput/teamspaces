/**
*@author Bruno Fagundez @ 6-9-2008
*/
public with sharing class TeamMembersWidgetController {
	// Get Team Id Attribute
	String team;
	
	/**
	* Constructor
	*/
	public TeamMembersWidgetController(){
		
	}
		
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
	
	/**
	* Setter method for Team Id variable
	*@param String idTeam
	*/
	public void setTeam(String tID) {
		if (team == null || team != tID) {
			team = tID;
			genPermissions();
			Boolean canView = userPermissions.getCanView();
			if(!canView){
				throw new CustomException('Insufficient Privileges');
			} 
			assignNewMemberVarsNewProfile();
		}
	}
	
	/**
	*@return String idUser
	*/
	public String getCurrentUser () {
		return UserInfo.getUserId();	
	}
	
	/**
	*@return String idTeam
	*/
	public String getTeam(){
		return team;
	}

	String typeList;
	
	/**
	* Setter method for Team Id variable
	*@param String typeList
	*/
	public void setTypeList(String typeL) {
		typeList = typeL;		
	}
	
	public void getIsTeamAdmin(){
	
	}	
	
	/**
	*@return String typeList
	*/
	public String getTypeList(){
		return typeList;
	}
	
	/**
	* Return component title
	*@return String
	*/
	public String getComponentHeader () {
		if (typeList == 'adminList') {
			return 'Team Admins';	
		}else {
			return 'Team Members';	
		}
	}
	
	/**
	* Return conditional for LinkAction
	*@return Boolean
	*/
	public Boolean getRenderLinkAction () {
		return (typeList != 'adminList');
	}
	
	/**
	* Get Team Members
	*@return List<TeamMember>
	*/
	public List<TeamMember> getTeamspaceMembers() {
		List<TeamMember__c> temp = new List<TeamMember__c>();
      	
        if(typeList == 'adminList') {
        		temp = [select User__r.Id, User__r.Name from TeamMember__c where Team__c =: team and TeamProfile__r.ManageTeams__c = true order by User__r.Name];
        }else{
        		temp = [select User__r.Id, User__r.Name from TeamMember__c where Team__c =: team order by User__r.Name];
        }
        Set<Id> users = new Set<Id>();
        for(TeamMember__c t: temp) {
        	users.add(t.User__c);
		}
		Map<Id, PeopleProfile__c> userMap = new Map<Id, PeopleProfile__c>();
        for(PeopleProfile__c p: [SELECT Id, 
						         		YahooIM__c,
						         		Skype__c,
						         		Status__c,
						         		Picture__c,
						         		isPrivate__c,
						         		User__c
						         FROM  PeopleProfile__c
						         WHERE User__c IN: users]) {
			userMap.put(p.User__c, p);				          	
		}
                    	
        List<TeamMember> members = new List<TeamMember>();
		if(temp.size() > 0){ 
	        for(TeamMember__c t: temp) {
	            TeamMember m = new TeamMember(t, userMap.get(t.User__c));
	            m.Id = t.User__r.Id;
	            String nameAux = t.User__r.Name;
	            if(nameAux.length() > 20)
	            	nameAux = nameAux.substring(0,20);
	            m.username = nameAux;
	            members.add(m);
	        }
		}
		temp = null; 
		return members;
    }
    
    /**
    * Inner class for TeamMeber type
    *@class
    */
    public class TeamMember{
        
        TeamMember__c member;
        PeopleProfile__c profile = new PeopleProfile__c();
        String username = null;
        String yahoo = '';
        String skype = '';
        String Id = '';
        String picture = '';
        Boolean isPrivate = false;
        
		/**
		* Costructor
		*@param TeamMember__c
		*@param PeopleProfile__c
		*/
        public TeamMember(TeamMember__c m, PeopleProfile__c p) {
            member = m; 
            profile = p;                     
			
			if(profile != null){ 
	            if(profile.YahooIM__c != null){
	            	yahoo = profile.YahooIM__c;
	            }else { 
	            	yahoo = ''; 
	            }
	            
	            isPrivate = profile.isPrivate__c;
	            if(profile.Skype__c != null){
	            	skype = profile.Skype__c;
	            }else { 
	            	skype = ''; 
	            }
	            
	            if(profile.Picture__c != null){
	            	picture = profile.Picture__c;
	            }else {
	            	picture = ''; 
	            }
	            
	        }else {
	        	yahoo = '';
	        	skype = '';
	        	picture = '';
	        }
        }       
        
        /**
        *@return String idTeamMember
        */
        public String getId(){
        	return Id;
        }
		
		/**
		*@return TeamMember__c
		*/
        public TeamMember__c getMember() {
            return member;
        }
        
        /**
        *@return String
        */
        public String getUsername() { 
       		return username; 
        }
        
        /**
        *@return Boolean
        */
        public Boolean getIsPrivate() { 
       		return isPrivate; 
        }
        
        /**
        *@return String
        */
        public String getYahoo(){
        	if(profile != null){
        		return yahoo;
        	}else {
        	 	return '';
        	}
        }
        
        /**
        *@return String
        */
        public String getSkype(){
        	if(profile != null){	
        		return skype;
        	} else {
        	 	return '';
        	}
        }
        
        /**
        *@return String
        */
        public String getStatus() {	
        	if(profile != null){		 
				return profile.Status__c;
        	}else {
        		return '';
        	}
        }
        
        /**
        *@return PeopleProfile__c
        */
        public PeopleProfile__c getProfile(){         
         	 if(profile != null){
         	 	return profile;
         	 } else {
         	 	return new PeopleProfile__c();
         	 }
       	}
		
        /**
        *@return String
        */
        public String getImage() {
        	if(profile != null){
        		return picture;
        	} else {
         		return '';
         	}
        }
    }
	
	
	// Add new Member
	public String idTeam = System.currentPageReference().getParameters().get('id');
	
	/**
	*@param String ID
	*/
	public void setIdTeam(String s){
		idTeam = s;
	}
	
	public List<TeamMember__c> membersToInsert = new List<TeamMember__c>();
	public List<User> mailList = new List<User>();
	public Integer groupCount = 1;
	
	public String teamName = null;
	
	/**
	* Get Team Name
	*@return String team name
	*/
	public String getTeamName () {
		if(teamName == null)
			teamName = [select Name from Team__c where id =: idTeam].Name;
		return teamName;	
	}
	
	/**
	*@return String
	*/
	public String getTeamId () { 
		return idTeam;	
	}
	
	/**
	*@return List<SelectOption>
	*/
	public List<SelectOption> getProfilesOptions () {
		List<SelectOption> options = new List<SelectOption>();
		for (TeamProfile__c item: [select id, Name from TeamProfile__c order by Name]) {
			options.add(new SelectOption(item.id,item.Name));
		}
		return options;
	}
	

	public Member newMemberVars = new Member();
	
	/**
	* Assign new Member vars to new Profile
	*@void
	*/
	public void assignNewMemberVarsNewProfile () {
		List<Team__c> currentTeam = [select NewMemberProfile__c from Team__c where id=:idTeam];
		if (currentTeam.size() > 0 && currentTeam[0].NewMemberProfile__c != null) {	
			newMemberVars.profileId = currentTeam[0].NewMemberProfile__c;
		}
	}
	
	/**
	*@return Member
	*/	
	public Member getNewMemberVars () {
		return newMemberVars;	
	}
	
	/**
	*@param Member vars
	*/
	public void setNewMemberVars (Member vars) {
		this.newMemberVars = vars;
	}
	
	/**
	*@class
	*/
	public class Member {
		String profileId;
		String message;
		String teamRole;
		String colleagueNames;
		
		/**
        *@return String
        */
		public String getColleagueNames () {
			return colleagueNames;
		}
		
		/**
        *@param String names
        */
		public void setColleagueNames (String names) {
			this.colleagueNames = names;
		}
		
		/**
        *@return String ID
        */
		public String getProfileId () {
			return profileId;
		}
		
		/**
        *@param String ID
        */
		public void setProfileId (String profile) {
			this.profileId = profile;
		}	
		
		/**
        *@return String Message
        */
		public String getMessage () {
			return message;
		}
		
		/**
        *@param String Message
        */
		public void setMessage (String msj) {
			this.message = msj;
		}
		
		/**
        *@return String Role
        */
		public String getTeamRole () {
			return teamRole;
		}
		
		/**
        *@param String Role
        */
		public void setTeamRole (String tRole) {
			this.teamRole = tRole;
		}	
		
	}
	
	public List<TeamMember__c> memberListToolkit = new List<TeamMember__c>();
	
	/**
	*@return List<TeamMember__c>
	*/
	public List<TeamMember__c> getMemberListToolkit () {
		return memberListToolkit;
	}
	
	public Integer memberListToolkitCount = 0;
	
	/**
	*@return Integer
	*/
	public Integer getMemberListToolkitCount () {
		return memberListToolkitCount;
	}
		
	/**
	* Save Member and New
	*@void
	*/
	public void saveMembersNew () {
		List<TeamMember__c> newMemberList = new List<TeamMember__c>();
		List<String> newMembers = newMemberVars.colleagueNames.split(',');
		List<User> userList = new List<User>();
		Boolean already = false;
		
		for(String item: newMembers) {
			List<User> userItem = new List<User>();
			String itemTrim = item.trim();
			userItem = [select id, Name, Email from User where Name =:itemTrim limit 1];
			if (userItem.size() > 0) {
				already = false;
				Integer listPos = 0;
				while (!already && listPos < userList.size()) {
					if(userList[listPos].Name == userItem[0].Name) {
						already = true;
					}
					listPos++;
				}
				if (!already) {
					userList.add(userItem[0]);	
				}
			}
		}
		
		for (User user : userList) {
			Integer isMember = [select count() from TeamMember__c where team__c =:idTeam and user__c =: user.id];
			if (isMember == 0) {
				TeamMember__c newMember = new TeamMember__c();
				newMember.User__c = user.id;
				newMember.Name = user.Name;
				newMember.Team__c = idTeam;
				newMember.TeamProfile__c = newMemberVars.profileId;
				newMember.TeamRole__c = newMemberVars.teamRole;
				newMemberList.add(newMember); 
				mailList.add(user);
				 
			}
		}
		
		userList.clear();
		
		memberListToolkit = newMemberList;
		memberListToolkitCount = newMemberList.size();
		
		membersToInsert = newMemberList;	
		
		newMemberVars.colleagueNames = '';
		newMemberVars.teamRole = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
	}

	/**
	* Save Members
	*@void
	*/
	public void saveMembers () {
		List<TeamMember__c> newMemberList = new List<TeamMember__c>();
		List<String> newMembers = newMemberVars.colleagueNames.split('[ ]*,[ ]*');
		List<User> userList = new List<User>();
		Boolean already = false;
		
		Map<String, User> usersMap = new Map<String, User>();
		for (User iterUser :[select id, Name, Email from User where Name in:newMembers]) {
			usersMap.put(iterUser.Name, iterUser);
		}

		for(String item: newMembers) {
			if (usersMap.get(item) != null) {
				already = false;
				Integer listPos = 0;
				while (!already && listPos < userList.size()) {
					if(userList[listPos].Name == usersMap.get(item).Name) {
						already = true;
					}
					listPos++;
				}
				if (!already) {
					userList.add(usersMap.get(item));
				}
			}
		}
		
		Map<Id, TeamMember__c> teamMemberMap = new Map<Id, TeamMember__c>();
		for (TeamMember__c iterMember : [select id, User__c  from TeamMember__c where team__c =:idTeam]) {
			teamMemberMap.put(iterMember.User__c,iterMember);
		}

		for (User user : userList) {
			if (teamMemberMap.get(user.Id) == null) {
				TeamMember__c newMember = new TeamMember__c();
				newMember.User__c = user.id;
				newMember.Name = user.Name;
				newMember.Team__c = idTeam;
				newMember.TeamProfile__c = newMemberVars.profileId;
				newMember.TeamRole__c = newMemberVars.teamRole;
				newMemberList.add(newMember);
				mailList.add(user);
				
			}
		}
		
		userList.clear();
		teamMemberMap.clear();
		usersMap.clear();
		
		memberListToolkit = newMemberList;
		memberListToolkitCount = newMemberList.size();
		    
		//Insert newMemberList;
		membersToInsert = newMemberList;
		newMemberVars.colleagueNames = '';
		newMemberVars.teamRole = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
	}
	
	//New save
	public Integer countSaved = 0;
	public Boolean reset = false;
	
	/**
	* Sync Save Members
	*@return PageReference
	*/
	public PageReference syncSaveMembers(){
		Integer endIt =  countSaved + 2;
		for(Integer it = countSaved; it <= endIt; it++){
			if(it < membersToInsert.size()){
				TeamMember__c tm = membersToInsert[it];
				for(User user: mailList){
					if(tm.User__c == user.id){
						SendMail(user,newMemberVars.message);
					}
				}
				insert tm;
				memberListToolkitCount--;
			}else{
				membersToInsert.clear();
				mailList.clear();
				groupCount = 0;
				reset = true;
			}
		}
		if(reset){
			countSaved = 0;
			reset = false;
		}else{
			countSaved += 3;
		}
		return null;
	}
	
	/**
	* Init save members
	*@return Boolean
	*/
	public Boolean getInitAddMembers (){
		return membersToInsert.size() > 0;
	} 
	
	/**
	* Send mail to new mambers
	*@void
	*/
	public void SendMail(User user, String message) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        String[] toAddresses = new String[] {user.Email};
 		// Assign the addresses for the To and CC lists to the mail object.
		mail.setToAddresses(toAddresses);
		// Specify the address used when the recipients reply to the email.
		mail.setReplyTo('forwardtosfdc@gmail.com');
		// Specify the name used as the display name.
		mail.setSenderDisplayName(user.Name);
		// Specify the subject line for your email address.
		mail.setSubject('You Have Been Added to ' + this.getTeamName());
		// Set to True if you want to BCC yourself on the email.
		mail.setBccSender(false);
		// Optionally append the salesforce.com email signature to the email.
		// The email address of the user executing the Apex Code will be used.
		mail.setUseSignature(true);
		// Specify the html version of the content as well.
		message = (message == null) ? '' : message;
		mail.setHtmlBody(message);
		// Send the email you have created.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }	
    
    // Sharing rules
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	
	/**
	* Generate user permissions
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(team);
		userPermissions.setObjectType('Team');
		userPermissions.setPermissions();		
	}
	
	/**
	* Return user permissions
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}	
	
	/**
	* Rerender use only
	*/
	public void refreshMethod(){
		
	}

}
/**
*@author Juan M. Bessonart @ 6-11-2008
*/
public with sharing class TeamsNewMemberController {

	/**
	*@constructor
	*/
	public TeamsNewMemberController (){
		if(idTeam != null)
			teamName = [select Name from Team__c where id=: idTeam].Name;	
	}	
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
	
	public String idTeam = System.currentPageReference().getParameters().get('id');
	
	public String teamName = null;
	
	/**
	*@return String
	*/
	public String getTeamName () {
		return teamName;	
	}
	
	/**
	*@param String
	*/
	public void setTeamId(String s){
		idTeam = s;
	}
	
	/**
	*@return String
	*/
	public String getTeamId() { 
		return idTeam;	
	}

	/**
	* Load Select Menu
	*@return List<SelectOption>
	*/
	public List<SelectOption> getProfilesOptions () {
		List<SelectOption> options = new List<SelectOption>();
		for (TeamProfile__c item: [select id, Name from TeamProfile__c order by Name]) 
			options.add(new SelectOption(item.id,item.Name));

		return options;
	}
	
	public Member newMemberVars = new Member();
	
	/**
	*@return Member
	*/
	public Member getNewMemberVars () {
		return newMemberVars;	
	}
	
	/**
	*@param Member
	*/
	public void setNewMemberVars (Member vars) {
		this.newMemberVars = vars;
	}
	
	/**
	* Inner class for Member type
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
		*@param String
		*/
		public void setColleagueNames (String names) {
			this.colleagueNames = names;
		}
		
		/**
		*@return String
		*/
		public String getProfileId () {
			return profileId;
		}
		
		/**
		*@param String
		*/
		public void setProfileId (String profile) {
			this.profileId = profile;
		}	
		
		/**
		*@return String
		*/
		public String getMessage () {
			return message;
		}
		
		/**
		*@param String
		*/
		public void setMessage (String msj) {
			this.message = msj;
		}
		
		/**
		*@return String
		*/
		public String getTeamRole () {
			return teamRole;
		}
		
		/**
		*@param String
		*/
		public void setTeamRole (String tRole) {
			this.teamRole = tRole;
		}	
		
	}
		
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
				SendMail(user,newMemberVars.message); 
			}
		}
		insert newMemberList;
		
		newMemberVars.colleagueNames = '';
		newMemberVars.teamRole = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
	}

	public PageReference saveMembers () {
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
				SendMail(user,newMemberVars.message); 
			}
		}
		insert newMemberList;
		
		newMemberVars.colleagueNames = '';
		newMemberVars.teamRole = '';
		newMemberVars.profileId = '';
		newMemberVars.message = '';
		
		PageReference pageRef = Page.TeamsMembersList;
		pageRef.getParameters().put('id', idTeam);
		pageRef.setRedirect(true);
		return pageRef;	
	}
	
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
		mail.setSubject('You Have Been Added to ' + teamName);
           
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
}
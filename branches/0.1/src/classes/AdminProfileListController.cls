public class AdminProfileListController {

	
	List<TeamProfile> profiles;
	String oldIdProfile = null;
	String newIdProfile = null;
	
	public AdminProfileListController (){
		getTeamProfiles();
	}
	
	/**
	*@param String id
	*/
	public void setOldIdProfile (String id){
		oldIdProfile = id;
	}
	
	/**
	*@return String id
	*/
	public String getOldIdProfile (){
		return oldIdProfile;
	}
	
	/**
	*@param String id
	*/
	public void setNewIdProfile (String id){
		newIdProfile = id;
	}
	
	/**
	*@return String id
	*/
	public String getNewIdProfile (){
		return newIdProfile;
	}			
	
	/**
	*@void
	*/
	public void getTeamProfiles(){
		profiles = new List<TeamProfile>();
		List<TeamProfile__c> teamProfileList = new List<TeamProfile__c>(); 
		teamProfileList = [select t.Id, t.CreatedById, t.CreatedDate, 
						t.Name from TeamProfile__c t order by t.Name];	
		
		for (TeamProfile__c teamProfile : teamProfileList){
			profiles.add (new TeamProfile(teamProfile));
		}	
	}
	
	
	/**
	*@return List<TeamTypes>
	*/
	public List<TeamProfile> getProfiles () {
		return profiles;
	}
	
	/**
	*Reasing users to other team profile
	*@void
	*/
	public void reAssignUsers (){
		List<TeamMember__c> members = new List<TeamMember__c>();
		members = [select m.Id, m.TeamProfile__c from TeamMember__c m where m.TeamProfile__c =: oldIdProfile];
		for (TeamMember__c m : members){
			m.TeamProfile__c = newIdProfile;
		}
		try{
			update members;
		}
		catch(DmlException e){
		}
	}
	
	
	
	/**
	*@class::TeamProfile
	*/
	public class TeamProfile {
		
		public TeamProfile__c teamProfile = null;
		String createdDate = null;
		User creator = null;
		
		/**
		*@param TeamProfile__c
		*/
		public TeamProfile(TeamProfile__c teamProfile){
			this.teamProfile = teamProfile;
			this.createdDate = this.teamProfile.CreatedDate.format('MMMM dd, yyyy HH:mm aa');
			this.getCreatorName();
		}
		
		/**
		*@return TeamProfile__c t
		*/
		public TeamProfile__c getTeamProfile (){
			return teamProfile;
		}
		
		/**
		*@return String
		*/		
		public User getCreator (){
			return creator;
		}
		
		/**
		*@return String
		*/
		public String getCreatedDate (){
			return createdDate;
		}
		
		/**
		*@void
		*/
		public void getCreatorName (){
			User user = null;
			user = [select u.Name, u.Id from User u where u.Id =: teamProfile.CreatedById];
			this.creator = user; 
		}
		

	}




}
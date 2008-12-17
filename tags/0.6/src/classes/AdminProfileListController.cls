/**
*@author: Nicolas Gunther @ 5-22-2008
*/
public class AdminProfileListController {

	List<TeamProfile> profiles;
	String oldIdProfile = null;
	String newIdProfile = null;
	String newIdProfileNewMember = null;
	String newIdProfilePublicProfile = null;
	public String sortBy = 'Name';
	public Boolean sortByDesc = false;
	
	/**
	* Constructor
	*/
	public AdminProfileListController (){
		TeamUtil.isAdminMemberUser();
		getTeamProfiles();
	}

	/**
	* Returns current sort by
	*@return String sortBy
	*/
	public String getSortBy(){
		return sortBy;
	}
	
	/**
	* Set sort by
	*@param String sort
	*/
	public void setSortBy(String s){
		sortBy = s;
	}
	
	/**
	* Returns current order sense
	*@return Boolean sortByDesc
	*/
	public Boolean getSortByDesc(){
		return sortByDesc;
	}
	
	/**
	* Set order sense
	*@param String sort
	*/
	public void setSortByDesc(Boolean b){
		sortByDesc = b;
	}	
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
	
	/**
	* Set old TeamProfile__c Id
	*@param String
	*/
	public void setOldIdProfile (String id){
		oldIdProfile = id;
	}
	
	/**
	* Returns old TeamProfile__c Id
	*@return String
	*/
	public String getOldIdProfile (){
		return oldIdProfile;
	}
	
	/**
	* Set new TeamProfile__c Id
	*@param String
	*/
	public void setNewIdProfile (String id){
		newIdProfile = id;
	}
	
	public void setNewIdProfileNewMember (String id){
		newIdProfileNewMember = id;
	}
	
	public void setNewIdProfilePublicProfile  (String id){
		newIdProfilePublicProfile  = id;
	}
	
	/**
	* Returns new TeamProfile__c Id
	*@return String
	*/
	public String getNewIdProfile (){
		return newIdProfile;
	}			
	
	public String getNewIdProfileNewMember (){
		return newIdProfileNewMember;
	}	
	
	public String getNewIdProfilePublicProfile (){
		return newIdProfilePublicProfile;
	}	
	
	/**
	* Get TeamProfile list
	*/
	public void getTeamProfiles(){
		
		profiles = new List<TeamProfile>();
		List<TeamProfile__c> teamProfileList = new List<TeamProfile__c>();
		
		//Set oreder sense
		if (sortBy == System.currentPageReference().getParameters().get('sb')) {
			sortByDesc = !sortByDesc;
		}else {
			sortByDesc = false;
		}
		
		//Sort param
		if(System.currentPageReference().getParameters().get('sb') != null)
			sortBy = System.currentPageReference().getParameters().get('sb');		 
		
		//Do sort
		if (sortByDesc){
			if (sortBy == 'Name'){
				teamProfileList = [select t.Id, t.CreatedById, t.CreatedDate, t.Name, (Select Id From TeamMember__r) from TeamProfile__c t order by t.Name desc];
			}
			if (sortBy == 'created'){
				teamProfileList = [select t.Id, t.CreatedById, t.CreatedDate, t.Name, (Select Id From TeamMember__r) from TeamProfile__c t order by t.CreatedDate desc];
			}
			if (sortBy == 'creator'){
				teamProfileList = [select t.Id, t.CreatedById, t.CreatedDate, t.Name, (Select Id From TeamMember__r) from TeamProfile__c t];
			}
		}else{
			if (sortBy == 'Name'){
				teamProfileList = [select t.Id, t.CreatedById, t.CreatedDate, t.Name, (Select Id From TeamMember__r) from TeamProfile__c t order by t.Name asc];
			}
			if (sortBy == 'created'){
				teamProfileList = [select t.Id, t.CreatedById, t.CreatedDate, t.Name, (Select Id From TeamMember__r) from TeamProfile__c t order by t.CreatedDate asc];
			}
			if (sortBy == 'creator'){
				teamProfileList = [select t.Id, t.CreatedById, t.CreatedDate, t.Name, (Select Id From TeamMember__r) from TeamProfile__c t];
			}
		}
		
		//Iterate all result
		for (TeamProfile__c teamProfile : teamProfileList){
			profiles.add (new TeamProfile(teamProfile));
		}
		
		//If its a creator order
		if (sortBy == 'creator'){
			profiles = sortList(profiles);		
		}	
	}
	
	/**
	* Returns TeamProfile list
	*@return List<TeamProfile>
	*/
	public List<TeamProfile> getProfiles () {
		return profiles;
	}
	
	/**
	* Reassing members asoc from old profile to new team profile
	*/
	public void reAssignUsers (){
		
		//users
		List<TeamMember__c> members = new List<TeamMember__c>();
		members = [select m.Id, m.TeamProfile__c from TeamMember__c m where m.TeamProfile__c =: oldIdProfile];
		for (TeamMember__c m : members){
			m.TeamProfile__c = newIdProfile;
		}
		
		//newMemberProfile
		List<Team__c> teamsNewMemProfile = new List<Team__c>();
		teamsNewMemProfile = [select tnm.Id, tnm.NewMemberProfile__c from Team__c tnm where tnm.NewMemberProfile__c =: oldIdProfile];
		for (Team__c tnm : teamsNewMemProfile){
			tnm.NewMemberProfile__c = newIdProfileNewMember;
		}
		
		//publicProfile
		List<Team__c> teamsPublicProfile = new List<Team__c>();
		teamsPublicProfile = [select tnm.Id, tnm.PublicProfile__c from Team__c tnm where tnm.PublicProfile__c =: oldIdProfile];
		for (Team__c tnm : teamsPublicProfile){
			tnm.PublicProfile__c = newIdProfilePublicProfile;
		}
		
		try{
			update members;
			update teamsNewMemProfile;
			update teamsPublicProfile;
			List<TeamProfile__c> oldProfile = [select Id, Name from TeamProfile__c where id=:this.getOldIdProfile()];
			delete oldProfile;
		}catch(DmlException e){
			throw e;
		}
	}
		
	/**
	* Class for TeamProfile__c formating
	*@author Nicolas Gunther
	*/
	public class TeamProfile {
		
		public TeamProfile__c teamProfile = null;
		String createdDate = null;
		User creator = null;
		Boolean hasMember = false;
		Boolean hasTeams = false;
		
		/**
		* Constructor
		*@param TeamProfile__c
		*/
		public TeamProfile(TeamProfile__c teamProfile){
			this.teamProfile = teamProfile;
			this.createdDate = this.teamProfile.CreatedDate.format('MMMM dd, yyyy HH:mm aa');
			if (teamProfile.TeamMember__r.size() > 0) {
				this.hasMember = true;
			} else {
				this.hasMember = false;
			}
			
			//has teams
			TeamProfile__c profileRes;
			List<TeamProfile__c> profileList = new List<TeamProfile__c>();
			profileList=[select t.Name, (Select Name From Teams__r), (Select Name From Teams1__r) from TeamProfile__c t where t.id=:teamProfile.id];
			for (TeamProfile__c tp : profileList){
				profileRes = tp;
			}
			if ((profileRes.Teams__r.size() > 0) || (profileRes.Teams1__r.size() > 0)) {
				this.hasTeams = true;
			} else {
				this.hasTeams = false;
			}
			this.getCreatorName();
		}
		
		/**
		* Returns TeamProfile__c instance
		*@return TeamProfile__c
		*/
		public TeamProfile__c getTeamProfile (){
			return teamProfile;
		}
		
		/**
		* Returns creator User
		*@return User 
		*/		
		public User getCreator (){
			return creator;
		}
		
		/**
		* Returns created date.
		*@return String
		*/
		public String getCreatedDate (){
			return createdDate;
		}
		
		/**
		* Returns has members asoc.
		*@return Boolean
		*/
		public Boolean getHasMember (){
			return hasMember;
		}
		
		public Boolean getHasTeams (){
			return hasTeams;
		}
		
		public Boolean hasMemberOrTeams (){
			return (hasMember || hasTeams);
		}
		
		/**
		* Returns creator name
		*/
		public void getCreatorName (){
			User user = null;
			user = [select u.Name, u.Id from User u where u.Id =: teamProfile.CreatedById];
			this.creator = user; 
		}
	}
	
	/**
	* Sort list by creator name
	*@return List<TeamProfile> tempProfiles
	*/
	public List<TeamProfile> sortList(List<TeamProfile> tempProfiles){
	    Integer n;
	    Integer i;
	    Integer j;
	    
	    n = tempProfiles.size() - 1;  
	    for (i = 1; i <= n; i++) {  
	        for (j = n; j >= i ; j--) {
	            if (sortByDesc) {
	                if (tempProfiles.get(j).creator.Name >= tempProfiles.get(j - 1).creator.Name) {
	                    TeamProfile tempTeamProfile;
	                    tempTeamProfile = tempProfiles.get(j - 1);
	                    tempProfiles.set(j - 1, tempProfiles.get(j));
	                    tempProfiles.set(j, tempTeamProfile);  
	                }   
	            } else {
	                if (tempProfiles.get(j).creator.Name <= tempProfiles.get(j - 1).creator.Name) {
	                    TeamProfile tempTeamProfile;
	                    tempTeamProfile = tempProfiles.get(j - 1);
	                    tempProfiles.set(j - 1, tempProfiles.get(j));
	                    tempProfiles.set(j, tempTeamProfile); 
	                }   
				}
			}
	    }
	    return tempProfiles;	
	}

	public String idTeamProfileNoMembers = '';
	/**
	* Set TeamProfile__c Id has no members asoc
	*@param String
	*/
	public void setIdTeamProfileNoMembers (String idTeamProfileNoMembers) {
		this.idTeamProfileNoMembers = idTeamProfileNoMembers;
	}
	
	/**
	* Remove TeamProfile__c has no members asoc.
	*/
	public void removeTeamProfileNoMembers () {
		if (System.currentPageReference().getParameters().get('idRmvTP') != null) {
			idTeamProfileNoMembers = System.currentPageReference().getParameters().get('idRmvTP');
		}
		List<TeamProfile__c> teamProfileToRemove = [select id from TeamProfile__c where id=: idTeamProfileNoMembers];
		delete 	teamProfileToRemove;
		getTeamProfiles();	
	}

}
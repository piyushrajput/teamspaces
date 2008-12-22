/**
*@author: Virginia Jamardo @ 5-29-2008
*/
public class AdminMainSetupController {
	
	List<TeamTypes> types;
	List<TeamProfile> profiles;
	String oldIdProfile = null;
	String newIdProfile = null;
	String newIdProfileNewMember = null;
	String newIdProfilePublicProfile = null; 
	
	// Param to indicate list to order
	String listToOrder = System.CurrentPageReference().getParameters().get('list');
	// Param to indicate field to order
	String fieldToOrder = 'created';
	// Boolean to define if order is desc
	Boolean isDesc = true;
	
	/**
	* Constructor
	*/
	public AdminMainSetupController(){
		TeamUtil.isAdminMemberUser();
		getTeamTypes();
		getTeamProfiles();
	}
	
	/**
	*@param Boolean
	*/
	public void setIsDesc(Boolean isDesc){
		this.isDesc = isDesc;
	}
	
	/**
	* Return true if the order is desc
	*@return Boolean
	*/
	public Boolean getIsDesc(){
		return isDesc;
	}
	
	/**
	*@param String
	*/
	public void setField(String field){
		this.fieldToOrder = field;
	}
	
	/**
	* Return the name of ordered field
	*@return String
	*/
	public String getField(){
		return fieldToOrder;
	}
	
	/**
	* Return the Namespace Prefix
	*@return String namespace
	*/
	public String getNamespace() {
        return TeamUtil.getNamespace();
    } 
	
	/**
	* Get 5 last TeamTypes order by CreatedDate.
	*/
	public void getTeamTypes(){
		Integer n;
	    Integer i;
	    Integer j;
	    
	    types = new List<TeamTypes>();
		List<TeamType__c> teamTypeList = new List<TeamType__c>(); 
		teamTypeList = [select Id, CreatedById, CreatedDate, 
						Name, PageName__c, IsActive__c
						from TeamType__c order by CreatedDate desc LIMIT 5];
		for (TeamType__c teamType : teamTypeList){
			types.add (new TeamTypes(teamType));
		}	
	    
	    //Set oreder sense
		if (fieldToOrder == System.CurrentPageReference().getParameters().get('field')) {
			isDesc = !isDesc;
		}else {
			isDesc = true;
		}
		
		if(System.CurrentPageReference().getParameters().get('list') != null && System.CurrentPageReference().getParameters().get('list') != '')
			listToOrder = System.CurrentPageReference().getParameters().get('list');
		
		if(System.CurrentPageReference().getParameters().get('field') != null && System.CurrentPageReference().getParameters().get('field') != '')
			this.setField(System.CurrentPageReference().getParameters().get('field'));
		
	    n = types.size() - 1;
	    if(listToOrder == 'tmtp'){
		    if(isDesc){
		    	if(fieldToOrder == 'name'){
					for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).teamType.Name >= types.get(j - 1).teamType.Name){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}else if(fieldToOrder == 'nteams'){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).teams >= types.get(j - 1).teams){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}else if(fieldToOrder == 'creator'){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).creator.Name >= types.get(j - 1).creator.Name){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}else if(fieldToOrder == 'created' || fieldToOrder == null){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).teamType.CreatedDate >= types.get(j - 1).teamType.CreatedDate){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}
			}else {
		    	if(fieldToOrder == 'name'){
					for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).teamType.Name <= types.get(j - 1).teamType.Name){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}else if(fieldToOrder == 'nteams'){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).teams <= types.get(j - 1).teams){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}else if(fieldToOrder == 'creator'){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).creator.Name <= types.get(j - 1).creator.Name){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}else if(fieldToOrder == 'created' || fieldToOrder == null){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(types.get(j).teamType.CreatedDate <= types.get(j - 1).teamType.CreatedDate){
								TeamTypes tempTeamTypes;
								tempTeamTypes = types.get(j - 1);
								types.set(j - 1, types.get(j));
								types.set(j, tempTeamTypes);
							}
						}
					}
		    	}
			}
		}
	}
	
	/**
	* Returns TeamTypes list.
	*@return List<TeamTypes>
	*/
	public List<TeamTypes> getTypes() {
		return types;
	}
	
	/**
	* Class for TeamType__c formating.
	*@author Nicolas Gunther 
	*/
	public class TeamTypes {
		
		TeamType__c teamType = null;
		String createdDate = null;
		User creator = null;
		Integer teams = 0;
		Boolean hasTeams = true;
		
		/**
		* Constructor
		*@param TeamType__c The TeamType__c instance
		*/
		public TeamTypes(TeamType__c teamType){
			this.teamType = teamType;
			this.createdDate = this.teamType.CreatedDate.format('MMMM dd, yyyy HH:mm aa');
			this.getCreatorName();
			this.getNumberOfTeams();
		}
		
		/**
		* Get current TeamType__c
		*@return TeamType__c t
		*/
		public TeamType__c getTeamType (){
			return teamType;
		}
		
		/**
		* Get creator User instance
		*@return String
		*/		
		public User getCreator (){
			return creator;
		}
		
		/**
		* Get created date
		*@return String
		*/
		public String getCreatedDate (){
			return createdDate;
		}
		
		/**
		* Return number of teams
		*@return Integer
		*/
		public Integer getTeams(){
			return teams;
		}
		
		/**
		* Return true if has teams
		*@return Boolean 
		*/	
		public Boolean getHasTeams(){
			return hasTeams;
		}

		/**
		* Get creator name
		*/
		public void getCreatorName (){
			User user = null;
			user = [select u.Name, u.Id from User u where u.Id =: teamType.CreatedById];
			this.creator = user; 
		}
		
		/**
		* Get number of teams
		*/
		public void getNumberOfTeams(){
			this.teams = [select count() from Team__c t where t.TeamType__c =: teamType.Id];
			if(this.teams == 0)
				this.hasTeams = false;
		}
	}
	
	/**
	* Set old TeamProfile__c Id
	*/
	public void setOldIdProfile (String id){
		oldIdProfile = id;
	}
	
	/**
	* Returns old TeamProfile__c Id
	*@return String Id
	*/
	public String getOldIdProfile (){
		return oldIdProfile;
	}
	
	/**
	* Set new TeamProfile__c Id
	*@param String Id
	*/
	public void setNewIdProfile (String id){
		newIdProfile = id;
	}
	
	/**
	*@param id new member profile id
	*/
	public void setNewIdProfileNewMember (String id){
		newIdProfileNewMember = id;
	}
	
	/**
	*@param id public profile id
	*/
	public void setNewIdProfilePublicProfile  (String id){
		newIdProfilePublicProfile  = id;
	}
	
	/**
	* Returns new TeamProfile__c Id
	*@return String Id
	*/
	public String getNewIdProfile (){
		return newIdProfile;
	}
	
	/**
	*@return new member profile id
	*/
	public String getNewIdProfileNewMember (){
		return newIdProfileNewMember;
	}	
	
	/**
	*@return public profile id
	*/
	public String getNewIdProfilePublicProfile (){
		return newIdProfilePublicProfile;
	}		
	
	/**
	* Read 5 last TeamProfile__c order by CreatedDate
	*/
	public void getTeamProfiles(){
		Integer n;
	    Integer i;
	    Integer j;
		
		profiles = new List<TeamProfile>();
		List<TeamProfile__c> teamProfileList = new List<TeamProfile__c>(); 
		teamProfileList = [select Id, CreatedById, CreatedDate, 
						Name from TeamProfile__c order by CreatedDate desc LIMIT 5];
		for (TeamProfile__c teamProfile : teamProfileList){
			profiles.add (new TeamProfile(teamProfile));
		}	
		
		//Set oreder sense
		if (fieldToOrder == System.CurrentPageReference().getParameters().get('field')) {
			isDesc = !isDesc;
		}else {
			isDesc = true;
		}
		
		if(System.CurrentPageReference().getParameters().get('list') != null && System.CurrentPageReference().getParameters().get('list') != '')
			listToOrder = System.CurrentPageReference().getParameters().get('list');
		
		if(System.CurrentPageReference().getParameters().get('field') != null && System.CurrentPageReference().getParameters().get('field') != '')
			this.setField(System.CurrentPageReference().getParameters().get('field'));
		
		n = profiles.size() - 1;
	    if(listToOrder == 'tmpf'){
		    if(isDesc){
		    	if(fieldToOrder == 'name'){
					for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(profiles.get(j).teamProfile.Name >= profiles.get(j - 1).teamProfile.Name){
								TeamProfile tempTeamProfile;
								tempTeamProfile = profiles.get(j - 1);
								profiles.set(j - 1, profiles.get(j));
								profiles.set(j, tempTeamProfile);
							}
						}
					}
		    	}else if(fieldToOrder == 'creator'){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(profiles.get(j).creator.Name >= profiles.get(j - 1).creator.Name){
								TeamProfile tempTeamProfile;
								tempTeamProfile = profiles.get(j - 1);
								profiles.set(j - 1, profiles.get(j));
								profiles.set(j, tempTeamProfile);
							}
						}
					}
		    	}else if(fieldToOrder == 'created' || fieldToOrder == null){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(profiles.get(j).teamProfile.CreatedDate >= profiles.get(j - 1).teamProfile.CreatedDate){
								TeamProfile tempTeamProfile;
								tempTeamProfile = profiles.get(j - 1);
								profiles.set(j - 1, profiles.get(j));
								profiles.set(j, tempTeamProfile);
							}
						}
					}
		    	}
			}else {
		    	if(fieldToOrder == 'name'){
					for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(profiles.get(j).teamProfile.Name <= profiles.get(j - 1).teamProfile.Name){
								TeamProfile tempTeamProfile;
								tempTeamProfile = profiles.get(j - 1);
								profiles.set(j - 1, profiles.get(j));
								profiles.set(j, tempTeamProfile);
							}
						}
					}
		    	}else if(fieldToOrder == 'creator'){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(profiles.get(j).creator.Name <= profiles.get(j - 1).creator.Name){
								TeamProfile tempTeamProfile;
								tempTeamProfile = profiles.get(j - 1);
								profiles.set(j - 1, profiles.get(j));
								profiles.set(j, tempTeamProfile);
							}
						}
					}
		    	}else if(fieldToOrder == 'created' || fieldToOrder == null){
		    		for(i = 1; i <= n; i++){
						for(j = n; j >= i; j--){
							if(profiles.get(j).teamProfile.CreatedDate >= profiles.get(j - 1).teamProfile.CreatedDate){
								TeamProfile tempTeamProfile;
								tempTeamProfile = profiles.get(j - 1);
								profiles.set(j - 1, profiles.get(j));
								profiles.set(j, tempTeamProfile);
							}
						}
					}
		    	}
			}
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
	* Reasing users to other team profile
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
	* Class for TeamProfile__c formating.
	*@author Virginia Jamardo
	*/
	public class TeamProfile {
		
		public TeamProfile__c teamProfile = null;
		String createdDate = null;
		User creator = null;
		
		/**
		*@param TeamProfile__c
		*/
		public TeamProfile(TeamProfile__c profile){
			this.teamProfile = profile;
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
	
	/**
	* Load TeamProfile list and TeamType list
	*/
	public void getAll(){
		getTeamProfiles();
		getTeamTypes();
	}
	
}
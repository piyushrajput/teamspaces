/**
*@author: Fabritzio Calvetti @ 5-29-2008
*/
public class AdminProfileController {
	
	public TeamProfile__c teamProfile;
	public String section;
	public Boolean hasMember = false;
	
	/**
	* Constructor
	*/
	public AdminProfileController(){
		methodConstruct();	
	}

	/**
	* Returns true if hasMember
	*@return Boolean
	*/
	public Boolean getHasMember () {
		return hasMember;
	}
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 	
	
	/**
	* Initialize data for current action
	*/
	public void methodConstruct(){
		TeamUtil.isAdminMemberUser();
		String teamProfileId;
		String clonParameter;
		String teamProfileView;
		teamProfileId = System.currentPageReference().getParameters().get('id');
		clonParameter = System.currentPageReference().getParameters().get('clone');
		teamProfileView = System.currentPageReference().getParameters().get('view');
		String idTeamProf;
		
		if(clonParameter != null){
			idTeamProf = clonParameter;	
			setSection('clone');
		}else if(teamProfileId != null){
			idTeamProf = teamProfileId;
			setSection('edit');
		}else if (teamProfileView != null){
			idTeamProf = teamProfileView;
			setSection('view');
		}else{
			setSection('create');
		}
		
		if(idTeamProf != null && idTeamProf != ''){
			teamProfile = [SELECT   t.PostWikiComments__c, 
									t.PostDiscussionTopicReplies__c, 
									t.PostBookmarkComments__c, 
									t.PostBlogComments__c, 
									t.Name, 
									t.ManageWikis__c, 
									t.ManageTeams__c, 
									t.ManageAttachments__c, 
									t.ManageProjectTasks__c, 
									t.ManageDiscussionForums__c, 
									t.ManageBookmarks__c, 
									t.ManageBlogs__c, 
									t.Id, 
									t.Description__c, 
									t.CreatedBy.Name, 
									t.CreatedById, 
									T.CreatedDate,
									t.CreateWikiPages__c, 
									t.CreateProjectTasks__c, 
									t.CreateDiscussionTopics__c, 
									t.CreateBookmarks__c,
									t.LastModifiedBy.Name,
									t.LastModifiedById,
									t.LastModifiedDate, 
									t.CreateBlogs__c,
									(select id from TeamMember__r) 
							 From TeamProfile__c t
							 Where t.Id =: idTeamProf];
			if (teamProfile.TeamMember__r.size() > 0) {
				hasMember = true;
			} else {
				hasMember = false;
			} 
		}else{
			teamProfile = new TeamProfile__c();	
		}
	}
	
	/**
	* Returns is a Clone action
	*@return Boolean
	*/
	public boolean getIsAClone(){
		String clon = System.currentPageReference().getParameters().get('clone');
		if(clon != null) {
			return true;
		}
		return false;
	}
		
	/**
	* Returns TeamProfile__c instance
	*@return TeamProfile__c
	*/
	public TeamProfile__c getTeamProfile(){
		return teamProfile;
	}
	
	/**
	* Set TeamProfile__c instance
	*@param TeamProfile__c The TeamProfile__c instance
	*/
	public void setTeamProfile (TeamProfile__c t){
		teamProfile = t;
	}
	
	/**
	* Get permissions for author
	*@return Boolean
	*/
	public boolean getPermissionAuthorApex(){
		User user = [Select u.Profile.Name, u.Profile.PermissionsAuthorApex, u.ProfileId, u.Name, u.Id From User u Where Id =: UserInfo.getUserId()];
		return user.Profile.PermissionsAuthorApex;
	}
	
	/**
	* Get is a Team Administrator user
	*@return Boolean Is team admin
	*/
	public boolean getIsTeamAdminMember(){
		List<User> teamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =:UserInfo.getUserId() limit 1];                             
        if(getPermissionAuthorApex() && teamAdmin[0].Profile.PermissionsModifyAllData){
        	return true;
        }
        return false;
	}
	
	/**
	* Returns current action
	*@return String The section
	*/
	public String getSection(){
		return section;
	}
	
	/**
	* Set new action
	*@param String The new section
	*/
	public void setSection(String newSection){
		section = newSection;
	}
	
	/**
	* Set current action
	*/
	public void asignSection(){
		setSection(System.currentPageReference().getParameters().get('section'));
	}
	
	/**
	* Read TeamProfile__c list
	*@return List<TeamProfile__c> The list of TeamProfiles
	*/
	public List<TeamProfile__c> getAllTeamProfiles(){
		List<TeamProfile__c> allTeamProfiles = new List<TeamProfile__c>();
		allTeamProfiles = [Select t.OwnerId, 
								  t.Name, 
								  t.LastModifiedDate, 
								  t.Id, 
								  t.Description__c, 
								  t.CreatedDate 
						   From TeamProfile__c t ];
		return 	allTeamProfiles;
	}			   			   
	
	/**
	* Check TeamProfile__c name be unique.
	*@return Boolean 
	*/
	public boolean getExistName(){
		for(TeamProfile__c t : getAllTeamProfiles()){
			if(t.Name == teamProfile.Name && section == 'clone'){
				return true;
			}
		}	
		return false;
	}					   
	   
	/**
	* Save new/clone TeamProfile__c
	*@return PageReference
	*/					   
	public PageReference saveTeamProfile(){
		if(teamProfile != null){
			if(section == 'edit'){
				update teamProfile;
			}else{
				if(section == 'clone'){
					if(!getExistName()){
						TeamProfile__c clone = new TeamProfile__c();
						clone = teamProfile.clone(false, true);
						insert clone;
					}
				}else if (section == 'create'){
					insert teamProfile;
				}
			}
		}
		
		System.currentPageReference().getParameters().put('success', section);
		PageReference pageRef = Page.AdminProfileList;
		pageRef.setRedirect(true);
		return pageRef;
	}
	

	public String oldIdProfile = '';
	/**
	* Returns old TeamProfile__c Id
	*@return String
	*/
	public String getOldIdProfile () {
		return oldIdProfile;
	}
	
	/**
	* Set old TeamProfile__c Id
	*@param String 
	*/
	public void setOldIdProfile (String oldIdProfile) {
		this.oldIdProfile = oldIdProfile;	
	}
	
	public String newIdProfile = '';
	public String newIdProfilePublicProfile = '';
	public String newIdProfileNewMember = '';
	
	/**
	* Returns new TeamProfile__c Id
	*@return String
	*/
	public String getNewIdProfile () {
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
	* Set new TeamProfile__c Id
	*@param String
	*/
	public void setNewIdProfile (String newIdProfile) {
		this.newIdProfile = newIdProfile;	
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
	
	public String profileListMode = '';
	/**
	* Returns TeamProfile__c list mode
	*@return String
	*/
	public String getProfileListMode () {
		return profileListMode;
	}
	
	/**
	* Set TeamProfile__c list mode
	*@param String
	*/
	public void setProfileListMode (String profileListMode) {
		this.profileListMode = profileListMode;	
	}	
	
	/**
	* Reassing members asoc. from old TeamProfile__c to new profile
	*@return PageReference
	*/
	public PageReference reAssignUsers (){
		List<TeamMember__c> members = new List<TeamMember__c>();
		
		if (this.getOldIdProfile() != null && this.getNewIdProfile() != null) {
			members = [select m.Id,m.User__r.Name, m.TeamProfile__c from TeamMember__c m where m.TeamProfile__c =: this.getOldIdProfile()];
			
			for (TeamMember__c m : members){
				m.TeamProfile__c = this.getNewIdProfile();
			}
			
			update members;
			List<TeamProfile__c> oldProfile = [select Id, Name from TeamProfile__c where id=:this.getOldIdProfile()];
			delete oldProfile;
		}
		
		PageReference reAssignPage = Page.AdminProfileList;
		reAssignPage.setRedirect(true);
		
		if (profileListMode == 'true') {
			return null;
		} else {
			return reAssignPage;
		}
	}

	public String idTeamProfileNoMembers = '';
	/**
	* Set TeamProfile__c Id has no members asoc.
	*@param String
	*/
	public void setIdTeamProfileNoMembers (String idTeamProfileNoMembers) {
		this.idTeamProfileNoMembers = idTeamProfileNoMembers;
	}
	
	/**
	* Remove TeamProfile__c has no members.
	*@return PageReference
	*/
	public PageReference removeTeamProfileNoMembers () {
		if (System.currentPageReference().getParameters().get('idRmvTP') != null) {
			idTeamProfileNoMembers = System.currentPageReference().getParameters().get('idRmvTP');
		}
		List<TeamProfile__c> teamProfileToRemove = [select id from TeamProfile__c where id=: idTeamProfileNoMembers];
		delete 	teamProfileToRemove;
		PageReference reAssignPage = Page.AdminProfileList;
		reAssignPage.setRedirect(true);
		return reAssignPage;	
	}
		
}
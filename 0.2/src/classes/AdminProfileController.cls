public class AdminProfileController {
	
	public TeamProfile__c teamProfile;
	public String section;
	
	public AdminProfileController(){
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
		}
		else if(teamProfileId != null){
			idTeamProf = teamProfileId;
			setSection('edit');
		}else if (teamProfileView != null){
			idTeamProf = teamProfileView;
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
									t.CreateBlogs__c 
							 From TeamProfile__c t
							 Where t.Id =: idTeamProf];
		}else{
			teamProfile = new TeamProfile__c();	
		}					 
	}
	
	public boolean getIsAClone(){
		String clon = System.currentPageReference().getParameters().get('clone');
		if(clon != null){
			return true;
		}
		return false;
	}
		
	
	public TeamProfile__c getTeamProfile(){
		return teamProfile;
	}
	
	public void setTeamProfile (TeamProfile__c t){
		teamProfile = t;
	}
	
	public Id getQueueGroupId(){
		
		Group teamAdmin = [SELECT Id FROM Group WHERE Name = 'Team Admin'];	
                                       
        return teamAdmin.Id;
	}
	
	public boolean getPermissionAuthorApex(){
		User user = [Select u.Profile.Name, u.Profile.PermissionsAuthorApex, u.ProfileId, u.Name, u.Id From User u Where Id =: UserInfo.getUserId()];
		return user.Profile.PermissionsAuthorApex;
	}
	
	public boolean getIsTeamAdminMember(){
		
		List<GroupMember> groupMember= [SELECT Id
                                        FROM GroupMember
                                        WHERE GroupId =: getQueueGroupId()
                                        AND UserOrGroupId =: UserInfo.getUserId()];
                                        
        if(getPermissionAuthorApex() && groupMember.size() != 0){
        	return true;
        }
        
        return false;
	}
	
	public String getSection(){
		return section;
	}
	public void setSection(String newSection){
		section = newSection;
	}
	
	public void asignSection(){
		setSection(System.currentPageReference().getParameters().get('section'));
	}
	
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
	
	public boolean getExistName(){
		for(TeamProfile__c t : getAllTeamProfiles()){
			if(t.Name == teamProfile.Name && section == 'clone'){
				return true;
			}
		}	
		return false;
	}					   
	   
						   
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
		
		PageReference pageRef = new PageReference('/apex/AdminProfileList?success='+section);
		pageRef.setRedirect(true);
		return pageRef;
	}
}
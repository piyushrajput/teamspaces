/**
*@author Juan Bessonart @ 07/22/2008
*/
public class UserPermissions {

	/* Vars */
	String id;
	String team;
	String objectType;
	String ownerId;
	
	User teamAdmin = null;
	List<TeamMember__c> members = null;
	List<Team__c> currentTeam = null;
	TeamProfile__c profile = null;
	
	/* Booleans */
	Boolean canCreate = false;
	Boolean canManage = false;
	Boolean canComment = false;
	Boolean canView = true;
	
	/**
	* Costructor
	*/
	public UserPermissions (){
		
	}
	
	/**
	*@return String
	*/
	public String getId () {
		return id;
	}
	
	/**
	*@return String
	*/
	public String getTeam () {
		return team;
	}
	
	/**
	*@return String
	*/
	public String getObjectType () {
		return objectType;
	}
	
	/**
	*@return Boolean
	*/
	public Boolean getCanCreate () {
		return canCreate;
	}
	
	
	/**
	*@return Boolean
	*/
	public Boolean getCanManage () {
		return canManage;
	}
	
	/**
	*@return Boolean
	*/
	public Boolean getCanComment () {
		return canComment;
	}
	
	/**
	*@return Boolean
	*/
	public Boolean getCanView () {
		return canView;
	}
	
	/**
	*@param String
	*/
	public void setId (String id) {
		this.id = id;
	}
	
	/**
	*@param String
	*/ 	
 	public void setOwnerId (String ownerId) {
		this.ownerId = ownerId;
	}
	
	/**
	*@param String
	*/	
	public void setTeam (String team) {
		this.team = team;
	}
	
	/**
	*@param String
	*/	
	public void setObjectType (String objectType) {
		this.objectType = objectType;
	}
	
	/**
	* Get permissions for current user
	*@throws Exception
	*/
	public void setPermissions () {
		try{
			canManage = false;
			canCreate = false;
			canComment = false;
			Boolean isAdmin = false;			
			
			if(teamAdmin == null || teamAdmin.Id != UserInfo.getUserId())
				teamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =: id limit 1];

			if(teamAdmin.Profile.PermissionsModifyAllData){
				canManage = true;
				canCreate = true;
				canView = true;
				canComment = true;
				isAdmin = true;
			}
			if(!isAdmin){
				if(members == null){
					members = new List<TeamMember__c>();
					members = [select TeamProfile__r.PostWikiComments__c, 
									TeamProfile__r.PostDiscussionTopicReplies__c,
									TeamProfile__r.PostBookmarkComments__c,
									TeamProfile__r.PostBlogComments__c,
									TeamProfile__r.ManageWikis__c,
									TeamProfile__r.ManageTeams__c,
									TeamProfile__r.ManageAttachments__c,
									TeamProfile__r.ManageProjectTasks__c,
									TeamProfile__r.ManageDiscussionForums__c,
									TeamProfile__r.ManageBookmarks__c,
									TeamProfile__r.ManageBlogs__c,
									TeamProfile__r.CreateWikiPages__c, 
									TeamProfile__r.CreateProjectTasks__c,
									TeamProfile__r.CreateDiscussionTopics__c,
									TeamProfile__r.CreateBookmarks__c,
									TeamProfile__r.CreateBlogs__c,
									User__c
							  from TeamMember__c 
							  where User__c =:id 
							  and Team__c=:Team 
							  limit 1];
				}
				// If the user is a member of the team we should use the profile assigned to that user
				if (members.size() > 0) {
					profile = members[0].TeamProfile__r;
				
				// If the user is not a member of the team then we have to go to the public profile of the team
				// to figure out the permissions.
				}else{
					if(currentTeam == null){
						currentTeam = new List<Team__c>();
						List<Team__c> currentTeam = [SELECT PublicProfile__c, 
													 Id,
													 PublicProfile__r.PostWikiComments__c, 
													 PublicProfile__r.PostDiscussionTopicReplies__c,
													 PublicProfile__r.PostBookmarkComments__c,
													 PublicProfile__r.PostBlogComments__c,
													 PublicProfile__r.ManageWikis__c,
													 PublicProfile__r.ManageTeams__c,
													 PublicProfile__r.ManageAttachments__c,
													 PublicProfile__r.ManageProjectTasks__c,
													 PublicProfile__r.ManageDiscussionForums__c,
													 PublicProfile__r.ManageBookmarks__c,
													 PublicProfile__r.ManageBlogs__c,
													 PublicProfile__r.CreateWikiPages__c, 
													 PublicProfile__r.CreateProjectTasks__c,
													 PublicProfile__r.CreateDiscussionTopics__c,
													 PublicProfile__r.CreateBookmarks__c,
													 PublicProfile__r.CreateBlogs__c
											  FROM Team__c
											  WHERE Id =: Team];
										
						if(currentTeam.size() > 0) 
							profile = currentTeam[0].PublicProfile__r;
					}
				}				
				if (profile != null) {
					/*		WIKI		*/
					if (objectType == 'Wiki') {
						if(profile.CreateWikiPages__c) 	
							canCreate = true;
						if(profile.PostWikiComments__c) 
							canComment = true;
						if(profile.ManageWikis__c){ 
							canManage = true; 
							canCreate = true; 
							canComment = true; 
						}
					}
					/*		PROJECT		*/
					if (objectType == 'Project') {
						if(profile.CreateProjectTasks__c)
							canCreate = true;	
						if (profile.ManageProjectTasks__c){
							canManage = true; 
							canCreate = true;
						}
					}
					/*		DISCUSSION		*/
					if (objectType == 'Discussion') {
						if(profile.CreateDiscussionTopics__c)
							canCreate = true;
						if(profile.PostDiscussionTopicReplies__c)
							canComment = true;
						if (profile.ManageDiscussionForums__c){
							canManage = true;
							canCreate = true;
							canComment = true;
						}					
					}						
					/*     TEAM   */
					if(objectType == 'Team') {
						if(profile.ManageTeams__c)
							canManage = true;
					}
					/*     ATTACHMENT   */
					if(objectType == 'Attachment') {
						if(profile.ManageAttachments__c)
							canManage = true;
					}
				}
			}
			
			String canManageStr = (canManage) ? 'true' : 'false';
			System.debug('\n\n User Permissions Results: \n\tObject: ' + objectType + '\n\tCan Manage: ' + canManage + '\n\tCan Create: ' + canCreate+ '\n\tCan Comment: ' + canComment + '\n\tCan View: ' + canView + '\n\n');
			
			if(ownerId == id) 
				canManage = true;  // Shouldnt this be called user UserId?
		}catch(Exception e){
			throw e;
		}
	}
}
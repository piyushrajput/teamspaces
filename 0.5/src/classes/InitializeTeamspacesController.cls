public class InitializeTeamspacesController {

	//Action history
	public Boolean alreadyRun {get; set;}
	public Boolean insertWidget {get; set;}
	public Boolean insertProfiles {get; set;}
	
	
	//Asoc. widget name with component name
	static final Map<String, String> widgets  = new Map<String, String>{'Attachments' => 'TeamsWidgetAttachments', 
																		'Tasks' => 'TeamsWidgetTasksMain',
																		'Recent WikiPages' => 'TeamsWidgetRecentWikiPages', 
																		'Recent Activities' => 'TeamsWidgetRecentActivities',
																		'Active Discussions' => 'TeamsWidgetActiveDiscussions',
																		'Milestones' => 'TeamsWidgetMilestones', 
																		'Wiki Directory' => 'TeamsWidgetWikiDirectory'};
	//Default profiles
	static final Set<String> profiles = new Set<String> {'Team Administrator', 'Read Only', 'Individual Contributor'};
	
	public InitializeTeamspacesController(){
		//Only for Admin use
		TeamUtil.isAdminMemberUser();
		
		alreadyRun = false;
	}
	
	/**
	* Initialize
	*@void
	*/
	public void initialize(){

		insertWidget = false;
		insertProfiles = false;

		/* ### Default Widgets ### */
		List<Widget__c> widgetList = new List<Widget__c>();
		Set<String> widgetNames = new Set<String>();
		
		widgetList = [select w.Id, w.Name, WidgetUrl__c from Widget__c w where w.Type__c = 'Widget'];
		for(Widget__c widget : widgetList)
			widgetNames.add(widget.Name);	
		
		Widget__c newWidget;
		widgetList.clear();
		
		for(String widgetName : widgets.keySet()){
			if(!widgetNames.contains(widgetName)){
				newWidget = new Widget__c();	
				newWidget.Name = widgetName;
				newWidget.WidgetUrl__c = widgets.get(widgetName);
				newWidget.Type__c = 'Widget';
				System.debug('\n --- Add Widget:' + widgetName + '--- \n');
				widgetList.add(newWidget);
			}
		}
		
		if(widgetList.size() > 0){
			insertWidget = true;
			insert widgetList;
		}
		
		/* ### Default Profiles ###*/
		List<TeamProfile__c> profilesList = new List<TeamProfile__c>();
		Set<String> profilesNames = new Set<String>(); 
		
		profilesList = [select p.Id, p.Name from TeamProfile__c p];
		for(TeamProfile__c profile : profilesList)
			profilesNames.add(profile.Name);
			 
		for(String profileName : profiles){
			if(!profilesNames.contains(profileName)){
				createProfile(profileName);	
			}
		}
		
		alreadyRun = true;
	}
	
	/**
	* Create profile
	*@void
	*/
	public void createProfile (String name){
		
		TeamProfile__c profile = new TeamProfile__c(); 
		if(name == 'Team Administrator'){
			profile.Name = name;
			profile.ManageAttachments__c = true;
			profile.ManageProjectTasks__c = true;
			profile.ManageTeams__c = true;
			profile.ManageBookmarks__c = true;
			profile.ManageDiscussionForums__c = true;
			profile.PostBookmarkComments__c = true;
			profile.PostDiscussionTopicReplies__c = true;
			profile.CreateBookmarks__c = true;
			profile.CreateDiscussionTopics__c = true;
			profile.CreateWikiPages__c = true;
			profile.PostBlogComments__c = true;
			profile.ManageWikis__c = true;
			profile.PostWikiComments__c = true;
			profile.CreateProjectTasks__c = true;
			profile.CreateBlogs__c = true;
		}else if (name == 'Read Only'){
			profile.Name = name;
		}else if (name == 'Individual Contributor'){
			profile.Name = name;
			profile.PostDiscussionTopicReplies__c = true;
			profile.CreateDiscussionTopics__c = true;
			profile.CreateWikiPages__c = true;
			profile.PostWikiComments__c = true;
			profile.CreateProjectTasks__c = true;
		}
		
		if(profile.Name != null){
			System.debug('\n --- Add profile:' + profile.Name + '--- \n');
			insertProfiles = true;
			insert profile;
		}
	}

}
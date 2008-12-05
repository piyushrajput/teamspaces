public class GenerateEnvironmentTest {
    
    public static Team__c newTeam = new Team__c();
    public static TeamProfile__c newTeamProfile = new TeamProfile__c();
    public static TeamMember__c newTeamMember = new TeamMember__c();
    public static ProjectTask__c newTask = new ProjectTask__c();
    public static Team__c newSubTeam = new Team__c();
    public static DiscussionTopic__c newTopic = new DiscussionTopic__c();
    public static DiscussionForum__c newForum = new DiscussionForum__c();
    public static WikiPage__c newWiki = new WikiPage__c();
    public static DiscussionMessage__c newMessage = new DiscussionMessage__c();
    
    //Boolen for run minimal date gen
    public static Boolean runLite = false;
    
    public static testMethod void gen(){
        if (!TeamUtil.alreadyGenEnv) {
            // Create a new Team Administrator Profile
            newTeamProfile.Name = 'Team Administrator';
            newTeamProfile.PostWikiComments__c = true; 
            newTeamProfile.PostDiscussionTopicReplies__c = true; 
            newTeamProfile.PostBookmarkComments__c = true; 
            newTeamProfile.PostBlogComments__c = true;  
            newTeamProfile.ManageWikis__c = true; 
            newTeamProfile.ManageTeams__c = true; 
            newTeamProfile.ManageProjectTasks__c = true; 
            newTeamProfile.ManageDiscussionForums__c = true; 
            newTeamProfile.ManageBookmarks__c = true; 
            newTeamProfile.ManageBlogs__c = true; 
            newTeamProfile.CreateWikiPages__c = true; 
            newTeamProfile.CreateProjectTasks__c = true; 
            newTeamProfile.CreateDiscussionTopics__c = true; 
            newTeamProfile.CreateBookmarks__c = true; 
            newTeamProfile.CreateBlogs__c = true;
            upsert newTeamProfile;
            
			Attachment attach = new Attachment();
            attach.Name = 'Test';
            attach.Body = Blob.valueOf('Content');
            attach.ParentId = newTeamProfile.Id;
            insert attach;
            
            //Create new PeopleProfile
            PeopleProfile__c peopleProfile = new PeopleProfile__c();
            peopleProfile.Name = 'Test';
            peopleProfile.User__c = UserInfo.getUserId();
            peopleProfile.Picture__c = attach.Id;
            insert peopleProfile;
            
            
            // Create a new Team
            newTeam.Name = 'Test class Team';
            newTeam.NewMemberProfile__c = newTeamProfile.Id;
            newTeam.Picture__c = attach.Id;
            newTeam.Description__c = 'Team description';
            
            upsert newTeam;  
            
            // Create a new SubTeam
            if(!runLite){
	            newSubTeam.Name = 'Test class Sub Team';
	            newSubTeam.NewMemberProfile__c = newTeamProfile.Id;
	            newSubTeam.ParentTeam__c = newTeam.Id;
	            upsert newSubTeam; 
            }
            
            // Create a new User
            Profile p = [select id from profile where name='Standard User'];
            User newUser = new User(alias = 'standt', email='standarduser@testorg.com', 
                                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
                                    localesidkey='en_US', profileid = p.Id, 
                                    timezonesidkey='America/Los_Angeles', username='standarduser2@testorg.com');
            insert newUser;
            
            // Create a new Team Member
            newTeamMember.TeamProfile__c = newTeamProfile.Id;
            newTeamMember.User__c = newUser.Id;
            newTeamMember.Team__c = newTeam.Id;
            newTeamMember.TeamRole__c = 'Foo Role';
            upsert newTeamMember;
            
            
            // Create a new Wiki
            newWiki.Name = 'Foo Wiki';
            newWiki.Team__c = newTeam.Id;
            newWiki.Body__c = 'Foo Body';
            upsert newWiki;
            
            //Create a new Discussion Topic
            
            newForum = [select id from DiscussionForum__c where team__c =:newTeam.Id limit 1];
            newTopic.Subject__c = 'Foo Topic';  
            newTopic.Team__c = newTeam.Id;
            newTopic.DiscussionForum__c = newForum.Id;
            upsert newTopic;
    
            // Create the First Discussion Message 
            newMessage.Discussiontopic__c = newTopic.Id;
            newMessage.Team__c = newTeam.Id;
            newMessage.Message__c = 'Foo Text';     
            upsert newMessage;
            
            // Create a new Project Task
            newTask.Name = 'Foo Task';
            newTask.team__c = newTeam.Id;
            newTask.StartDate__c = System.now();
            newTask.EndDate__c = System.now();
            newTask.Duration__c = 1;
            newTask.Percent_Completed__c = 0;
            newTask.Milestone__c = true; 
            upsert newTask;   
            
            // Create a new Task Assign
            ProjectAssignee__c newAssignee = new ProjectAssignee__c();
            newAssignee.User__c = UserInfo.getUserId();
            newAssignee.Team__c = newTeam.Id;
            newAssignee.PercentDedicated__c = 0; 
            newAssignee.ProjectTask__c = newTask.Id;
            upsert newAssignee; 
            
            //
            TeamUtil.alreadyGenEnv = true; 
        }
    }
    
    public static void createTeamType(){
            //Create a new Team Type
            TeamType__c teamType = new TeamType__c(); 
            teamType.Name = 'Some name';
            upsert teamType;
            newTeam.TeamType__c = teamType.Id;
            update newTeam;
    }
}
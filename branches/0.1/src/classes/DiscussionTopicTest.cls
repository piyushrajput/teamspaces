public class DiscussionTopicTest {

  	public static Boolean sortByDesc = false;
	public static String sortBy = 'LastPostedMessage__c';
	public static String USERID = UserInfo.getUserId();
	
	public static testMethod void testDiscussion() {
	
	DiscussionTopicsController dis= new  DiscussionTopicsController ();
	List<DiscussionTopicsController.TopicList> topicList =dis.fillTopicList();
	DiscussionTopicsController.TopicList top = new DiscussionTopicsController.TopicList();
	
	DiscussionMessage__c[] disMessage= [Select id from DiscussionMessage__c]; 
	
	String info = top.lastPostInfoString(disMessage[0].id);
	List<TeamMember__c> userTeams = new List<TeamMember__c>();
	userTeams = [SELECT Team__c, TeamProfile__c FROM TeamMember__c WHERE User__c =: USERID];
   
    TeamMember__c teams = userTeams.get(0);
    
    List<TeamProfile__c> profileList=[SELECT CreateDiscussionTopics__c,ManageDiscussionForums__c,PostDiscussionTopicReplies__c FROM TeamProfile__c WHERE id=: teams.TeamProfile__c];
    TeamProfile__c profile = profileList.get(0);

    boolean createDiscussionTopics = profile.createDiscussionTopics__c;
	System.assert(createDiscussionTopics==true,'Tiene Discussion Topics ');
	boolean manageDiscussionForums= profile.ManageDiscussionForums__c;
	System.assert(createDiscussionTopics==false,'Tiene Manage Discussion ');
	boolean postDiscussionTopicReplies= profile.PostDiscussionTopicReplies__c;
	System.assert(createDiscussionTopics==false,'Tiene Discussion Topics ');
	/*
	
		para este usuario
		conseguir el team member Id de el usuario 
		consegui el team profile Id para ese team member Id
		fijarse que persmisos tiene y assertar para cada caso ABM para ese usuario.
	*/
	
	
	System.assert(info==null,'No existe info');
	DiscussionForum__c disForum =  dis.getForumData();
	dis.saveTopic ();
	List<DiscussionTopic__c> lisDis= dis.getMostRead ();
	boolean permiso = dis.getPermissionAuthorApex();
	System.assert(permiso==false,'No tiene permiso');
	boolean isTeamAdminMember = dis.getIsTeamAdminMember();
	
	String resultSort= dis.getSortBy ();
	System.assert(sortBy=='lastReplies','OK');
	dis.sortList () ;
	
	}	
	
	
	
}
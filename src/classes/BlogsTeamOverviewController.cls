public class BlogsTeamOverviewController {

	Team__c teamspace;
	
	public BlogsTeamOverviewController() {
		
		teamspace = [SELECT Name
					 FROM Team__c
					 WHERE Id =: System.currentPageReference().getParameters().get('id')];
	}
	
	public void auxAction (){
		System.debug('ENTRO AL ACTION');
	}
	
	public Team__c getTeamspace() {
		return teamspace;
	}
	
	public List<AnnouncementGroup> getMyTeam() {
				
		
		// get list
		List<BlogEntry__c> myTeams = [SELECT Title__c,
									  		    Team__c,
									  			Message__c,
									  			CreatedDate,
									  			CreatedById,
									  			(Select Id From Attachments Order By CreatedDate DESC Limit 1)									  			
							   			 FROM BlogEntry__c
							   			 WHERE Team__c =: teamspace.Id
							   			 ORDER BY CreatedDate DESC
							             LIMIT 10];
				

		return sortAnnouncements(myTeams);
	}
	
	public List<AnnouncementGroup> getAllTeam() {
		
		// get list
		List<BlogEntry__c> allTeams = [SELECT Title__c,
									  			 Team__c,
									  			 Message__c,
									  			 CreatedDate,
									  			 CreatedById,
									  			 (Select Id From Attachments Order By CreatedDate DESC Limit 1)
							   			  FROM BlogEntry__c
							   			  ORDER BY CreatedDate DESC
							              LIMIT 10];

		
		return sortAnnouncements(allTeams);

	}
	
	/*
	 * sort into announcement groups
	 */
	private List<AnnouncementGroup> sortAnnouncements(List<BlogEntry__c> announcements) {
		
		List<AnnouncementGroup> groupList = new List<AnnouncementGroup>();
		AnnouncementGroup currentGroup = null;
		Announcement an = null;
		
		for(BlogEntry__c a: announcements) {			
		
			if(currentGroup == null || 
			   !currentGroup.getPostedDate().isSameDay(a.CreatedDate)) {
			    currentGroup = new AnnouncementGroup(a.CreatedDate);
			    an = new Announcement(a);
			    currentGroup.addAnnouncement(an);		   	
				groupList.add(currentGroup);
			} else {
			    an = new Announcement(a);
			    currentGroup.addAnnouncement(an);
			}
				
		}	
		
		return groupList;
	}
	
	public class AnnouncementGroup {
		
		List<Announcement> announcements = new List<Announcement>();
		Datetime postedDate;
		
		public AnnouncementGroup (Datetime a) {
			postedDate = a;
		}
		
		public Datetime getPostedDate() {
			return postedDate;
		}
		
		public String getFormatedPostDate() {
			return postedDate.format('MMMM dd, yyyy');
		}
		
		public void addAnnouncement(Announcement a) {
			announcements.add(a);
		}
		
		public List<Announcement> getAnnouncements() {
			return announcements;
		}
	}
	
	public class Announcement {
		BlogEntry__c announcement;
		String picture;
		
		public Announcement(BlogEntry__c a){
			if(a.Attachments.size() == 0){
				picture = '';
			}else{
				picture = a.Attachments[0].Id;
			}
			//picture = a.Attachments[0].Id;
			
			//System.debug(a);
			announcement = a;
		}
		
		public String getPicture(){
			return picture;
		}
		
		public BlogEntry__c getAnnouncement(){
			return announcement;
		}
	}
}
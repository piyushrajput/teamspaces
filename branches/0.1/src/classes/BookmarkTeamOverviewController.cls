public class BookmarkTeamOverviewController {

	Team__c teamspace;
	
	public BookmarkTeamOverviewController() {
		
		teamspace = [SELECT Name
					 FROM Team__c
					 WHERE Id =: System.currentPageReference().getParameters().get('id')];
	}
	
	public Team__c getTeamspace() {
		return teamspace; 
	}
	
	public List<BookmarkGroup> getMyTeam() {
				
		
		// get list
		List<Bookmark__c> myTeams = [SELECT Title__c,
									  		    Team__c,
									  		    
									  			Body__c,
									  			Comments__c,
									  			// Comment__c,
									  			BookmarkURL__c,
									  			ImageUrl__c,									  			
									  			CreatedDate,
									  			CreatedById
							   			 FROM Bookmark__c
							   			 WHERE Team__c =: teamspace.Id
							   			 ORDER BY CreatedDate DESC
							             LIMIT 10];
				

		return sortBookmarks(myTeams);
	}
	
	public List<BookmarkGroup> getAllTeam() {
		
		// get list
		List<Bookmark__c> allTeams = [SELECT Title__c,
									  			 Team__c,
									  			 
									  			 Body__c,
									  			 Comments__c,
									  			//  Comment__c,
									  			 BookmarkURL__c,
									  			 ImageUrl__c,									  			 
									  			 CreatedDate,
									  			 CreatedById
							   			  FROM Bookmark__c
							   			  ORDER BY CreatedDate DESC
							              LIMIT 10];
		
		return sortBookmarks(allTeams);

	}
	
	/*
	 * sort into bookmark groups
	 */
	private List<BookmarkGroup> sortBookmarks(List<Bookmark__c> bookmarks) {
		
		List<BookmarkGroup> groupList = new List<BookmarkGroup>();
		BookmarkGroup currentGroup = null;
		
		for(Bookmark__c a: bookmarks) {			
		
			if(currentGroup == null || 
			   !currentGroup.getPostedDate().isSameDay(a.CreatedDate)) {
			    currentGroup = new BookmarkGroup(a.CreatedDate);
			    currentGroup.addBookmark(a);		   	
				groupList.add(currentGroup);
			} else {
				currentGroup.addBookmark(a);
			}
				
		}	
		
		return groupList;
	}
	
	public class BookmarkGroup {
		
		List<Bookmark__c> bookmarks = new List<Bookmark__c>();
		Datetime postedDate;
		
		public BookmarkGroup (Datetime a) {
			postedDate = a;
		}
		
		public Datetime getPostedDate() {
			return postedDate;
		}
		
		public String getFormatedPostDate() {
			return postedDate.format('MMMM dd, yyyy');
		}
		
		public void addBookmark(Bookmark__c a) {
			bookmarks.add(a);
		}
		
		public List<Bookmark__c> getBookmarks() {
			return bookmarks;
		}
	}
}
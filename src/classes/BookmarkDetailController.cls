public class BookmarkDetailController {
	// COLLABSUITE-883
	Bookmark__c bookmark;
	
	 Comment__c newComment;
	
	public BookmarkDetailController(ApexPages.StandardController controller) {
    	bookmark = (Bookmark__c)controller.getRecord();
    	
    	// I am going to query the datebase for the information 
    	// that should already be in the bookmark object b/c at
    	// the time of writing this code the stardcontroller overide has some
    	// issues.  When it gets over it issues you can delete this block of
    	// code
    	bookmark = [SELECT Title__c, 
    							
    						   Body__c,
    						   Team__c,
    						   Team__r.Name,
    						   Comments__c,
    						 //   Comment__c,
							   BookmarkURL__c,
							   ImageUrl__c,
    						   CreatedDate,
    						   CreatedById
    					FROM Bookmark__c
    					WHERE Id =: bookmark.Id];
    	
    	// newComment = new Comment__c(Bookmark__c = bookmark.Id);
    }
    
    public String getPostedDate() {
    	return bookmark.CreatedDate.format('MMMM dd, yyyy');    	
    }
    
    public List<Comment> getComments() {
    	
    	List<Comment__c> comments = [SELECT Id,
    									    Message__c, 
    									    CreatedDate, 
    									    CreatedById
    								 FROM Comment__c
    								 WHERE Bookmark__c =: bookmark.Id
    								 ORDER BY CreatedDate ASC];
    	// Get list of users
    	
    	Set<Id> users = new Set<Id>();
    							 
    	for(Comment__c c: comments) {
    		users.add(c.CreatedById);
    	}
    	
    	Map<Id, Id> userProfileMap = new Map<Id, Id>();
    	for(PeopleProfile__c p: [SELECT Picture__c,
    									User__c
    							 FROM PeopleProfile__c
    							 WHERE User__c IN: users]) {
    		userProfileMap.put(p.User__c, p.Picture__c);						 	
    	}
    	
    	List<Comment> commentWrappers = new List<Comment>();
    	
    	// create comments wrapper
    	for(Comment__c c: comments) {
    		commentWrappers.add(new Comment(c, userProfileMap.get(c.CreatedById)));
    	}
    	
    	return commentWrappers;
    }

    
    public class Comment {
    	
    	Comment__c comment;
    	Id imageId;
    	
    	public Comment(Comment__c c, Id i) {
    		comment = c;
    		imageId = i;
    	}
    	
    	public String getFormatedCommentDate() {
    		return comment.CreatedDate.format('MMM dd, yyyy');
    	}
    	
    	public String getFormatedCommentTime() {
    		return comment.CreatedDate.format('hh:mm aa');
    	}
    	
    	public Id getUserImageId() {
    		if(imageId == null) return '01530000000VO5s';
		    else             return imageId;
    	}

    	public Comment__c getDetail() {
    		return comment;
    	}
    }

   
    public PageReference savePost() {
    	
    	// Refresh the new comment object for the next post
    	newComment = new Comment__c(Bookmark__c = bookmark.Id);
    	insert newComment;
    	// Increment the count for display
    	// The trigger updates the database
    	bookmark.Comments__c += 1;
    	
    	return null;
    }
    
    public Comment__c getNewComment() {
    	return newComment;
    } 
	
	
}
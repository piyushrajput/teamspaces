public class BlogDetailsController {
	
	BlogEntry__c blogEntry;
	Comment__c newComment;
	
	public BlogDetailsController(ApexPages.StandardController controller) {
    	blogEntry = (BlogEntry__c)controller.getRecord();
    	
    	// I am going to query the datebase for the information 
    	// that should already be in the blogEntry object b/c at
    	// the time of writing this code the stardcontroller overide has some
    	// issues.  When it gets over it issues you can delete this block of
    	// code
    	blogEntry = [SELECT Title__c, 
    						   Message__c,
    						   Team__c,
    						   Owner.Name,
    						   OwnerId,
    						   Team__r.Name,
    						   CreatedDate,
    						   CreatedById
    					FROM BlogEntry__c
    					WHERE Id =: blogEntry.Id];
    	if(blogEntry != null){
    		newComment = new Comment__c(BlogEntry__c = blogEntry.Id);
    	}
    }
    
    public BlogEntry__c getBlogEntry(){
    	return blogEntry;
    }
    public String getBlogEntryTitle () {
    	return blogEntry.Title__c;	
    }
    
    public String getBlogEntryMessage () {
    	return blogEntry.Message__c;	
    }  
    
    public String getBlogEntryCreatedDate () {
    	return blogEntry.CreatedDate.format('MMMM dd, yyyy');	
    }    
    
    public String getBlogEntryTeamId() {
    	return blogEntry.Team__c;
    }

    public String getBlogEntryTeamName() {
    	return blogEntry.Team__r.Name;
    }
	
    /*
    public PageReference goToTeam() {
		String url = '/apex/TeamsRedirect?id='+getBlogEntryTeamId();	
		return forwardTo(url);
	}    
    */
    public String getBlogEntryCreatedById () {
    	return blogEntry.CreatedById;	
    }              
    /*
    public PageReference forwardTo (String url) {
		PageReference page = new pageReference(url);
		page.setRedirect(true);
		return page;
	}
    */
    public List<Comment> getComments() {
    	
    	List<Comment__c> comments = [SELECT Id,
    									    Message__c,
    									    Owner.Name,
    									    OwnerId, 
    									    CreatedDate, 
    									    CreatedById
    								 FROM Comment__c
    								 WHERE BlogEntry__c =: blogEntry.Id
    								 ORDER BY CreatedDate ASC];
    	// Get list of users
    	/*
    	Set<Id> users = new Set<Id>();
    							 
    	for(Comment__c c: comments) {
    		users.add(c.CreatedById);
    	}
    	
    	Map<Id, Id> userProfileMap = new Map<Id, Id>();
    	Map<Id, String> userNameMap = new Map<Id, String>();
    	
    	for(PeopleProfile__c p: [SELECT Picture__c,
    									User__c,
    									Name
    					
    							 FROM PeopleProfile__c
    							 WHERE User__c IN: users]) {
    		userProfileMap.put(p.User__c, p.Picture__c);	
    		userNameMap.put(p.User__c, p.Name);					 	
    	}
    	
    	List<Comment> commentWrappers = new List<Comment>();
    	
    	
    	// create comments wrapper
    	for(Comment__c c: comments) {
    		commentWrappers.add(new Comment(c, userProfileMap.get(c.CreatedById), userNameMap.get(c.CreatedById)));
    	}
    	
    	return commentWrappers;
    	*/
    	List<Comment> commentWrappers = new List<Comment>();
    	for(Comment__c c: comments) {
    		Comment comment = new Comment(c);
    		comment.setPicture(c.OwnerId);
    		commentWrappers.add(comment);
    	}
    	return commentWrappers;	
    }
    
    public Integer getCommentsSize(){
    	return getComments().size();
    }
    
    public class Comment {
    	
    	String userPicture;
    	Comment__c comment;
    	Id imageId;
    	String name;
    	
    	public Comment(Comment__c c, Id i, String n) {
    		comment = c;
    		imageId = i;
    		name = n;
    	}
    	
    	public Comment(Comment__c c) {
    		comment = c;
    	}
    	
    	public String getFormatedCommentDate() {
    		return comment.CreatedDate.format('MMM dd, yyyy');
    	}
    	
    	public String getName(){
    		return comment.Owner.Name;
    	}
    	public String getMessage(){
    		return comment.Message__c;
    	}
    	
    	public String getFormatedCommentTime() {
    		return comment.CreatedDate.format('hh:mm aa');
    	}
    	
    	public boolean getIsUserOwner(){
			if(comment.OwnerId == userInfo.getUserId()){
				return true;
			}
			return false;
		}
    	/*
    	public Id getUserImageId() {
    		if(imageId == null) return '01530000000VO5s';//esto deberia usar el nombre de un static resource y no un id.
		    else             	return imageId;
    	}
		
    	public Comment__c getDetail() {
    		return comment;
    	}
    	*/
    	public String getPicture(){
			return this.userPicture;
		}
    	
    	public void setPicture (String userId) {
			String PictureId;
			Integer cntPicture;
			
			cntPicture = [SELECT count() FROM PeopleProfile__c WHERE User__c =: userId];
			
			if (cntPicture != 0) {
				PeopleProfile__c picture = [SELECT Picture__c FROM PeopleProfile__c WHERE User__c =: userId limit 1];
		        if(picture.Picture__c == '' || picture.Picture__c == null) {                	                                          	 
			     	PictureId = '01530000000VO5s';
				} 
				else {
					PictureId = picture.Picture__c;
				} 
			}
			else {
				PictureId = '01530000000VO5s';
			}
   			this.userPicture = PictureId ;
   		}
    }
    
    public String messageBody = '';
    
	public void setMessageBody (String s) {
		this.messageBody = s;
	}
	
	public String getMessageBody () {
		return messageBody;
	}
	
    public void savePost() {
    	// Refresh the new comment object for the next post
    	//newComment = new Comment__c(BlogEntry__c = blogEntry.Id);
    	newComment = new Comment__c();
    	newComment.BlogEntry__c = System.currentPageReference().getParameters().get('id');
    	newComment.Message__c = getMessageBody();
    	
    	insert newComment;
        
        messageBody = '';
       // return null;
    }
    
    public Comment__c getNewComment() {
    	return newComment;
    }
}
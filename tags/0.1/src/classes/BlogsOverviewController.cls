public class BlogsOverviewController {

	List<TeamMember__c> myTeams = new List<TeamMember__c>();
	// Set<Id> teams = new Set<Id>();
	String tabControl;	
	Integer countDraft;
	
	List<BlogEntry__c> blogs = new List<BlogEntry__c>();
	public BlogsOverviewController() {
			
		if(System.currentPageReference().getParameters().get('Dra') == null){			
			getRecentBlogs();
				
			tabControl = 'RecentBlogs';
		} else {			
			getDrafts();
			tabControl = 'Drafts';	
		}
												
		totalItemsNumber = blogs.size();
			genCntPagination();

	}
	
	public void getRecentBlogs()
	{
			blogs =  [SELECT Title__c,
							  			 Team__c,
							  			 PostedDate__c,
							  			 Message__c,									  			
							  			 CreatedDate,
							  			 CreatedById,	
							  			 PostedBy__r.Name, 	
							  			 PostedBy__r.Email,							  			 						
										 Team__r.Name, 
										 Name, 													
										 Id, 						
										 CommentCount__c	
					   			  FROM BlogEntry__c
					   			  where PostedDate__c <> null
					   			  ORDER BY PostedDate__c DESC];
					   			  
	}
	
	public void getDrafts()
	{
		blogs =  [SELECT Title__c,
							  			 Team__c,
							  			 PostedDate__c,
							  			 Message__c,									  			
							  			 CreatedDate,
							  			 CreatedById,	
							  			 PostedBy__r.Name, 	
							  			 PostedBy__r.Email,							  			 						
										 Team__r.Name, 
										 Name, 													
										 Id, 						
										 CommentCount__c	
					   			  FROM BlogEntry__c
					   			  where PostedDate__c = null
					   			  ORDER BY CreatedDate DESC];
					   			  	
	}
	
	public String getTabControl(){
		return tabControl;
	}
	
	public Integer getCountDraft(){
				
		countDraft = [SELECT count() FROM BlogEntry__c where PostedDate__c = null];
					   			  
		return countDraft;
	}
	
	public List<TeamMember__c> getTeams() {
		return myTeams;
	}
		 
     public List<BlogsEntry> getAllTeam() {
     	
        boolean monthShow = false ;
	    String dateAlreadyShown = '';
	    String ParsedDate = '';
	    Datetime DateIterator;
	  	    	  	
	    List<BlogsEntry> allblogs = new List<BlogsEntry>();

		     	if (allblogs.size() < 1) {				
						
						for(Integer i = 0; i < blogs.size() ; i++){
						
							BlogsEntry blogE = new BlogsEntry(blogs[i].Team__c,blogs[i].Id,blogs[i].PostedBy__r.Email,blogs[i].PostedBy__r.Id,0,blogs[i].PostedBy__r.Name,blogs[i].Message__c,blogs[i].Title__c,blogs[i].CommentCount__c,blogs[i].Team__r.Name, getBlogEntryImage(blogs[i].Id));		
									             
				            // Set the Date Message 
				            if (tabControl == 'RecentBlogs'){
				            	DateIterator = blogs[i].PostedDate__c;
				            }
				            else{
				            	DateIterator = blogs[i].CreatedDate;
				            }
				           						
							ParsedDate = 'Date' + DateIterator.day() + DateIterator.month() + DateIterator.year();	        		
				               																
								String Month;
								if( DateIterator.month() == 1)  { Month = 'January '; }
								if( DateIterator.month() == 2)  { Month = 'February '; }
								if( DateIterator.month() == 3)  { Month = 'March  '; }
								if( DateIterator.month() == 4)  { Month = 'April '; }
								if( DateIterator.month() == 5)  { Month = 'May '; }
								if( DateIterator.month() == 6)  { Month = 'June '; }
								if( DateIterator.month() == 7)  { Month = 'July '; }
								if( DateIterator.month() == 8)  { Month = 'August '; }
								if( DateIterator.month() == 9)  { Month = 'September '; }
								if( DateIterator.month() == 10)  { Month = 'October '; }
								if( DateIterator.month() == 11)  { Month = 'November '; }
								if( DateIterator.month() == 12)  { Month = 'December '; }
								
								String tempDate = Month + DateIterator.day() + ', ' + DateIterator.year();
								blogE.setDateString(tempDate);
									
								if ( dateAlreadyShown != ParsedDate ){      					
							        blogE.setDateClass('Date');	
							        dateAlreadyShown = 'Date' + DateIterator.day() + DateIterator.month() + DateIterator.year();
								
							    }							        	
					        	else{					        		
									blogE.setDateClass('Date_empty');	
					        	}
						
								
				        	  allblogs.add(blogE);  
	        			}  		
	      		}    
	        	
	        
	        	                     
             return allblogs;       					
		}    					
	
	public List<BlogsEntry> getMostCommented() {
		
		// get list
		List<BlogEntry__c> MostCommented = new List<BlogEntry__c>();
		
		MostCommented = [ SELECT 
								b.PostedBy__c,
								b.Title__c, 
								b.Team__c, 
								b.Team__r.Name, 
								b.Name, 
								b.Message__c,													
								b.Id,
								b.PostedBy__r.Name, 
								b.PostedBy__r.Email, 
										
								b.CommentCount__c 								
								From BlogEntry__c b							
			   			  ORDER BY CommentCount__c DESC
			              LIMIT 5];		
	   
	    List<BlogsEntry> listMostCommented = new List<BlogsEntry>();	
	    
	    for(BlogEntry__c c: MostCommented) {
    		listMostCommented.add(new BlogsEntry(c.Team__c,c.Id,c.PostedBy__r.Email,c.Id,0,c.PostedBy__r.Name,c.Message__c,c.Title__c,c.CommentCount__c,c.Team__r.Name, getBlogEntryImage(c.Id)));
    	}    
	      	              	
		return listMostCommented;
	}
	
	public class BlogsEntry {
    	
    	String title;
    	Integer comments;
    	String imageURL;
    	String name;
    	String message;
    	String user;
    	Integer postedBlogs;
    	Id IdU;
    	Id IdT;
    	Id IdB;
    	String mail;
    	String dateString = '';
    	String DateClass = '';
    	
    	public BlogsEntry(Id idTeam,Id idBlog,String mails, Id idUser,Double p,String u,String m,String t, Double c, String n, String i) {
    		 title = t;
    		 comments = c.intValue();
    		 imageURL = i;
    		 name = n;
    		 message =m;
    		 user = u;
    		 postedBlogs = p.intValue();
    		 IdU = idUser;
    		 mail = mails;
    		 IdT = idTeam;
    		 IdB = idBlog;
    	}
    	
	   public String getDateClass() {
        	return DateClass;		        		       
        }
        
        public void setDateClass(String sDateClass){
                DateClass = sDateClass;
        }  
	        
    	public String getDate(){
    		return dateString;
    	}
    	
      	public void setDateString(String sDateString){
	         dateString = sDateString;
	    }  
	        
    	public String getMail() {
    		return mail;
    	}
    	
    	public Id getIdUser() {
    		return IdU;
    	}
    	
    	public Id getIdBlog() {
    		return IdB;
    	}
    	
    	public Id getIdTeam() {
    		return IdT;
    	}
    	
    	public String getTitle() {
    		return title;
    	}
    	
    	public Integer getPosted() {
    		return postedBlogs;
    	}
    	
    	public String getUser() {
    		return user;
    	}
    	
    	public Integer getComments() {
    		return comments;
    	}
    	
    	public String getImageURL() {
    		return imageURL;
    	}
    	
    	public String getName() {
    		return name;
    	}
    	
    	public String getMessage() {
    		return message;
    	}

	 }
	
	
	 public String getBlogEntryImage(Id param) {	 	
    	List<Attachment> attach = [SELECT Id 
        									 FROM Attachment 
        									 WHERE ParentId =: param];
        	if(attach.size() == 0) return '';					
        	return '/servlet/servlet.FileDownload?file=' + attach[0].Id;
    }
    
     public String getUserImage(Id param) {	 	
    	List<Attachment> attach = [SELECT Id 
        									 FROM Attachment 
        									 WHERE CreatedById =: param];
        	if(attach.size() == 0) return '';					
        	return '/servlet/servlet.FileDownload?file=' + attach[0].Id;
    }
    
   	//********************************************************************************
	//******************* BlogWidgets Most Active People *****************************
	
	public List<PostedUser> getMostActiveUsers(){
	
		Date first = System.today().toStartOfWeek();
    	Datetime firstWeekDay = Datetime.newInstance(first.year(), first.month(), first.day(), 0, 0, 0);
    	Datetime lastWeekDay = firstWeekDay.addDays(7);
		Map<Id, PostedUser> tempmap = new Map<Id, PostedUser>();
		List<PostedUser> mostPostedUsers = new List<PostedUser>();
		Integer i;
		
		for(BlogEntry__c blog : [Select  Title__c,
							  			 Team__c,
							  			 Message__c,							  						  			
							  			 CreatedDate,
							  			 CreatedById,	
							  			 PostedBy__r.Name, 	
							  			 PostedBy__r.Email,							  			 						
										 Team__r.Name, 
										 Name, 	
										 PostedDate__c,												
										 Id, 						
										 CommentCount__c	
					   			  FROM BlogEntry__c
								//Where PostedDate__c <: lastWeekDay 
					 			//AND PostedDate__c >: firstWeekDay
					 			
					 			]){
			
			if(tempmap.containsKey(blog.CreatedById)){
				PostedUser postedUser = tempmap.get(blog.CreatedById);
				Integer tempCount = postedUser.getPostedBlogs() + 1;
				postedUser.setPostedBlogs(tempCount); 
				tempmap.put(blog.CreatedById, postedUser);
			}
			else
			{
				PostedUser postedUser = new PostedUser();
				postedUser.setPostedBlogs(1);
				postedUser.setId (blog.CreatedById);
				postedUser.setName(blog.PostedBy__r.Name);
				postedUser.setPicture (blog.CreatedById);
				tempmap.put(blog.CreatedById, postedUser);
			}
		}	
			
		List<PostedUser> postedUserList = tempmap.values();		 				
		this.sortResult(postedUserList);
		
		for(i = 0; i <= 5; i++ ){
			if(i < postedUserList.size()){
				postedUserList[i].commentCount();
				mostPostedUsers.add(postedUserList[i]);
			}
		}	
		return mostPostedUsers;
	}
	
	public List<PostedUser> sortResult (List<PostedUser> result) {
 		Integer n;
 		Integer i;
 		Integer j;
 		n = result.size() - 1;	
 		for (i = 1; i <= n; i++) {	
 			for (j = n; j >= i ; j--) {
 				if (result.get(j).getPostedBlogs() >= result.get(j - 1).getPostedBlogs()) {
 					PostedUser tempPostedUser;
 					tempPostedUser = result.get(j - 1);
 					result.set(j - 1, result.get(j));
 					result.set(j, tempPostedUser); 	
 				}	
 			}
 		}
 		return result;
 	}	
 	
	
	public class PostedUser{
		
		//******************* Attributs ***************************************
		
		public String userPicture;
		public Integer postedBlogs;
		public String name;
		public Integer commentsCount;
		public String id;
		//*********************************************************************
		//******************* Constructor *************************************
		
		public PostedUser(){
			
		}
		public PostedUser(String id){
			
		}
		
			
		/**
		*@void
		*/
		public void commentCount(){
			this.commentsCount = [Select count() From Comment__c where OwnerId =: id and BlogEntry__c != null];	
		}
		
		//*********************************************************************
		//******************* Getters *****************************************
		
		public Integer getPostedBlogs(){
						
				return 	postedBlogs;
		}	
		
		public String getName(){
		
				return 	name;
		}	
		
		public String getId(){
		
				return 	id;
		}	
		
		public Integer getCommentsCount(){
		
				return 	commentsCount;
		}
		
		public String getPicture(){
			return this.userPicture;
		}
		//********************************************************************
		//******************* Seters *****************************************
		
		public void setPostedBlogs(Integer postBlogs){
				
			postedBlogs = postBlogs;
		}
		
		public void setName(String postName){
				
			name = postName;
		}
		public void setId(String id){
				
			this.id = id;
		}
		public void setCommentsCount(Integer countComments){
				
			commentsCount = countComments;
		}
		
		public void setPicture (String userId) {
			String PictureId;
			Integer cntPicture;
			
			cntPicture = [SELECT count() FROM PeopleProfile__c WHERE User__c =:userId];
			
			if (cntPicture != 0) {
				PeopleProfile__c picture = [SELECT Picture__c FROM PeopleProfile__c WHERE User__c =:userId limit 1];
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
		//*******************************************************************
	}
	
	 //********************************************************************************
	//******************* BlogWidgets My Recent  *****************************
	
	public List<BlogsEntry> getMyRecentBlogs(){
		
		List<BlogEntry__c> myRecentBlogs = new List<BlogEntry__c>();
		
		myRecentBlogs = [SELECT 		Id,
										Name,
										Title__c, 
										Team__c, 
										Team__r.Name, 										
										PostedBy__r.Name, 
										PostedBy__r.Email,		
										PostedBy__r.Id, 				
										CommentCount__c 								
										From BlogEntry__c 		
			   			  	WHERE CreatedById =: userInfo.getUserId()
			   			  	ORDER BY PostedDate__c DESC
			              	LIMIT 5];
			              	
		  List<BlogsEntry> listRecent = new List<BlogsEntry>();	
	    
	    for(BlogEntry__c c: myRecentBlogs) {
    		listRecent.add(new BlogsEntry(c.Team__c,c.Id,c.PostedBy__r.Email,c.Id,0,'','',c.Title__c,c.CommentCount__c,c.Team__r.Name, getBlogEntryImage(c.Id)));
    	}  
    	
		return 	listRecent;          
			
	} 
	
	public Integer getMyRecentBlogsSize(){
		if(getMyRecentBlogs() != null){
			return getMyRecentBlogs().size();
		}
		return 0;		
	}
	
	
	 //********************************************************************************
	//******************* Pagination  *****************************
	   	
     /*
     * Set of Integers to control pagination
     */
     public Integer totalItemsNumber;
     public Integer numberOfItemsToShow = 4;
     public Integer cntPagination;
     public Integer currentPagination = 1;
     public Integer firstRow = 0;
   
     /*
     * Set of Booleans to show or not prev / next links
     */
     public boolean prevPageLinkShow = false;
     public boolean prevPageShow  = false;
     public boolean nextPageLinkShow  = false;
     public boolean nextPageShow  = false;
               
     public void genCntPagination () {
          cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;             
          	if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
         		 cntPagination++;
    		 }                   
     }
     
     public void nextPage () {
         currentPagination++;
         firstRow = firstRow + numberOfItemsToShow;      
     }
     
     public void prevPage () {
         currentPagination--;
         firstRow = firstRow - numberOfItemsToShow;          
     }
         
     /*
     * Pagination Integer Getters
     */
         
     public Integer getCurrentPagination () {
         return currentPagination;
     }
     
     public Integer getCntPagination () {
         return cntPagination;
     }
     
     public Integer getNumberOfItemsToShow () {
         return numberOfItemsToShow;
     }
     
     public Integer getFirstRow () {
         return firstRow;
     }
     
     /*
     *  Pagination Boolean Getters
     */
     
     public boolean getPrevPageLinkShow () {
         if(currentPagination == 1){ 
         	prevPageLinkShow = false;               
         } 
         else {
         	prevPageLinkShow = true;
         }
              
         return prevPageLinkShow;
     }
          
     public boolean getPrevPageShow () {
         if(currentPagination == 1){    
         	prevPageShow = true;
         } 
         else {
         	prevPageShow = false;
         }
            return prevPageShow;
     }
           
     public boolean getNextPageLinkShow () {
	       if(currentPagination == cntPagination){    
	          		nextPageLinkShow = false;
	      	} 
	       else { 
	      	nextPageLinkShow = true;
	       }                              
	      return nextPageLinkShow;
     }
     
     public boolean getNextPageShow () {
             if(currentPagination == cntPagination){ nextPageShow = true;
     		 } 
     		 else { 
     		 	nextPageShow = false;
     		 }
                   return nextPageShow;
     }
 
   	
   	 //********************************************************************************
	//******************* Archives Widget *****************************
	
	 public List<String> getArchives(){		
 		Datetime today = System.now();
 		Integer month = today.month();
 		Integer year = today.year();
 		Integer i;
 		String dateShow;
 		String monthStringFrom;
 		List<String> dates = new List<String>();
 		 
 		for(i = 0; i <= 12; i++){
 			if(month != 1){	
 			   month = month -1;	 
 			   
 			   	if (month == 1){
			 			monthStringFrom = 'January';
			 	}
			 	if (month == 2){
			 			monthStringFrom = 'February';
			 	}
			 	if (month == 3){
			 			monthStringFrom = 'March';
			 	}
			 	if (month == 4){ 
			 			monthStringFrom = 'April';
			 	}	
			 	if (month == 5){
			 			monthStringFrom = 'May';
			 	}	
			 	if (month == 6){
			 			monthStringFrom = 'June';
			 	}	
			 	if (month == 7){
			 			monthStringFrom = 'July';
			 	}	
			 	if (month == 8){
			 			monthStringFrom = 'August';
			 	}	
			 	if (month == 9){
			 			monthStringFrom = 'September';
			 	}	
			 	if (month == 10){
			 			monthStringFrom = 'October';
			 	}	
			 	if (month == 11){
			 			monthStringFrom = 'November';
			 	}	
			 	if (month == 12){	monthStringFrom = 'December';	}	 
			 	
			 	dateShow =  monthStringFrom + ' ' +  year  ;
 			   dates.add(dateShow);  
 			}
 			else
 			{
 				month = 12;
 				year = year - 1;
 				dateShow =  'December ' +  year  ;
 				dates.add(dateShow);
 			} 	
 		}
 		return dates;
 	}	
	
	
	public void genFilter (){
		String monthId = System.currentPageReference().getParameters().get('monthId');
		String yearString = monthId.substring(monthId.length() - 4, monthId.length());
		Integer year = Integer.valueOf(yearString);
	
		Integer month;
		String monthStringFrom = monthId.substring(0, monthId.length() - 5);
		
		if (monthStringFrom == 'January'){
	 			
	 		month = 1;
	 	}
	 	if (monthStringFrom == 'February'){
	 		month = 2;
	 	}
	 	if (monthStringFrom == 'March'){
	 			
	 		month = 3;
	 	}
	 	if (monthStringFrom == 'April'){ 
	 			
	 		month = 4;
	 	}	
	 	if (monthStringFrom == 'May'){
	 			
	 		month = 5;
	 	}	
	 	if (monthStringFrom == 'June'){
	 			
	 		month = 6;
	 	}	
	 	if (monthStringFrom == 'July'){
	 			
	 		month = 7;
	 	}	
	 	if (monthStringFrom == 'August'){
	 			
	 		month = 8;
	 	}	
	 	if (monthStringFrom == 'September'){
	 			
	 		month = 9;
	 	}	
	 	if (monthStringFrom == 'October'){
	 			
	 		month = 10;
	 	}	
	 	if (monthStringFrom == 'November'){
	 			
	 		month = 11;
	 	}	
	 	if (monthStringFrom == 'December'){
	 		month = 12;
	 	}
		Datetime selectedMonth = Datetime.newInstance(year, month, 31);
		Datetime beforeMonth;
		
		
		
		if(month != 1){
			beforeMonth = Datetime.newInstance(year, month , 01);
		}
		//else{
		//	beforeMonth = Datetime.newInstance(year - 1, 12, 1);
		//}
			
			
				blogs =  [SELECT 		 Title__c,
							  			 Team__c,
							  			 Message__c,
							  			 PostedDate__c,									  			
							  			 CreatedDate,
							  			 CreatedById,	
							  			 PostedBy__r.Name, 	
							  			 PostedBy__r.Email,							  			 						
										 Team__r.Name, 
										 Name, 													
										 Id, 						
										 CommentCount__c	
							   			 FROM BlogEntry__c
							   			 where PostedDate__c <=: selectedMonth
							   			 AND 	PostedDate__c >=: beforeMonth
							   			 ORDER BY PostedDate__c DESC
							             LIMIT 5];
													
		totalItemsNumber = blogs.size();
		genCntPagination();	
		          
		
	}
	
	
			
			
 		 //********************************************************************************
	//******************* Teams Widget *****************************
	   	
	   	
   		public List<TeamMember__c> getMyTeamsWidget(){		
 
 			List<TeamMember__c> teamList = new List<TeamMember__c>();
		
			teamList = [SELECT 	   Team__c,
								   Name,
								   Team__r.Name		
							  	   FROM TeamMember__c
							       WHERE User__c =: UserInfo.getUserId()
							       LIMIT 10];	
				return teamList; 
 								
 		}	
}
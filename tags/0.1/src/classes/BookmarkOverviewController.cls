public class BookmarkOverviewController {
// COLLABSUITE-883
	List<TeamMember__c> myTeams = new List<TeamMember__c>();
	List<Bookmark__c> teamBookmarks = new List<Bookmark__c>();
	Set<Id> teams = new Set<Id>();
	List<BookmarkGroup> bookmarkGroups;
	String tabControl;
	
	public BookmarkOverviewController() {
		
			
		Integer count;
		// get my teams
		// We need a list and a set one for display and one
		// for making the query against bookmarks
		count = [SELECT count() FROM TeamMember__c WHERE User__c =: UserInfo.getUserId()];
		System.debug('\n //////////// \n ' + count + '\n //////////// \n');
		if (count != 0) {
			for(TeamMember__c tm:[SELECT Team__c,
										 Team__r.Name		
								  	   FROM TeamMember__c
								       WHERE User__c =: UserInfo.getUserId()]) {
				teams.add(tm.Team__c);
				myTeams.add(tm);	  								
			}
		}
		
		if(System.currentPageReference().getParameters().get('all') == null){			
			
			
			
			bookmarkGroups = getMyTeam();
			totalItemsNumber = getMyTeam().size();
			tabControl = 'myBookmarks';
			
		} else {
			
			
			bookmarkGroups = getAllTeam();
			totalItemsNumber = bookmarkGroups.size();
			tabControl = 'allBookmarks';	
		}
		
		genCntPagination();
	}
	
	public Integer getBookmarkGroupsSize(){
		return bookmarkGroups.size();
	}
	
	public String getTabControl(){
		return tabControl;
	}
	
	public List<TeamMember__c> getTeams() {
		return myTeams;
	}
	
	public List<BookmarkGroup> getBookmarkGroups (){
		return bookmarkGroups;
	}
	
	
	public List<BookmarkGroup> getMyTeam() {						
		
		boolean monthShow = false ;
	    String dateAlreadyShown = '';
	    String ParsedDate = '';
	    Datetime DateIterator;
	    
		List<Bookmark__c> myTeams = new List<Bookmark__c>(); 
		List<BookmarkGroup> bkmGroups = new List<BookmarkGroup>(); 
		 
		myTeams = [SELECT   Title__c,
				  		    Team__c,
				  		    Team__r.Name,
				  			Body__c,
				  			PostedBy__r.Name,
				  			PostedBy__c,
				  			Comments__c,
				  			BookmarkURL__c,
				  			ImageUrl__c,
				  			PostedDate__c,
				  			CreatedById
		   			 FROM Bookmark__c
		   			 WHERE Team__c IN: teams
		   			 ORDER BY PostedDate__c DESC
		             ];
		
		for(Integer i = 0; i < myTeams.size() ; i++){
			BookmarkGroup bkmGroup = new BookmarkGroup (myTeams[i].PostedDate__c);
			DateIterator = myTeams[i].PostedDate__c;
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
			
			bkmGroup.setDateString(tempDate);
			bkmGroup.setId(myTeams[i].Id);
			bkmGroup.setTitle(myTeams[i].Title__c);
			bkmGroup.setCommentsCount(myTeams[i].Comments__c);
			bkmGroup.setTeamName(myTeams[i].Team__r.Name);
			bkmGroup.setBody(myTeams[i].Body__c);
			bkmGroup.setPostedByName(myTeams[i].PostedBy__r.Name);
			bkmGroup.setBookmarkURL(myTeams[i].BookmarkURL__c);
			bkmGroup.setPostedDate(myTeams[i].PostedDate__c);
			
			
			if ( dateAlreadyShown != ParsedDate ){      					
		        bkmGroup.setDateClass('Date');	
		        dateAlreadyShown = 'Date' + DateIterator.day() + DateIterator.month() + DateIterator.year();
			
		    }							        	
        	else{					        		
				bkmGroup.setDateClass('Date_empty');	
        	}
        	bkmGroups.add(bkmGroup);
        	
		}
		
		return bkmGroups;
	}
	
	public List<BookmarkGroup> getAllTeam() {
		
		
		boolean monthShow = false ;
	    String dateAlreadyShown = '';
	    String ParsedDate = '';
	    Datetime DateIterator;
	    List<BookmarkGroup> bkmGroups = new List<BookmarkGroup>(); 
		// get list
		List<Bookmark__c> allTeams = new List<Bookmark__c>();
		allTeams = [SELECT   Title__c,
				  			 Team__c,			  			 
				  			 Body__c,
				  			 PostedBy__r.Name,
				  			 PostedBy__c,
				  			 Comments__c,
				  			 Team__r.Name,
				  			 BookmarkURL__c,	
				  			 ImageUrl__c,								  			 
				  			 PostedDate__c,
				  			 CreatedById
		   			  FROM Bookmark__c
		   			  ORDER BY PostedDate__c DESC ];

		for(Integer i = 0; i < allTeams.size() ; i++){
			BookmarkGroup bkmGroup = new BookmarkGroup (allTeams[i].PostedDate__c);
			DateIterator = allTeams[i].PostedDate__c;
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
			
			bkmGroup.setDateString(tempDate);
			bkmGroup.setId(allTeams[i].Id);
			bkmGroup.setTitle(allTeams[i].Title__c);
			bkmGroup.setCommentsCount(allTeams[i].Comments__c);
			bkmGroup.setTeamName(allTeams[i].Team__r.Name);
			bkmGroup.setBody(allTeams[i].Body__c);
			bkmGroup.setPostedByName(allTeams[i].PostedBy__r.Name);
			bkmGroup.setBookmarkURL(allTeams[i].BookmarkURL__c);
			bkmGroup.setPostedDate(allTeams[i].PostedDate__c);
			
			
			if ( dateAlreadyShown != ParsedDate ){      					
		        bkmGroup.setDateClass('Date');	
		        dateAlreadyShown = 'Date' + DateIterator.day() + DateIterator.month() + DateIterator.year();
			
		    }							        	
        	else{					        		
				bkmGroup.setDateClass('Date_empty');	
        	}
        	bkmGroups.add(bkmGroup);
        	
		}
		
		return bkmGroups;

	}
	
	/*
	 * sort into bookmark groups
	 */
	private List<BookmarkGroup> sortBookmarks(List<Bookmark__c> bookmarks) {
		
		List<BookmarkGroup> groupList = new List<BookmarkGroup>();
		BookmarkGroup currentGroup = null;
		
		for(Bookmark__c a: bookmarks) {			
		
			if(currentGroup == null || 
			   !currentGroup.getPostedDate().isSameDay(a.PostedDate__c)) {
			    currentGroup = new BookmarkGroup(a.PostedDate__c);
			    currentGroup.addBookmark(a);		   	
				groupList.add(currentGroup);
			} else {
				currentGroup.addBookmark(a);
			}
				
		}	
		
		return groupList;
	}
	
	//**********************************************************************************
	//******************* BookMarkMostCommentedWidget Page *****************************
	//**********************************************************************************
	public List<Bookmark> getMostCommented() {
		
		Date first = System.today().toStartOfWeek();
    	Datetime firstWeekDay = Datetime.newInstance(first.year(), first.month(), first.day(), 0, 0, 0);
    	Datetime lastWeekDay = firstWeekDay.addDays(7);
    	List<Bookmark> bookmarks = new List<Bookmark>();
		// get list
		List<Bookmark__c> mostCommented = new List<Bookmark__c>();
		mostCommented = [ SELECT Title__c,
					  			 Team__c,
					  			 Id,
					  			 Team__r.Name, 
					  			 Body__c,
					  			 Comments__c,
					  			 SiteDescription__c,
					  			 BookmarkURL__c,	
					  			 ImageUrl__c,								  			 
					  			 PostedDate__c,
					  			 CreatedById
			   			  FROM Bookmark__c
			   			  Where PostedDate__c <=: lastWeekDay 
					 	  AND PostedDate__c >=: firstWeekDay
			   			  ORDER BY Comments__c DESC
			              LIMIT 5];	
			              
		for(Bookmark__c b : mostCommented){
			Bookmark bkm = new Bookmark();
			
			bkm.setCommentsCount(b.Comments__c);
			bkm.setTitle(b.Title__c);
			bkm.setTeamName(b.Team__r.Name);
			bkm.setImageURL(b.ImageURL__c);
			bkm.setId(b.Id);
			
			bookmarks.add(bkm);	
		}
		
			              	
		return bookmarks;
	}
	//********************************************************************************
	//******************* BookMarkActiveUsersWidget Page *****************************
	//********************************************************************************
	
	public List<PostedUser> getMostActiveUsers(){
		
		Date first = System.today().toStartOfWeek();
    	Datetime firstWeekDay = Datetime.newInstance(first.year(), first.month(), first.day(), 0, 0, 0);
    	Datetime lastWeekDay = firstWeekDay.addDays(7);
		Map<Id, PostedUser> tempmap = new Map<Id, PostedUser>();
		List<PostedUser> mostPostedUsers = new List<PostedUser>();
		Integer i;
		
		for(Bookmark__c book : [Select 	b.Title__c, 
										b.Team__c, 
										b.PostedDate__c, 
										b.PostedBy__c, 
										b.OwnerId,
										b.PostedBy__r.Name, 
										b.Name, 
										b.LastModifiedDate, 
										b.LastModifiedById, 
										b.Id,  
										b.CreatedById
								From Bookmark__c b
					 			Where PostedDate__c <: lastWeekDay 
					 			AND PostedDate__c >: firstWeekDay]){
			
			if(tempmap.containsKey(book.PostedBy__c)){
				PostedUser postedUser = tempmap.get(book.PostedBy__c);
				Integer tempCount = postedUser.getPostedBookmarks() + 1;
				postedUser.setPostedBookmarks(tempCount); 
				tempmap.put(book.PostedBy__c, postedUser);
			}
			else
			{
				PostedUser postedUser = new PostedUser();
				postedUser.setPostedBookmarks(1);
				postedUser.setId (book.PostedBy__c);
				postedUser.setName(book.PostedBy__r.Name);
				postedUser.setPicture (book.PostedBy__c);
				tempmap.put(book.PostedBy__c, postedUser);
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
 				if (result.get(j).getPostedBookmarks() >= result.get(j - 1).getPostedBookmarks()) {
 					PostedUser tempPostedUser;
 					tempPostedUser = result.get(j - 1);
 					result.set(j - 1, result.get(j));
 					result.set(j, tempPostedUser); 	
 				}	
 			}
 		}
 		return result;
 	}	
 	
 	
	//******************************************************************************************
	//************* Methods that returns the month number & the month name *********************
	//******************************************************************************************
	public String getMonthName(Integer numberMonth){
		
		String monthName;
		
		if( numberMonth == 1)  { return monthName = 'January'; }
		if( numberMonth == 2)  { return monthName = 'February'; }
		if( numberMonth == 3)  { return monthName = 'March'; }
		if( numberMonth == 4)  { return monthName = 'April'; }
		if( numberMonth == 5)  { return monthName = 'May'; }
		if( numberMonth == 6)  { return monthName = 'June'; }
		if( numberMonth == 7)  { return monthName = 'July'; }
		if( numberMonth == 8)  { return monthName = 'August'; }
		if( numberMonth == 9)  { return monthName = 'September'; }
		if( numberMonth == 10)  { return monthName = 'October'; }
		if( numberMonth == 11)  { return monthName = 'November'; }
		if( numberMonth == 12)  { return monthName = 'December'; }
		
		return '';	
	}
	
	public Integer monthNumber(String monthStringFrom){
		
		Integer numberMonth;
		
		if (monthStringFrom == 'January')  { numberMonth = 1;}
	 	if (monthStringFrom == 'February') { numberMonth = 2;}
	 	if (monthStringFrom == 'March')    { numberMonth = 3;}
	 	if (monthStringFrom == 'April')    { numberMonth = 4;}	
	 	if (monthStringFrom == 'May')      { numberMonth = 5;}	
	 	if (monthStringFrom == 'June')     { numberMonth = 6;}	
	 	if (monthStringFrom == 'July')     { numberMonth = 7;}	
	 	if (monthStringFrom == 'August')   { numberMonth = 8;}	
	 	if (monthStringFrom == 'September'){ numberMonth = 9;}	
	 	if (monthStringFrom == 'October')  { numberMonth = 10;}	
	 	if (monthStringFrom == 'November') { numberMonth = 11;}	
	 	if (monthStringFrom == 'December') { numberMonth = 12;}
	 	
	 	return numberMonth;
	 	
	}
	
	
	//*****************************************************************************
	//******************* Archives Filters ****************************************
	//*****************************************************************************
	public List<String> getArchives(){		
 		Datetime today = System.now();
 		Integer month = today.month();
 		Integer year = today.year();
 		Integer i;
 		String dateShow;
 		String monthStringFrom;
 		List<String> dates = new List<String>();
 		
 		 
 		for(i = 0; i <= 12; i++){	 
			 	monthStringFrom = getMonthName(month);
			 	if(month != 1){
			 		month = month -1;
			 		dateShow =  monthStringFrom + ' ' +  year  ;
 			    	dates.add(dateShow);
			 	}  
			 	else{
			 		dateShow =  monthStringFrom + ' ' +  year  ;
			 		dates.add(dateShow);
			 		month = 12;
			 		year = year - 1;
			 	}
 		}
 		return dates;
 	}	
	
	public void genFilter (){
		
		String dateAlreadyShown = '';
		String ParsedDate = '';
	    Datetime DateIterator;
		String monthId = System.currentPageReference().getParameters().get('monthId');
		String yearString = monthId.substring(monthId.length() - 4, monthId.length());
		Integer year = Integer.valueOf(yearString);	
		Integer month;
		String monthStringFrom = monthId.substring(0, monthId.length() - 5);
		List<Bookmark__c> bookmarks = new List<Bookmark__c>(); 
	
	 	month = monthNumber(monthStringFrom);
		Datetime selectedMonth = Datetime.newInstance(year, month, 31);
		Datetime beforeMonth;
		
		
		if(month != 1){
			beforeMonth = Datetime.newInstance(year, month , 01);
		}
		else{
			beforeMonth = Datetime.newInstance(year - 1, 12, 31);
		}
		
		List<BookmarkGroup> bkmGroups = new List<BookmarkGroup>();
				
		bookmarks = [SELECT Title__c,
				  			 Team__c,
				  			 Team__r.Name,			  			 
				  			 Body__c,
				  			 PostedBy__r.Name,
				  			 PostedBy__c,
				  		     Comments__c,
				  			 BookmarkURL__c,	
				  			 ImageUrl__c,								  			 
				  			 PostedDate__c,
				  			 CreatedById
		   			  FROM Bookmark__c
		   			  where PostedDate__c <=: selectedMonth
		   			  AND 	PostedDate__c >=: beforeMonth
		   			  ORDER BY PostedDate__c DESC
		              LIMIT 5];
		 
		     
		 for(Bookmark__c b : bookmarks){
		 	BookmarkGroup bkmGroup = new BookmarkGroup(b.PostedDate__c);
		 	
		 	dateIterator = b.PostedDate__c;
		 	ParsedDate = 'Date' + DateIterator.day() + DateIterator.month() + DateIterator.year(); 	
		 	
		 	String monthGroup = getMonthName(DateIterator.month());
		 	String tempDate = monthGroup + DateIterator.day() + ', ' + DateIterator.year();
			
			bkmGroup.setDateString(tempDate);
		 	bkmGroup.setId(b.Id);
			bkmGroup.setTitle(b.Title__c);
			bkmGroup.setCommentsCount(b.Comments__c);
			bkmGroup.setTeamName(b.Team__r.Name);
			bkmGroup.setBody(b.Body__c);
			bkmGroup.setPostedByName(b.PostedBy__r.Name);
			bkmGroup.setBookmarkURL(b.BookmarkURL__c);
			bkmGroup.setPostedDate(b.PostedDate__c);
			
			if ( dateAlreadyShown != ParsedDate ){      					
		        bkmGroup.setDateClass('Date');	
		        dateAlreadyShown = 'Date' + DateIterator.day() + DateIterator.month() + DateIterator.year();
			
		    }							        	
        	else{					        		
				bkmGroup.setDateClass('Date_empty');	
        	}
		
			bkmGroups.add(bkmGroup);
		 }           
			bookmarkGroups = bkmGroups;
			
			if(bookmarkGroups.size() > 0){
				totalItemsNumber = bookmarkGroups.size();
				currentPagination = 1;
				firstRow = 0;
				
			}
			else{
				totalItemsNumber = 1;
				currentPagination = 1;
				firstRow = 0;
			}
			genCntPagination();
	}
 	
	//*****************************************************************************
	//******************* BookMarkMyRecentWidget Page *****************************
	//*****************************************************************************
	
	public List<Bookmark> getMyRecentBookmarks(){
		
		List<Bookmark__c> myRecentBookmarks = new List<Bookmark__c>();
		List<Bookmark> recentBookmarkshow = new List<Bookmark>();
		
		myRecentBookmarks = [SELECT Title__c,
					  			 	Team__c,
					  			 	Team__r.Name, 
					  			 	Comments__c,
					  			 	BookmarkURL__c,	
					  			 	ImageUrl__c								  			 
			   			  	FROM Bookmark__c
			   			  	WHERE PostedBy__c =: userInfo.getUserId()
			   			  	ORDER BY PostedDate__c DESC
			              	LIMIT 5];
			              	
		for(Bookmark__c b : myRecentBookmarks){
			Bookmark bkm = new Bookmark();
			
			bkm.setCommentsCount(b.Comments__c);
			bkm.setTitle(b.Title__c);
			bkm.setTeamName(b.Team__r.Name);
			bkm.setImageURL(b.ImageURL__c);
			bkm.setId(b.Id);
			
			recentBookmarkshow.add(bkm);	
		}              	
			              	
		return 	recentBookmarkshow;          
			
	} 
	
	public Integer getMyRecentBookmarksSize(){
		if(getMyRecentBookmarks() != null){
			return getMyRecentBookmarks().size();
		}
		return 0;		
	}
	
	//*****************************************************************************
	
	/* -------------------------------------------------------------------------- */
   	/*                                PAGINATION	                              */
   	/* -------------------------------------------------------------------------- */
   
   
   
    public Integer totalItemsNumber;
   	public Integer numberOfItemsToShow = 4;
   	public Integer cntPagination;
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	
   	/**
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
   	
   	/**
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
   	
   	/**
   	* Pagination Boolean Getters
   	*/
   	
	public boolean getPrevPageLinkShow () {
		
		if(currentPagination == 1){ prevPageLinkShow = false;		
		} else {prevPageLinkShow = true;}
		
   		return prevPageLinkShow;
   	}
   	
   	public boolean getPrevPageShow () {
   		
   		if(currentPagination == 1){	prevPageShow = true; 
   		} else {prevPageShow = false;}
   		
   		return prevPageShow;
   	}
   	
   	public boolean getNextPageLinkShow () {
   		
   		if(currentPagination == cntPagination){	nextPageLinkShow = false; 
		} else { nextPageLinkShow = true;}   		
   		
   		return nextPageLinkShow;
   	}
   	
   	public boolean getNextPageShow () {
   		
   		if(currentPagination == cntPagination){ nextPageShow = true; 
		} else { nextPageShow = false;} 
   		
   		return nextPageShow;
   	}
   
   
   
   
	public class PostedUser{
		
		//******************* Attributs ***************************************
		
		public String userPicture;
		public Integer postedBookmarks;
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
			this.commentsCount = [Select count() From Comment__c where OwnerId =: id and Bookmark__c != null];	
		}
		
		//*********************************************************************
		//******************* Getters *****************************************
		
		public Integer getPostedBookmarks(){
						
				return 	postedBookmarks;
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
		
		public void setPostedBookmarks(Integer postBookmarks){
				
			postedBookmarks = postBookmarks;
		}
		
		public void setName(String bookName){
				
			name = bookName;
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
	
	public class Bookmark{
		
		//******************* Attributs ***************************************
		
		Double commentsCount;
		String title;
		String teamName;
		String imageURL;
		String id;
		
		//*********************************************************************
		//******************* Constructor *************************************
		public Bookmark(){
			
		}
	
		//*********************************************************************
		//******************* Getters *****************************************
		public String getId(){
			return id;
		}
		public String getImageURL(){
			return imageURL;
		}
		
		public Long getCommentsCount(){
			
			return Math.roundToLong(commentsCount);
		}
		public String getTitle(){
			return title;
		}
		public String getTeamName(){
			return teamName;
		}
		
		//********************************************************************
		//******************* Setters *****************************************
		
		public void setCommentsCount(Double countComments){
			
			this.commentsCount = countComments;
		}
		public void setTitle(String title){
			this.title = title;
		}
		public void setTeamName(String team){
			this.teamName = team;
		}
		public void setImageURL(String imgURL){
			this.imageURL = imgURL;
		}
		public void setId(String id){
			this.id = id;
		}
		
	}	
	
	public class BookmarkGroup {
		
		//******************* Attributs ***************************************
		
		List<Bookmark__c> bookmarks = new List<Bookmark__c>();
		Datetime postedDate;
		Double commentsCount;
		String title;
		String teamName;
		String imageURL;
		String id;
		String dateString = '';
    	String dateClass = '';
		String team;
		String body;
		String postedByName;
		String postedBy;
		String bookmarkURL;
		
		
		//*********************************************************************
		//******************* Getters *****************************************
		public String getId(){
			return id;
		}
		public String getImageURL(){
			return imageURL;
		}
		
		public Long getCommentsCount(){
			
			return Math.roundToLong(commentsCount);
		}
		public String getTitle(){
			return title;
		}
		public String getTeamName(){
			return teamName;
		}
		public String getTeam(){
			return team;
		}
		public String getBody(){
			return body;
		}
		public String getPostedByName(){
			return postedByName;
		}
		public String getPostedBy(){
			return postedBy;
		}
		public String getBookmarkURL(){
			return bookmarkURL;
		}	
		

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
		public String getDateClass(){
			return dateClass;
		}
		
		//********************************************************************
		//******************* Setters *****************************************
		
		public void setDateString(String sDateString){
	         dateString = sDateString;
	    } 
	    public void setDateClass(String sDateClass){
                dateClass = sDateClass;
        }  
        public void setCommentsCount(Double countComments){
			
			this.commentsCount = countComments;
		}
		public void setTitle(String title){
			this.title = title;
		}
		public void setTeamName(String team){
			this.teamName = team;
		}
		public void setImageURL(String imgURL){
			this.imageURL = imgURL;
		}
		public void setId(String id){
			this.id = id;
		}
		public void setTeam(String team){
			this.team = team;
		}
		public void setBody(String body){
			this.body = body;
		}
		public void setPostedByName(String user){
			this.postedByName = user;
		}
		public void setPostedBy(String postedBy){
			this.postedBy = postedBy;
		}
		public void setBookmarkURL(String bookmarkURL){
			this.bookmarkURL = bookmarkURL;
		}
		public void setPostedDate(Datetime postedDate){
			this.postedDate = postedDate;
		}
	}
	
	
}
/**
*@author Yuri Alvarez @ 04/30/2008
*/
public class PeopleKeywordSearchController{	

	//Generate Instance of PaginatorController Class
	protected PaginatorController paginator = new PaginatorController();
	protected String title;
	protected boolean myPeople = false;
	
	public Boolean isTest = false;
	
	/**
	*Constructor Default
	*/
	public PeopleKeywordSearchController() {
		ResultCore('Search');
	}	
	
	/**
	*Set is test
	*@param Boolean
	*/
	public void setIsTest (Boolean isTest) {
		this.isTest = isTest;
	}
	
	//User Id 
	protected String userId = Userinfo.getUserId();
	
	/**
	*Set user id
	*@param String
	*/
	public void setUserId(String sUserid){
		userId = sUserid;
	}
	
	public Integer SizeList = 0;
	
	// Primary Set to store result values
	public Set<String> results = new Set<String>();
	
	
	/**
	*Get Parameter
	*@param parameter name
	*@return String parameter
	*/      
	public String getParam(String nameParam){
		return System.currentPageReference().getParameters().get(nameParam);
	}
     
     
       
    /**
    *Return like Parameters
    *@param String 
    *@return String parameter
    */ 
    public String likeParam(String nameParam){
        return '%' + nameParam + '%';
    }
       
    /**
    *Return true if parameter is empty
    *@param String parameter name
    *@return Boolean
    */      
    public boolean paramIsEmpty(String parameterName) {
		String parameterValue = getParam(parameterName);
		boolean emptyParam = false;
    	if (parameterValue == null) {
        	emptyParam = true;
    	} else {
        	if (parameterValue.equals('')) {
            	emptyParam = true;
            }
    	}
    	return emptyParam;
    }
    
	
	/* -------- */
   	/*  SETTERS */
   	/* -------- */
	
	
	/**
	*Set Size of List
	*@param Integer size
	*/
	public Void setSizeList(Integer size) {
		SizeList = size;
	}

	//GET Generic List of Pepole Profile
	
	List<PeopleSearchResultItem> searchResultsItems = new List<PeopleSearchResultItem>();
	
	/**
	*Get list of People Profile
	*@return List<PeopleSearchResultItem> 
	*/
	public List<PeopleSearchResultItem> getPeople()	{
		return searchResultsItems;
	}
	
	
	/**
	*Get Instance of Class PaginatorController
	*@return PaginatorController
	*/
	public PaginatorController getPaginator() {
		return paginator;
	}
	
	
	/**
	*Get Size of List
	*@return Integer size
	*/
	public Integer getSizeList() {
		return SizeList;
	}

	/* ---------------------------- */
   	/*  Public Atributes for Layout */
   	/* ---------------------------- */
   	
   	/**
   	*Get Tilte for page.
   	*@return String title
   	*/
   	public String getTitle () {
   		return title;
   	}
   	
   	public static final String KEYWORD = 'key';	
	
	/**
	*get parameter with keyword
	*@return String parameter
	*/
	public String getKeyword(){
		return getParam(KEYWORD);
	}
	
	public String typeAction = 'Search';
	
	/**
	*get tye action
	*@return String
	*/
	public String getTypeAction(){
		return typeAction;
	}
	
   	/* ------------ */
   	/*  Result Core */
   	/* ------------ */
	//List of Users 
	List<User> result = new List<User>();
	
	String keywordString = '';
	
	//summary of results
	Integer nameSearchMatch = 0;
	Integer formerJobSearchMatch = 0;
	Integer collegeSearchMatch = 0;
	Integer competencySearchMatch = 0;
	Integer teamspaceSearchMatch = 0;
	
	/**
	*Set keyword
	*@param String
	*/
	public void setKeywordString (String sKey){ 
		keywordString = sKey;
	} 
	
	/**
	*Returns the number of users whose names match the search condition
	*@return Integer
	*/
	public Integer getNameSearchMatch(){
		return nameSearchMatch;
	}
	
	/**
	*Returns the number of users whose job match the search condition
	*@return Integer
	*/
	public Integer getFormerJobSearchMatch(){
		return formerJobSearchMatch;
	}
	
	/**
	*Returns the number of users whose college match the search condition
	*@return Integer
	*/
	public Integer getCollegeSearchMatch(){
		return collegeSearchMatch;
	}
	
	/**
	*Returns the number of users whose competency match the search condition
	*@return Integer
	*/
	public Integer getCompetencySearchMatch(){
		return competencySearchMatch;
	}
	
	/**
	*Returns the number of users whose team name match the search condition
	*@return Integer
	*/
	public Integer getTeamspaceSearchMatch(){
		return teamspaceSearchMatch;
	}
		
	/**
	*Executes the search on People Profile
	*@param String 
	*/
	
	public void ResultCore(String TypeA) {
		if(!(paramIsEmpty(KEYWORD))){
			keywordString = System.currentPageReference().getParameters().get('key');
		}
		TypeA = 'Search';
		if(userId == null){
			userId = Userinfo.getUserId();
			myPeople = true;
		}
	 	
 		// Declarations
       	List<User> nameSearch = new List<User>();
       	List<User> allUsers = new List<User>();
    	List<EmploymentHistory__c> formerJobSearch = new List<EmploymentHistory__c>(); 
    	List<EducationHistory__c> collegeSearch = new List<EducationHistory__c>();
    	List<UserCompetencies__c> competencySearch = new List<UserCompetencies__c>();
    	List<TeamMember__c> teamspaceSearch = new List<TeamMember__c>();		
			
		// Search lists
		if(keywordString != ''){
			nameSearch = [select id from User WHERE Name LIKE :likeParam(keywordString)];		        	
	    	formerJobSearch = [select User__c from EmploymentHistory__c WHERE Employer__r.Name LIKE :likeParam(keywordString)];
	    	collegeSearch = [select User__c from EducationHistory__c WHERE School__r.Name LIKE :likeParam(keywordString)];
	    	competencySearch = [select User__c from UserCompetencies__c WHERE Competency__r.Name LIKE :likeParam(keywordString)];
	    	
	    	if (!TeamUtil.isTest) {
	    		teamspaceSearch = [select User__c from TeamMember__c WHERE Team__r.Name LIKE :likeParam(keywordString) ];
	    	}else {
	    		teamspaceSearch = [select User__c from TeamMember__c WHERE Team__r.Name LIKE :likeParam(keywordString) limit 100];
	    	}
			
			nameSearchMatch = nameSearch.size();
			formerJobSearchMatch = formerJobSearch.size();
			collegeSearchMatch = collegeSearch.size();
			competencySearchMatch = competencySearch.size();
			teamspaceSearchMatch = teamspaceSearch.size();
			
			if(nameSearch.size() > 0 ) {
	        	for(User userId:nameSearch){
	        		results.add(userId.id);
	        	}
        	}
        	
			/// Former Job List ////
			if(formerJobSearch.size() > 0){
	        	for(EmploymentHistory__c userId:formerJobSearch){        		
	        			results.add(userId.User__c);        		 		
	        	}        	 			
			}	        		

	    	/// College List ///
       		if(collegeSearch.size() > 0){    			
        		for(EducationHistory__c userId:collegeSearch){	        		
	        			results.add(userId.User__c);	        		  		
	        	} 	        
    		}

	    	/// Competency List ///
    		if(competencySearch.size() > 0){    		
	        	for(UserCompetencies__c userId:competencySearch){	        		
	        			results.add(userId.User__c);	        				
	        	} 	        	
    		}
	    	    	
	    	/// Teamspace List ///
			if(teamspaceSearch.size() > 0){			
	    		for(TeamMember__c userId:teamspaceSearch){        	
	        			results.add(userId.User__c);        		 		
	        	}         	
			}

		} else {
			// Get all users, no keyword given
			allusers = [SELECT Id FROM User];
			for(User userId:allusers){        	
        		results.add(userId.Id);        		 		
        	}
		}
			
		List<Id> users = new List<Id>();
		// Convert the Set to a list for Pagination	
		for(String r:results){
			users.add(r);			
		}	
		
		List<Team__c> commonTeams = new List<Team__c>();
		if (!TeamUtil.isTest) {
			result = [Select u.Title, 
						u.Phone, 
						u.Name, 
						u.Id, 
						u.Email, 
						u.Division, 
						u.Department, 
						u.CompanyName, 
						(Select AboutMe__c, Aol__c, Picture__c, Skype__c, YahooIM__c, isPrivate__c From People__r) 
						From User u where u.Id in : users and u.IsActive = true order by u.Name asc];
						
			commonTeams = [Select t.Name, (Select id, User__c, Team__c From TeamMembers__r where User__c =:UserInfo.getUserId() or User__c in: result) From Team__c t];
		}else {
			result = [Select u.Title, 
						u.Phone, 
						u.Name, 
						u.Id, 
						u.Email, 
						u.Division, 
						u.Department, 
						u.CompanyName, 
						(Select AboutMe__c, Aol__c, Picture__c, Skype__c, YahooIM__c, isPrivate__c From People__r limit 1) 
						From User u where u.Id in : users and u.IsActive = true order by u.Name asc limit 1];
			
			commonTeams = [Select t.Name, (Select id, User__c, Team__c From TeamMembers__r where User__c =:UserInfo.getUserId() or User__c in: result limit 1) From Team__c t limit 1];	
		}
		
		// Add the values to the list
		for(User u:result){
			PeopleSearchResultItem item = new PeopleSearchResultItem();
			item.Id = u.Id;
			item.Name = u.Name;
			item.Title = u.Title;
			item.Phone = u.Phone;
			item.Email = u.Email;
			item.Division = u.Division;
			item.Department = u.Department;
			item.CompanyName = u.CompanyName;
			if(u.People__r.size() > 0){
				// Display Profile Information
				Boolean findJoinTeam = false;
				Integer countTeam = 0;
				if (u.People__r[0].isPrivate__c && u.Id != UserInfo.getUserId()) {
					while (!findJoinTeam && countTeam < commonTeams.size()) {
						Integer countTeamMembers = 0;
						for (TeamMember__c iterTeamMember : commonTeams[countTeam].TeamMembers__r) {
							if (iterTeamMember.User__c == u.Id || iterTeamMember.User__c == UserInfo.getUserId()) {
								countTeamMembers++;
							}
						}
						if (countTeamMembers > 1) {
							findJoinTeam = true;	
						}else {
							countTeam++;
						}
					}
				}
				if (!u.People__r[0].isPrivate__c || findJoinTeam || u.Id == UserInfo.getUserId()) {
					item.isPrivate = false;
				}else {
					if (!u.People__r[0].isPrivate__c) {
						item.isPrivate = false;	
					}else {
						item.isPrivate = true;		
					}
				}
				
				item.AboutMe = u.People__r[0].Aboutme__c;
				item.Aol = u.People__r[0].Aol__c;
				item.Skype = u.People__r[0].Skype__c;
				item.Yahoo = u.People__r[0].YahooIM__c;
				item.Picture = u.People__r[0].Picture__c;
			}
			searchResultsItems.add(item);	
		}
	 	//Set the Values of Paginator
	 	setSizeList(result.size());
	 	paginator.setTotalItemsNumber(result.size());
	 	paginator.genCntPagination();
	 	
	 	title = 'Search Results from People';	 	
	}
	 	
	 	/**
	 	*Class PeopleSearchResultItem wraps the data of the search result
		*@author Yuri Alvarez
		*/	
	 	public class PeopleSearchResultItem {	 		
	 		public String Id { get; set; }
	 		public Boolean isPrivate { get; set; }
			public String Title { get; set; }
			public String Phone { get; set; }
			public String Name { get; set; }
			public String Email { get; set; }
			public String Division { get; set; }
			public String Department { get; set; }
			public String CompanyName { get; set; }
			public String AboutMe { get; set; }
			public String Aol { get; set; }
			public String Picture { get; set; }
			public String Skype { get; set; }
			public String Yahoo { get; set; }		   	
	 	}
	 	
}
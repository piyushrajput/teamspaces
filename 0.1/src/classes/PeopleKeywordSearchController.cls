public class PeopleKeywordSearchController{	

	//Generate Instance of PaginatorController Class
	protected PaginatorController paginator = new PaginatorController();
	protected String title;
	protected boolean myPeople = false;
	
	//User Id 
	protected String userId = Userinfo.getUserId();
	
	public void setUserId(String sUserid){
		userId = sUserid;
	}
	
	protected Integer SizeList = 0;
	
	// Primary Set to store result values
	public Set<String> results = new Set<String>();
	
	//@@ Get Parameters      
	public String getParam(String nameParam){
		return System.currentPageReference().getParameters().get(nameParam);
	}
        
    //@@ Like Parameters 
    public String likeParam(String nameParam){
                    return '%' + nameParam + '%';
    }
       
    //@@ Parameter is empty        
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
	
	
	//Set Size of List
	public Void setSizeList(Integer size)
	{
		SizeList = size;
	}

	
	//GET Generic List of Pepole Profile
	public List<PeopleProfile__c> getPeople()
	{
		return result;
	}
	
	//GET Instance of Class PaginatorController
	public PaginatorController getPaginator()
	{
		return paginator;
	}
	
	//GET Size of List
	public Integer getSizeList()
	{
		return SizeList;
	}
	
	
	//Constructor Default
	public PeopleKeywordSearchController() {
		ResultCore('Search');	
	
	}
	
	/* ---------------------------- */
   	/*  Public Atributes for Layout */
   	/* ---------------------------- */
   	// Get Tilte for page.
   	public String getTitle () 
   	{
   		return title;
   	}
   	
   	
   	public static final String KEYWORD = 'keyword';	
	
	public String getKeyword(){
		return getParam(KEYWORD);
	}
	
	public String typeAction = 'Search';
	
	public String getTypeAction(){
		return typeAction;
	}
	
   	/* ------------ */
   	/*  Result Core */
   	/* ------------ */
	//List of PeopleProfile__c 
	List<PeopleProfile__c> result = new List<PeopleProfile__c>();
	
	String keywordString = '';
	
	public void setKeywordString (String sKey){
		keywordString = sKey;
	} 
	
	//ResultCore()
	// @String type { result binding} 
	public void ResultCore(String TypeA)
	{
			
		if(!(paramIsEmpty(KEYWORD))){
			keywordString = System.currentPageReference().getParameters().get('keyword');
		}
		TypeA = 'Search';
		if(userId == null)
		{
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
	    	formerJobSearch = [select User__c from EmploymentHistory__c WHERE Employer__r.Name LIKE :likeParam(keywordString) ];
	    	collegeSearch = [select User__c from EducationHistory__c WHERE School__r.Name LIKE :likeParam(keywordString) ];
	    	competencySearch = [select User__c from UserCompetencies__c WHERE Competency__r.Name LIKE :likeParam(keywordString) ];
	    	teamspaceSearch = [select User__c from TeamMember__c WHERE Team__r.Name LIKE :likeParam(keywordString) ];
			
			
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
			
			
				result = [Select p.YahooIM__c, 
 						 p.Aol__c,
	 					 p.User__r.Phone, 
	 					 p.User__r.Email, 
	 					 p.User__r.Title, 
	 					 p.User__r.Department, 
	 					 p.User__r.Division, 
	 					 p.User__r.CompanyName, 
	 					 p.User__r.Name,
	 					 p.User__r.Id, 
	 					 p.User__c, 
	 					 p.Skype__c, 
	 					 p.Picture__c, 
	 					 p.AboutMe__c
	 					 From PeopleProfile__c p where p.User__c in : users
	 					 order by p.User__r.Name asc ];	
			
	 	
	 	
		 	//Set the Values of Paginator
		 	setSizeList(result.size());
		 	paginator.serTotalItemsNumber(result.size());
		 	paginator.genCntPagination();
		 	
		 	title = 'Search Results from People';	 	
	   		
	 	}
	 	
}
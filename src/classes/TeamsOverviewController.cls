/**
*@author Yuri Alvarez @ 05/02/2008
*/
public with sharing class TeamsOverviewController {

    public List<TeamMember__c> teams = new List<TeamMember__c>();
    public List<teams> auxTeamsList = new List<teams>();
	public String parentId = null;
	public String filter = System.currentPageReference().getParameters().get('filter');
	public PaginatorController paginator = new PaginatorController();
	public Boolean isTest = false;	
	
    /**
    * Construct
    */
    public TeamsOverviewController(){
    	teamsForTabs();
    }	
	
	/**
	*@param Boolean
	*/
	public void setIsTest(Boolean b){
		isTest = b;
	}
	
	/**
	*@return PaginatorController
	*/
	public PaginatorController getPaginator (){
		return paginator;
	}
	
	/**
	*@param String id
	*/
	public void setParentId (String id){
		parentId = id;	
	}
	
	/**
	*@param String f
	*/
	public void setFilter(String f){
		filter = f;
	}       

	/**
	* Check if people profile exist for current user
	* @return PageReference
	*/
	public PageReference profileExist(){
		PageReference pr = null;
		List<PeopleProfile__c> profiles = new List<PeopleProfile__c>();
		profiles = getPeopleProfile();
		if(profiles.size() == 0){
			PeopleProfile__c profile = new PeopleProfile__c();
			profile.User__c = UserInfo.getUserId();
			profile.Name = UserInfo.getName();
			insert profile;
		}
		return pr;
	}
	
	/**
	* Get people profile for current user
	*@return List<PeopleProfile__c>
	*/
	public List<PeopleProfile__c> getPeopleProfile(){
		List<PeopleProfile__c> profiles = new List<PeopleProfile__c>();			
		profiles = [SELECT Id,  Status__c, Picture__c, StatusLastModifiedDate__c
		     		FROM PeopleProfile__c
		     		WHERE User__c =: UserInfo.getUserId()];
		return profiles;	
	}
	
    /**
    *@return List<TeamMember__c>
    */
    public List<TeamMember__c> getTeams(){
    	return teams;
    }
    
    /**
    *@param List<TeamMember__c>
    */
    public void setTeams(List<TeamMember__c> tms){
    	teams = tms;
    }
     
    List<teams> retTeams = new List<teams>();
	/**
    * This method completes the list of Teams: "retTeams"
    *@return list of teams
    */
  	public List<teams> getTeamsForTabs(){
    	return retTeams;
    }  

  	/**
    *@teamsForTabs()
    * This method completes the list of Teams: "retTeams"
    */
    public void teamsForTabs(){
		//filter for query
		List<Team__c> teams = new List<Team__c>();
		retTeams.clear();
		auxTeamsList.clear();
		isAllTeams = false;
		
		//For Code Coverage Use
		Integer lim = (isTest) ? 1 : 100;		
		
		//Types of filter
		if(System.currentPageReference().getParameters().get('filter') != null)
			filter = System.currentPageReference().getParameters().get('filter');
			
					
		//@newTeams
		if(filter == 'newTeams'){
			teams = [Select 
					(Select Id From TeamMembers__r), 
					(Select Id From ProjectTasks__r), 
					(Select Id From DiscussionTopics__r),
					t.TeamCreatedDate__c ,
					t.Name,
					t.Picture__c, 
					t.Id  
					From Team__c t order by t.TeamCreatedDate__c  desc limit :lim];
		//@recommendedTeams
		}else if(filter == 'recommendedTeams'){
			List<TeamMember__c> members = new List<TeamMember__c>();
    		members = [SELECT s.Team__r.Id, 
    					  s.Team__r.Name, 
    					  User__c
	               FROM TeamMember__c s
    			   WHERE s.User__c =: UserInfo.getUserId()
    			   AND Team__c != null limit :lim];
    				
    	
	    	if(members.size() > 0){
		    	Set<Id> myTeams = new Set<Id>();
		    	for(TeamMember__c tm : members){
		    		myTeams.add(tm.Team__c);
		    	}
	 					
				members.clear();
				members = [select User__c 
							from TeamMember__c 
							where Team__c IN : myTeams];
	    	    
	    	    // Collect each user
	    	    Set<Id> users = new Set<Id>();
	    	    for(TeamMember__c tm: members) {
	    	    	users.add(tm.User__c);
	    	    } 				
	    		members.clear();
				members = [select Team__c, Team__r.Id, CreatedDate, Team__r.Name, Team__r.TeamCreatedBy__c, User__c 
							from TeamMember__c 
							where User__c IN : users
							AND User__c !=:UserInfo.getUserId() 
							order by CreatedDate DESC];
							
				Set<Id> teamsAux = new Set<Id>();
	    		for(TeamMember__c tm : members){
				  	teamsAux.add(tm.Team__c);		
	    		}	
				teams = [Select 
						(Select Id,User__c From TeamMembers__r), 
						(Select Id From ProjectTasks__r), 
						(Select Id From DiscussionTopics__r),
						t.Name,
						t.TeamCreatedDate__c, 
						t.Picture__c,
						t.Id  
						From Team__c t
						where id in :teamsAux
						limit :lim];
			}					
		//@allTeams
		}else if(filter == 'allTeams'){
			teams = [Select 
					(Select Id From TeamMembers__r), 
					(Select Id From ProjectTasks__r), 
					(Select Id From DiscussionTopics__r),
					t.TeamCreatedDate__c,
					t.Name,
					t.Picture__c, 
					t.Id  
					From Team__c t order by t.Name asc limit :lim];
			
			//Only allTeams show pagination and abc
			isAllTeams = true;
		//@Default My Teams
		}else {
			List<TeamMember__c> tml = new List<TeamMember__c>();
			tml =	[Select s.Team__c, s.Team__r.Id 
	                From TeamMember__c s
    				where s.User__c =: UserInfo.getUserId()
    				order by s.CreatedDate desc limit :lim];
    		
    		List<Team__c> teamsAux = new List<Team__c>();
    		for(TeamMember__c tm : tml){
				if(tm.Team__r != null){
			  		teamsAux.add(tm.Team__r);
				}
    		}
    		
			teams = [Select 
					(Select Id,User__c From TeamMembers__r), 
					(Select Id From ProjectTasks__r), 
					(Select Id From DiscussionTopics__r),
					t.Name,
					t.Picture__c, 
					t.Id  
					From Team__c t where t.Id in : teamsAux order by t.Name asc];
		}
		
		if(filter == 'allTeams'){
			paginator.setNumberOfItemsToShow(10);	
		}else{
			paginator.setNumberOfItemsToShow(teams.size());	
		}
		//Populate Inner class with team List
		if(teams.size() > 0){
			for(Integer i=0; i<teams.size(); i++){
				teams t = new teams();
				t.name = teams[i].Name;
				t.image = teams[i].Picture__c;
				t.id = teams[i].Id;
				t.members = teams[i].TeamMembers__r.size();
				t.tasks = teams[i].ProjectTasks__r.size();
				t.discussions = teams[i].DiscussionTopics__r.size();
				if(filter == 'newTeams'){
					if(teams[i].TeamCreatedDate__c != null){
						String format = teams[i].TeamCreatedDate__c.format('MM/dd/yyyy');
						t.createDate = 'Created on '+String.valueOf(format);
					}
				}else { 
					t.createDate = '';
				}

				retTeams.add(t);
				auxTeamsList.add(t);
				paginator.clearPagination();
				paginator.setTotalItemsNumber(retTeams.size());
	 			paginator.genCntPagination();			
			} 
		}
    }
    
    /**
    * This method returns the size of the Teams list: "retTeams"
    *@return Integer
    */
    public Integer getTeamsForTabsSize(){
    	return retTeams.size();
    }
    
    public Boolean isAllTeams { get; set; }
    
    /*
    * Class teams
    */
    public class teams {
    	
    	//Atributes, getters and setters
    	public String name { get; set; }
    	public String createDate{ 
    		get; 
    		set{
    			createDate = value;
    		} 
    	}
    	public String id { get; set; }
    	/**
    	*@return String
    	*/
    	public String image { 	
    		set {
	        	if(value == null) 
	        		image = 'null';
	        	else
	        		image = '/servlet/servlet.FileDownload?file=' + value;
    		}
    		get; 
    	}
    	public Integer members { get; set; }
    	public Integer tasks { get; set; }
    	public Integer discussions { get; set; }		
    }
    

	//Letters list
	public List<String> lettersList = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};	

	/**
	* Class Letters
	*/
	public class Letters{
		
		Boolean containSites;
		public String Letter{ get; set; }
		public Integer CntSites { get; set; }

		/**
		* Set num of ocurs.
		*@param Integer
		*/
		public void setContainSites (Integer cntSites){
			if (cntSites == 0){
				this.containSites = false;
			}else{
				this.containSites = true;
			}
		}
		
		/**
		* Returns num of ocurs.
		*@return Boolean
		*/
		public Boolean getContainSites (){
			return containSites;
		}
	}  	
   	
   	public List<Letters> letterFilter = new List<Letters>();
   	
   	/**
   	* Get Letter Filter
   	*@return List<Letters> 
   	*/
   	public List<Letters> getLetterFilter(){	
		setLetterFilter();
		return  letterFilter;
	}
   	
	/**
	* Set Letter Filter
	*/
	public void setLetterFilter () {	
   		if(System.currentPageReference().getParameters().get('ltr') != null)
   			return;	 
   		letterFilter.clear();
   		for (String item : lettersList){
			Letters currentLetter = new Letters();	   			
   			Integer cntSites = 0;	
   			
   			for (teams t : auxTeamsList){ 
   				if (t.name.startsWith(item) || t.name.startsWith(item.toLowerCase())){
   					cntSites++;
   				}
   			}
   			currentLetter.CntSites = cntSites;
   			currentLetter.Letter = item;
   			currentLetter.setContainSites(cntSites);
   		    letterFilter.add(currentLetter);
   		}	
	}
	
	/**
	* Filter Teams
	*/
	public void filterTeams (){
   		String letter = System.currentPageReference().getParameters().get('ltr');
   		retTeams.clear();
   		if(letter != 'ALL'){
	   		for (teams t : auxTeamsList){
	   			if (t.name.startsWith(letter) || t.name.startsWith(letter.toLowerCase())){
	   				retTeams.add(t);
	   			}
	   		}
	   	}else{
   			for (teams t : auxTeamsList){
   				retTeams.add(t);
   			}
   		}
		paginator.clearPagination();
		paginator.setTotalItemsNumber(retTeams.size());
 		paginator.genCntPagination();   		
	}
}
/**
*@author: Nicolas Gunther @ 5-19-2008
*/
public class AdminTeamTypeListController {

	List<TeamTypes> types;
	public String sortBy = 'name';
	public Boolean sortByDesc = false;
	
	/**
	* Constructor
	*/
	public AdminTeamTypeListController(){
		TeamUtil.isAdminMemberUser();
		getTeamTypes ();
	}	
	
	/**
	* Returns current sort by
	*@return String sortBy
	*/
	public String getSortBy(){
		return sortBy;
	}
	
	/**
	* Set sort by
	*@param String sort
	*/
	public void setSortBy(String s){
		sortBy = s;
	}
	
	/**
	* Returns current order sense
	*@return Boolean sortByDesc
	*/
	public Boolean getSortByDesc(){
		return sortByDesc;
	}
	
	/**
	* Set order sense
	*@param String sort
	*/
	public void setSortByDesc(Boolean b){
		sortByDesc = b;
	}	
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
    	
	/**
	* Get TeamType__c list
	*/
	public void getTeamTypes(){
		types = new List<TeamTypes>();
		List<TeamType__c> teamTypeList = new List<TeamType__c>(); 
		
		//Set oreder sense
		if (sortBy == System.currentPageReference().getParameters().get('sb')) {
			sortByDesc = !sortByDesc;
		}else {
			sortByDesc = false;
		}
		
		//Sort param
		if(System.currentPageReference().getParameters().get('sb') != null)
			sortBy = System.currentPageReference().getParameters().get('sb');
			
		if(sortByDesc){
			if(sortBy == 'name'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t order by t.Name desc];
			}
			if(sortBy == 'teams'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t];
			}
			if(sortBy == 'creator'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t order by t.CreatedBy.Name desc];
			}
			if(sortBy == 'created'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t order by t.CreatedDate desc];
			}
		}else{
			if(sortBy == 'name'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t order by t.Name asc];
			}
			if(sortBy == 'teams'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t];
			}
			if(sortBy == 'creator'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t order by t.CreatedBy.Name asc];
			}
			if(sortBy == 'created'){
				teamTypeList = [select 	t.Id, 
								t.CreatedBy.Name, 
								t.CreatedBy.Id, 
								t.CreatedDate, 
								t.Name, 
								t.PageName__c, 
								t.IsActive__c,
							    (Select Id From Teams__r)
							from TeamType__c t order by t.CreatedDate asc];
			}
		}
		
		for (TeamType__c teamType : teamTypeList){
			types.add (new TeamTypes(teamType));
		}	
		
		if (sortBy == 'teams'){
			types = sortList(types);		
		}	
	}
	
	/**
	* Returns TeamTypes list
	*@return List<TeamTypes>
	*/
	public List<TeamTypes> getTypes () {
		return types;
	}
	
	/**
	* Class for TeamType__c formating.
	*@author Nicolas Gunther
	*/
	public class TeamTypes {
		
		TeamType__c teamType = null;
		String createdDate = null;
		String createdById = null;
		String createdBy = null;
		User creator = null;
		
		/**
		* Constructor
		*@param TeamType__c
		*/
		public TeamTypes(TeamType__c teamType){
			this.teamType = teamType;
			this.createdDate = this.teamType.CreatedDate.format('MMMM dd, yyyy HH:mm aa');
			this.getCreatedById();
			this.getCreatedBy();
		}
		
		/**
		* Get TeamType__c instance
		*@return TeamType__c
		*/
		public TeamType__c getTeamType (){
			return teamType;
		}
		
		/**
		* Returns creator User Id
		*@return String
		*/		
		public String getCreatedById (){
			return createdById;
		}
		
		/**
		* Returns creator Name
		*@return String
		*/		
		public String getCreatedBy (){
			return createdBy;
		}		
		
		/**
		* Returns TeamType__c createdDate
		*@return String
		*/
		public String getCreatedDate (){
			return createdDate;
		}
		
		/**
		* Returns creator User
		*@return User 
		*/		
		public User getCreator (){
			return creator;
		}
		
		/**
		* Returns numbers of Teams asoc.
		*@return Integer
		*/
		public Integer getTeams(){
			return this.teamType.Teams__r.size();
		}
	}
	
	/**
	* Sort list by creator name
	*@return List<TeamProfile> tempProfiles
	*/
	public List<TeamTypes> sortList(List<TeamTypes> tempTypes){
	    Integer n;
	    Integer i;
	    Integer j;
	    
	    n = tempTypes.size() - 1;  
	    for (i = 1; i <= n; i++) {  
	        for (j = n; j >= i ; j--) {
	            if (sortByDesc) {
	                if (tempTypes.get(j).teamType.Teams__r.size() >= tempTypes.get(j - 1).teamType.Teams__r.size()) {
	                    TeamTypes tempTeamType;
	                    tempTeamType = tempTypes.get(j - 1);
	                    tempTypes.set(j - 1, tempTypes.get(j));
	                    tempTypes.set(j, tempTeamType);  
	                }   
	            } else {
	                if (tempTypes.get(j).teamType.Teams__r.size() <= tempTypes.get(j - 1).teamType.Teams__r.size()) {
	                    TeamTypes tempTeamType;
	                    tempTeamType = tempTypes.get(j - 1);
	                    tempTypes.set(j - 1, tempTypes.get(j));
	                    tempTypes.set(j, tempTeamType); 
	                }   
				}
			}
	    }
	    return tempTypes;	
	}
}
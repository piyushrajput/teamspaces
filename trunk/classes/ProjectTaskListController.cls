public with sharing class ProjectTaskListController {
    
    //Get Team Id 
    public String name;
    public Id USERID = UserInfo.getUserId(); 

    public Boolean editDeletePer = false;
    
    public boolean isTeamMember = false;
    public String TEAMID = System.currentPageReference().getParameters().get('id');
    public String filter = System.currentPageReference().getParameters().get('filter');
    List<ProjectTask__c> ListTask = new List<ProjectTask__c>();
    public Map<String, User> mapAsignees = new Map<String, User>();
    List<TaskDetails> taskList = new List<TaskDetails>();
    String option = 'all';
    
    public void reConstruct(){
        ListTask.clear();
    }
    
    public ProjectTaskListController(){
		genPermissions();   
		editDeletePer = userPermissions.getCanManage();
		genTaskList();
    	if(filter != null) {
    		option = 'allMilestones';
    		getsortListOption();
    	}
		genCntPagination();
		getUserProfile();    
    }
    
    public String getOption() {
        return option;
    }
    
    public void setOption(String option) {
        this.option = option;
    }
    
    public String getTeamId() {
        return TEAMID;
    }
    
    public void setTeamId(String sTEAMID) {
        TEAMID = sTEAMID;
    }
    
    public void setUserId(String sUSERID) {
        USERID = sUSERID;
    }
    
    public Boolean getEditDeletePer(){
        return editDeletePer;
    }
    
    public Boolean getIsTeamMember(){
        return isTeamMember;
    }

   
    public void getUserProfile(){
        
        List<TeamMember__c> members = new List<TeamMember__c>();
        
        members = [select tm.Id, tm.Name, tm.TeamProfile__c 
                    from TeamMember__c tm 
                    where tm.Team__c =: TEAMID and tm.User__c =: USERID];
        
        if(members.size() > 0){
            isTeamMember = true;
            List<TeamProfile__c> profile = new List<TeamProfile__c>();
            profile = [select p.Id, p.Name, p.ManageTeams__c 
                                        from TeamProfile__c p
                                        where p.Id =: members[0].TeamProfile__c];		
        }       
    }
    
    
    /* ---------------------------- */
   	/*   	 SHARING RULES			*/
   	/* ---------------------------- */	
	public UserPermissions userPermissions = new UserPermissions();
	
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(TEAMID);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}
	/* ---------------------------- */	
    
    public void  refresh(){
    	genTaskList();
    }
    
    public List<TaskDetails> getTaskList(){
    	return taskList;
    }
    
    public void genTaskList(){ 

		if((TEAMID != null) && (TEAMID != ' ')){
	        setAllUsers();
			ListTask = [select 
	                    p.Team__c, 
	                    p.Project__c,
	                    p.Priority__c, 
	                    p.Percent_Completed__c, 
	                    p.OwnerId, 
	                    p.Name, 
	                    p.Milestone__c, 
	                    p.Id,  
	                    p.createdById,
	                    p.EndDate__c, 
	                    p.Duration__c, 
	                    (select Id, User__c from ProjectAssignee__r),
	                    p.Description__c                                                
	                    from ProjectTask__c p where Team__c =: TEAMID order by EndDate__c asc];
	        
		     if(ListTask.size() > 0){
			     for(Integer i=0; i<ListTask.size();i++){
		            TaskDetails TaskDetail = new TaskDetails();
		            TaskDetail.id = ListTask[i].Id;
		            
		            if(ListTask[i].ProjectAssignee__r.size() > 0){
			            if(ListTask[i].ProjectAssignee__r[0]!=null ){
			            	TaskDetail.setAsigneeName(mapAsignees.get(ListTask[i].ProjectAssignee__r[0].User__c));
			            }
			            if(ListTask[i].ProjectAssignee__r[0].User__c == USERID){
			                TaskDetail.isTaskOwner = true; 
			            } else {
			                TaskDetail.isTaskOwner = false; 
			            }
		            }
		                
		            if(ListTask[i].Name!=null)
		            	TaskDetail.Name = ListTask[i].Name;
		            if(ListTask[i].Priority__c!=null)
		            	TaskDetail.Priority = ListTask[i].Priority__c;
		            if(ListTask[i].EndDate__c!=null)
		            	TaskDetail.DueDate = ((ListTask[i].EndDate__c).format('MM/dd/yyyy'));
		            if(ListTask[i].Duration__c!=null)
		            	TaskDetail.Estimate = (ListTask[i].Duration__c).intValue();
		            if(ListTask[i].Description__c!=null)
		            	TaskDetail.Description = ListTask[i].Description__c;
		            if(ListTask[i].Milestone__c!=null)
		            	TaskDetail.Milestone = ListTask[i].Milestone__c;
		            
		            if(ListTask[i].Percent_Completed__c != null && ListTask[i].Percent_Completed__c > 0) {
		            	TaskDetail.Percent_Completed= (ListTask[i].Percent_Completed__c).intValue();
		            } else {
		            	TaskDetail.Percent_Completed = 0;
		            }
		            if(ListTask[i].EndDate__c!=null){
		                if(ListTask[i].EndDate__c < System.now()) {
		                    TaskDetail.comparoFecha=true;
		                    long fechaInicialMs = ListTask[i].EndDate__c.getTime();
		                    long fechaFinalMs = System.now().getTime();
		                    long diferencia = fechaFinalMs - fechaInicialMs;
		                    TaskDetail.cantDias = (Math.floor(diferencia / (1000 * 60 * 60 * 24))).intValue();
		                    
		                } else {
		                    TaskDetail.comparoFecha=false;  
		                }
		            }
		            if(ListTask[i].createdById == USERID ) {
		            	TaskDetail.canEditAndDelete =  true;
		            } else {
		            	TaskDetail.canEditAndDelete =  false;
		            }

		            // If the user is an assignee of the task then they should have edit rights to the task
		            for(ProjectAssignee__c assignee: ListTask[i].ProjectAssignee__r) {
		            	if(assignee.User__c == USERID)
		            		TaskDetail.canEditAndDelete =  true;
		            }	            	            
		            taskList.add(TaskDetail); 
		    	 }
	         }
         
			List<Team__c> NameTeam =[select Name from Team__c where id=:TEAMID];
			if(NameTeam.size() > 0){
				this.setNameTeam(NameTeam[0].Name);  
			} 
			
			totalItemsNumber = taskList.size();
	        firstRow = 0;
	        currentPagination = 1;
	        if (totalItemsNumber == 0) {
	            cntPagination = 0;  
	        } else {
	            genCntPagination(); 
	        }
		}    
    }
    
    public String getNameTeam(){
        return this.name;
    }
    
    public void setNameTeam(String name){
        this.name=name;
    }       

	public void setAllUsers() {
		// LOADING THE ASIGNEES ONLY ONCE
		if(mapAsignees.size() == 0) {
			for(User a: [select Id, Name, (select Picture__c from People__r) from User]) {
				mapAsignees.put(a.Id, a);				          	
			}
		}
	}

    public class TaskDetails {

            // Task Id
            public String id { get; set; }
            
            // Task Asignee
			public String AsigneeName = null;         
            
            public void setAsigneeName(User u){ 
            	this.userTask = u;
            }            
            
            public String getAsigneeName (){
			   	if(this.userTask != null){
			    	if(userTask.People__r.size() <= 0){
			        	return '';
					}else {
			        	return userTask.People__r[0].Picture__c;
			        }
			   	}else {
			    	return '';
			   	}
		     
		   	}

            // Is Task Owner
            public boolean isTaskOwner {
                get;
                set ;
            }
            
            // Task Name
            public String Name { get; set; }
                        
            // Team Name
            public String TeamName { get; set; }
            
            // Priority
            public String Priority { get; set; }
            
            // Start Date
            public String StartDate { get; set; }
            
            // Due Date
            public String DueDate { get; set; } 
            
            // Estimated Time 
            public Integer Estimate { get; set; }
            
            // Description 
            public String Description { get; set; } 
            
            public boolean Milestone { 
                get { 
                    return Milestone; 
                }
                set {
                	Milestone = value;
                }
            }
            
            public Integer Percent_Completed { 
            	get; set; 
            }  
            
            public boolean comparoFecha { 
            	get; set; 
            }
            
            public Integer cantDias { 
            	get; set; 
            }  
            
            public User userTask { 
            	get; set; 
            }  
            
            public Boolean canEditAndDelete { 
            	get; set; 
            } 
                
    }
    
    /**
    * Pagination
    *
    */
    
    /**
    * Set of Integers to control pagination
    */
    public Integer totalItemsNumber = taskList.size();
    public Integer numberOfItemsToShow = 18;
    public Integer cntPagination = 0;
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
        cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow))) / numberOfItemsToShow;
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
    
    public void refreshPages () {
        
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
        if(currentPagination == 1){
        	prevPageLinkShow = false;       
        } else {
        	prevPageLinkShow = true;
    	}
        return prevPageLinkShow;
    }
    
    public boolean getPrevPageShow () {
        if(currentPagination == 1){ 
        	prevPageShow = true; 
        } else {
        	prevPageShow = false;
    	}
        return prevPageShow;
    }
    
    public boolean getNextPageLinkShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){   
        	nextPageLinkShow = false; 
        } else { 
        	nextPageLinkShow = true;
        }          
        return nextPageLinkShow;
    }
    
    public boolean getNextPageShow () {
        if((currentPagination == cntPagination) || (cntPagination == 0)){ 
        	nextPageShow = true; 
        } else { 
        	nextPageShow = false;
        } 
        return nextPageShow;
    }
    /* ---------------------------- */
    /*           ORDER BY           */
    /* ---------------------------- */
    public Boolean sortByDesc = false;
    
    public String sortBy = 'EndDate__c';
    
    public Boolean getSortByDesc () {
        return !sortByDesc;
    }
    

    public String getSortBy () {
        String sbCol = '';
        if (sortBy == null || sortBy == 'Milestone__c') 
            sbCol = 'type'; 
        if (sortBy == 'Priority__c') 
            sbCol = 'priority'; 
        if (sortBy == 'Name') 
            sbCol = 'name'; 
        if (sortBy == 'User__c.Name') 
            sbCol = 'assigned'; 
        if (sortBy == 'Percent_Completed__c') 
            sbCol = 'completed';    
        if (sortBy == 'Duration__c') 
            sbCol = 'est';  
        if (sortBy == 'EndDate__c') 
            sbCol = 'date'; 
        return sbCol;
    }
    
    public String SORTBYPARAM = '';
    
    public boolean sortByParamSet = false;
    
    public void setSORTBYPARAM (String SortVal){
    	sortByParamSet = true;
    	SORTBYPARAM = SortVal;
    }
    
    String sortByExt ;
    
    public void setSortByPrev(String s){
    	sortByExt = s;
    }
     
    /*
	 * This is a temporary method to cover us until dynamic apex is back.  This will use hard coded
	 * SOQL statements in place of the dynamic statements
	 */
	public void sortList () {
        List<TaskDetails> td = new List<TaskDetails>();
        
        setAllUsers();
        String SortByCriteria = '';
        
        if(sortByParamSet){
        	SortByCriteria = SORTBYPARAM;
        } else {     
        	if((System.currentPageReference().getParameters().get('sb') != 'refresh')){   	
        		SortByCriteria = System.currentPageReference().getParameters().get('sb'); 
        	} else {
        		SortByCriteria = System.currentPageReference().getParameters().get('criteria');
        	}
        }
       	
       	
	   	if ((sortBy == SortByCriteria) && (System.currentPageReference().getParameters().get('criteria') == null)) {
	       	sortByDesc = !sortByDesc;        	
	    } else {
	       	sortByDesc = false;
	    }
       	
    	sortBy = SortByCriteria;
        String sortByAux=sortBy;
        
        List<ProjectTask__c> resultTaskList = new List<ProjectTask__c>();
        
        if (sortBy.equals('User__c.Name'))
            sortBy='Name';        
        
        if (sortByDesc) {
	        if (sortBy == 'Milestone__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                 	From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Milestone__c desc];
	        }
	        if (sortBy == 'Priority__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID];	           
	        }   
	        if (sortBy == 'Name') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Name desc];	            
	        }
	        if (sortBy == 'User__c.Name') { // This one just does not work.  AssignTo cant be sorted on since it can be more then one
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Name desc];	            
	        }
	        if (sortBy == 'Percent_Completed__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Percent_Completed__c desc];	                
	        }
	        if (sortBy == 'Duration__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Duration__c desc];	              
	        }
	        if (sortBy == 'EndDate__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by EndDate__c desc];	            
	        }
        } else {
	        if (sortBy == 'Milestone__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Milestone__c];	            
	        }
	        if (sortBy == 'Priority__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID];
		                                
		                                           
	        }   
	        if (sortBy == 'Name') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Name];	            
	        }
	        if (sortBy == 'User__c.Name') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Name];	            
	        }
	        if (sortBy == 'Percent_Completed__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Percent_Completed__c];	                
	        }
	        if (sortBy == 'Duration__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by Duration__c];	              
	        }
	        if (sortBy == 'EndDate__c') {
	        	resultTaskList = [Select p.Team__c, 
		                                 p.Project__c,
		                                 p.Priority__c, 
		                                 p.Percent_Completed__c,
		                                 p.OwnerId, 
		                                 p.Name, 
		                                 p.Milestone__c, 
		                                 p.Id,
		                                 p.EndDate__c,
		                                 p.Duration__c,
		                                 (Select Id, 
		                                 		 User__r.Name,
		                                 		 User__c 
		                                  From ProjectAssignee__r), 
		                                 p.Description__c 
		                                 From ProjectTask__c p 
		                                 where Team__c =: TEAMID  
		                                 order by EndDate__c];	            
	        }        	
        }                
        
        if (sortBy == 'Priority__c'){
    		insertionSort(resultTaskList,sortByDesc);
        }
        
        for(Integer i=0; i < resultTaskList.size();i++){
            TaskDetails TaskDetail = new TaskDetails();
            TaskDetail.id = resultTaskList[i].Id;
            
            if(resultTaskList[i].ProjectAssignee__r.size() > 0){
            	TaskDetail.setAsigneeName(mapAsignees.get(resultTaskList[i].ProjectAssignee__r[0].User__c));
            	if(resultTaskList[i].ProjectAssignee__r[0].User__c == USERID){
	                TaskDetail.isTaskOwner = true; 
	            } else {
	                TaskDetail.isTaskOwner = false; 
	            }   
            }
            TaskDetail.Name = resultTaskList[i].Name;
            String picture = TaskDetail.getAsigneeName();
            TaskDetail.Priority = resultTaskList[i].Priority__c;
            if(resultTaskList[i].EndDate__c != null) TaskDetail.DueDate = ((resultTaskList[i].EndDate__c).format('MM/dd/yyyy'));
            TaskDetail.Estimate = (resultTaskList[i].Duration__c).intValue();
            TaskDetail.Description = resultTaskList[i].Description__c;
            TaskDetail.Milestone = resultTaskList[i].Milestone__c;
            
            if(resultTaskList[i].Percent_Completed__c != null){
                TaskDetail.Percent_Completed= (resultTaskList[i].Percent_Completed__c).intValue();
            }else{
            	TaskDetail.Percent_Completed= 0;
            }
            
            if(resultTaskList[i].EndDate__c < System.now()){
                TaskDetail.comparoFecha=true;
                long fechaInicialMs = resultTaskList[i].EndDate__c.getTime();
                long fechaFinalMs = System.now().getTime();
                long diferencia = fechaFinalMs - fechaInicialMs;
                TaskDetail.cantDias = (Math.floor(diferencia / (1000 * 60 * 60 * 24))).intValue();
            }else{
                TaskDetail.comparoFecha=false;  
            }
            
            td.add(TaskDetail);
        }
            
        totalItemsNumber = td.size();
        firstRow = 0;
        currentPagination = 1;
        
        if (totalItemsNumber == 0) {
            cntPagination = 0;  
        } else {
            genCntPagination(); 
        } 

        if (sortByAux.equals('User__c.Name')){
	        sortBy='User__c.Name';
	        Integer n;
	        Integer i;
	        Integer j;
	        
	        n = td.size() - 1;  
	        for (i = 1; i <= n; i++) {  
	            for (j = n; j >= i ; j--) {
	                if (sortByDesc) {
	                    if (td.get(j).userTask.name >= td.get(j - 1).userTask.name) {
	                        TaskDetails tempTaskDetail;
	                        tempTaskDetail = td.get(j - 1);
	                        td.set(j - 1, td.get(j));
	                        td.set(j, tempTaskDetail);  
	                    }   
	                } else {
	                    if (td.get(j).userTask.name <= td.get(j - 1).userTask.name) {
	                        TaskDetails tempTaskDetail;
	                        tempTaskDetail = td.get(j - 1);
	                        td.set(j - 1, td.get(j));
	                        td.set(j, tempTaskDetail); 
	                    }   
					}
				}
	        }
    	}
        taskList = td;  
    } 
	 
	private Integer mapPriority(String key, Boolean sortByDesc){
		if (!sortByDesc){
			if (key == 'High')
				return 3;
			else if (key == 'Normal')
				return 2;
			else if (key == 'Low')
				return 1;
			else return 4; // null value
		}else{
			if (key == 'High')
				return 1;
			else if (key == 'Normal')
				return 2;
			else if (key == 'Low')
				return 3;
			else 
				return 4; // null value
	 	}
	}
	 
	private void insertionSort(List<ProjectTask__c> listToOrder, Boolean sortByDesc) {
		Integer i, j, current_prio;
		ProjectTask__c current;
		Integer list_size = listToOrder.size();
		for (i=1; i < list_size; i++){
			current = listToOrder.get(i);
			current_prio = mapPriority(listToOrder.get(i).Priority__c,sortByDesc);
		  	j = i; // index of the end of sorted region
		  	while ((j > 0) && (mapPriority(listToOrder.get(j-1).Priority__c,sortByDesc) > current_prio)){
		    	listToOrder.set(j,listToOrder.get(j-1));
		    	j = j - 1;
		  	}
		  	listToOrder.set(j,current);
		}
	}

	public void getsortListOption () {
        List<TaskDetails> td = new List<TaskDetails>();
        List<TaskDetails> tdoTask = new List<TaskDetails>();
        List<TaskDetails> tdoMile = new List<TaskDetails>();
        List<TaskDetails> tdoComplete = new List<TaskDetails>();
        List<TaskDetails> tdoUser = new List<TaskDetails>();
        List<TaskDetails> listAllMilestones = new List<TaskDetails>();
        List<ProjectTask__c> resultTaskList = new List<ProjectTask__c>();
        String opciones=this.getOption();
        
        resultTaskList = [select p.Team__c, 
        						 p.Project__c,
        						 p.Priority__c, 
        						 p.Percent_Completed__c,
        						 p.OwnerId, 
        						 p.Name, 
        						 p.Milestone__c, 
        						 p.Id,
        						 p.EndDate__c,
        						 p.Duration__c,
        						 (select Id, 
        						 		 User__r.Name,
        						 		 User__c 
        						  from ProjectAssignee__r),   
        						 p.Description__c 
        				  from ProjectTask__c p 
        				  where Team__c =: TEAMID
        				  order by p.EndDate__c asc];
        				  
        for(Integer i=0; i < resultTaskList.size();i++){
            TaskDetails TaskDetail = new TaskDetails();
            TaskDetail.id = resultTaskList[i].Id;
            
            if(resultTaskList[i].ProjectAssignee__r.size() > 0) {
           		if(resultTaskList[i].ProjectAssignee__r[0]!=null )
	           		TaskDetail.setAsigneeName(mapAsignees.get(resultTaskList[i].ProjectAssignee__r[0].User__c));
            } 

            TaskDetail.Name = resultTaskList[i].Name;
            String picture = TaskDetail.getAsigneeName();
            
            TaskDetail.Priority = resultTaskList[i].Priority__c;
            
            if(resultTaskList[i].EndDate__c != null) {
            	TaskDetail.DueDate = ((resultTaskList[i].EndDate__c).format('MM/dd/yyyy'));
            }else {
            	TaskDetail.DueDate = '';
            }
            
            TaskDetail.Estimate = (resultTaskList[i].Duration__c).intValue();
            TaskDetail.Description = resultTaskList[i].Description__c;
            TaskDetail.Milestone = resultTaskList[i].Milestone__c;
            
            if(resultTaskList[i].Percent_Completed__c!=null){
	            TaskDetail.Percent_Completed= (resultTaskList[i].Percent_Completed__c).intValue();
            }else{
	            TaskDetail.Percent_Completed= 0;
            }
            
            if(resultTaskList[i].EndDate__c < System.now()){
                TaskDetail.comparoFecha=true;
                long fechaInicialMs = resultTaskList[i].EndDate__c.getTime();
                long fechaFinalMs = System.now().getTime();
                long diferencia = fechaFinalMs - fechaInicialMs;
                TaskDetail.cantDias = (Math.floor(diferencia / (1000 * 60 * 60 * 24))).intValue();
                
            }else{
                TaskDetail.comparoFecha=false;  
            }
            
            if(TaskDetail.comparoFecha==true && opciones.equals('oTask'))
            	tdoTask.add(TaskDetail);
            if(TaskDetail.comparoFecha==true && TaskDetail.Milestone==true && opciones.equals('oMiles'))
            	tdoMile.add(TaskDetail);
            if(opciones.equals('all'))
            	td.add(TaskDetail);
            if(TaskDetail.Milestone && opciones.equals('allMilestones'))
				listAllMilestones.add(TaskDetail);
            if(TaskDetail.Percent_Completed==100 && opciones.equals('complete'))
            	tdoComplete.add(TaskDetail);
            	
            if(TaskDetail.userTask != null){   
                if(TaskDetail.userTask.Id==USERID && opciones.equals('my'))
                tdoUser.add(TaskDetail);
            }
		}
        
        if( opciones.equals('oTask')){
            totalItemsNumber = tdoTask.size();
            this.taskList=tdoTask;
        }
        if(opciones.equals('oMiles')){
            totalItemsNumber = tdoMile.size();
            this.taskList=tdoMile;
        }
        if(opciones.equals('all')){
            totalItemsNumber = td.size();
            this.taskList=td;
        }
        if(opciones.equals('allMilestones')){
            totalItemsNumber = listAllMilestones.size();
        	//THERE MUST BE A SORTING BY DATE ASC
            this.taskList = listAllMilestones;
        }
        if(opciones.equals('complete')){
            totalItemsNumber = tdoComplete.size();
            this.taskList=tdoComplete;
        }
        if(opciones.equals('my')){
            totalItemsNumber = tdoUser.size();
            this.taskList=tdoUser;
        }

        firstRow = 0;
        currentPagination = 1;
        if (totalItemsNumber == 0) {
            cntPagination = 0;  
        } else {
            genCntPagination(); 
        } 
    }
  
  	/* ---------------------------- */
    /*        MARK COMPLETE         */
    /* ---------------------------- */
	public String idTaskToComplete = '';
	
	public String getIdTaskToComplete () {
		return idTaskToComplete;	
	}
	
	public void setIdTaskToComplete (String idTaskToComplete) {
		this.idTaskToComplete = idTaskToComplete;	
	}
	
	public void markComplete () {
		List<String> idsUpdate = new List<String>();
		
		if (idTaskToComplete != '' && idTaskToComplete != null) {
			idsUpdate = idTaskToComplete.split(':'); 
		}
		
		if(idsUpdate.size()>0){
			List<ProjectTask__c> tasksUpdate = [select (Select User__c from ProjectAssignee__r ), id from ProjectTask__c where id in: idsUpdate];
			
			if (tasksUpdate.size() > 0) {
				for (ProjectTask__c iterTask : tasksUpdate) {
					Boolean cantEditAndDelete = false;
					Integer countAssignee = 0;
					while (!cantEditAndDelete && countAssignee < iterTask.ProjectAssignee__r.size()) {
						if(iterTask.ProjectAssignee__r[countAssignee].User__c != USERID) {
							cantEditAndDelete =  true;
						}else {
							countAssignee++;
						}
		            }
					
					if(!cantEditAndDelete || editDeletePer || iterTask.createdById == USERID){
						iterTask.Percent_Completed__c = 100;
					}else {
						throw new CustomException('Insufficient Privileges');	
					}
						
				}	
				update tasksUpdate;
			}else{
				throw new CustomException('Insufficient Privileges');
			}
		}
		idTaskToComplete = '';
	}
	
	/* ---------------------------- */
    /*        DELETE TASK           */
    /* ---------------------------- */
    
    //String 
    public String idDeletes = '';
	
	public String getIdDeletes () {
		return idDeletes;	
	}
	
	public void setIdDeletes (String sidDeletes) {
		idDeletes = sidDeletes;	
	}
    
    public void deleteTask(){
    	List<String> myIds = new List<String>();
		
		if (idDeletes != '' && idDeletes != null){
			myIds = idDeletes.split(':'); 
		}
		if(myIds.size()>0){
			List<ProjectTask__c> tasksToDelete = [select (Select User__c from ProjectAssignee__r ), id from ProjectTask__c where id in: myIds];
			
			if (tasksToDelete.size() > 0){
				List<ProjectTask__c> taskListToDelete = new List<ProjectTask__c>(); 
				for (ProjectTask__c iterTask : tasksToDelete){
					Boolean cantEditAndDelete = false;
					Integer countAssignee = 0;
					while (!cantEditAndDelete && countAssignee < iterTask.ProjectAssignee__r.size()){
						if(iterTask.ProjectAssignee__r[countAssignee].User__c != USERID){
							cantEditAndDelete =  true;
						}else {
							countAssignee++;
						}
		            }
					if(!cantEditAndDelete || editDeletePer || iterTask.createdById == USERID){
						taskListToDelete.add(iterTask);
					}else {
						throw new CustomException('Insufficient Privileges');	
					}
				}
				if(taskListToDelete.size() > 0) {
					delete taskListToDelete;
				}
			}else if (tasksToDelete.size() == 0){
				
			}
		}
		idDeletes = '';
    }
    
}
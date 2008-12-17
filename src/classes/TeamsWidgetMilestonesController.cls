/**
*@author Martin Prado @ 06/18/2008
*/
public with sharing class TeamsWidgetMilestonesController {

	String teamId;
	
	/**
	*@param String
	*/
	public void setTeamId(String id) {
		if (teamId == null || teamId != id) {
			teamId = id;
			genPermissions();
			genAllProjectTasks();	
		}	
	}
	
	/**
	*@return String 
	*/
	public String getTeamId(){
		return teamId;
	} 
	
	public Boolean sidebar = false;
	
	/**
	* Set Sidebar
	*@param Boolean
	*/
	public void setSidebar (Boolean b){
		sidebar = b;
	}
	
	/**
	* Get Sidebar
	*@return Boolean
	*/
	public Boolean getSidebar(){
		return sidebar;
	}	
	
	//Size of List
	Integer listSize = 0;
	/**
	*@return Integer
	*/
	public Integer getListSize (){
		return listSize;
	}
	
	/**
	* For rerender use
	*/
	public void refresh(){}
	
	
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	
	/**
	* Read user permissions
	*/
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(teamId);
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		if(userPermissions == null) genPermissions();
		return userPermissions;
	}

	List<ProjectTasks> result = new List<ProjectTasks>();
	/**
	*@return List<ProjectTasks>
	*/
	public List<ProjectTasks> getAllProjectTasks() {
		return result;
	}
	
	/**
	* Read List of milestones
	*/
	public void genAllProjectTasks() {
		List<ProjectTask__c> milestones = new List<ProjectTask__c>();
		result = new List<ProjectTasks>();
		milestones = [Select 		
	 					p.Name,
	 					p.Priority__c, 
	 					p.Id, 
	 					p.EndDate__c, 
	 					p.Duration__c, 
	 					p.Team__c,
	 					p.Milestone__c,
	 					p.Percent_Completed__c,
	 					p.Description__c, 
	 					(Select User__c, User__r.Name From ProjectAssignee__r) 
	 					From ProjectTask__c  p 
	 					where  p.Milestone__c = true 
	 					and p.Team__c =: teamId  
	 					order by p.EndDate__c asc limit 5
	 					];
	 					
	 	listSize = milestones.size();  // think there is a better way todo this
	 	
	 	// Retrieve Users
		Set<Id> users = new Set<Id>();		
	 	for( ProjectTask__c milestone : milestones) {
	 		if(milestone.ProjectAssignee__r.size() > 0){
				users.add(milestone.ProjectAssignee__r[0].User__c);
	 		}
	 	}
	 	
	 	Map<Id, User> userMap = new Map<Id,User>();
		for(User u: [SELECT Id, 
							Name, 
							(Select Name, Picture__c From People__r) 
							FROM User u 
							WHERE u.id IN: users]){
			userMap.put(u.Id, u);							
		}
	 	
		for( ProjectTask__c milestone : milestones) {
			if(milestone.Percent_Completed__c < 100){				
				ProjectTasks miMilestones = new ProjectTasks();
				miMilestones.setTaskName(milestone.Name);
				miMilestones.setTaskId(milestone.Id);
				if(milestone.ProjectAssignee__r.size() > 0){
					miMilestones.setUser(userMap.get(milestone.ProjectAssignee__r[0].User__c));					
				}
				miMilestones.setDaysCount(milestone.EndDate__c, milestone.Duration__c);
				miMilestones.setDayPercent(milestone.EndDate__c, milestone.Duration__c);
				miMilestones.setDayPercentRight(milestone.EndDate__c, milestone.Duration__c);
				miMilestones.setPriority(milestone.Priority__c);
				miMilestones.setEndDate(milestone.EndDate__c, milestone.Duration__c);
				miMilestones.setEndDateRight(milestone.EndDate__c, milestone.Duration__c);				
				miMilestones.setIsToLate(milestone.EndDate__c);  
				result.add(miMilestones);
			}
			
		 } 
		 
		 milestones.clear();
		 users.clear();
		 userMap.clear();
	 }
		
					
	
	
	 /**
	 * Class ProjectTasks
	 */
	 public class ProjectTasks {
		
        public String TaskId;
        public String TaskName;
        public String DaysCount;
        public String UserId;
		public String UserName;
		public String EndDate;
		public String EndDateRight;
		public Integer DayPercent;
		public Integer DayPercentRight;
        public String Picture;
        public String Priority;
        public String isToLate;
      	DateTime now = System.now();
		
      	/**
      	* Constructor
      	*/
      	public ProjectTasks(){		
      		
      	}		
		
		/**
		*@return Integer
		*/
		public Integer getDayPercent() {
      		return DayPercent;
        }
        
        /**
        * For progress bar use (wide widget use)
        *@param Datetime end date
        *@param Double duration
        */
        public void setDayPercent(Datetime endD, Double dur){
			Date miToday = Date.today();
			Date endDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(endDate);
			if(dur > 0){
				DayDiference = DayDiference -  dur.intValue();
			}  
           	if(DayDiference < 0){
        		DayPercent = 0;	
        	}else {
        		 DayDiference = DayDiference * 4;
        		 if(DayDiference > 290){
        		 	DayPercent = 290;
        		 }else {
        		 	DayPercent = DayDiference;
        		 }
        	}
        }
        
        /**
        *@return Integer
        */
        public Integer getDayPercentRight() {
      		return DayPercentRight;
        }
        
        /**
        *@param Datetime end date (thin widget use)
        *@param Double duration
        */
        public void setDayPercentRight(Datetime endD, Double dur){
			Date miToday = Date.today();
			Date endDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(endDate);
			if(dur > 0){
				DayDiference = DayDiference -  dur.intValue();
			}  
           	if(DayDiference < 0){
        		DayPercentRight = 0;	
        	}else {
        		 DayDiference = DayDiference * 4;
        		 if(DayDiference > 131){
        		 	DayPercentRight = 132;
        		 }else {
        		 	DayPercentRight = DayDiference;
        		 }
        	}
        }
      	
      	/**
      	*@return String
      	*/
      	public String getPicture() {
      		return Picture;
        }
      	
      	/**
      	*@return String
      	*/
      	public String getEndDate() {
      		return EndDate;
        }
        
        /**
        *@param Datetime end time
        *@param Double dif
        */
        public void setEndDate(Datetime endD, Double dif){			
			if(dif > 0){
				endD = endD.addDays(-dif.intValue());
			}  
           	EndDate =  endD.format('MM/dd/yyyy');
        }
        
  		/**
  		*@return String
  		*/
  		public String getIsToLate() {
      		return isToLate;
        }
        
        /**
        *@param Datetime end date
        *@param Double dif
        */
        public void setEndDateRight(Datetime endD, Double dif){	
			if(dif > 0){
				endD = endD.addDays(-dif.intValue());
			}
           	EndDateRight =  endD.format('(MM/dd)');
        }
        
  		/**
  		*@return String
  		*/
  		public String getEndDateRight() {
      		return EndDateRight;
        }
        
        /**
        *@param Datetime end date
        */
        public void setIsToLate(Datetime endD){	
        	Date miToday = Date.today();
			Date myEndDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(myEndDate); 	
        	
        	if(DayDiference < 1){
        		isToLate = 'latter';	
        	}else {
            	isToLate = '';
            }
        }
        
		/**
		*@return String
		*/       
        public String getDaysCount() {
      		return DaysCount;
        }
       
        /**
        *@param Datetime end date
        *@param Double duration
        */
        public void setDaysCount(Datetime endD, Double dur){
        	Date miToday = Date.today();
			Date endDate = Date.newInstance(endD.year(), endD.month(),endD.day());
			Integer DayDiference = miToday.daysBetween(endDate);   
			if(dur > 0){
				DayDiference = DayDiference -  dur.intValue();
			}   	
        	if(DayDiference < 2){	
        		if(DayDiference == 1){
        			DaysCount = 'Tomorrow';
        		}else if(DayDiference == 0 ){
        			DaysCount = 'Today';
        		}else {
        			DaysCount =  (DayDiference*-1) +' days late';
        		}
        	}else {
        		 DaysCount = DayDiference +' days';
        	}
        }
        
        /**
        *@param User
        */
        public void setUser(User user){
        	if(user != null){
	            UserName = user.name;
	            UserId = user.Id;
	        	
	            if(user.People__r.size() > 0 &&
	               user.People__r[0].Picture__c != null &&
	               user.People__r[0].Picture__c != '') {
	           		Picture = user.People__r[0].Picture__c;
	            } else {
	            	Picture = ' ';
	            }
        	}
        }
        
        /**
        *@return String
        */
        public String getUserId() {
      		return UserId;
        }
        
    	/**
    	*@return String
    	*/
    	public String getUserName() {
       		return UserName;
        }
      	
      	/**
      	*@return String
      	*/
      	public String getTaskId() {
            return TaskId;
        }
        
        /**
        *@param String
        */
        public void setTaskId(String idTask){
            TaskId = idTask;
        }
        
      	/**
      	*@return String
      	*/
      	public String getPriority() {
            return Priority;
        }
        
        /**
        *@param String
        */
        public void setPriority(String pr){
            Priority = pr;
        }
        
        /**
        *@return String
        */
        public String getTaskName() {
            return TaskName;
        }
        
        /**
        *@param String
        */
        public void setTaskName(String sName){
            TaskName = sName;
        }
	 }
}
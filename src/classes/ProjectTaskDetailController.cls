public class ProjectTaskDetailController {

	String param;
	TaskDetails TaskDetail = new TaskDetails();
	public Boolean isAdmin = false;
	public boolean isTeamMember = false;	
	boolean detailsOk;
	
	public ProjectTaskDetailController(){
		param = System.currentPageReference().getParameters().get('id');
		getTask(param);
		getUserProfile();	
	}
	
	public Boolean getIsAdmin(){
		return isAdmin;
	}
	
	public Boolean getIsTeamMember(){
		return isTeamMember;
	}		
	
	/**
	* Get Project Task
	*@param String param
	*@void
	*/
	public void getTask (String param){
		if((param != null) && (param != '')){
			detailsOk = true;
			ProjectTask__c TD = [Select 
									p.Id,												
									p.Team__c,
									p.Team__r.Name, 
									p.StartDate__c, 
									p.Priority__c, 
									p.Percent_Completed__c,
									p.Name, 
									p.Milestone__c, 
									p.LastModifiedById, 
									p.LastModifiedBy.Name,
									p.LastModifiedDate,
									p.EndDate__c, 
									p.Duration__c, 
									p.Description__c, 
									p.ParentTask__c,
									p.ParentTask__r.Name,
									p.ParentTask__r.Id,
									p.CreatedById,
									p.CreatedBy.Name,
									p.CreatedDate, 
									(Select Id, Name, Deadline__c, Description__c From Project_Task__r),
									(Select Id, Name, ContentType, BodyLength From Attachments),
									(Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectAssignee__r order by User__r.Name) 
									From ProjectTask__c p where p.Id =: param ];
			
			if(TD.Id != null ){
				TaskDetail.id = TD.Id;
				// Parent Task Data
				TaskDetail.IsTaskOwner = false;
				
				if(((TD.ProjectAssignee__r).size() != 0) && (TD.ProjectAssignee__r != null)){
					// Has Asignee
					TaskDetail.HasAsignee = true;
					//List<User> u = [Select Id, Name from User where id =: TD.ProjectAssignee__r[0].User__c ];
					
					List<ProjectAssignee> assignees = new List<ProjectAssignee>();
					
					for (ProjectAssignee__c item: TD.ProjectAssignee__r) {
						ProjectAssignee assignUser = new ProjectAssignee();
						assignUser.setId(item.User__r.id);
						assignUser.setName(item.User__r.Name);
						if (item.PercentDedicated__c == null) {
							assignUser.setPercent(0);
						}
						else {
							assignUser.setPercent(item.PercentDedicated__c.intValue());	
						}
						assignees.add(assignUser);
					}
					
					TaskDetail.Asignee = assignees;
					//TaskDetail.Asignee = TD.ProjectAssignee__r;
					// Is the Task Owner ?
					if(UserInfo.getUserId() == TD.CreatedById){
						TaskDetail.IsTaskOwner = true;	
					}						
				} else {
					TaskDetail.HasAsignee = false;
					TaskDetail.IsTaskOwner = false;
				}
				TaskDetail.Name = TD.Name;
				
				TaskDetail.TeamId = TD.Team__c;
				TaskDetail.TeamName = TD.Team__r.Name;
				TaskDetail.Priority = TD.Priority__c;
				TaskDetail.StartDate = ((TD.StartDate__c).format('MM/dd/yyyy'));
				TaskDetail.DueDate = ((TD.EndDate__c).format('MM/dd/yyyy'));
				TaskDetail.Estimate = (TD.Duration__c).intValue();
				TaskDetail.Description = TD.Description__c;
				TaskDetail.Milestone = TD.Milestone__c;
				
				// Parent Task Data
				if(TD.ParentTask__c != null){
					TaskDetail.ParentTaskName = TD.ParentTask__r.Name;
					TaskDetail.ParentTaskId = TD.ParentTask__r.Id;
				}
				
				// Last Modified data
				TaskDetail.LastModifiedById = TD.LastModifiedById;
				TaskDetail.LastModifiedByName = TD.LastModifiedBy.Name;
				TaskDetail.LastModifiedDate = ((TD.LastModifiedDate).format('MM/dd/yyyy hh:mm aaa'));
				
				// Created By Data
				TaskDetail.CreatedById = TD.CreatedById;
				TaskDetail.CreatedByName = TD.CreatedBy.Name;
				TaskDetail.CreatedDate = ((TD.CreatedDate).format('MM/dd/yyyy hh:mm aaa')); 
				
				// Percent Completed
				if(TD.Percent_Completed__c != null){
					TaskDetail.PercentCompleted = ((TD.Percent_Completed__c).intValue());
				} else {
					TaskDetail.PercentCompleted = 0;
				}
				
				//List of files attached
				if((TD.Attachments.size() != 0) || (TD.Attachments == null)){				
					TaskDetail.ShowAttachs = true;
					
					
					List<AttachmentInfo> infos = new List<AttachmentInfo>();

					for (Attachment item: TD.Attachments){	
			            AttachmentInfo info = new AttachmentInfo();
			            info.setId(item.Id);
			            info.setName(item.Name);
			            
			            String ContentType = item.ContentType;
			            String image = '';
			            if (ContentType == null || ContentType == '') {
			            	// LO HAGO POR LA EXTENSION
			            	Integer extPos = item.Name.lastIndexOf('.') + 1;
			            	String extension = item.Name.substring(extPos);	
			           		Map<String, String> typesExt = new Map<String, String>{'rar' => 'rar.gif', 'xls' => 'xls.gif', 'ppt' => 'ppt.gif', 'avi' => 'video.gif', 'mpeg' => 'video.gif', 'flv' => 'video.gif','mpg' => 'video.gif', 'mp3' => 'audio.gif' , 'wav' => 'audio.gif'};	
			           		if(typesExt.containsKey(extension)) {
			           			image = typesExt.get(extension);
			           		}
			           		else {
			           			image = 'generic.gif';
			           		}
			            }
			            else {
			           		// LO HAGO POR EL MIME TYPE
			           		Map<String, String> typesMime = new Map<String, String>{'image/jpeg' => 'images.gif', 'image/png' => 'images.gif', 'image/gif' => 'images.gif', 'image/bmp' => 'images.gif', 'application/pdf' => 'pdf.gif', 'text/plain' => 'txt.gif','application/msword' => 'doc.gif', 'application/x-zip-compressed' => 'zip.gif'};	
			           		if(typesMime.containsKey(ContentType)) {
			           			image = typesMime.get(ContentType);
			           		}
			           		else {
			           			image = 'generic.gif';
			           		}
			            }
			            
			            info.setAttachImage(image);
			            infos.add(info);
			        }
					TaskDetail.Files = infos;
					
					//TaskDetail.Files = TD.Attachments;				
				} else {
					TaskDetail.ShowAttachs = false;
				}
				
				
			} 
		} else {
			detailsOk = false;		
		}	
	}
	
	public class ProjectAssignee {
		String id;
		String name;
		Integer percent;	
		
		public String getId () {
        	return id;
        }
        
        public void setId (String id) {
        	this.id = id;
        }
        
        public String getName() {
        	return name;
        }

        public void setName(String name) {
       		this.name = name;
        } 
        
        public Integer getPercent() {
        	return percent;
        }
        
        public void setPercent (Integer percent) {
        	this.percent = percent;
        }
	}
	
	public class AttachmentInfo {
        
        String name;
        String attachImage;
		String id;
        
        public String getId () {
        	return id;
        }
        
        public void setId (String id) {
        	this.id = id;
        }
        
        public String getName() {
        	return name;
        }

        public void setName(String name) {
        	this.name = name;
        }  
        
        public String getAttachImage() {
        	return attachImage;
        }

        public void setAttachImage (String attachImage) {
        	this.attachImage = attachImage;
        }          
                                        
	}
	
	
	public boolean getDetailsOk(){
		return detailsOk;
	}
	
	
	public TaskDetails getTask(){
		return TaskDetail;
	}
	
	
	/**
	* Get Team member profile
	*@void
	*/
	public void getUserProfile(){
		
		List<TeamMember__c> members = new List<TeamMember__c>();
		
		members = [select tm.Id, tm.Name, tm.TeamProfile__c 
					from TeamMember__c tm 
					where tm.Team__c =: TaskDetail.TeamId and tm.User__c =: userInfo.getUserId()];
		
		if(members.size() > 0){
			isTeamMember = true;
			List<TeamProfile__c> profile = new List<TeamProfile__c>();
			profile = [select p.Id, p.Name, p.ManageTeams__c 
										from TeamProfile__c p
										where p.Id =: members[0].TeamProfile__c];
			if(profile.size() > 0){
				if(profile[0].ManageTeams__c)
					isAdmin	= true;					
			}
		}
	}	
	
	
	public class TaskDetails {
			
			// Task Id
			public String id { get; set; }		   	
		   	
		   	// Task Asignee
			public List<ProjectAssignee> Asignee { get; set; }
			
			// Task Has Asignee
			public boolean HasAsignee { get; set; }
			
			// Current Viewer is the task owner
			public boolean IsTaskOwner { get; set; }				
			
			// Task Name
			public String Name { get; set; }
		    			
			// Team Name
			public String TeamName { get; set; }
			
			public String TeamId { get; set; }
		   	
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
			
			// Parent Task Data
			/////////////////////////
			// Name
			public String ParentTaskName { get; set; }
			// Id			 
			public String ParentTaskId { get; set; }
		
			
			// Last Modified By data
			/////////////////////////
			// Last Modified By ID
			public String LastModifiedById { get; set; }
			
			// Last Modified By Name
			public String LastModifiedByName { get; set; }
			
			// Last Modified Date
			public String LastModifiedDate { get; set; }
			
			// Created By data
			/////////////////////////
			// Created By ID
			public String CreatedById { get; set; }
			
			// Created By Name
			public String CreatedByName { get; set; }
			
			// Created Date
			public String CreatedDate { get; set; }
			
			// Created Date
			public Boolean Milestone { get; set; }			
			
			// Percent Completed
			public Integer PercentCompleted { get; set; }
			
			// Attached Files
			/////////////////
			//Show List ? (boolean)
			public boolean ShowAttachs { get; set; }
			//Attachment List
			public List<AttachmentInfo> Files { get; set; }	
		
	}
	
	
}
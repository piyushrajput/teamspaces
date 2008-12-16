/**
*@author Nicolas Gunther @ 6-23-2008
*/
public with sharing class ProjectTaskDetailController {

	TaskDetails taskDetail = null;
	boolean detailsOk;
	
	/**
	* Constructor
	*/
	public ProjectTaskDetailController(){
		param = System.currentPageReference().getParameters().get('id');
		getTask(param);
		genPermissions();		
	}	
	
	public UserPermissions userPermissions = new UserPermissions();
	
	/**
	* Generate permissions for an especific user
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setObjectType('Project');
		userPermissions.setPermissions();		
	}
	
	/**
	* Return the user's permissions
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}
	/* ---------------------------- */
	
	public String param {get; set;}

	/**
	* Set the value of task id
	*@param String
	*/
	public void setTaskId(String s) {
		param = s;
	}
	
	/**
	* Update the task's percent to 100
	*/
	public void markComplete(){
		try{
			ProjectTask__c myTask = [Select Percent_Completed__c, Team__c, Id From ProjectTask__c where Id =: param];
			myTask.Percent_Completed__c = 100;
			update myTask;
		}catch(Exception e){
			throw e;
		}
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
									(Select Id, Name, ContentType, BodyLength From Attachments),
									(Select Id, User__c, User__r.Name, User__r.Id,PercentDedicated__c From ProjectAssignee__r order by User__r.Name) 
									From ProjectTask__c p where p.Id =: param ];
			
			if(TD != null ){
				taskDetail = new TaskDetails();
				taskDetail.id = TD.Id;
				taskDetail.IsTaskOwner = false;
				
				if(((TD.ProjectAssignee__r).size() != 0) && (TD.ProjectAssignee__r != null)){
					taskDetail.HasAsignee = true;
					List<ProjectAssignee> assignees = new List<ProjectAssignee>();
					
					for (ProjectAssignee__c item: TD.ProjectAssignee__r) {
						ProjectAssignee assignUser = new ProjectAssignee();
						assignUser.setId(item.User__r.id);
						assignUser.setName(item.User__r.Name);
						if (item.PercentDedicated__c == null) {
							assignUser.setPercent(0);
						}else {
							assignUser.setPercent(item.PercentDedicated__c.intValue());	
						}
						assignees.add(assignUser);
						if(item.User__c == UserInfo.getUserId()) 
							taskDetail.IsTaskOwner = true;	
					}
					taskDetail.Asignee = assignees;
					if(UserInfo.getUserId() == TD.CreatedById){
						taskDetail.IsTaskOwner = true;	
					}
				} else {
					taskDetail.HasAsignee = false;
					taskDetail.IsTaskOwner = false;
				}
				taskDetail.Name = TD.Name;
				userPermissions.setTeam(TD.Team__c);
				taskDetail.TeamId = TD.Team__c;
				taskDetail.TeamName = TD.Team__r.Name;
				taskDetail.Priority = TD.Priority__c;
				taskDetail.StartDate = ((TD.StartDate__c).format('MM/dd/yyyy'));
				
				if(TD.EndDate__c != null){
					taskDetail.DueDate = ((TD.EndDate__c).format('MM/dd/yyyy'));
				}else {
					taskDetail.DueDate = '';
				}
				
				taskDetail.Estimate = (TD.Duration__c).intValue();
				taskDetail.Description = TD.Description__c;
				taskDetail.Milestone = TD.Milestone__c;
				
				// Parent Task Data
				if(TD.ParentTask__c != null){
					taskDetail.ParentTaskName = TD.ParentTask__r.Name;
					taskDetail.ParentTaskId = TD.ParentTask__r.Id;
				}
				
				// Last Modified data
				taskDetail.LastModifiedById = TD.LastModifiedById;
				taskDetail.LastModifiedByName = TD.LastModifiedBy.Name;
				taskDetail.LastModifiedDate = ((TD.LastModifiedDate).format('MM/dd/yyyy hh:mm aaa'));
				
				// Created By Data
				taskDetail.CreatedById = TD.CreatedById;
				taskDetail.CreatedByName = TD.CreatedBy.Name;
				taskDetail.CreatedDate = ((TD.CreatedDate).format('MM/dd/yyyy hh:mm aaa')); 
				
				// Percent Completed
				if(TD.Percent_Completed__c != null){
					taskDetail.PercentCompleted = ((TD.Percent_Completed__c).intValue());
				} else {
					taskDetail.PercentCompleted = 0;
				}
				
				//List of files attached
				if((TD.Attachments.size() != 0) || (TD.Attachments == null)){				
					taskDetail.ShowAttachs = true;
					
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
			           		}else {
			           			image = 'generic.gif';
			           		}
			            }else {
			           		// LO HAGO POR EL MIME TYPE
			           		Map<String, String> typesMime = new Map<String, String>{'image/jpeg' => 'images.gif', 'image/png' => 'images.gif', 'image/gif' => 'images.gif', 'image/bmp' => 'images.gif', 'application/pdf' => 'pdf.gif', 'text/plain' => 'txt.gif','application/msword' => 'doc.gif', 'application/x-zip-compressed' => 'zip.gif'};	
			           		if(typesMime.containsKey(ContentType)) {
			           			image = typesMime.get(ContentType);
			           		}else {
			           			image = 'generic.gif';
			           		}
			            }
			            info.setAttachImage(image);
			            infos.add(info);
			        }
					taskDetail.Files = infos;				
				} else {
					taskDetail.ShowAttachs = false;
				}
			} 
		} else {
			detailsOk = false;		
		}	
	}
	
	/**
	* Inner class for Proyect Assignee
	*/
	public class ProjectAssignee {
		String id;
		String name;
		Integer percent;	
		
		/**
		*@return String
		*/
		public String getId () {
        	return id;
        }
        
        /**
        *@param String
        */
        public void setId (String id) {
        	this.id = id;
        }
        
        /**
		*@return String
		*/
        public String getName() {
        	return name;
        }
		
		/**
        *@param String
        */
        public void setName(String name) {
       		this.name = name;
        } 
        
        /**
		*@return Integer
		*/
        public Integer getPercent() {
        	return percent;
        }
        
        /**
		*@param Integer
		*/
        public void setPercent (Integer percent) {
        	this.percent = percent;
        }
	}
	
	/**
	* Inner class for Attachment Info
	*/
	public class AttachmentInfo {
        
        String name;
        String attachImage;
		String id;
        
        /**
		*@return String
		*/
        public String getId () {
        	return id;
        }
        
        /**
        *@param String
        */
        public void setId (String id) {
        	this.id = id;
        }
        
        /**
		*@return String
		*/
        public String getName() {
        	return name;
        }
		
        /**
        *@param String
        */
        public void setName(String name) {
        	this.name = name;
        }  
        
        /**
		*@return String
		*/
        public String getAttachImage() {
        	return attachImage;
        }

        /**
        *@param String
        */
        public void setAttachImage (String attachImage) {
        	this.attachImage = attachImage;
        }          
                                        
	}
	
	
	/**
	*@return boolean
	*/
	public boolean getDetailsOk(){
		return detailsOk;
	}
	
	/**
	*@return TaskDetails
	*/
	public TaskDetails getTask(){
		return taskDetail;
	}
	
	/**
	* Inner class for Task Details
	*/
	public class TaskDetails {
			
			/**
			* Task Id
			*/
			public String id { 
				get; set; 
			}		   	
		   	
		   	/**
		   	* Task Asignees 
		   	*/
			public List<ProjectAssignee> Asignee { 
				get; set; 
			}
			
			/**
			* Has Asignee
			*/
			public boolean HasAsignee { 
				get; set; 
			}
			
			/**
			* Current Viewer is the task owner
			*/
			public boolean IsTaskOwner { 
				get; set; 
			}				
			
			/**
			* Task Name
			*/
			public String Name { 
				get; set; 
			}
		    			
			/**
			* Team Name
			*/
			public String TeamName { 
				get; set; 
			}
			
			/**
			* Team ID
			*/
			public String TeamId { 
				get; set; 
			}
		   				
			/**
			* Team Priority
			*/
			public String Priority { 
				get; set; 
			}
						
			/**
			* Task Start Date
			*/
			public String StartDate { 
				get; set; 
			}
						
			/**
			* Due Date
			*/
			public String DueDate { 
				get; set; 
			}	
						
			/**
			* Estimated Time
			*/
			public Integer Estimate { 
				get; set; 
			}
						
			/**
			* Description
			*/
			public String Description { 
				get; set; 
			}	
			
			/**
			* Parent Name
			*/
			public String ParentTaskName { 
				get; set; 
			}
						
			/**
			* Parent ID
			*/
			public String ParentTaskId { 
				get; set; 
			}

			/**
			* Last Modified By Id
			*/
			public String LastModifiedById { 
				get; set;
			}
			
			/**
			* Last Modified By Name
			*/
			public String LastModifiedByName { 
				get; set; 
			}
			
			/**
			* Last Modified Date
			*/
			public String LastModifiedDate {
				get; set; 
			}
			
			/**
			* Created By ID
			*/
			public String CreatedById { 
				get; set; 
			}
			
			/**
			* Created By Name
			*/
			public String CreatedByName { 
				get; set; 
			}
			
			/**
			* Created Date
			*/
			public String CreatedDate { 
				get; set; 
			}
			
			/**
			* Created Milestone
			*/
			public Boolean Milestone { 
				get; set; 
			}			
			
			/**
			* Percent Completed
			*/
			public Integer PercentCompleted { 
				get; set; 
			}
			
			/**
			* Show Attachs List?
			*/
			public boolean ShowAttachs { 
				get; set; 
			}
			
			/**
			* Attachment List
			*/
			public List<AttachmentInfo> Files { 
				get; set; 
			}	
			
	}
	
}
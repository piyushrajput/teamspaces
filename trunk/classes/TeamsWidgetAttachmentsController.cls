public class TeamsWidgetAttachmentsController {
	
	String teamId;
	public List<AttachmentInfo> attachs = new List<AttachmentInfo>();	
	
	public Boolean sidebar = false;
	
	/**
	* Set Sidebar
	*@void
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
	
	// Setter method for Team Id variable
	public void setTeamId(String id) {
		if(teamId == null || teamId == ''){
			teamId = id;
			currentTeam();
			genPermissions();
			getAttachments();
		}
	}
	
	// Getter Team Id variable
	public String getTeamId(){
		return teamId;
	}
	
	/**
	*@return List<AttachmentInfo
	*/
	public List<AttachmentInfo> getAttachs(){
		return attachs;
	}
	
	public void refresh() {
		getAttachments();
	} 
	
	//Constructor
	public TeamsWidgetAttachmentsController(){
		
	}
	
	//set the current team Picture
	public void currentTeam() {
		teamInfo = [Select 
	                t.Picture__c, CreatedById
	                From Team__c t Where t.Id =:teamId];
	    PictureIDSet();	
	}
	
	public String PictureID{get; set;}

	//set Id of current Picture inside Team__c.Picture__c 
	public void PictureIDSet () {
		if(teamInfo.Picture__c != null){
			PictureID = teamInfo.Picture__c;	    	
        }
	}
	
	public Team__c teamInfo = new Team__c();
	
	public Team__c getTeamInfo () {
		return teamInfo;
	}
	
	public void setTeamInfo (Team__c teamInfo) {
		this.teamInfo = teamInfo;
	}
	
    public void getAttachments() {
    	List<Attachment> Attachments = [select name, 
    											id, 
    											parentid, 
    											ContentType, 
    											BodyLength, 
    											LastModifiedDate, 
    											LastModifiedBy.Name
    									from attachment 
    									where parentid=:teamId 
    									order by name];		
    	
		List<AttachmentInfo> infos = new List<AttachmentInfo>();

		for (Attachment item: Attachments){	
            AttachmentInfo info = new AttachmentInfo();
            info.setId(item.Id);
            info.setName(item.Name);
            info.setAttachment(item);
            
            String ContentType = item.ContentType;
            String image = '';
            
            //Exclude current team avatar
            if(PictureID == item.Id)
            	continue;
            
            if (ContentType == null || ContentType == '') {
            	// Using extension
            	Integer extPos = item.Name.lastIndexOf('.') + 1;
            	String extension = item.Name.substring(extPos);
            	// containsKey does a case sensitive comparison
            	extension = extension.toLowerCase();
           		Map<String, String> typesExt = new Map<String, String>{
           			'rar' => 'rar.gif', 
           			'xls' => 'xls.gif', 
           			'ppt' => 'ppt.gif', 
           			'avi' => 'video.gif', 
           			'mpg' => 'video.gif', 
           			'mpeg' => 'video.gif', 
           			'flv' => 'video.gif', 
           			'mp3' => 'audio.gif', 
           			'doc' => 'doc.gif'
       			};
           		if(typesExt.containsKey(extension)) {
           			image = typesExt.get(extension);
           		}else {
           			image = 'generic.gif';
           		}
            }else {
           		// Using mime type
           		Map<String, String> typesMime = new Map<String, String>{
           			'image/jpeg' => 'images.gif', 
           			'image/pjpeg' => 'images.gif', 
           			'image/png' => 'images.gif', 
           			'image/x-png' => 'images.gif', 
           			'image/gif' => 'images.gif', 
           			'image/bmp' => 'images.gif', 
           			'text/plain' => 'txt.gif', 
           			'application/pdf' => 'pdf.gif', 
           			'application/msword' => 'doc.gif', 
           			'application/x-zip-compressed' => 'zip.gif', 
           			'audio/wav' => 'audio.gif', 
           			'audio/mpeg' => 'audio.gif', 
           			'video/mpeg' => 'video.gif', 
           			'video/avi' => 'video.gif'
       			};	
           		if(typesMime.containsKey(ContentType)) {
           			image = typesMime.get(ContentType);
           		}else {
           			image = 'generic.gif';
           		}
            }
            info.setAttachImage(image);
            infos.add(info);
        }
        Attachments.clear();	
		attachs = infos;   	    									
    }     
    
    public Integer getAttachCount () {
    	return attachs.size();
    }
    
    /* ---------------------------- */
   	/*   	 SHARING RULES			*/
   	/* ---------------------------- */	
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	
	public void genPermissions () {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(teamId);
		userPermissions.setOwnerId(teamInfo.CreatedById);
		userPermissions.setObjectType('Team');
		userPermissions.setPermissions();
		if(!userPermissions.getCanManage()) {
			userPermissions.setObjectType('Attachment');
			userPermissions.setPermissions();
		}
	}
	
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}
    
   	/* ---------------------------- */
   	/*   	  DELETE ATTACH			*/
   	/* ---------------------------- */  
   	
   	public void DeleteAttach () { 
   		String idAttach = System.currentPageReference().getParameters().get('idAttach');
   		Attachment delAttach;
   		if(idAttach != null && idAttach!= ''){
   			try{
	   			delAttach = [select Id, Name from Attachment where id =:idAttach ];
	   			delete delAttach; 
   				//update attachments list
   				getAttachments();
   			}catch(Exception e){
   				throw e;
   			}
   		}
   	}

   	/* ---------------------------- */
   	/*   	  ATTACH WIKI PAGE		*/
   	/* ---------------------------- */	 	 
	public class AttachmentInfo {
        
        String name;
        String attachImage;
		String id;
		Attachment attach;
		      
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

        public void setAttachment (Attachment attach) {
                this.attach = attach;
        }
        
        public Attachment getAttachment() {
                return attach;
        }
                                     
	}

}
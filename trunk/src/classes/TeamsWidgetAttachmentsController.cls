/**
*@author Marc Ferrentino @ 07/31/2008
*/
public class TeamsWidgetAttachmentsController {
	
	String teamId;
	public List<AttachmentInfo> attachs = new List<AttachmentInfo>();	
	public Boolean sidebar = false;
	
	/**
	* Constructor
	*/
	public TeamsWidgetAttachmentsController(){
		
	}
	
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
	
	/**
	*@param String team id
	*/
	public void setTeamId(String id) {
		if(teamId == null || teamId == ''){
			teamId = id;
			currentTeam();
			genPermissions();
			getAttachments();
		}
	}
	
	/**
	*@return String
	*/
	public String getTeamId(){
		return teamId;
	}
	
	/**
	*@return List<AttachmentInfo
	*/
	public List<AttachmentInfo> getAttachs(){
		return attachs;
	}
	
	/**
	* Refresh attachment list
	*/
	public void refresh() {
		getAttachments();
	} 

	/**
	* Set current team pic
	*/
	public void currentTeam() {
		teamInfo = [Select 
	                t.Picture__c, CreatedById
	                From Team__c t Where t.Id =:teamId];
	    PictureIDSet();	
	}
	
	public String PictureID{get; set;}
 
	/**
	* Set Id of current Picture inside Team__c.Picture__c
	*/
	public void PictureIDSet () {
		if(teamInfo.Picture__c != null){
			PictureID = teamInfo.Picture__c;	    	
        }
	}
	
	public Team__c teamInfo = new Team__c();
	
	/**
	*@return Team__c
	*/
	public Team__c getTeamInfo () {
		return teamInfo;
	}
	
	/**
	*@param Team__c 
	*/
	public void setTeamInfo (Team__c teamInfo) {
		this.teamInfo = teamInfo;
	}
	
    /**
    * Read attachments for current team
    */
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
    
    /**
    *@return Integer
    */
    public Integer getAttachCount () {
    	return attachs.size();
    }
    
	public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
	
	/**
	* Read user permissions
	*/
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
	
	/**
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}

   	/**
   	* Delete Attachment
   	*/
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

	/**
	* Class AttachmentInfo
	*/ 
	public class AttachmentInfo {
        
        String name;
        String attachImage;
		String id;
		Attachment attach;
		      
        /**
        *@return String Attach id
        */
        public String getId () {
        	return id;
        }
        
        /**
        *@param String Attach id
        */
        public void setId (String id) {
        	this.id = id;
        }
        
        /**
        *@return String Attach name
        */        
        public String getName() {
                return name;
        }

        /**
        *@param String Attach name
        */
        public void setName(String name) {
                this.name = name;
        }  
        
		/**
		*@return String attach type icon
		*/       
        public String getAttachImage() {
                return attachImage;
        }

        /**
        *@param String attach type icon
        */
        public void setAttachImage (String attachImage) {
                this.attachImage = attachImage;
        }          

        /**
        *@param Attachment
        */
        public void setAttachment (Attachment attach) {
                this.attach = attach;
        }
        
        /**
        *@return Attachment
        */
        public Attachment getAttachment() {
                return attach;
        }
                                     
	}

}
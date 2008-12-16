public class TeamsWidgetAttachmentsController {
	
	String teamId;
	
	// Setter method for Team Id variable
	public void setTeamId(String id) {
		teamId = id;
		currentTeam();	
		
	}
	// Getter Team Id variable
	public String getTeamId(){
		return teamId;
	}
	
	public void refresh() {
	} 
	
	//Constructor
	public TeamsWidgetAttachmentsController(){
		
		
	}
	
	//set the current team Picture
	public void currentTeam() {
		teamInfo = [Select 
	                t.Picture__c
	                From Team__c t Where t.Id =:teamId];
	    PictureIDSet();	
	}
	
	//set Id of current Picture inside Team__c.Picture__c 
	public void PictureIDSet () {
		List<Attachment> attach = new List<Attachment>();
    	
        attach = [select Id 
                    from Attachment 
                    where Id =: teamInfo.Picture__c];
        
        if(attach.size() > 0)
        {            
            PictureID = attach[0].Id;
    	}
    	
    	//Old teams no have Team__c.Picture__c
    	else
    	{
    		
			attach = [select Id 
                        from Attachment 
                        where ParentId =: teamId];
            if(attach.size() > 0)
            {            
	            PictureID = attach[0].Id;
            }
        }
	}
	
	public String PictureID{get; set;}
	
	public Team__c teamInfo{get; set;}
	
    public List<AttachmentInfo> getAttachments() {
    	
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
		return infos;   	    									
    }     
    
    public Integer getAttachCount () {
    	return [select count() from attachment where parentid=:teamId];
    }

   	/* ---------------------------- */
   	/*   	  DELETE ATTACH			*/
   	/* ---------------------------- */  
   	
   	public void DeleteAttach () { 
   		String idAttach = System.currentPageReference().getParameters().get('idAttach');
   		Attachment delAttach;
   		if(idAttach != null && idAttach!= '')
   		{
   			delAttach = [select Id, Name from Attachment where id =:idAttach ];
   			delete delAttach; 
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
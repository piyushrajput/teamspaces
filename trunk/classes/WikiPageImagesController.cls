public class WikiPageImagesController {
	
	String idWikiPage = System.currentPageReference().getParameters().get('idWP');

   	/* ---------------------------- */
   	/*   	  ATTACH WIKI PAGE		*/
   	/* ---------------------------- */	 	 
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
	
	public void setIdWikiPage (String idWikiPage) {
		this.idWikiPage = idWikiPage;
	}
	
    public List<AttachmentInfo> getAttachments() {
    	List<Attachment> Attachments = new List<Attachment>();
    	if (idWikiPage == '{!idWikiPage}') {
    		Attachments = [select name, id, parentid, ContentType from attachment order by name];
    	}else {
    		Attachments = [select name, id, parentid, ContentType from attachment where parentid=:idWikiPage order by name];
    	}
    	List<AttachmentInfo> infos = new List<AttachmentInfo>();

		for (Attachment item: Attachments){	
            AttachmentInfo info = new AttachmentInfo();
            info.setId(item.Id);
            info.setName(item.Name);
            
            String ContentType = item.ContentType;
            String image = '';
       		
       		if (ContentType == null || ContentType == '') {
            	// Using extension
            	Integer extPos = item.Name.lastIndexOf('.') + 1;
            	String extension = item.Name.substring(extPos);
            	// containsKey does a case sensitive comparison
            	extension = extension.toLowerCase();
            	Map<String, String> typesExt = new Map<String, String>{
           			'png' => 'images.gif',
           			'jpg' => 'images.gif',
           			'gif' => 'images.gif'
       			};
           		if(typesExt.containsKey(extension)) {
           			image = typesExt.get(extension);
           		}
            }else {
           		// Using mime type
           		Map<String, String> typesMime = new Map<String, String>{
           			'image/jpeg' => 'images.gif', 
           			'image/pjpeg' => 'images.gif', 
           			'image/png' => 'images.gif', 
           			'image/x-png' => 'images.gif', 
           			'image/gif' => 'images.gif', 
           			'image/bmp' => 'images.gif'
       			};	
           		if(typesMime.containsKey(ContentType)) {
           			image = typesMime.get(ContentType);
           		}
            }
       		
       		// MIME TYPE
       		
            info.setAttachImage(image);
            infos.add(info);
        }	
        return infos;   	    									
    }     
    
    public Integer getAttachCount () {
    	return [select count() from attachment where parentid=:idWikiPage];
    }
}
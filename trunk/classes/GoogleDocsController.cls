public class GoogleDocsController { 
	
	
    String teamId;
    public Boolean sidebar = false;
    
    public GoogleDocsController () {    
    }
    
    
     // Getter Team Id variable
    public String getTeamId(){
        return teamId;
    }

    //void
    public void setSidebar(Boolean b){
    	sidebar = b;
    }
    
    //Get Sidebar
    //return Boolean
    
    public Boolean getSidebar (){
    	return sidebar;
    }
    
    // Setter method for Team Id variable
    public void setTeamId(String id) {
        teamId = id;
        //setGoogleDocuments();
    }
    
    /**
    // Google Documents List 
    public List<Documents> googleDocuments = new List<Documents>();
    
    public List<Documents> getGoogleDocuments () {
    	return googleDocuments;
    }
    
    // Count of Google Documents
    public Integer googleDocumentsCount = 0;
    
    public Integer getGoogleDocumentsCount () {
    	return googleDocumentsCount;
    }
    
    ////////////////////////////
    // Delete Google Document //
    ////////////////////////////
    public String delDoc;
    
    public void setDelDoc (String delDoc) {
    	this.delDoc = delDoc;
    }
    
    public void deleteGoogleDoc () {
    	if (System.currentPageReference().getParameters().get('delDoc') != null) {
    		delDoc = System.currentPageReference().getParameters().get('delDoc');	
    	}
    	if (delDoc != null) {
    		GoogleDoc delGoogleDoc = [select id from GoogleDoc where id=:delDoc];
    		delete delGoogleDoc;
    		setGoogleDocuments();
    	}
    }
    
    ///////////////////////////////////
    // Construct the google Doc list //
    ///////////////////////////////////
    public void setGoogleDocuments () {
    	List<GoogleDoc> googleDocsList = [select id, Name, ParentId, Url, CreatedBy.Name, LastModifiedDate from GoogleDoc where parentId =:teamId];
    	
    	googleDocumentsCount = googleDocsList.size();
    	
    	googleDocuments = new List<Documents>();
    	for(GoogleDoc entry: googleDocsList) {
            Documents entryDoc = new Documents();
            entryDoc.setId(entry.Id);
            entryDoc.setName(entry.Name);
            entryDoc.setUrl(entry.Url);
            if (entry.Url.indexOf('https://spreadsheets.google.com') == 0) {
            	entryDoc.setDocType('Google Spreadsheet');
            }
            if (entry.Url.indexOf('https://docs.google.com') == 0 && entry.Url.indexOf('/Presentation?') == -1) {
            	entryDoc.setDocType('Google Document');
            }
            if (entry.Url.indexOf('https://docs.google.com') == 0 && entry.Url.indexOf('/Presentation?') != -1) {
            	entryDoc.setDocType('Google Presentation');
            }
            
            entryDoc.setAuthor(entry.CreatedBy.Name);
            entryDoc.setUpdated(entry.LastModifiedDate.format());
            googleDocuments.add(entryDoc);
        }
    }
    
    // Getter Team Id variable
    public String getTeamId(){
        return teamId;
    }

	// Google Api Session Token
    public String sessToken = '';
    
    public String getSessToken () {
        return System.currentPageReference().getParameters().get('sesstoken');
    }
    
    public void exchangeRequestToken() {
        if ( System.currentPageReference().getParameters().get('sesstoken') != null) {
            sessToken = System.currentPageReference().getParameters().get('sesstoken');
        }
    }
    
    //////////////////////////////////
    // Google Documents Inner Class //
    //////////////////////////////////
    public class Documents {
        String name;
        String url;
        String author;
        String updated;
        String docType;
        String id;
        
        public String getId () {
        	return id;
        }
        
        public void setId (String id) {
        	this.id = id;
        }
        
        public String getDocType () {
        	return docType;
        }
        
        public void setDocType (String docType) {
        	this.docType = docType;
        }
        
        public String getName () {
            return name;
        }
        
        public void setName (String name) {
            this.name = name;
        }
        
        public String getUrl () {
            return url;
        }
        
        public String getUpdated () {
            return updated;
        }
        
        public void setUpdated (String updated) {
            this.updated = updated;
        }
        
        public void setUrl (String url) {
            this.url = url;
        }
        
        public String getAuthor () {
            return author;  
        }
        
        public void setAuthor (String author) {
            this.author = author;
        }
    }
    */
}
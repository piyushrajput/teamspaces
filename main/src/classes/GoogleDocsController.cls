/**
*@author Juan Bessonart @ 09/02/2008
*/
public class GoogleDocsController { 
	
    String teamId;
    public Boolean sidebar = false;
    
    /**
    * Constructor
    */
    public GoogleDocsController () {}
    
    /**
    * Get team Id
    *@return String team id
    */
    public String getTeamId(){
        return teamId;
    }

    /**
    * Set sidebar (Use for render wide or thin widget)
    *@param Boolen sidebar
    */
    public void setSidebar(Boolean b){
    	sidebar = b;
    }
    
    /**
    * Get sidebar
    *@return Boolean sidebar
    */
    public Boolean getSidebar (){
    	return sidebar;
    }
    
    /**
    * Set team Id
    *@param String Id
    */
    public void setTeamId(String id) {
        teamId = id;
    }
    
    // Google Documents List 
    //public List<Documents> googleDocuments = new List<Documents>();
    
    /**
    * Get google document list
    *@return List<Documents>
    
    public List<Documents> getGoogleDocuments () {
    	return googleDocuments;
    }
    */
    
    // Count of Google Documents
    //public Integer googleDocumentsCount = 0;
    
    /**
    * Get google documents count
    *@return Integer
    
    public Integer getGoogleDocumentsCount () {
    	return googleDocumentsCount;
    }
    */
    //public String delDoc;
    
    /**
    * Set google document to delete
    *@param String doc to delete
    
    public void setDelDoc (String delDoc) {
    	this.delDoc = delDoc;
    }
    */
    /**
    * Delete google document
    
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
    */
	/**
	* Read google document for current team
	
    public void setGoogleDocuments () {
    	List<GoogleDoc> googleDocsList = [select id, Name, ParentId, Url, CreatedBy.Name, LastModifiedDate from GoogleDoc where parentId =:teamId];
    	
    	googleDocumentsCount = googleDocsList.size();
    	
    	googleDocuments = new List<Documents>();
    	for(GoogleDoc entry: googleDocsList) {
            Documents entryDoc = new Documents();
            entryDoc.setId(entry.Id);
            entryDoc.setName(entry.Name);
            entryDoc.setUrl(entry.Url);
            if (entry.Url.indexOf('https://spreadsheets.google.com') == 0)
            	entryDoc.setDocType('Google Spreadsheet');
            if (entry.Url.indexOf('https://docs.google.com') == 0 && entry.Url.indexOf('/Presentation?') == -1) 
            	entryDoc.setDocType('Google Document');
            if (entry.Url.indexOf('https://docs.google.com') == 0 && entry.Url.indexOf('/Presentation?') != -1) 
            	entryDoc.setDocType('Google Presentation');
            entryDoc.setAuthor(entry.CreatedBy.Name);
            entryDoc.setUpdated(entry.LastModifiedDate.format());
            googleDocuments.add(entryDoc);
        }
    }
	*/

	// Google Api Session Token
    //public String sessToken = '';
    
    /**
    * Get security token
    *@return String
    
    public String getSessToken () {
        return System.currentPageReference().getParameters().get('sesstoken');
    }
    */
    /**
    * Exchange security token
    
    public void exchangeRequestToken() {
        if ( System.currentPageReference().getParameters().get('sesstoken') != null) {
            sessToken = System.currentPageReference().getParameters().get('sesstoken');
        }
    }
    */
    
	/**
	* Class Documents
	*@author Juan Bessonart
	
	
    public class Documents {
        String name;
        String url;
        String author;
        String updated;
        String docType;
        String id;
      */ 
       
		/**
		* Get document Id
		*@return String doc id
		       
        public String getId () {
        	return id;
        }
        */
        
        /**
        * Set document id
        *@param String doc id
        
        public void setId (String id) {
        	this.id = id;
        }
        */
        
        /**
        * Get document type
        *@return String type
        
        public String getDocType () {
        	return docType;
        }
        */
        
        /**
        * Set document type
        *@param String type
        
        public void setDocType (String docType) {
        	this.docType = docType;
        }
        */
        
        /**
        * Get document name
        *@return String
        
        public String getName () {
            return name;
        }
        */
        
        /**
        * Set document name
        *@param String name
        
        public void setName (String name) {
            this.name = name;
        }
        */
        
        /**
        * Get document Url
        *@return String url
        
        public String getUrl () {
            return url;
        }
        */
        
        /**
        * Get document last updated date
        *@return String
        
        public String getUpdated () {
            return updated;
        }
        */
        
        /**
        * Set document last updated date
        *@param String date
        
        public void setUpdated (String updated) {
            this.updated = updated;
        }
        */
        
        /**
        * Set document Url
        *@param String url
        
        public void setUrl (String url) {
            this.url = url;
        }
        */
        
        /**
        * Get document author
        *@return String author
        
        public String getAuthor () {
            return author;  
        }
        */
        
        /**
        * Set document author
        *@param String author
        
        public void setAuthor (String author) {
            this.author = author;
        }
        */
    //}
}
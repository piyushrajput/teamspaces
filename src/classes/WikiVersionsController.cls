/**
*@author Yuri Alvarez @ 5-2-2008
*/
public class WikiVersionsController {
    
    public String idRevL;
    public String idRevR;
    public String idWikiPage = System.currentPageReference().getParameters().get('idWP');
    public Boolean goLeft = false;
    public Boolean goRight = false;
    
    /**
    *@param String ID
    */
    public void setIdWikiPage(String id){
        idWikiPage = id;    
    }
    
    /**
    * Set the Left view verssion
    *@param String
    */
    public void setIdRevL (String s){
        idRevL = s;
    }
    
    /**
    * Set the Right view verssion
    *@param String
    */
    public void setIdRevR (String s){
        idRevR = s;
    }
      
    /**
    * Class for Show Revisions
    *@class
    */   
    public class InfoRev {
        Double revisionCount;
        String name;
        String lastModifiedDate;
        String id;
        String body;
        String modifiedBy;
        
        /**
        *@return String
        */
        public String getModifiedBy () {
            return modifiedBy;
        }
        
        /**
        *@param String
        */
        public void setModifiedBy(String modBy) {
            this.modifiedBy = modBy;
        }
        
        /**
        *@return String
        */
        public String getBody () {
            String convertBody;
            convertBody = body.replaceAll('\n',' <br> ');
            convertBody = convertBody.replace('\"','&quot');
            return convertBody;
        }
        
        /**
        *@param String
        */
        public void setBody (String body) {
            this.body = body;
        }
        
        /**
        *@return Double
        */
        public Double getRevisionCount () {
            return revisionCount;
        }
        
        /**
        *@param Double
        */
        public void setRevisionCount (Double revisionCount) {
            this.revisionCount = revisionCount;
        }
        
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
        public String getLastModifiedDate() {
            return lastModifiedDate;
        }
		
        /**
        *@param Datetime lastModified
        */
        public void setLastModifiedDate(Datetime lastModifiedDate) {
            this.lastModifiedDate = lastModifiedDate.format();
        }                
                                        
    }
	
	/**
	*@return WikiPage__c
	*/
    public WikiPage__c getWikiInfo () {
        return [select Name, Team__r.Name from WikiPage__c where id =: idWikiPage];
    }
	
	/**
	* Return list of revisions
	*@return List<InfoRev>
	*/
    public List<InfoRev> getRevisionsList () {
        List<WikiVersions__c> revisionList;
        revisionList = [select Id, Name, LastModifiedDate,revisionCount__c, LastModifiedBy.Name from WikiVersions__c where WikiPageId__c =: idWikiPage order by LastModifiedDate desc]; 
        List<InfoRev> infosRev = new List<InfoRev>();
        for (WikiVersions__c item: revisionList){
                    InfoRev infoRev = new InfoRev();
                    infoRev.setId(item.Id);
                    infoRev.setName(item.Name);
                    infoRev.setLastModifiedDate(item.LastModifiedDate);
                    infoRev.setModifiedBy(item.LastModifiedBy.Name);
                    if (item.revisionCount__c == null) {
                        infoRev.setRevisionCount(1);
                    }else {
                        infoRev.setRevisionCount(item.revisionCount__c);
                    }
                    infosRev.add(infoRev);
        }
        return infosRev;
    }
    
    /**
    * Cancel and redirect
    *@return PageReference
    */
    public PageReference cancelRevision () {
        PageReference pageRef = Page.WikiPage;
        pageRef.getParameters().put('idWP', idWikiPage);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
    *@return Boolean
    */
    public Boolean getGoDiff () {
        return (goLeft && goRight);
    }   
    
    /**
    *@return Boolean
    */
    public Boolean getGoLeft () {
        return goLeft;
    }
    
    /**
    * Set goLeft to true
    */
    public void getWikiLeft () {
        goLeft = true;
    } 
    
    /**
    *@return InfoRev
    */
    public InfoRev getRevLeftBody () {
        InfoRev revLeftBody = new InfoRev();
        if (System.currentPageReference().getParameters().get('idRevL') != null && System.currentPageReference().getParameters().get('idRevL') != '') {
            idRevL =    System.currentPageReference().getParameters().get('idRevL');
            WikiVersions__c wikiVersionLeft = [select Name, Body__c, revisionCount__c from WikiVersions__c where Id =: idRevL];
            revLeftBody.setBody(wikiVersionLeft.Body__c);
            revLeftBody.setRevisionCount(wikiVersionLeft.revisionCount__c);
        }else {
            if (idRevL != null && idRevL != '') {
                WikiVersions__c wikiVersionLeft = [select Name, Body__c, revisionCount__c from WikiVersions__c where Id =: idRevL];
                revLeftBody.setBody(wikiVersionLeft.Body__c);
                revLeftBody.setRevisionCount(wikiVersionLeft.revisionCount__c);
            }else {
                revLeftBody.setBody('');
            }   
        }
        return revLeftBody;
    }    
    
    /**
    * Set goLeft to false
    */
    public void hideLeftBody () {
        goLeft = false;
    }
    
    /**
    *@return Boolean
    */
    public Boolean getGoRight () {
        return goRight;
    }
    
    /**
    * Set goRight to true
    */
    public void getWikiRight () {
        goRight = true;
    } 
    
    /**
    *@return InfoRev
    */
    public InfoRev getRevRightBody () {
        InfoRev revRightBody = new InfoRev();
        if (System.currentPageReference().getParameters().get('idRevR') != null && System.currentPageReference().getParameters().get('idRevR') != '') {
            idRevR =    System.currentPageReference().getParameters().get('idRevR');
            WikiVersions__c wikiVersionRight = [select Name, Body__c, revisionCount__c from WikiVersions__c where Id =: idRevR];
            revRightBody.setBody(wikiVersionRight.Body__c);
            revRightBody.setRevisionCount(wikiVersionRight.revisionCount__c);
        }else {
            if (idRevR != null && idRevR != '') {
                WikiVersions__c wikiVersionRight = [select Name, Body__c, revisionCount__c from WikiVersions__c where Id =: idRevR];
                revRightBody.setBody(wikiVersionRight.Body__c);
                revRightBody.setRevisionCount(wikiVersionRight.revisionCount__c);
            }else {
                revRightBody.setBody('');
            }
        }
        return revRightBody;
    }
    
    /**
    * Set goRight to false
    */
    public void hideRightBody () {
        goRight = false;
    }

    /**
    * Save as current and redirect
    *@return PageReference
    */  
    public PageReference saveLeft () {
        WikiPage__c updateWiki = [select Body__c from WikiPage__c where id =:idWikiPage];
        WikiVersions__c currentRev = [select Name, revisionCount__c, Body__c from WikiVersions__c where Id =: idRevL];
        updateWiki.Body__c = currentRev.Body__c;
        update updateWiki;
                
        WikiVersions__c updateRev = new WikiVersions__c();
        updateRev.Name = currentRev.Name;
        updateRev.Body__c = currentRev.Body__c;
        updateRev.WikiPageId__c = idWikiPage;
        List<WikiVersions__c> resultCount = [select revisionCount__c from WikiVersions__c where WikiPageId__c =:idWikiPage order by LastModifiedDate desc limit 1];
        if (resultCount.size() > 0) {
            Double oldCount = resultCount[0].revisionCount__c;
            if (oldCount == null) {
                updateRev.revisionCount__c = 1;
            }else {
                updateRev.revisionCount__c = oldCount + 1;
            }
        }else {
            updateRev.revisionCount__c = 1;
        }       
        insert updateRev;
        PageReference pageRef = Page.WikiPage;
        pageRef.getParameters().put('idWP', idWikiPage);
        pageRef.setRedirect(true);
        return pageRef;         
    }   
    
    /**
    * Save as current and redirect
    *@return PageReference
    */ 
    public PageReference saveRight () {
        WikiPage__c updateWiki = [select Body__c from WikiPage__c where id =:idWikiPage];
        WikiVersions__c currentRev = [select Name, revisionCount__c, Body__c from WikiVersions__c where Id =: idRevR];
        updateWiki.Body__c = currentRev.Body__c;
        update updateWiki;
                
        WikiVersions__c updateRev = new WikiVersions__c();
        updateRev.Name = currentRev.Name;
        updateRev.Body__c = currentRev.Body__c;  
        updateRev.WikiPageId__c = idWikiPage;
        
        List<WikiVersions__c> resultCount = [select revisionCount__c from WikiVersions__c where WikiPageId__c =:idWikiPage order by LastModifiedDate desc limit 1];
        if (resultCount.size() > 0) {
            Double oldCount = resultCount[0].revisionCount__c;
            if (oldCount == null) {
                updateRev.revisionCount__c = 1;
            }else {
                updateRev.revisionCount__c = oldCount + 1;
            }
        }else {
            updateRev.revisionCount__c = 1;
        }       
        insert updateRev;
        PageReference pageRef = Page.WikiPage;
        pageRef.getParameters().put('idWP', idWikiPage);
        pageRef.setRedirect(true);
        return pageRef;         
    }   
                
}
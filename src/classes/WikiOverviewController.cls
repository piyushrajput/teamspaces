/**
*@author Yuri Alvarez @ 05/02/2008
*/
public with sharing class WikiOverviewController {
	
	public String allTeams = 'false';
	List<Letters> letterFilter = new List<Letters>();
   	List<Team__c> teamList = new List<Team__c>();
   	Letters currentLetter = new Letters();
   	List<Wiki> wikis = new List<Wiki>();
	
	/**
	* Costructor
	*/
	public WikiOverviewController () {
		genMyTeams();
		genWikiSites();
		setSiteCount();
		genCntPagination();	
	}
	

	List<Id> tmp = new List<Id>();
	/**
	* Load my teams
	*/
	public void genMyTeams() {
		tmp = new List<Id>();
		for(TeamMember__c tm : [Select Team__c From TeamMember__c WHERE User__c =: UserInfo.getUserId() ] ) { 
			tmp.add(tm.Team__c);
		}	
	}
	
	/**
	* Returns my temas list id
	*@return List<Id>
	*/
	public List<Id> myTeams(){
		return tmp;
	}	
	
	public List<TeamWikis> wikiSites;
	
	/**
	*@return List<TeamWikis>
	*/
	public List<TeamWikis> getWikiSites () {
		return wikiSites;
	}
	
	/**
	* For rerender use
	*/
	public void refreshTab(){
		numSitesRows = 7;
   		currentPagination = 1;
   		firstRow = 0;
   		letter = '';
		genWikiSites();
		setSiteCount();		
		genCntPagination();		
	}
	
	/**
	* Load all wikis list (all and mine)
	*/
	public void genWikiSites () {
		List<Team__c> sites;
		
		if (System.currentPageReference().getParameters().get('allTeams') != null) 
    		allTeams = System.currentPageReference().getParameters().get('allTeams');
    	
    	if(allTeams == '') 
    		allTeams = 'false';
    	
    	if(allTeams == 'true'){
	   		sites = [select Id, Name, Description__c, Picture__c from Team__c order by Name];
    	}else{
			sites = [select Id, Name, Description__c, Picture__c from Team__c where Id in: myTeams() order by Name];
    	}		
		
		List<TeamWikis> teamWikiList = new List<TeamWikis>();
		for (Team__c item : sites) {
			TeamWikis teamWikiItem = new TeamWikis();
			teamWikiItem.setId(item.Id);
			teamWikiItem.setName(item.Name);
			teamWikiItem.setDescription(item.Description__c);
			teamWikiItem.setPicture(item.Picture__c);
			teamWikiList.add(teamWikiItem);
		}
		wikiSites = teamWikiList;
	}


   	public Integer cntLetterSites;

   	/**
   	* Returns sites count
   	*/
   	public void setSiteCount(){
   		if (System.currentPageReference().getParameters().get('allTeams') != null) 
   			allTeams = System.currentPageReference().getParameters().get('allTeams');
	   	if(allTeams == '' || allTeams == 'false' || allTeams == null ){
	   		cntLetterSites = [select count() from Team__c where Id in: myTeams() ];	   		
	   	}else{
	   		cntLetterSites = [select count() from Team__c];
	   	}   			
   	}
   	
   	public Integer numSitesRows = 7;
   	public Integer cntPagination;
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	
   	/**
   	* Set total num of pages
   	*/
   	public void genCntPagination () {
   		cntPagination = (cntLetterSites - (Math.mod(cntLetterSites, numSitesRows)))/ numSitesRows;	
   		if (Math.mod(cntLetterSites, numSitesRows) != 0 ) 
   			cntPagination++;
   	}
   	
   	/**
   	*@return Integer
   	*/
   	public Integer getNumSitesRows () {
   		return numSitesRows;
   	}
   	
   	/**
   	*@return Integer
   	*/
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
   	/**
   	* Move to next page
   	*/
   	public void nextPage () {
   		currentPagination++;
   		firstRow = firstRow + numSitesRows;	
   	}
   	
   	/**
   	* Move to previus page
   	*/
   	public void prevPage () {
   		currentPagination--;
   		firstRow = firstRow - numSitesRows;	
   	}
   	
   	/**
   	*@return Integer
   	*/
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	/**
   	* Get total num of pages
   	*@return Integer
   	*/
   	public Integer getCntPagination () {
   		return cntPagination;
   	}


	public List<String> lettersList = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};	

	/**
	* Class Letters
	*/
	public class Letters {
		String letter;
		Boolean containSites;
		Integer cntSites;
		
		/**
		*@param String
		*/
		public void setLetter (String letter) {
			this.letter = letter;
		}
		
		/**
		*@return String
		*/
		public String getLetter () {
			return letter;
		}
		
		/**
		*@param Integer
		*/
		public void setContainSites (Integer cntSites) {
			if (cntSites == 0) {
				this.containSites = false;
			}else {
				this.containSites = true;
			}
		}
		
		/**
		*@return Boolean
		*/
		public Boolean getContainSites () {
			return containSites;
		}
		
		/**
		*@return Integer
		*/
		public Integer getCntSites () {
			return cntSites;
		}
		
		/**
		*@param Integer
		*/
		public void setCntSites (Integer cntSites) {
			this.cntSites = cntSites;
		}	
	}
	
	/**
	*@return List<Letters>
	*/
	public List<Letters> getLetterFilter(){
		setLetterFilter();
		return  letterFilter;
	}
	   	
	/**
	* Set letter filer with matches
	*/
	public void setLetterFilter () {
   		letterFilter = new List<Letters>();
   		teamList = new List<Team__c>();
   		currentLetter = new Letters();
   		
   		if (System.currentPageReference().getParameters().get('allTeams') != null) 
    		allTeams = System.currentPageReference().getParameters().get('allTeams');

    	if(allTeams == '') 
    		allTeams = 'false';
    	
    	if(allTeams == 'true'){
	   		teamList = [select Name from Team__c];
    	}else{
			teamList = [select Name from Team__c where Id in:  myTeams() ];
    	}

   		for (String item : lettersList) {
   			currentLetter = new Letters();
   			Integer cntSites = 0;
   			
   			for (Team__c teamItem: teamList) {
   				if (teamItem.Name.startsWith(item) || teamItem.Name.startsWith(item.toLowerCase())) 
   					cntSites++;
   			}
   			
   			currentLetter.setCntSites(cntSites);
   			currentLetter.setLetter(item);
   			currentLetter.setContainSites(cntSites);
   			letterFilter.add(currentLetter);
   		}	
	}
	
	/**
	* Class TeamWikis
	*/   	
   	public class TeamWikis  {
   		String id;
   		String name;
   		String description;
   		String picture;
   		
   		/**
   		*@return String
   		*/
   		public String getId () {
   			return id;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getName () {
   			return name;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getDescription () {
   			return description;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getPicture () {
   			return picture;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setId (String id) {
   			this.id = id;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setName (String name) {
   			this.name = name;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setDescription (String description) {
   			if(description != null){
    			 if(description.length() > 70){
    			 	this.description = description.substring(0,67) + '...';	
    			 	//Set full description for span title
    			 	fullDescription = description;
    			 }else{
    			 	this.description = description;
    			 }
        	}else{
    			this.description  = '';
    		}
   		}
   		
   		public String fullDescription {get; set;}
   		
		/**
		*@param String
		*/
		public void setPicture (String image) {
   			if(image != null) {	
	        	this.picture = image;
	        }else {
	        	this.picture = '';
	        }
   		}   	
   	}
   	
   	public String letter = '';
   	
   	/**
   	*@param String
   	*/
   	public void setLetter (String letter) {
   		this.letter = letter;
   	}
   	
	/**
	* List filter
	*/
	public void filterSites () {
		List<Id> myTeamsList = myTeams();
		List<Team__c> sites;
		
		if (System.currentPageReference().getParameters().get('ltr') != null && System.currentPageReference().getParameters().get('ltr') != '') {
			letter = System.currentPageReference().getParameters().get('ltr');
		}
		
		if (letter == 'ALL' || letter == null || letter == '') {
			Integer allTeamCount;
			if (allTeams == 'true') {
				sites = [select Id, Name, Description__c, Picture__c from Team__c order by Name];
			}else {
				sites = [select Id, Name, Description__c, Picture__c from Team__c where id in:myTeamsList order by Name];
			}
			allTeamCount = sites.size();
			cntPagination = (allTeamCount - (Math.mod(allTeamCount, numSitesRows)))/ numSitesRows;
			if (Math.mod(allTeamCount, numSitesRows) != 0 ) {
   				cntPagination++;
   			}
		}else {
			Integer lrtTeamCount;
			if (allTeams == 'true') {
				sites = [select Id, Name, Description__c, Picture__c from Team__c where Name like :(letter + '%') order by Name];
			}else {
				sites = [select Id, Name, Description__c, Picture__c from Team__c where Name like :(letter + '%') and id in:myTeamsList order by Name];
				
			}
			
			lrtTeamCount = sites.size();
			cntPagination = (lrtTeamCount - (Math.mod(lrtTeamCount, numSitesRows)))/ numSitesRows;
			
			if (Math.mod(lrtTeamCount, numSitesRows) != 0 ) 
   				cntPagination++;
		}
		
		List<TeamWikis> teamWikiList = new List<TeamWikis>();
		for (Team__c item : sites) {
			TeamWikis teamWikiItem = new TeamWikis();
			teamWikiItem.setId(item.Id);
			teamWikiItem.setName(item.Name);
			teamWikiItem.setDescription(item.Description__c);
			teamWikiItem.setPicture(item.Picture__c);
			teamWikiList.add(teamWikiItem);
		}
		
		currentPagination = 1;
		firstRow = 0;
		wikiSites = teamWikiList;
	}   	
	
   	/**
   	* Class Wiki
   	*/
   	public class Wiki {
   		String name; 
   		String id;
   		String lastModifiedBy;
   		String lastModifiedById;
   		String lastModifiedDate;
   		String parentName;
   		String parentId;
   		String shortDescription;
   		String modifiedByPicture;
   		
		/**
		*@param String
		*/
		public void setModifiedByPicture (String modById) {
			String PictureId = '';
			List<PeopleProfile__c> itemProfile = new List<PeopleProfile__c>();
			itemProfile = [SELECT Picture__c FROM PeopleProfile__c WHERE User__c =:modById];
			
			if (itemProfile != null) {
				if (itemProfile.size() > 0) {
					PeopleProfile__c picture = new PeopleProfile__c();
					picture = itemProfile.get(0);
			        if(picture.Picture__c == '' || picture.Picture__c == null) {                	                                          	 
				     	PictureId = '';
					}else {
						PictureId = picture.Picture__c;
					} 
				}else {
					PictureId = '';
				}
			}
   			this.modifiedByPicture = PictureId ;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getModifiedByPicture () {
   			return modifiedByPicture;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setParentName (String parentName) {
   			this.parentName = parentName;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getParentName () {
   			return parentName;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setParentId (String parentId) {
   			this.parentId = parentId;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getParentId () {
   			return parentId;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setName (String Name) {
   			this.name = Name;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getName () {
   			return name;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setId (String Id) {
   			this.id = Id;
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
   		public void setLastModifiedBy (String modById) {
   			User modBy = [select Name from User where id=: modById];
   			this.lastModifiedBy = modBy.Name;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getLastModifiedBy () {
   			return lastModifiedBy;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setLastModifiedById (String modById) {
   			this.lastModifiedById = modById;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getLastModifiedById () {
   			return lastModifiedById;
   		}
   		   		
   		/**
   		*@param Datetime
   		*/
   		public void setLastModifiedDate (DateTime dateMod) {
   			this.lastModifiedDate = dateMod.format();
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getLastModifiedDate () {
   			return LastModifiedDate;
   		}
   		
   		/**
   		*@param String
   		*/
   		public void setShortDescription (String shortDescription) {
   			this.shortDescription = shortDescription;
   		}
   		
   		/**
   		*@return String
   		*/
   		public String getShortDescription () {
   			return shortDescription;
   		}   		
   	}	
   	
   	/**
   	*@return List<Wiki>
   	*/
   	public List<Wiki> getRecentlyUpdated () {
   		setRecentlyUpdated();
		return wikis;
   	}
   	
   	/**
   	* Load recently updated
   	*/
   	public void setRecentlyUpdated () {
   		wikis = new List<Wiki>();
   		List<WikiPage__c> wikiPages = new List<WikiPage__c>();
   		
   		if (System.currentPageReference().getParameters().get('allTeams') != null) 
    		allTeams = System.currentPageReference().getParameters().get('allTeams');
   		
    	if(allTeams == '') 
    		allTeams = 'false';
    		
    	if(allTeams == 'true'){
	   		wikiPages = [ SELECT Team__r.Name, Id, Name, ShortDescription__c, LastModifiedById, LastModifiedDate FROM WikiPage__c ORDER BY LastModifiedDate desc limit 10];    	
    	}else{
			wikiPages  = [ SELECT Team__r.Name, Id, Name, ShortDescription__c, LastModifiedById, LastModifiedDate FROM WikiPage__c where Team__c in:  myTeams() order by LastModifiedDate desc limit 10];
    	}
    	
   		for (WikiPage__c item: wikiPages) {
   			Wiki wiki = new Wiki();
   			wiki.setId(item.Id);
   			wiki.setName(item.Name);
   			wiki.setLastModifiedBy(item.LastModifiedById);
   			wiki.setLastModifiedById(item.LastModifiedById);
   			
   			/* TO DO! */
   			wiki.setModifiedByPicture(item.LastModifiedById);
   			
   			wiki.setLastModifiedDate(item.LastModifiedDate);
   			wiki.setParentName(item.Team__r.Name);
   			wiki.setParentId(item.Team__r.Id);
   			wiki.setShortDescription(item.ShortDescription__c);
   			wikis.add(wiki);
   		}
   	}

	/**
	*@return List<FavoriteWikis__c> 
	*/
   	public List<FavoriteWikis__c> getFavorite () {
   		return	[SELECT WikiPage__r.Team__r.Id, WikiPage__r.Team__r.Name, WikiPage__r.Name, WikiPage__r.Id FROM FavoriteWikis__c WHERE User__c = :UserInfo.getUserId() order by WikiPage__r.Name LIMIT 5];
   	}    	
   	
   	/**
   	*@return Integer
   	*/
   	public Integer getCntFav () {
   		return [select count() from FavoriteWikis__c where User__c = :UserInfo.getUserId()];
   	} 
  	
   	/**
   	*@return List<Wiki>
   	*/
   	public List<Wiki> getMyRecentChanges () {
   		List<Wiki> wikis = new List<Wiki>();
   		for (WikiPage__c item: [ SELECT Team__r.Id , Team__r.Name, Id, Name, ShortDescription__c, LastModifiedById, LastModifiedDate FROM WikiPage__c WHERE LastModifiedById =: UserInfo.getUserId() ORDER BY LastModifiedDate desc limit 5]) {
   			Wiki wiki = new Wiki();
   			wiki.setId(item.Id);
   			wiki.setName(item.Name);
   			wiki.setLastModifiedBy(item.LastModifiedById);
   			wiki.setLastModifiedDate(item.LastModifiedDate);
   			wiki.setParentName(item.Team__r.Name);
   			wiki.setParentId(item.Team__r.Id);
   			wiki.setShortDescription(item.ShortDescription__c);
   			wikis.add(wiki);
   		}
   		return wikis;
   	}
   	
   	/**
   	*@return Integer
   	*/
   	public Integer getCntMyRecentChanges () {
   		return [ SELECT count() FROM WikiPage__c WHERE LastModifiedById =:UserInfo.getUserId()];
   	}

}
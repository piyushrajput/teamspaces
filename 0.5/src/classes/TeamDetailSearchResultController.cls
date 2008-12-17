public with sharing class TeamDetailSearchResultController {
	
	
	public TeamDetailSearchResultController(){
		criteria = System.currentPageReference().getParameters().get('key');
	}	
	
	public String teamId = System.currentPageReference().getParameters().get('id');
	
	public void setTeamId (String team){
		teamId = team;
	}
	
	public String getTeamId () {
		return teamId;
	}		
	
	public String criteria;
	
	public String getCriteria () {
		return criteria;
	}
	
	public void setCriteria (String criteria) {
		this.criteria = criteria;
	}
	
	
	public class SearchResult {
		String name;
		String matches;
		Id id;
		String resultType;
		String realName;
		
		public void setId (Id id) {
			this.id = id;
		}

		public void setName (String name, String criteria) {
			String highlight = '';
			if (name != null) {
			
				String nameLow = name.toLowerCase();
				String criteriaLow = criteria.toLowerCase();
				
				if (criteria != null && criteria != '' && nameLow.indexOf(criteriaLow) != -1) {
					highlight = name.replaceAll('(?i)' + criteria, '<span class="highlight">$0</span>');
				}else{
					highlight = name;
				}
			}
			this.name = highlight;	
		}	
		
		
		public void setMatches (String matches, String criteria) {
			String highlight = '';
			Integer maxLength = 50;
			if (matches != null) {
				String matchesLow = matches.toLowerCase();
				String criteriaLow = criteria.toLowerCase();
				matches = matches.replaceAll('(?i)<[^>]*>', '');
				if (criteria != null && criteria != '' && matchesLow.indexOf(criteriaLow) != -1) {
					Integer msjLength = matches.length();
					Integer iniHighLight = matchesLow.indexOf(criteriaLow) - 50;
					Integer criteriaLength = criteria.length();
					Integer endHighLight = matchesLow.indexOf(criteriaLow) + criteriaLength + 50;
					if (iniHighLight < 0) {
						if (endHighLight > msjLength) {
							highlight = matches.substring(0,msjLength);	
						}
						else {
							highlight = matches.substring(0,endHighLight) + '...';	
						}
					}
					else {
						if (endHighLight > msjLength) {
							highlight = '...' + matches.substring(iniHighLight,msjLength);	
						}
						else {
							highlight = '...' + matches.substring(iniHighLight,endHighLight) + '...';	
						}		
					}
					
					highlight = highlight.replaceAll('(?i)' + criteria, '<span class="highlight">$0</span>');
				}
				else {
					if(matches.length() <= maxLength*2) {
						highlight = matches;	
					}
					else {
						//highlight = matches;
						highlight = matches.substring(0,maxLength*2) + '...';	
					}	
				}
			}
			this.matches = highlight;
		}
			
		public void setResultType (String resultType) {
			this.resultType = resultType;	
		}
		
		public void setRealName (String realName) {
			this.realName = realName;
		}
		
		/* ************************ */
		/*		  Getters			*/
		/* ************************ */			
		public Id getId () {
			return id;
		}
		
		public String getResultType () {
			return resultType;
		}
		
		public String getMatches () {
			return matches;
		}
		
		public String getName () {
			return name; 
		}	
		
		public String getRealName () {
			return realName;
		}	
			
	}
	
	public Integer totalItemsNumber= 0;
	
	public Integer getTotalItemsNumber () {
		return totalItemsNumber;
	}
	
	public Boolean noMatches;
	
	public Boolean getNoMatches () {
		return noMatches;	
	}	
	
	public List<SearchResult> searchResultList = new List<SearchResult>();	
	
	public List<SearchResult> getSearchResultList () {
		return searchResultList;
	}

	public List<TeamMember__c> resultsTeamMember = new List<TeamMember__c>();
	public List<WikiPage__c> resultsWiki = new List<WikiPage__c>();
	public List<ProjectTask__c> resultsProjectTask = new List<ProjectTask__c>();
	public List<DiscussionMessage__c> resultsDiscussion = new List<DiscussionMessage__c>();
	
	public void search () {
		
		List<SearchResult> tempResultList = new List<SearchResult>();	
		
		
		
		List<List<SObject>> resultList = [FIND :(criteria + '*') IN ALL FIELDS RETURNING TeamMember__c (Id, Team__c, User__c, User__r.Name where Team__c=:teamId), WikiPage__c (Id, Team__c, Name, ShortDescription__c where Team__c=:teamId), ProjectTask__c (Id, Name, Description__c, Team__c where Team__c=:teamId) , DiscussionMessage__c (Id, Subject__c, DiscussionTopic__c, DiscussionTopic__r.Subject__c , Message__c, Team__c where Team__c=:teamId)];
		resultsWiki.clear();
		resultsTeamMember = ((List<TeamMember__c>)resultList[0]);
		resultsWiki = ((List<WikiPage__c>)resultList[1]);
		resultsProjectTask = ((List<ProjectTask__c>)resultList[2]);
		resultsDiscussion = ((List<DiscussionMessage__c>)resultList[3]);
		
		System.debug('\n\n//////////////////////////////////////////////\n SEARCH DEBUG \n//////////////////////////////////////\n\n');
		
		System.debug('\n\n/////////////////////////////////////\n CRITERIA: ' + criteria + '\n////////////////////////////////////\n\n');
		System.debug('\n\n/////////////////////////////////////\n TEAM ID: ' + teamId + '\n////////////////////////////////////\n\n');
		
		System.debug('\n\n//////////////////////////////////////////////\n RESULT LISTS' + resultList + '\n//////////////////////////////////////\n\n');
		System.debug('\n\n//////////////////////////////////////////////\n Team Members: ' + resultsTeamMember + '\nWiki Pages: ' + resultsWiki + '\nProject Task and Milestones: ' + resultsProjectTask + '\nDiscussion Messages: ' + resultsDiscussion + '\n//////////////////////////////////////\n\n');
		
		// PARSE THE TEAM MEMBER RESULT LIST
		for(TeamMember__c iter: resultsTeamMember){
			SearchResult currentResult = new SearchResult();
			
			currentResult.setName(iter.User__r.Name, criteria);
			currentResult.setRealName(iter.User__r.Name);
			currentResult.setId(iter.User__c);
			currentResult.setResultType('Team Member');
			currentResult.setMatches('', criteria);
			
			tempResultList.add(currentResult);
		}
		
		// PARSE THE WIKI PAGE RESULT LIST
		for(WikiPage__c iter: resultsWiki){
			SearchResult currentResult = new SearchResult();
			
			currentResult.setName(iter.Name, criteria);
			currentResult.setRealName(iter.Name);
			currentResult.setId(iter.Id);
			currentResult.setResultType('Wiki Page');
			currentResult.setMatches(iter.ShortDescription__c, criteria);
			
			tempResultList.add(currentResult);
		}
		
		// PARSE THE PROJECT TASK RESULT LIST
		for(ProjectTask__c iter: resultsProjectTask){
			SearchResult currentResult = new SearchResult();
			
			currentResult.setName(iter.Name, criteria);
			currentResult.setRealName(iter.Name);
			currentResult.setId(iter.Id);
			currentResult.setResultType('Project Task');
			currentResult.setMatches(iter.Description__c, criteria);
			
			tempResultList.add(currentResult);
		}
		
		// PARSE THE DISCUSSION MESSAGE RESULT LIST
		for(DiscussionMessage__c iter: resultsDiscussion){
			SearchResult currentResult = new SearchResult();
			
			currentResult.setName(iter.DiscussionTopic__r.Subject__c, criteria);
			currentResult.setRealName(iter.DiscussionTopic__r.Subject__c);
			currentResult.setId(iter.DiscussionTopic__c);
			currentResult.setResultType('Discussion Message');
			currentResult.setMatches(iter.Message__c, criteria);
			
			tempResultList.add(currentResult);
		}
		
		/* ORDER THE MULTI OBJECT RESULT BY NAME */
		Integer n;
 		Integer i;
 		Integer j;
 		n = tempResultList.size() - 1;	
 		
 		System.debug('\n\n/////////////////////////////////////\n RESULT LIST BEFORE SORT METHOD: ' + tempResultList + '\n////////////////////////////////////\n\n');
 		
 		for (i = 1; i <= n; i++) {	
 			for (j = n; j >= i ; j--) {
 				if (tempResultList.get(j).realName <= tempResultList.get(j - 1).realName) {
 					SearchResult tempResult = new SearchResult();
 					tempResult = tempResultList.get(j - 1);
 					tempResultList.set(j - 1, tempResultList.get(j));
 					tempResultList.set(j, tempResult); 	
 				}
 				
 				System.debug('\n\n/////////////////////////////////////\n RESULT LIST INTO SORT METHOD: ' + tempResultList + '\n////////////////////////////////////\n\n');	
 			}
 		}
 		
 		System.debug('\n\n/////////////////////////////////////\n RESULT LIST AFTER SORT METHOD: ' + tempResultList + '\n////////////////////////////////////\n\n'); 
		
		searchResultList = tempResultList;
		totalItemsNumber = searchResultList.size();
		if (totalItemsNumber == 0 ) {
			noMatches = true;
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
			jumpPage = 1;
		}
		else {
			noMatches = false;
			firstRow = 0;
			currentPagination = 1;
			jumpPage = 1;
			genCntPagination();	
		}
		
	}
	
	
	
	/* ************************ */
	/*		  Pagination		*/
	/* ************************ */
   	
    /**
   	* Set of Integers to control pagination
   	*/
   	public Integer numberOfItemsToShow = 10;
   	public Integer cntPagination;
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	
   	/**
   	* Set of Booleans to show or not prev / next links
   	*/
   	public boolean prevPageLinkShow = false;
   	public boolean prevPageShow  = false;
   	public boolean nextPageLinkShow  = false;
   	public boolean nextPageShow  = false;
   	   	
   	public void genCntPagination () {
   		
   		cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		} 	
   		
   	}
   	
   	public void nextPage () {
   		currentPagination++;
   		jumpPage = currentPagination;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	public void prevPage () {
   		currentPagination--;
   		jumpPage = currentPagination;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}

	/* Last Page */
   	public void lastPage () {
   		currentPagination = cntPagination;
		jumpPage = cntPagination;
		firstRow = (jumpPage - 1)* numberOfItemsToShow;		
   	}
   	
   	/* First Page */
   	public void firstPage () {
   		currentPagination = 1;
   		jumpPage = 1;
   		firstRow = (jumpPage - 1)* numberOfItemsToShow;	
   	}

   	public void refreshPages () {
   		
   	}
   	/**
   	* Pagination Integer Getters
   	*/
   	public Integer getFirstItem () {
		return (firstRow + 1);
	}
	
	public Integer getLastItem () {
		Integer lastItem;
		if ((currentPagination == cntPagination) || (currentPagination == 1 && (totalItemsNumber < numberOfItemsToShow))) {
			lastItem = firstRow + Math.mod(totalItemsNumber, numberOfItemsToShow);
		}
		else {
			lastItem = firstRow + 10;
		}
		return lastItem;
	}
   	
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
   	/**
   	* Pagination Boolean Getters
   	*/
   	
	public boolean getPrevPageLinkShow () {
		if(currentPagination == 1){ prevPageLinkShow = false;		
		} else {prevPageLinkShow = true;}
		
   		return prevPageLinkShow;
   	}
   	
   	public boolean getPrevPageShow () {
   		
   		if(currentPagination == 1){	prevPageShow = true; 
   		} else {prevPageShow = false;}
   		
   		return prevPageShow;
   	}
   	
   	public boolean getNextPageLinkShow () {
   		
   		if((currentPagination == cntPagination) || (cntPagination == 0)){	nextPageLinkShow = false; 
		} else { nextPageLinkShow = true;}   		
   		
   		return nextPageLinkShow;
   	}
   	
   	public boolean getNextPageShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){ 
   			nextPageShow = true; 
		} else { 
			nextPageShow = false;
		} 
   		return nextPageShow;
   	}	
   	
	/* ************************ */
	/*		  Jump to Page		*/
	/* ************************ */
	
	public Integer jumpPage = 1;
	
	public Integer getJumpPage () {
		return jumpPage;
	}
	
	public void setJumpPage (Integer jumpPage) {
		this.jumpPage = jumpPage;
	}
	
	public void JumpToPage () {
		if (jumpPage > cntPagination) {
			currentPagination = cntPagination;
			jumpPage = cntPagination;
		}
		else {
			if (jumpPage < 1) {
				currentPagination = 1;
				jumpPage = 1;
			}
			else {	
				currentPagination = jumpPage;
			}
		}
		firstRow = (jumpPage - 1)* numberOfItemsToShow;
	}
	
	public String getCurrentUser () {
		return UserInfo.getUserId();
	}
	
}
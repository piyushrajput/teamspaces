/**
*@author Nicolas Gunther @ 13-6-2008
*/
public with sharing class TeamSearchResultController {

	/**
	* Constructor
	*/
	public TeamSearchResultController(){
		criteria = System.currentPageReference().getParameters().get('key');
	}

	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
	
	public String teamId = System.currentPageReference().getParameters().get('teamId');
	public LeaveJoinTeam leaveJoinTeam = new LeaveJoinTeam();
	
	/**
	*@param String
	*/
	public void setTeamId (String team){
		teamId = team;
	}		
	
	public String criteria;
	
	/**
	*@return String
	*/
	public String getCriteria () {
		return criteria;
	}
	
	/**
	*@param String
	*/
	public void setCriteria (String criteria) {
		this.criteria = criteria;
	}
	
	/**
	* Inner class for sr type
	*@class
	*/
	public class sr{
		String teamName;
		String matches;
		String url;
		String teamId = System.currentPageReference().getParameters().get('teamId');
		Boolean isMember;
		Boolean closeTeam;
		Id idTeamMember;
		
		/**
		*@param idTeamMember
		*/
		public void setIdTeamMember (Id idTeamMember) {
			this.idTeamMember = idTeamMember;	
		}
			
		/**
		*@param Id
		*/
		public void setCloseTeam (Id newNenberProf) {
			if (newNenberProf == null) {
				this.closeTeam = true;
			}else {
				this.closeTeam = false;
			}
		}
			
		/**
		*@param Boolean
		*/
		public void setIsMember (Boolean isMember) {
			this.isMember = isMember;
		}
			
		/**
		*@param String
		*/
		public void setTeamId (String teamId) {
			this.teamId = teamId;
		} 
			
		/**
		*@param String name
		*@param String criteria
		*/
		public void setTeamName (String name, String criteria) {
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
			this.teamName = highlight;	
		}	
		
		
		/**
		*@param String matches
		*@param String criteria
		*/
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
						}else {
							highlight = matches.substring(0,endHighLight) + '...';	
						}
					}else {
						if (endHighLight > msjLength) {
							highlight = '...' + matches.substring(iniHighLight,msjLength);	
						}else {
							highlight = '...' + matches.substring(iniHighLight,endHighLight) + '...';	
						}		
					}
					
					highlight = highlight.replaceAll('(?i)' + criteria, '<span class="highlight">$0</span>');
				}else {
					if(matches.length() <= maxLength*2) {
						highlight = matches;	
					}else {
						highlight = matches.substring(0,maxLength*2) + '...';	
					}	
				}
			}
			this.matches = highlight;
		}
			
		
		/**
		*@return Id
		*/		
		public Id getIdTeamMember () {
			return idTeamMember;
		}
		
		/**
		*@return Boolean
		*/
		public Boolean getCloseTeam () {
			return closeTeam;
		}
		
		/**
		*@return Boolean
		*/
		public Boolean getIsMember () {
			return isMember;
		}
		
		/**
		*@return String
		*/
		public String getTeamId () {
			return teamId;
		}
		
		/**
		*@return String
		*/
		public String getMatches () {
			return matches;
		}
		
		/**
		*@return String
		*/
		public String getUrl () {
			return url;
		}		
		
		/**
		*@return String
		*/
		public String getTeamName () {
			return teamName; 
		}		
			
	}
	
	public Integer totalItemsNumber= 0;

	/**
	*@return Integer
	*/
	public Integer getTotalItemsNumber () {
		return totalItemsNumber;
	}
	
	public Boolean noMatches;
	
	/**
	*@return Boolean
	*/
	public Boolean getNoMatches () {
		return noMatches;	
	}	
	
	public List<sr> srList = new List<sr>();	
	
	/**
	*@return List<sr>
	*/
	public List<sr> getsrList () {
		return srList;
	}
	
	public List<Team__c> results = new List<Team__c>();
	
	/**
	*@return List<sr>
	*/
	public List<Team__c> getResults () {
		return results; 
	}
	
	
	/**
	* Make the Search
	*/
	public void search () {
		
		List<sr> srList2 = new List<sr>();	
		
		List<TeamMember__c> allMembers = [select id, Team__c , User__c from TeamMember__c];
		
		if (criteria == null || criteria == '') {
			results = [select Name, Description__c, Id, NewMemberProfile__c from Team__c where PublicProfile__c != null and NewMemberProfile__c != null order by Name];
		}else{
			results = (List<Team__c>)[FIND :(criteria + '*') IN ALL FIELDS RETURNING Team__c (Id, NewMemberProfile__c, Name, Description__c where PublicProfile__c != null or NewMemberProfile__c != null)][0];
		}

		for(Team__c l: results){
			sr searchResult = new sr();
			searchResult.setTeamName(l.Name, criteria);
			searchResult.setTeamId(l.Id);
			searchResult.setMatches(l.Description__c, criteria);
			
			Boolean findM = false;
			Integer posList = 0;
			Id idTeamMember;
			while (!findM && (posList < allMembers.size())) {
				if ((allMembers.get(posList).User__c == UserInfo.getUserId()) && (allMembers.get(posList).Team__c == l.Id)) {
					findM = true;
					idTeamMember = allMembers.get(posList).Id;
				}else {
					posList++;
				}		
			}
			
			searchResult.setIsMember(findM);
			searchResult.setIdTeamMember(idTeamMember);
			searchResult.setCloseTeam(l.NewMemberProfile__c);
			srList2.add(searchResult);
		}	
		
		srList = srList2;
		totalItemsNumber = srList.size();
		if (totalItemsNumber == 0 ) {
			noMatches = true;
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
			jumpPage = 1;
		}else {
			noMatches = false;
			firstRow = 0;
			currentPagination = 1;
			jumpPage = 1;
			genCntPagination();	
		}
		
	}
   	
   	// Set of Integers to control pagination
   	public Integer numberOfItemsToShow = 10;
   	public Integer cntPagination;
   	public Integer currentPagination = 1;
   	public Integer firstRow = 0;
   	
   	// Set of Booleans to show or not prev / next links
   	public boolean prevPageLinkShow = false;
   	public boolean prevPageShow  = false;
   	public boolean nextPageLinkShow  = false;
   	public boolean nextPageShow  = false;
   	
   	/**
   	* Count number of result pages
   	*@void
   	*/
   	public void genCntPagination () {
   		cntPagination = (totalItemsNumber - (Math.mod(totalItemsNumber, numberOfItemsToShow)))/ numberOfItemsToShow;	
   		if (Math.mod(totalItemsNumber, numberOfItemsToShow) != 0 ) {
   			cntPagination++;
   		} 	
   	}
   	
   	/**
   	* Go next result page
   	*/
   	public void nextPage () {
   		currentPagination++;
   		jumpPage = currentPagination;
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	/**
   	* Go previus result page
   	*/
   	public void prevPage () {
   		currentPagination--;
   		jumpPage = currentPagination;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}

	/**
   	* Go last result page
   	*/
   	public void lastPage () {
   		currentPagination = cntPagination;
		jumpPage = cntPagination;
		firstRow = (jumpPage - 1)* numberOfItemsToShow;		
   	}
   	
   	/**
   	* Go first result page
   	*/
   	public void firstPage () {
   		currentPagination = 1;
   		jumpPage = 1;
   		firstRow = (jumpPage - 1)* numberOfItemsToShow;	
   	}

	/**
	* Empty function for refresh result list
	*/
   	public void refreshPages () {
   		
   	}
   	
   	/**
   	* Pagination Integer Getters
   	*@return Integer
   	*/
   	public Integer getFirstItem () {
		return (firstRow + 1);
	}
	
	/**
	* Assign a number to the last page's result
	*@return Integer
	*/
	public Integer getLastItem () {
		Integer lastItem;
		if ((currentPagination == cntPagination) || (currentPagination == 1 && (totalItemsNumber < numberOfItemsToShow))) {
			lastItem = firstRow + Math.mod(totalItemsNumber, numberOfItemsToShow);
		}else {
			lastItem = firstRow + 10;
		}
		return lastItem;
	}
   	
   	/**
   	* Return current page number
   	*@return Integer
   	*/
   	public Integer getCurrentPagination () {
   		return currentPagination;
   	}
   	
   	/**
   	* Return number of result pages
   	*@return Integer
   	*/
   	public Integer getCntPagination () {
   		return cntPagination;
   	}
   	
   	/**
   	* Return number of results
   	*@return Integer
   	*/
   	public Integer getNumberOfItemsToShow () {
   		return numberOfItemsToShow;
   	}
   	
   	/**
   	* Return the number of the first item of page
   	*@return Integer
   	*/
   	public Integer getFirstRow () {
   		return firstRow;
   	}
   	
   	/**
   	* Return if show Prev Link
   	*@return boolean
   	*/
	public boolean getPrevPageLinkShow () {
		if(currentPagination == 1){ 
			prevPageLinkShow = false;		
		}else {
			prevPageLinkShow = true;
		}
   		return prevPageLinkShow;
   	}
   	
   	/**
   	* Return if show Prev Link
   	*@return boolean
   	*/
   	public boolean getPrevPageShow () {
   		
   		if(currentPagination == 1){	
   			prevPageShow = true; 
   		}else {
   			prevPageShow = false;
   		}
   		return prevPageShow;
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageLinkShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){	
   			nextPageLinkShow = false; 
		} else { 
			nextPageLinkShow = true;
		}   		
   		return nextPageLinkShow;
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageShow () {
   		if((currentPagination == cntPagination) || (cntPagination == 0)){ 
   			nextPageShow = true; 
		} else { 
			nextPageShow = false;
		} 
   		return nextPageShow;
   	}
	
	public Integer jumpPage = 1;
	
	/**
	* Jump to page
	*@return Integer jumpPage
	*/   
	public Integer getJumpPage () {
		return jumpPage;
	}
	
    /**
    * Set jumpo to page
    *@param Integer jumpPage
    */
	public void setJumpPage (Integer jumpPage) {
		this.jumpPage = jumpPage;
	}
	
    /**
    * Jump to page
    */
	public void JumpToPage () {
		if (jumpPage > cntPagination) {
			currentPagination = cntPagination;
			jumpPage = cntPagination;
		}else {
			if (jumpPage < 1) {
				currentPagination = 1;
				jumpPage = 1;
			}else {	
				currentPagination = jumpPage;
			}
		}
		firstRow = (jumpPage - 1)* numberOfItemsToShow;
	}
	
	/**
	* Inner without sharing class
	*@class
	*/
	public without sharing class LeaveJoinTeam{
		
		/**
		* Join Team w/o sharing
		*@param teamId
		*@return PageReference
		*/
		public PageReference joinTeam(String teamId){
			Team__c t = [select Id, NewMemberProfile__c from Team__c where Id =: teamId];
			TeamMember__c newUserJoin = new TeamMember__c();
			newUserJoin.User__c = UserInfo.getUserId();
			newUserJoin.TeamProfile__c = t.NewMemberProfile__c;
			newUserJoin.Team__c = teamId;
			insert newUserJoin;
				
			Team__c teamT = [SELECT TeamType__c, TeamType__r.Id FROM Team__c WHERE id =: teamId];
			String teamTypeId;
			if (teamT.TeamType__c != null) {
				teamTypeId = teamT.TeamType__r.Id;
			}
	 		PageReference pageRef = new PageReference('/apex/TeamsDetail' + teamTypeId + '?id=' + teamId + '&j=true');
			pageRef.setRedirect(true);
			return pageRef;
		}
		
		/**
		* Leave Team w/o sharing
		*@param String idTeam
		*@throws Exception
		*/
		public void leaveTeam(String teamId){
			 TeamMember__c userRow = new TeamMember__c();
			 try {
			 	userRow = [Select Id, User__c, Team__c from TeamMember__c where User__c =: UserInfo.getUserId() and Team__c =: teamId];
			 	delete userRow; 
			 }catch(Exception e){ 
			 	throw e;
			 }
		}			
	
	}
	
	/**
	* Redirect after join
	*@return PageReference
	*/
	public PageReference joinTeam(){
		if(System.currentPageReference().getParameters().get('teamId') != null)
	 		teamId = System.currentPageReference().getParameters().get('teamId');		
		PageReference pr = leaveJoinTeam.joinTeam(teamId);
		return pr;
	}
	
	/**
	* Leave team
	*@void
	*/
	public void leaveTeam(){
		if(System.currentPageReference().getParameters().get('teamId') != null)
	 		teamId = System.currentPageReference().getParameters().get('teamId');		
		leaveJoinTeam.leaveTeam(teamId);
		search();	
	}
	
	/**
	*@return String ID
	*/
	public String getCurrentUser () {
		return UserInfo.getUserId();
	}
	
	public String leaveTeamId;
	
	/**
	*@return String ID
	*/
	public String getLeaveTeamId () {
		return leaveTeamId;
	}
	
	public String leaveTeamName;
	
	/**
	*@return String Name
	*/
	public String getLeaveTeamName () {
		return leaveTeamName;
	}
	
	public Integer leaveTeamCnt;
	
	/**
	*@return Integer
	*/
	public Integer getLeaveTeamCnt () {
		return leaveTeamCnt;
	}
	
	/**
	* Assign leave team id
	*@void
	*/
	public void assignLeaveTeamId () {
		teamId = System.currentPageReference().getParameters().get('teamId');
		if (teamId != null) {
			leaveTeamCnt = [select count() from TeamMember__c where team__c =:teamId];
			leaveTeamName = [select Name from Team__c where Id =:teamId].Name;
			leaveTeamId = teamId;
		}
	}
	
	
}
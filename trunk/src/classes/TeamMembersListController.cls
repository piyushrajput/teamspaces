/**
*@author Juan Bessonart @ 06/09/2008
*/
public without sharing class TeamMembersListController {
	public String idTeam = System.currentPageReference().getParameters().get('id');
	public String removeMemberId = System.currentPageReference().getParameters().get('delId');
	public String delName;

	/**
	* Constructor
	*/
	public TeamMembersListController () {
		genPermissions();
		genMembers();
	}
	
	/**
	* Return the Namespace Prefix
	*@return String
	*/
	public String getNamespace () {
        return TeamUtil.getNamespace();
    } 
	
	/**
	*@param String idTeam
	*/
	public void setIdTeam(String team){
		idTeam = team;
	}
	
	/**
	* Set memberId to remove
	*@param String memberId
	*/
	public void setRemoveMemberId (String mamberId){
		removeMemberId = mamberId; 
	}
	
	/**
	* Refresh member list
	*@void
	*/
	public void refresh() {genMembers();}
	
	public UserPermissions userPermissions = new UserPermissions();
	
	/**
	* Generate user permissions
	*@void
	*/
	public void genPermissions() {
		userPermissions.setId(UserInfo.getUserId());
		userPermissions.setTeam(idTeam);
		userPermissions.setObjectType('Team');
		userPermissions.setPermissions();		
	}
	
	/**
	* Return user permissions
	*@return UserPermissions
	*/
	public UserPermissions getUserPermissions () {
		return userPermissions;
	}	
	
	/**
	*@return String Name
	*/	
	public String getTeamName () {
		Team__c currentTeam = [select Name from Team__c where id=: idTeam];
		return currentTeam.Name;	 
	}

	/**
	*@return String ID
	*/	
	public String getTeamId () {
		return idTeam;	
	}
	
	/**
	* Return number of admin(s) in the team
	*@return Integer
	*/	
	public Integer getAdminCount () {
		Integer countAdmin = [select count() from TeamMember__c where team__c = :idTeam and TeamProfile__r.ManageTeams__c = true];
		return countAdmin;	
	}
	
	/**
	* Return user id from Team Member
	*@return String ID
	*/	
	public String getUserMemberId () {
		List<TeamMember__c> userMember = new List<TeamMember__c>();
		userMember = [select id from TeamMember__c where team__c =:idTeam and User__c =:UserInfo.getUserId() limit 1];
		String userMemberId = '';
		if (userMember.size() > 0) {
			userMemberId = userMember[0].Id;	
		}
		return userMemberId;
	}
	
	/**
	* Return the current user's ID
	*@return String ID
	*/
	public String getCurrentUser () {
		return UserInfo.getUserId();
	}
	
	/**
	* Return if show the Remove Message
	*@return Boolean
	*/	
	public Boolean getRemoveMessage () {
		String removeParam = System.currentPageReference().getParameters().get('remMsg');
		return (removeParam == 'true');
	}
	
	/**
	* Asign the Name of the user to remove
	*@void
	*/
	public void assignRemoveId () {
		if (System.currentPageReference().getParameters().get('delId') != null) {
			removeMemberId = System.currentPageReference().getParameters().get('delId');	
		}
		
		delName = [select User__r.Name from TeamMember__c where User__c =: removeMemberId and team__c =: idTeam].User__r.Name;
	}
	
	/**
	* Return the Name of the user to remove
	*@return String
	*/
	public String getDelName () {
		return delName;
	}
	
	/**
	* Redirect after remove a member
	*@return PageReference
	*/
	public PageReference removeMember () {
		if (removeMemberId != UserInfo.getUserId()) {
			TeamMember__c delMember = [select User__r.Name from TeamMember__c where User__c =: removeMemberId and Team__c =: idTeam];
			delete delMember;
		}
		PageReference pageRef = Page.TeamsMembersList;
		pageRef.getParameters().put('remMsg', 'true');
		pageRef.getParameters().put('id', idTeam);
		pageRef.setRedirect(true);
		return pageRef;	
	}
	
	// Edit Members
	public String editMemberId = System.currentPageReference().getParameters().get('editId');
	public TeamMember__c editMember;
	public String imgEditMember = '';
	public Boolean itsLastAdmin = false;
	
	/**
	* Return if the user to delette is the last admin
	*@return Boolean
	*/
	public Boolean getItsLastAdmin () {
		return itsLastAdmin;	
	}
	
	/**
	* Return if the user to delette is the last admin
	*@param s member id
	*/
	public void setEditMemberId (String s){
		editMemberId = s;	
	}
	
	/**
	* Stuff before edit
	*@void
	*/
	public void assignEditId () {
		if (System.currentPageReference().getParameters().get('editId') != null) {
			editMemberId = 	System.currentPageReference().getParameters().get('editId');
		}
		editMember = [select id, User__r.name, TeamRole__c, TeamProfile__c, User__r.companyName, User__r.Title  from TeamMember__c where User__c =: editMemberId and Team__c =: idTeam];
		PeopleProfile__c img = [SELECT Picture__c from PeopleProfile__c WHERE User__c =: editMemberId LIMIT 1];
		if (img == null) {
			imgEditMember = '';
		}else {
			imgEditMember = img.Picture__c;
		}
		
		Integer countAdmin = [select count() from TeamMember__c where team__c = :idTeam];
		Boolean isAdmin = [select TeamProfile__r.ManageTeams__c from TeamMember__c where team__c =:idTeam and User__c=:editMemberId].TeamProfile__r.ManageTeams__c;
		
		itsLastAdmin = (editMemberId == UserInfo.getUserId()) && isAdmin;
		
		editMemberRole = editmember.TeamRole__c;
		editMemberProfile = editmember.TeamProfile__c;
	}
	
	public String editMemberRole;
	
	/**
	* Get role from edit member
	*@return String
	*/
	public String getEditMemberRole () {
		return editMemberRole;
	}
	
	/**
	* Set role to edit member
	*@param String role
	*/
	public void setEditMemberRole (String role) {
		this.editMemberRole = role;
	}

	public String editMemberProfile;
	
	/**
	* Return idProfile from edit member
	*@return String
	*/
	public String getEditMemberProfile () {
		return editMemberProfile;
	}
	
	/**
	* Set idProfile to edit member
	*@param String
	*/
	public void setEditMemberProfile (String profile) {
		this.editMemberProfile = profile;
	}
	
	/**
	*@return TeamMember__c
	*/
	public TeamMember__c getEditMember () {
		return editMember;
	}
	
	/**
	* Return idImg from edit member
	*@return String
	*/
	public String getImgEditMember () {
		return imgEditMember;
	}
	
	
	/**
	* Redirect after edit a member
	*@return PageReference
	*/
	public PageReference editMemberAction () {	
		editMember.TeamProfile__c = editMemberProfile;
		editMember.TeamRole__c = editMemberRole;
		update editMember;
		PageReference pageRef = Page.TeamsMembersList;
		pageRef.getParameters().put('id', idTeam);
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	/**
	*@return profiles select option list
	*/
	public List<SelectOption> getProfilesOptions () {
		List<SelectOption> options = new List<SelectOption>();
		for (TeamProfile__c item: [select id, Name from TeamProfile__c order by Name]) {
			options.add(new SelectOption(item.id,item.Name));
		}
		return options;
	}
	
	/**
	*@return profile list option filter
	*/
	public List<SelectOption> getProfilesOptionsFilter () {
		List<SelectOption> options = new List<SelectOption>();
		for (TeamProfile__c item: [select id, Name from TeamProfile__c where ManageTeams__c = true order by Name]) {
			options.add(new SelectOption(item.id,item.Name));
		}
		return options;
	}
	
	/**
	* Return all Profiles
	*@return List<TeamProfile__c>
	*/
	public List<TeamProfile__c> getTeamEditProfiles () {
		return [select Name, id from TeamProfile__c order by Name];
	}
	
	public List<Member> members = new List<Member>();
	
	/**
	* Return list of members
	*@return List<Member>
	*/
	public List<Member> getMembers () {
		return members;
	}
	
	/**
	* Inner class for Member class
	*@class
	*/
	public class Member {
		String memberImg;
		String company;
		String title;
		String profile;
		String role;
		String name;
		String userId;
		String teamMemberId;
		Boolean admin;
		String yahoo;
		String skype;
		
		/**
		*@return String
		*/
		public String getYahoo () {
			return yahoo;
		}
		
		/**
		*@return String
		*/
		public String getSkype () {
			return skype;	
		}
		
		/**
		*@return String ID
		*/
		public String getUserId (){
			return userId;
		}
		
		/**
		*@return String ID
		*/
		public String getTeamMemberId (){
			return teamMemberId;
		}
		
		/**
		*@param String ID
		*/
		public void setTeamMemberId (String teamMemberId){
			this.teamMemberId = teamMemberId;
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
		public String getMemberImg () {
			return memberImg;
		}
		
		/**
		*@return String
		*/
		public String getCompany () {
			return company;
		}
		
		/**
		*@return String
		*/
		public String getTitle () {
			return title;
		}
		
		/**
		*@return String
		*/
		public String getProfile () {
			return profile;
		}
		
		/**
		*@return String
		*/
		public String getRole () {
			return role;
		}
		
		/**
		*@param String ID
		*/
		public void setUserId (String userId) {
			this.userId = userId;
		}
		
		/**
		*@param String company
		*/
		public void setCompany (String company) {
			this.company = company;
		}
		
		/**
		*@param String name
		*/
		public void setName (String name) {
			this.name = name;
		}
		
		/**
		*@param String idMember
		*/
		public void setMemberImg (String memberId) {
			
			List<PeopleProfile__c> imgs = new List<PeopleProfile__c>();
			try {
				imgs = [SELECT Id, YahooIM__c, Skype__c, Picture__c from PeopleProfile__c WHERE User__c =: memberId LIMIT 1];
			} catch(Exception e){
				throw e;
			}
			PeopleProfile__c img = new PeopleProfile__c();
			if(imgs.size() > 0){
				img = imgs[0];
			} 
			
			if (img == null) {
				this.memberImg = '';
				this.yahoo = '';
				this.skype = '';
			}else {
				this.memberImg = img.Picture__c;
				if(img.YahooIM__c != null){
	            	this.yahoo = img.YahooIM__c;
	            }else {
	            	this.yahoo = '';
	            }
	            if(img.Skype__c != null){
	            	this.skype = img.Skype__c;
	            }else {
	            	this.skype = '';
	            }
			}
		}
		
		/**
		*@param String
		*/
		public void setProfile (String profile) {
			this.profile = profile;
		}
		
		/**
		*@param String
		*/
		public void setRole (String role) {
			this.role = role;
		}
		
		/**
		*@param String
		*/
		public void setTitle (String title) {
			this.title = title;
		}
		
		/**
		*@param Boolean
		*/
		public void setAdmin (Boolean admin) {
			this.admin = admin;	
		}
		
		/**
		*@return Boolean
		*/
		public Boolean getAdmin () {
			return admin;
		}
	}
	
	public String letter = System.currentPageReference().getParameters().get('ltr');
	
	/**
	* Set letter value
	*@param String
	*/
	public void setLetter(String s){
		letter = s;	
	}
	
	/**
	* Search members
	*@void
	*/
	public void genMembers () {
		List<Member> membersList = new List<Member>();
		
		sortByDesc = false;
		sortBy = 'User__r.Name';
		
		if(System.currentPageReference().getParameters().get('ltr') != null)
			letter = System.currentPageReference().getParameters().get('ltr');
				
		if (letter == null || letter == '' || letter== 'ALL') {
			for (TeamMember__c item: [select id, Name, TeamRole__c, TeamProfile__r.Name, TeamProfile__r.ManageTeams__c, TeamProfile__r.Description__c, User__r.Name, User__r.Title, User__r.Id, User__r.CompanyName from TeamMember__c where team__c =:idTeam order by User__r.Name]) {
				Member memberItem = new Member();
				memberItem.setName(item.User__r.Name);
				memberItem.setRole(item.TeamRole__c);
				memberItem.setProfile(item.TeamProfile__r.Name);
				memberItem.setTitle(item.User__r.Title);
				memberItem.setUserId(item.User__r.Id);
				memberItem.setTeamMemberId(item.id);
				memberItem.setMemberImg(item.User__r.Id);
				memberItem.setAdmin(item.TeamProfile__r.ManageTeams__c);
				memberItem.setCompany(item.User__r.CompanyName);
				membersList.add(memberItem);
			}
		}else {
			for (TeamMember__c item: [select id, Name, TeamRole__c, TeamProfile__r.Name, TeamProfile__r.ManageTeams__c, TeamProfile__r.Description__c, User__r.Name, User__r.Title, User__r.Id, User__r.CompanyName from TeamMember__c where User__r.Name like :(letter + '%') and team__c =:idTeam order by User__r.Name]) {
				Member memberItem = new Member();
				memberItem.setName(item.User__r.Name);
				memberItem.setRole(item.TeamRole__c);
				memberItem.setProfile(item.TeamProfile__r.Name);
				memberItem.setTitle(item.User__r.Title);
				memberItem.setUserId(item.User__r.Id);
				memberItem.setTeamMemberId(item.id);	
				memberItem.setMemberImg(item.User__r.Id);
				memberItem.setAdmin(item.TeamProfile__r.ManageTeams__c);
				memberItem.setCompany(item.User__r.CompanyName);
				membersList.add(memberItem);
			}
		}	
		totalItemsNumber = membersList.size();
		if (totalItemsNumber == 0 ) {
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
		}else {
			firstRow = 0;
			currentPagination = 1;
			genCntPagination();	
		}
		members = membersList;
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
   		firstRow = firstRow + numberOfItemsToShow;   		
   	}
   	
   	/**
   	* Go previus result page
   	*/
   	public void prevPage () {
   		currentPagination--;
   		firstRow = firstRow - numberOfItemsToShow;	
   	}

   	// Pagination Integer Getters
	public Integer totalItemsNumber= 0;
	
	/**
	*@return Integer
	*/
	public Integer getTotalItemsNumber () {
		return totalItemsNumber;
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
		return currentPagination != 1;
   	}
   	
   	/**
   	* Return if show Prev Link
   	*@return boolean
   	*/
   	public boolean getPrevPageShow () {
   		return currentPagination == 1;
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageLinkShow () {
   		return !(currentPagination == cntPagination) || (cntPagination == 0);
   	}
   	
   	/**
   	* Return if show Next Link
   	*@return boolean
   	*/
   	public boolean getNextPageShow () {
   		return (currentPagination == cntPagination) || (cntPagination == 0);
   	}
	
	public List<String> lettersList = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};	
	
	/**
	* Inner class for Letters type
	*
	*/
	public class Letters {
		String letter;
		Boolean containMembers;
		
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
		public void setContainMembers (Integer cntMembers) {
			this.containMembers = cntMembers == 0;
		}
		
		/**
		*@return Boolean
		*/
		public Boolean getContainMembers () {
			return containMembers;
		}
	}
	
	/**
	* Return list with letters and if contain Team Members
	*@return List<Letters>
	*/
	public List<Letters> getLetterFilter () {
		List<Letters> letterFilter = new List<Letters>();
   		for (String item : lettersList) {
   			Letters currentLetter = new Letters();
   			Integer cntMembers = [select count() from TeamMember__c where User__r.Name like :(item + '%') and team__c =:idTeam];
   			currentLetter.setLetter(item);
   			currentLetter.setContainMembers(cntMembers);
   			letterFilter.add(currentLetter);
   		}
   		return letterFilter;		
	}

   	/**
   	* Admin member
   	*@return Boolean
   	*/
	public Boolean getIsTeamAdmin () {
		List<TeamMember__c> currentUser = new List<TeamMember__c>();
		currentUser = [select TeamProfile__r.ManageTeams__c from TeamMember__c where team__c =:idTeam and User__c =:UserInfo.getUserId()];
		Boolean isTeamAdmin = false;
		if (currentUser.size() > 0) {
			isTeamAdmin = (currentUser[0].TeamProfile__r.ManageTeams__c);
		} 
		return isTeamAdmin;		
	}

   	// SortBy
	public Boolean sortByDesc = false;
	// Order
	public String sortBy = 'User__r.Name';
	
	/**
	*@return Boolean
	*/
	public Boolean getSortByDesc () {
		return !sortByDesc;
	}
	
	/**
	*@param s sort by field
	*/
	public void setSortBy (String s){
		sortBy = s;	
	}
	
	/**
	*@return String
	*/
	public String getSortBy () {
		String sbCol = '';
		if (sortBy == null || sortBy == 'User__r.Name') 
			sbCol = 'name';	
		if (sortBy == 'User__r.CompanyName') 
			sbCol = 'company';	
		if (sortBy == 'User__r.Title') 
			sbCol = 'title';	
		if (sortBy == 'TeamProfile__r.Name') 
			sbCol = 'profile';	
		if (sortBy == 'TeamRole__c') 
			sbCol = 'role';	
		return sbCol;
	}
	
	/*
	 * This is a temporary method to cover us until dynamic apex is back.  This will use hard coded
	 * SOQL statements in place of the dynamic statements
	 */
	public void sortList () {
		List<Member> membersList = new List<Member>();
		if (sortBy == System.currentPageReference().getParameters().get('sb')) {
			sortByDesc = !sortByDesc;
		}else {
			sortByDesc = false;
		}
		
		//Sort param
		if(System.currentPageReference().getParameters().get('sb') != null)
			sortBy = System.currentPageReference().getParameters().get('sb');
		
		List<TeamMember__c> memberResultList = new List<TeamMember__c>();

		if (sortByDesc) {
			if (letter == null || letter == '' || letter== 'ALL') {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by User__r.Name desc];
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by User__r.CompanyName desc];						
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by User__r.Title desc];							
				}
				if (sortBy == 'TeamProfile__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by TeamProfile__r.Name desc];						
				}
				if (sortBy == 'TeamRole__c') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by TeamRole__c desc];						
				}		
			}else {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by User__r.Name desc];					
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by User__r.CompanyName desc];							
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by User__r.Title desc];							
				}
				if (sortBy == 'TeamProfile__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by TeamProfile__r.Name desc];						
				}
				if (sortBy == 'TeamRole__c') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by TeamRole__c desc];						
				}		
			}
		}else {
			if (letter == null || letter == '' || letter== 'ALL') {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by User__r.Name];
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by User__r.CompanyName asc];						
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by User__r.Title];							
				}
				if (sortBy == 'TeamProfile__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by TeamProfile__r.Name];						
				}
				if (sortBy == 'TeamRole__c') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where team__c =: idTeam
										order by TeamRole__c];						
				}		
			}else {
				if (sortBy == 'User__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by User__r.Name];					
				}
				if (sortBy == 'User__r.CompanyName') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by User__r.CompanyName];							
				}	
				if (sortBy == 'User__r.Title') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by User__r.Title];							
				}
				if (sortBy == 'TeamProfile__r.Name') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by TeamProfile__r.Name];						
				}
				if (sortBy == 'TeamRole__c') {
					memberResultList = [select id, 
											   Name, 
											   TeamRole__c, 
											   TeamProfile__r.Name, 
											   TeamProfile__r.Description__c, 
											   User__r.Name, 
											   User__r.Title, 
											   User__r.Id, 
											   User__r.CompanyName 
										from TeamMember__c 
										where User__r.Name like: (letter + '%') 
										and team__c =: idTeam
										order by TeamRole__c];						
				}		
			}			
		}
				 
		for (TeamMember__c item: memberResultList) {
			Member memberItem = new Member();
			memberItem.setName(item.User__r.Name);
			memberItem.setRole(item.TeamRole__c);
			memberItem.setProfile(item.TeamProfile__r.Name);
			memberItem.setTitle(item.User__r.Title);
			memberItem.setUserId(item.User__r.Id);	
			memberItem.setMemberImg(item.User__r.Id);
			memberItem.setCompany(item.User__r.CompanyName);
			membersList.add(memberItem);
		}
			
		totalItemsNumber = membersList.size();
		if (totalItemsNumber == 0 ) {
			cntPagination = 0;	
			firstRow = 0;
			currentPagination = 1;
		}else {
			firstRow = 0;
			currentPagination = 1;
			genCntPagination();	
		}
		members = membersList;	
	}
	 
}
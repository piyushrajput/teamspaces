public class TeamsOverviewController {

    List<TeamMember__c> teams = new List<TeamMember__c>();
    List<MiniFeeds> minifeeds = new List<MiniFeeds>();    
    
    /*
    * Construct
    */
    public TeamsOverviewController(){
    	teams = getMyTeams();
    	if(teams.size() > 0)
    		getFeeds();
    }
    
    	
	/**
	* Check if people profile exist for current user
	* @return PageReference
	*/
	public PageReference profileExist(){
		PageReference pr = null;
		List<PeopleProfile__c> profiles = new List<PeopleProfile__c>();
		profiles = getPeopleProfile();
		if(profiles.size() == 0){
			PeopleProfile__c profile = new PeopleProfile__c();
			profile.User__c = UserInfo.getUserId();
			profile.Name = UserInfo.getName();
			insert profile;
		}
		return pr;
	}
	
	/**
	* Get people profile for current user
	*@return List<PeopleProfile__c>
	*/
	public List<PeopleProfile__c> getPeopleProfile(){
		List<PeopleProfile__c> profiles = new List<PeopleProfile__c>();			
		profiles = [SELECT Id,  Status__c, Picture__c, StatusLastModifiedDate__c
		     		FROM PeopleProfile__c
		     		WHERE User__c =: UserInfo.getUserId()];
		return profiles;	
	}
	
    
    /*
    * Getters
    */
    public List<TeamMember__c> getTeams(){
    	return teams;
    }
    
    public List<MiniFeeds> getMinifeeds(){
    	return minifeeds;
    }    
    
    /*
    *@retrun List<TeamMember__c>
    */    
    public List<TeamMember__c> getMyTeams(){
    	return  [Select s.Team__c, s.Team__r.Id, s.Team__r.Name,
	    			Team__r.Description__c, Team__r.CreatedDate 
	                From TeamMember__c s
    				where s.User__c =: UserInfo.getUserId()
    				order by s.CreatedDate desc
    				limit 15
    			];
    }
    
    /**
    *
    */
    public String getTeamspaceImage() {
    	List<Attachment> attach = [select Id 
        							from Attachment 
        							where ParentId =:System.currentPageReference().getParameters().get('id')];
        	if(attach.size() == 0) return '';					
        	return '/servlet/servlet.FileDownload?file=' + attach[0].Id;
    }
    
    
    /*
    *@void
    */
    public void getFeeds(){
    	List<MiniFeed__c> mf = new List<MiniFeed__c>();    	
    	String allFeeds = System.currentPageReference().getParameters().get('isAllFeeds');
    	if(allFeeds != 'true'){
	    	List<Id> myTeams = new List<Id>();
	    	for(TeamMember__c tm : teams){
	    		if(tm.Team__r.Id != null)
	    			myTeams.add(tm.Team__r.Id); 
	    	}
	
	    	mf = [Select 
	    				m.User__c,
	    				m.User__r.Name, 
	    				m.Type__c, 
	    				m.Message__c, 
	    				m.Id, 
	    				m.CreatedDate 
	    				from MiniFeed__c m
	    				where Team__c in:myTeams
	    				order by m.FeedDate__c desc
	    				limit 25];
    	}else{
	    	mf = [Select 
	    				m.User__c,
	    				m.User__r.Name, 
	    				m.Type__c, 
	    				m.Message__c, 
	    				m.Id, 
	    				m.CreatedDate 
	    				from MiniFeed__c m
	    				order by m.FeedDate__c desc
	    				limit 25];    		
    	}
    	
    	minifeeds.clear();
    	for(MiniFeed__c m : mf){
    		MiniFeeds minif = new MiniFeeds(m);
    		minifeeds.add(minif);
    	}
    }


    /*
    *@class
    */
    public class MiniFeeds {
    	
    	MiniFeed__c feed = null;
    	String formatedDate = null;
    	
    	/**
    	*@param MiniFeed__c
    	*/
    	public MiniFeeds(MiniFeed__c m){
    		feed = m;
    	}
    	
    	public MiniFeed__c getFeed(){
    		return feed;
    	}
    	
    	public String getFormatedDate(){
    		return feed.CreatedDate.format('MMMM dd, yyyy HH:mm');
    	}		
    }
}
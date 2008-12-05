/**
*@author Martin Prado @ 06/02/2008
*/
public class DiscussionWidgetSubTeamsController {
	
	public String teamId = '';
	public String url = System.currentPageReference().getUrl();	
	public String idUrl = System.currentPageReference().getParameters().get('id');
	
	public boolean noSubTeams;
	
	/**
	* Set team Id
	*@param String Id
	*/
	public void setTeamId (String teamId) {
		this.teamId = teamId;
	}
	
	/**
	* Constructor
	*/
	public DiscussionWidgetSubTeamsController(){
		if(url != null && url.split('DiscussionDetail').size() < 2)	{
			teamId = idUrl;
		}else if(idUrl != null){
			DiscussionTopic__c topicTeam = [SELECT Id,	Team__c From DiscussionTopic__c where Id =: idUrl  limit 1];
			teamId = topicTeam.Team__c;
		}
	}
	
	/**
	* Returns list of subteams
	*@return List<subTeams>
	*/
	public List<subTeams> getSubTeams(){
		return getSubTeam(teamId);
	}

 	/**
 	* Class SubTeams
 	*@author Martin Prado
 	*/
 	public class subTeams {
 		
 		String name;
 		Integer count;
 		String id;
        
        /**
        * Get team name
        *@return String name
        */
        public String getName () {
        	return name;
        } 
        
        /**
        * Get team Id
        *@return String Id
        */
        public String getId () {
        	return id;
        }        
        
        /**
        * Get topics count
        *@return Integer
        */
        public Integer getCount () {
        	return count;
        } 
        
        /**
        * Set team name
        *@param String name
        */
        public void setName (String name) {
        	this.name = name;
        }
        
        /**
        * Set team Id
        *@param String id
        */
        public void setId (String id) {
        	this.id = id;
        }        
        
        /**
        * Set topics count
        *@param Integer count
        */
        public void setCount (Integer intCount) {
        	this.count = intCount;
        }                              		
 	
 	}
	
	/**
	* Get subteams count for current team
	*@return Integer
	*/
	public Integer getCountSubTeams () {
		return 	[Select Id From Team__c where parentTeam__c =: teamId].size();
	}
	
	/**
	* Read subteams instances and count topics
	*@return List<subTeams>
	*/
	public List<subTeams> getSubTeam(String teamId){
 		List<subTeams> subTeamsCount = new List<subTeams>();
 		
 		for (Team__c item: [Select Name,Id From Team__c where parentTeam__c =: teamId order by CreatedDate desc limit 4]) {
 			subTeams subTeam = new subTeams();
 			Integer count;
 			List<DiscussionTopic__c> msjCount = [SELECT 
						Id, 
						ViewCount__c, 
						Team__c, 
						Team__r.Name,
						Subject__c, 
						Name, 
						MessageCount__c, 
						CreatedBy.Name,
						CreatedBy.Id,
						LastPostedMessage__c, 
						DiscussionForum__c 
						From DiscussionTopic__c where Team__c =: item.Id];
 			subTeam.setCount(msjCount.size());
 			subTeam.setName(item.Name);
 			subTeam.setId(item.Id);
 			subTeamsCount.add(subTeam);		
 		}
 		return subTeamsCount;	
	}
}
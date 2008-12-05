/**
*@author Martin Prado @ 06/02/2008 
*/
public class DiscussionWidgetActivePeopleController {
	
	public String teamId = '';
	public String url = System.currentPageReference().getUrl();	
	public String idUrl = System.currentPageReference().getParameters().get('id');
	
	/**
	* Construct
	*/
	public DiscussionWidgetActivePeopleController(){
		if(url != null && url.split('DiscussionDetail').size() < 2){
			teamId = idUrl;
		}else if(idUrl != null){
			DiscussionTopic__c topicTeam = [SELECT Id,	Team__c From DiscussionTopic__c where Id =: idUrl  limit 1];
			teamId = topicTeam.Team__c;
		}
	}
	
	/**
	* Class Actives
	*@author Martin Prado
	*/
	public class Actives {
 		String id;
 		String subject;
 		String name;
 		String picture;
 		String userId;
 		
        /**
        * Get topic name
        *@return String
        */
        public String getName () {
        	return name;
        } 
        
		/**
		* Get topic Id
		*@return String
		*/
        public String getId () {
        	return id;
        }  
              
        /**
        * Returns topic subject
        *@return String
        */
        public String getSubject () {
        	return subject;
        } 
        
        /**
        * Get picture
        *@return String
        */
        public String getPicture () {
        	return picture;
        } 
        
        /**
        * Get User Id
        *@return String
        */
        public String getUserId () {
        	return userId;
        } 
        
        /**
        * Set User Id
        *@param String
        */
        public void setUserId (String userId) {
        	this.userId = userId;
        }
        
        /**
        * Set topic Name
        *@param String
        */
        public void setName (String name) {
        	this.name = name;
        }
        
        /**
        * Set topic Id
        *@param String
        */
        public void setId (String id) {
        	this.id = id;
        }
        
        /**
        * Set topic subject
        *@param String 
        */
        public void setSubject (String subject) {
        	Integer subjectLength; 
        	if(subject != null ){
        		subjectLength = subject.length();
        		if(subjectLength > 20) {
        			this.subject = subject.substring(0, 19) + '...' ;
        		}else {
        			this.subject = subject;
        		}
        	}else {
        		this.subject = subject;
        	}
        }
                
        
        /**
        * Set user picture
        *@param String
        */
        public void setPicture (String userId) {
			String PictureId;
			Integer cntPicture;
			
			cntPicture = [SELECT count() FROM PeopleProfile__c WHERE User__c =:userId];
			
			if (cntPicture != 0) {
				PeopleProfile__c picture = [SELECT Picture__c FROM PeopleProfile__c WHERE User__c =:userId limit 1];
		        if(picture.Picture__c == null || picture.Picture__c == '') {                	                                          	 
			     	PictureId = '';
				}else {
					PictureId = picture.Picture__c;
				} 
			}else {
				PictureId = '';
			}
   			this.picture = PictureId ;
   		}    
 	}
	
	/**
	* For refresh use
	*@param String
	*/
	public void refreshActivePeople(){}
	
	public List<Actives> getActivePeople(){
		List<Actives> topics = new List<Actives>();
		// Primary Set to store result values
		Set<String> results = new Set<String>();
		List<DiscussionMessage__c> discussionList = new List<DiscussionMessage__c>();
		if(teamId == null || teamId == '' || teamId.length() < 16){
			discussionList = [Select d.PostedDate__c,
								d.PostedBy__c,  
								d.Id, 
								d.DiscussionTopic__r.Subject__c,
								d.DiscussionTopic__r.id,
								d.PostedBy__r.Name,
								d.PostedBy__r.id
								From DiscussionMessage__c d order by PostedDate__c desc limit 5];
		}else{
			discussionList = [Select d.PostedDate__c,
								d.PostedBy__c, 
								d.Id, 
								d.DiscussionTopic__r.Subject__c,
								d.DiscussionTopic__r.id,
								d.PostedBy__r.Name,
								d.PostedBy__r.id
								From DiscussionMessage__c d
								where Team__c =:  teamId
							 	order by PostedDate__c desc limit 5];
			
		}
		
		if(discussionList.size() > 0){
			for(DiscussionMessage__c item : discussionList){
				if(!results.contains(item.PostedBy__c)){
					Actives active = new Actives();
					active.setId(item.DiscussionTopic__r.id);	
					active.setName(item.PostedBy__r.Name);
					active.setSubject(item.DiscussionTopic__r.Subject__c);
					active.setPicture(item.PostedBy__c);
					active.setUserId(item.PostedBy__c);
					topics.add(active);
					results.add(item.PostedBy__c);
				} 		
			}
		}				
 		return topics; 	
	}
	
	/**
	* Get size for active people
	*@return Integer
	*/
	public Integer getActivePeopleSizeList(){
		Integer size = 0;
		if(getActivePeople() != null){
			size = getActivePeople().size();
		}	
		return size;
	}	
}
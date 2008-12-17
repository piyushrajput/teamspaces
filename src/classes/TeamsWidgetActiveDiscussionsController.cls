public with sharing class TeamsWidgetActiveDiscussionsController {
	
		String teamId = null;
		
		// Setter method for Team Id variable
		public void setTeamId(String id) {
			teamId = id;			
		}
		
		// Get Team Id Attribute
		public String getTeamId(){
			return teamId;
		}

		Integer actdisSize;
		
		String userId = UserInfo.getUserId();

		public Boolean getnewPrivileges() {
			
			Boolean result = true;
			
	    	List<TeamMember__c> tm = new List<TeamMember__c>();	
	    	
		    tm  = [Select 
					t.User__c, 
					t.Team__c, 
					t.TeamProfile__r.CreateDiscussionTopics__c, 
					t.TeamProfile__c From TeamMember__c t 
					where t.Team__c =: teamId and t.User__c =: userId ];
			
			if(tm.size() > 0){
				if(tm[0].TeamProfile__c != null){
					result = tm[0].TeamProfile__r.CreateDiscussionTopics__c;
				}							
			}
			else {
				result = false;					
			}
			return result;
	    }
		
		
		public List<Discussion> getDiscussions(){
			
		    List<DiscussionTopic__c> discussions = new List<DiscussionTopic__c>();

			discussions = [ SELECT ViewCount__c, 
								   Subject__c, 
								   OwnerId, 
								   Name, 
								   MessageCount__c, 
								   PostedDate__c, 
								   PostedBy__r.Name,
								   LastPostedMessage__r.PostedDate__c,
								   LastPostedMessage__r.PostedBy__r.Name
							FROM DiscussionTopic__c d
							WHERE Team__c =: teamId
							ORDER BY d.CreatedDate desc LIMIT 4
							];
			
			actdisSize = discussions.size();
											
			List<Discussion> retDisc = new List<Discussion>();
			
			if(discussions.size() > 0) {
				
				for(DiscussionTopic__c d: discussions) {
					Discussion di = new Discussion(d);
					retDisc.add(di);					
				}
				
			}
			return retDisc;
		}
		
		public Integer getActiveDiscussionsSize(){
			return actdisSize; 
		}
		
		public class Discussion{
			DiscussionTopic__c discussion;
			String author;
			Id authorId;
			String authorPicture;
			String lastReply;
			Integer views;
			Integer replies;
			Id replierId;
			String replierName;
			String lastPostDate;
			
			public Discussion(DiscussionTopic__c dis){
				
				discussion = dis;
				
				Datetime aux;
				views = dis.ViewCount__c.intValue();
				replies = dis.MessageCount__c.intValue();
				authorId = dis.PostedBy__c;
				author = dis.PostedBy__r.Name;

				if(discussion.LastPostedMessage__r.PostedBy__c == null){
						lastReply += '';
						authorPicture = '';
				}
				else {
					aux = discussion.LastPostedMessage__r.PostedDate__c;
												
					lastPostDate = formatDateToText(aux) + ' at ' + aux.format('hh:mm a');
						
					replierId = discussion.LastPostedMessage__r.PostedBy__c;

					replierName = discussion.LastPostedMessage__r.PostedBy__r.Name;
				}					

			}
			
			public DiscussionTopic__c getDiscussion(){
				return discussion;
			}
			
			public String getAuthor(){
				return author;
			}
			
			public Id getAuthorId(){
				return authorId;	
			}
			
			public String getLastPostDate(){
				return lastPostDate;
			}
						
			public String getLastReply(){
				return lastReply;
			}
			
			public Id getLastReplyAuthorId(){
				return replierId;
			}
			
			public String getLastReplyAuthor(){
				return replierName;
			}
			
			public String getAuthorPicture(){
				return authorPicture;
			}
			
			public Integer getViews(){
				return views;
			}
			
			public Integer getReplies(){
				return replies;
			}
			
			public String formatDateToText(Datetime d){
				DateTime now = System.now();
				String res = '';
				
				if(d.day() == now.day()){
					res = 'Today ';
				}else if(d.day() == (now.day() - 1)){
					res = 'Yesterday';
				}else{
					res = d.format('EEEE');
				}
				return res;
			}
			
		}

}
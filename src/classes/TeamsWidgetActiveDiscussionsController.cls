/**
*@author Yuri Alvarez @ 05/02/2008
*/
public with sharing class TeamsWidgetActiveDiscussionsController {
	
		public Boolean sidebar = false;
		
		/**
		* Constructor
		*/
		public TeamsWidgetActiveDiscussionsController(){}
				
		/**
		*@param Boolean
		*/
		public void setSidebar(Boolean b){
	 		sidebar = b;
		}

		/**
		*@return Boolean
		*/
		public Boolean getSidebar(){
			return sidebar;
		}
		
		String teamId;
		
		/**
		*@param String 
		*/
		public void setTeamId(String id) {
			teamId = id;
			genPermissions();			
		}
		
		/**
		*@return String
		*/
		public String getTeamId(){
			return teamId;
		}

		Integer actdisSize;
		String userId = UserInfo.getUserId();

		//UserPermission static instance clone from teamDetail 
		public UserPermissions userPermissions = TeamsDetailController.userPermission.clone();
		
		/**
		* Read user permissions
		*/
		public void genPermissions () {
			userPermissions.setId(UserInfo.getUserId());
			userPermissions.setTeam(teamId);
			userPermissions.setObjectType('Discussion');
			userPermissions.setPermissions();					
		}
		
		/**
		*@return UserPermission instance
		*/
		public UserPermissions getUserPermissions () {
			return userPermissions;
		}
		
		List<DiscussionTopic__c> discussions = new List<DiscussionTopic__c>();
		
		/**
		* Refresh list
		*/
		public void refresh(){
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
		}
		
	
		/**
		* Read discussions for current team
		*@return List<Discussion>
		*/
		public List<Discussion> getDiscussions(){
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
		
		/**
		*@return Integer
		*/
		public Integer getActiveDiscussionsSize(){
			return discussions.size();
		}
		
		/**
		* Class Discussion
		*/
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
			
			/**
			* Costructor
			*@param DiscussionTopic__c
			*/
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
				}else {
					aux = discussion.LastPostedMessage__r.PostedDate__c;
					lastPostDate = formatDateToText(aux) + ' at ' + aux.format('hh:mm a');
					replierId = discussion.LastPostedMessage__r.PostedBy__c;
					replierName = discussion.LastPostedMessage__r.PostedBy__r.Name;
				}					
			}
			
			/**
			*@return DiscussionTopic__c
			*/
			public DiscussionTopic__c getDiscussion(){
				return discussion;
			}
			
			/**
			* Get author name
			*@return String
			*/
			public String getAuthor(){
				return author;
			}
			
			/**
			* Get author Id
			*@return Id
			*/
			public Id getAuthorId(){
				return authorId;	
			}
			
			/**
			*@return String
			*/
			public String getLastPostDate(){
				return lastPostDate;
			}
						
			/**
			*@return String
			*/
			public String getLastReply(){
				return lastReply;
			}
			
			/**
			*@return Id
			*/
			public Id getLastReplyAuthorId(){
				return replierId;
			}
			
			/**
			*@return String
			*/
			public String getLastReplyAuthor(){
				return replierName;
			}
			
			/**
			*@return String
			*/
			public String getAuthorPicture(){
				return authorPicture;
			}
			
			/**
			*@return Integer
			*/
			public Integer getViews(){
				return views;
			}
			
			/**
			*@return Integer
			*/
			public Integer getReplies(){
				return replies;
			}
			
			/**
			*@return String
			*/
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
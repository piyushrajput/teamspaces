public without sharing class TeamsSubscribersEmailServices{
	
	//E-mail services instance
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	public Boolean isTaskEdit = false;
	
	public Boolean isTest = false;
	
	public void setIsTest (Boolean isTest) {
		this.isTest = isTest;	
	}
	
	public void setIsTaskEdit (Boolean isTaskEdit) {
		this.isTaskEdit = isTaskEdit;
	}
		
	//Default Constructor
	public TeamsSubscribersEmailServices(){
	
	}
	
	/**
	 * Search TeamMember for this team, Call Send Mail Method
	 * @TeamId Id of Team
	 * @IdFeed Id of feed
	*/
	
	public MiniFeed__c mf = new MiniFeed__c();

	public void TeamsMembersSubscribers(String TeamId,  MiniFeed__c feed, String compareDetail){
		List<TeamSubscription__c> TeamMemberSubscription = new List<TeamSubscription__c>();
		String emailMsj = '';
		String emailSub = '';
		
		if (feed != null && !isTest) {
			mf = new MiniFeed__c();
			mf = [select 
		    			m.User__c,
		    			m.User__r.Name,
		    			m.User__r.Id, 
		    			m.Type__c, 
		    			m.Team__c, 
		    			m.Team__r.Name,
		    			m.Team__r.Id,
		    			m.OwnerId, 
		    			m.Message__c, 
		    			m.LastModifiedDate, 
		    			m.LastModifiedById, 
		    			m.Id, 
		    			m.FeedDate__c, 
		    			m.CreatedDate, 
		    			m.CreatedById 
	    			from MiniFeed__c m
	    			where m.Id =: feed.Id
	    			limit 1]; 
		}
		if (teamId != null && mf != null) {
			//Select Current MiniFeed
			//All Member Subscribe to Team
			//Select the Path of Host //sample: na1.saleforce.com
			PageReference PR =  ApexPages.currentPage(); 
			
			String newPath ='';
			//In Gannt Page Reference is null
			if(PR !=  null){
				String props = '';
				if(PR.getHeaders() != null){
					props = (PR.getHeaders()).get('Host');
				}
				//Remove HTML tag of Path
				if (props == '' || props == null) {
					newPath = '';	
				}else {
					String [] path = props.split('</?[a-z][a-z0-9]*[^<>]*>');
					if(path.size() == 0){
						newPath = path[0];
					}else{
						for(Integer i = 0; i < path.size(); i++){	
							newPath += path[i];
						}
					}
				}
			}
			
			//////////////////////////////////////
			//////		TEAM MEMBER		//////////
			if (mf.Type__c == 'TeamMemberJoin' || mf.Type__c == 'TeamMemberAdd' || mf.Type__c == 'TeamMemberLeave') {
				if (mf.Type__c == 'TeamMemberLeave') {
					//Sub:Team Member has Left the team
					//Body: {Name} has left team {team name} 
					
					String oldMemberName = mf.User__r.Name;
				
					emailMsj = oldMemberName + ' has left team <a href="https://' + newPath + '/apex/TeamsRedirect?id=' + mf.Team__r.Id + '">' +  mf.Team__r.Name + '</a>.';
					emailSub = 'Team Member has Left the team ';
				}else {
					//Sub:New Team Member
					//Body: A new team member has joined team {}. Please welcome {name} to the team. 
					String newMemberName ='';
					if (mf.Message__c.indexOf('joined') == 0) {
						newMemberName = mf.User__r.Name;
					}else {
						newMemberName = mf.Message__c.replaceFirst('added ', '');
						newMemberName = newMemberName.replaceFirst(' to the team <a href=.*','');
					}
					emailMsj = 'A new team member has joined team <a href="https://' + newPath + '/apex/TeamsRedirect?id=' + mf.Team__r.Id + '">' +  mf.Team__r.Name + '</a>. Please welcome ' + newMemberName + ' to the team.';
					emailSub = 'New Team Member';
				}
				if (!isTest) {
					TeamMemberSubscription = [Select 
							t.WikiPageUpdated__c, 
							t.WikiNewPage__c, 
							t.WikiCreatedByMeUpdated__c, 
							t.User__c, 
							t.User__r.Id,
							t.User__r.Name,
							t.User__r.Email,
							t.Team__c,
							t.Team__r.Name,
							t.Team__r.ContactEmail__c,
							t.Team__r.Id, 
							t.TeamMemberStatusUpdated__c, 
							t.TeamMemberJoinLeave__c, 
							t.ProjectTaskDeleted__c, 
							t.ProjectTaskChanged__c, 
							t.ProjectTaskAssignedToMe__c, 
							t.ProjectTaskAssignToMeChanged__c,
							t.Id, 
							t.DiscussionReplyToMe__c, 
							t.DiscussionNewTopic__c, 
							t.DiscussionNewReply__c
						From TeamSubscription__c t
						where Team__c =: TeamId and TeamMemberJoinLeave__c = true];
				}
			} 
			
			//////////////////////////////////////
			//////		DISCUSSION		//////////
			if (mf.Type__c == 'DiscussionNewTopic') {
				//Sub: {Message Subject} from Teamspace {Team Name}
				//Body:{Topic Body} 
				
				String newTopicId = mf.Message__c.replaceFirst('created new discussion topic <a href="/apex/DiscussionDetail\\?id=', '');
				newTopicId = newTopicId.replaceFirst('"/>.*','');
				
				List<DiscussionMessage__c> newTopicList = [select DiscussionTopic__c, DiscussionTopic__r.Subject__c, Message__c from DiscussionMessage__c where DiscussionTopic__c=:newTopicId order by PostedDate__c];
				
				String topicSubject = '';
				String topicBody = '';
				if (newTopicList.size() > 0) {
					topicSubject = newTopicList[0].DiscussionTopic__r.Subject__c;
					topicBody = newTopicList[0].Message__c;
				}
				
				emailSub = topicSubject + ' from Teamspace ' +  mf.Team__r.Name + '.';
				emailMsj = topicBody;
				
				if (!isTest) {
					TeamMemberSubscription = [Select 
							t.WikiPageUpdated__c, 
							t.WikiNewPage__c, 
							t.WikiCreatedByMeUpdated__c, 
							t.User__c, 
							t.User__r.Id,
							t.User__r.Name,
							t.User__r.Email,
							t.Team__c,
							t.Team__r.Name,
							t.Team__r.ContactEmail__c,
							t.Team__r.Id, 
							t.TeamMemberStatusUpdated__c, 
							t.TeamMemberJoinLeave__c, 
							t.ProjectTaskDeleted__c, 
							t.ProjectTaskChanged__c, 
							t.ProjectTaskAssignedToMe__c, 
							t.ProjectTaskAssignToMeChanged__c,
							t.Id, 
							t.DiscussionReplyToMe__c, 
							t.DiscussionNewTopic__c, 
							t.DiscussionNewReply__c
						From TeamSubscription__c t
						where Team__c =: TeamId and (DiscussionNewTopic__c = true or DiscussionNewReply__c = true)];
				}
			}
			
			if (mf.Type__c == 'DiscussionNewReply') {
				//Sub: RE:{Reply Subject} from Teamspace {Team Name}
				//Body:{Reply Body}
				//
				//.......Reponding to.....
				// {Topic or Reply User is responding} 
								
				String newReplyId = mf.Message__c.replaceFirst('.*<span style="display:none;">', '');
				newReplyId = newReplyId.replaceFirst('</span>','');
				
				List<DiscussionMessage__c> newTopicList = [select ParentMessage__r.Message__c, ParentMessage__c, Subject__c, DiscussionTopic__c, DiscussionTopic__r.Subject__c, Message__c from DiscussionMessage__c where id =:newReplyId];
				
				String topicSubject = '';
				String topicBody = '';
				String respondingTo = '';
				if (newTopicList.size() > 0) {
					topicSubject = newTopicList[0].DiscussionTopic__r.Subject__c;
					topicBody = newTopicList[0].Message__c;
					if (newTopicList[0].ParentMessage__c != null) {
 						respondingTo = newTopicList[0].ParentMessage__r.Message__c;
					}else {
						List<DiscussionMessage__c> parentTopic = [select Message__c from DiscussionMessage__c where DiscussionTopic__c =:newTopicList[0].DiscussionTopic__c order by PostedDate__c];
						if (parentTopic.size() > 0) {
							respondingTo = parentTopic[0].Message__c;
						}
					}
				}
				
				mf.Message__c = mf.Message__c.replaceAll('<span style="display:none;">.*','');
				update mf;
				emailSub = 'RE: ' + topicSubject + ' from Teamspace ' +  mf.Team__r.Name + '.';
				emailMsj = topicBody;
				emailMsj += '<br>.......Reponding to.....<br>';
				emailMsj += respondingTo;
				
				if (!isTest) {
					TeamMemberSubscription = [Select 
							t.WikiPageUpdated__c, 
							t.WikiNewPage__c, 
							t.WikiCreatedByMeUpdated__c, 
							t.User__c, 
							t.User__r.Id,
							t.User__r.Name,
							t.User__r.Email,
							t.Team__c,
							t.Team__r.Name,
							t.Team__r.ContactEmail__c,
							t.Team__r.Id, 
							t.TeamMemberStatusUpdated__c, 
							t.TeamMemberJoinLeave__c, 
							t.ProjectTaskDeleted__c, 
							t.ProjectTaskChanged__c, 
							t.ProjectTaskAssignedToMe__c, 
							t.ProjectTaskAssignToMeChanged__c,
							t.Id, 
							t.DiscussionReplyToMe__c, 
							t.DiscussionNewTopic__c, 
							t.DiscussionNewReply__c
						From TeamSubscription__c t
						where Team__c =: TeamId and (DiscussionNewReply__c = true)];
				}
			}
			
			//////////////////////////////////////
			//////		PROYECT TASK	//////////
			if (mf.Type__c == 'TaskAssigned' || mf.Type__c == 'TaskAssignedDelete') {
				//Sub:{Task Name} has been assigned to you
				//Body: {Task Details such as name and description and start and end date} 
				String assignAction = '';
				String assignToId = '';
				String taskId = '';
				String taskName = '';
				
				List<MiniFeed__c> pastMiniFeedsList = new List<MiniFeed__c>();
				pastMiniFeedsList = [select id, Type__c, User__c, Team__c, FeedDate__c, CreatedById, OwnerId, LastModifiedById, CreatedDate from MiniFeed__c where CreatedDate <: mf.CreatedDate order by CreatedDate desc limit 2];
				// Check if this minifeed is product of the edition of a Task.
				if (mf.Type__c == 'TaskAssigned') {
					assignAction = 'assigned';
					assignToId = mf.Message__c.replaceFirst('.*to <a href="/apex/PeopleProfileDisplay\\?id=', '');
					assignToId = assignToId.replaceFirst('">.*','');
					taskId = mf.Message__c.replaceFirst('.*<span style="display:none;">', '');
					taskId = taskId.replaceFirst('</span>','');
					
					if (pastMiniFeedsList.size() > 1) {
						if ((pastMiniFeedsList[0].Type__c == 'TaskEdited' ||
							pastMiniFeedsList[0].Type__c == 'TaskCompleted' ||
							pastMiniFeedsList[0].Type__c == 'MilestoneEdited' ||
							pastMiniFeedsList[0].Type__c == 'MilestoneCompleted')&&
							pastMiniFeedsList[0].User__c == mf.User__c &&
							pastMiniFeedsList[0].Team__c == mf.Team__c &&
							pastMiniFeedsList[0].OwnerId == mf.OwnerId &&
							pastMiniFeedsList[0].CreatedById == mf.CreatedById &&
							pastMiniFeedsList[0].LastModifiedById == mf.LastModifiedById) 
							{
							
							// Change the Boolean
							isTaskEdit = true;	
						}		
					}
				}else {
					assignAction = 'unassigned';
					String auxInfo = mf.Message__c.replaceFirst('.*<span style="display:none;">', '');
					auxInfo = auxInfo.replaceFirst('</span>','');
					
					taskId = auxInfo.replaceAll('.*////', '');
					assignToId = auxInfo.replaceAll('////.*', '');
					
					if (pastMiniFeedsList.size() > 1) {
						if ((pastMiniFeedsList[0].Type__c == 'TaskEdited' ||
							pastMiniFeedsList[0].Type__c == 'TaskCompleted' ||
							pastMiniFeedsList[0].Type__c == 'MilestoneEdited' ||
							pastMiniFeedsList[0].Type__c == 'MilestoneCompleted')&&
							pastMiniFeedsList[0].User__c == mf.User__c &&
							pastMiniFeedsList[0].Team__c == mf.Team__c &&
							pastMiniFeedsList[0].OwnerId == mf.OwnerId &&
							pastMiniFeedsList[0].CreatedById == mf.CreatedById &&
							pastMiniFeedsList[0].LastModifiedById == mf.LastModifiedById)
							{
							
							// Change the Boolean
							isTaskEdit = true;	
						}		
					}
				}
				if (!isTaskEdit) {
					isTaskEdit = false;
					List<ProjectTask__c> taskList = [select 
														p.Team__c, 
								                        p.Project__c,
								                        p.Priority__c, 
								                        p.Percent_Completed__c, 
								                        p.OwnerId, 
								                        p.Name, 
								                        p.Milestone__c, 
								                        p.Id,  
								                        p.createdBy.Name,
								                        p.EndDate__c, 
								                        p.StartDate__c,
								                        p.Duration__c, 
								                        p.Description__c from ProjectTask__c p where id =:taskId];
					String taskDetail = '';
					if (taskList.size() > 0) {
						ProjectTask__c task = taskList[0];
						taskName = task.Name;
						taskDetail = 'Name: ' + task.Name + '<br>';
						if (task.Priority__c != null) 
							taskDetail += 'Priority: ' + task.Priority__c + '<br>';
						
						if (task.Percent_Completed__c != null) 
							taskDetail += 'Percent Completed: ' + task.Percent_Completed__c + '<br>';
						
						taskDetail += 'Is Milestone: ' + task.Milestone__c + '<br>';
						taskDetail += 'Duration: ' + task.Duration__c + ' hours<br>';
						if (task.StartDate__c != null) 
							taskDetail += 'Start Date: ' + task.StartDate__c.format() + '<br>';
						
						if (task.EndDate__c != null) 
							taskDetail += 'End Date: ' + task.EndDate__c.format() + '<br>';
						
						taskDetail += 'Created By: ' + task.createdBy.Name + '<br>';
						if (task.Description__c != null) 
							taskDetail += 'Description: ' + task.Description__c + '<br>';
					}
					
					if (taskName != '' && taskDetail != '') {
						emailSub = taskName + ' has been ' + assignAction + ' to you';
						emailMsj = taskDetail;
						TeamMemberSubscription = [Select 
								t.WikiPageUpdated__c, 
								t.WikiNewPage__c, 
								t.WikiCreatedByMeUpdated__c, 
								t.User__c, 
								t.User__r.Id,
								t.User__r.Name,
								t.User__r.Email,
								t.Team__c,
								t.Team__r.Name,
								t.Team__r.ContactEmail__c,
								t.Team__r.Id, 
								t.TeamMemberStatusUpdated__c, 
								t.TeamMemberJoinLeave__c, 
								t.ProjectTaskDeleted__c, 
								t.ProjectTaskChanged__c, 
								t.ProjectTaskAssignedToMe__c, 
								t.ProjectTaskAssignToMeChanged__c,
								t.Id, 
								t.DiscussionReplyToMe__c, 
								t.DiscussionNewTopic__c, 
								t.DiscussionNewReply__c
							From TeamSubscription__c t
							where Team__c =: TeamId and User__c =:assignToId and ProjectTaskAssignedToMe__c = true];
					}
					mf.Message__c = mf.Message__c.replaceAll('<span style="display:none;">.*','');
					update mf;
				}
			}
			
			if (mf.Type__c == 'TaskEdited' || mf.Type__c == 'TaskCompleted' || mf.Type__c == 'MilestoneEdited' || mf.Type__c == 'MilestoneCompleted') {
				//Sub:{Task Name} has changed
				//Body:{show which fields have changed and what the before and after values are} 
				if (compareDetail != '') {
					String changesInfo = compareDetail;
					String taskId = changesInfo.replaceFirst('////.*','');
					String taskName = '';
					
					List<Id> usersAssigned = new List<Id>();
					for (ProjectAssignee__c iterAssignee : [select User__c , ProjectTask__r.Name from ProjectAssignee__c where ProjectTask__c =: taskId]) {
						usersAssigned.add(iterAssignee.User__c);
						taskName = iterAssignee.ProjectTask__r.Name;	
					}
					String taskChangesDetail = changesInfo.replaceFirst('.*////' ,'');
					
					emailSub = taskName + ' has changed';
					emailMsj = taskChangesDetail;
					
					if (!isTest) {
						TeamMemberSubscription = [Select 
								t.WikiPageUpdated__c, 
								t.WikiNewPage__c, 
								t.WikiCreatedByMeUpdated__c, 
								t.User__c, 
								t.User__r.Id,
								t.User__r.Name,
								t.User__r.Email,
								t.Team__c,
								t.Team__r.Name,
								t.Team__r.ContactEmail__c,
								t.Team__r.Id, 
								t.TeamMemberStatusUpdated__c, 
								t.TeamMemberJoinLeave__c, 
								t.ProjectTaskDeleted__c, 
								t.ProjectTaskChanged__c, 
								t.ProjectTaskAssignedToMe__c, 
								t.ProjectTaskAssignToMeChanged__c,
								t.Id, 
								t.DiscussionReplyToMe__c, 
								t.DiscussionNewTopic__c, 
								t.DiscussionNewReply__c
							From TeamSubscription__c t
							where Team__c =: TeamId and ((ProjectTaskChanged__c = true and User__c not in:usersAssigned) or (ProjectTaskAssignToMeChanged__c = true and User__c in:usersAssigned))];
					}
				}
			}
			if (mf.Type__c == 'TaskDelete' || mf.Type__c == 'MilestoneDelete') {
				//Sub:{Task name} has been removed
				//Body: {Task Name} has been removed 
				String taskName = mf.Message__c.replaceFirst(' in <a href="/apex/TeamsRedirect\\?id=.*','');
				taskName = taskName.replaceFirst('deleted [^ ]* ','');
				
				emailSub = taskName + ' has been removed';
				emailMsj = emailSub;
				
				if (!isTest) {
					TeamMemberSubscription = [Select 
							t.WikiPageUpdated__c, 
							t.WikiNewPage__c, 
							t.WikiCreatedByMeUpdated__c, 
							t.User__c, 
							t.User__r.Id,
							t.User__r.Name,
							t.User__r.Email,
							t.Team__c,
							t.Team__r.Name,
							t.Team__r.ContactEmail__c,
							t.Team__r.Id, 
							t.TeamMemberStatusUpdated__c, 
							t.TeamMemberJoinLeave__c, 
							t.ProjectTaskDeleted__c, 
							t.ProjectTaskChanged__c, 
							t.ProjectTaskAssignedToMe__c, 
							t.ProjectTaskAssignToMeChanged__c,
							t.Id, 
							t.DiscussionReplyToMe__c, 
							t.DiscussionNewTopic__c, 
							t.DiscussionNewReply__c
						From TeamSubscription__c t
						where Team__c =: TeamId and ProjectTaskDeleted__c = true];
				}
			}
			//////////////////////////////////////
			//////		 WIKI PAGE		//////////
			if (mf.Type__c == 'WikiEditPage') {
				//Sub:Wiki Page {Name} with in Teamspace {team name} has been edited
				//Body:Wiki page {Name} has been edited by {User Name} . 
				//
				//Click here to see the page {link} 
				String wikiName = '';
				String wikiId = '';
				String editedByName = mf.User__r.Name;
				String editedById = mf.User__c;
				
				wikiId = mf.Message__c.replaceFirst('.*<a href="/apex/WikiPage\\?idWP=', '');
				wikiId = wikiId.replaceFirst('">.*', '');
				
				List<WikiPage__c> wikiPageList = [select id, PageCreatedBy__c from WikiPage__c where id=:wikiId];
				String createdById = wikiPageList[0].PageCreatedBy__c;
				
				wikiName = mf.Message__c.replaceFirst('.*<a href="/apex/WikiPage\\?idWP=[^>]*">', '');
				wikiName = wikiName.replaceFirst('</a>.*', '');
				
				emailSub = 'Wiki page ' + wikiName + ' with in Teamspace ' + mf.Team__r.Name + ' has been edited';
				emailMsj = 'Wiki page ' + wikiName + ' has been edited by <a href="https://' + newPath + '/apex/PeopleProfileDisplay?id=' + editedById + '">' +  editedByName + '</a><br><a href="https://' + newPath + '/apex/WikiPage?idWP=' + wikiId + '">Click here to see the page</a>.';
				
				if (!isTest) {
					TeamMemberSubscription = [Select 
							t.WikiPageUpdated__c, 
							t.WikiNewPage__c, 
							t.WikiCreatedByMeUpdated__c, 
							t.User__c, 
							t.User__r.Id,
							t.User__r.Name,
							t.User__r.Email,
							t.Team__c,
							t.Team__r.Name,
							t.Team__r.ContactEmail__c,
							t.Team__r.Id, 
							t.TeamMemberStatusUpdated__c, 
							t.TeamMemberJoinLeave__c, 
							t.ProjectTaskDeleted__c, 
							t.ProjectTaskChanged__c, 
							t.ProjectTaskAssignedToMe__c, 
							t.ProjectTaskAssignToMeChanged__c,
							t.Id, 
							t.DiscussionReplyToMe__c, 
							t.DiscussionNewTopic__c, 
							t.DiscussionNewReply__c
						From TeamSubscription__c t
						where Team__c =: TeamId and ((WikiPageUpdated__c = true and User__c !=:createdById) or (WikiCreatedByMeUpdated__c = true and User__c =:createdById))];
				}
			}
			if (mf.Type__c == 'WikiNewPage') {
				//Sub: Wiki page {wiki name} has been added to the Team {Team Name}'s wiki
				//Body: Wiki page {wiki name} has been added to the Team {Team Name}'s wiki
				//
				//Click here to see the page {link} 
				String wikiName = '';
				String wikiId = ''; 
				
				wikiId = mf.Message__c.replaceFirst('.*<a href="/apex/WikiPage\\?idWP=', '');
				wikiId = wikiId.replaceFirst('">.*', '');
				
				wikiName = mf.Message__c.replaceFirst('.*<a href="/apex/WikiPage\\?idWP=[^>]*">', '');
				wikiName = wikiName.replaceFirst('</a>.*', '');
				
				emailSub = 'Wiki page ' + wikiName + ' has been added to the Team ' + mf.Team__r.Name + '\'s wiki';
				emailMsj = 'Wiki page ' + wikiName + ' has been added to the Team <a href="https://' + newPath + '/apex/TeamsRedirect?id=' + mf.Team__r.Id + '">' +  mf.Team__r.Name + '\'s</a> wiki<br><a href="https://' + newPath + '/apex/WikiPage?idWP=' + wikiId + '">Click here to see the page</a>.';
				
				if (!isTest) {
					TeamMemberSubscription = [Select 
							t.WikiPageUpdated__c, 
							t.WikiNewPage__c, 
							t.WikiCreatedByMeUpdated__c, 
							t.User__c, 
							t.User__r.Id,
							t.User__r.Name,
							t.User__r.Email,
							t.Team__c,
							t.Team__r.Name,
							t.Team__r.ContactEmail__c,
							t.Team__r.Id, 
							t.TeamMemberStatusUpdated__c, 
							t.TeamMemberJoinLeave__c, 
							t.ProjectTaskDeleted__c, 
							t.ProjectTaskChanged__c, 
							t.ProjectTaskAssignedToMe__c, 
							t.ProjectTaskAssignToMeChanged__c,
							t.Id, 
							t.DiscussionReplyToMe__c, 
							t.DiscussionNewTopic__c, 
							t.DiscussionNewReply__c
						From TeamSubscription__c t
						where Team__c =: TeamId and WikiNewPage__c = true];
				}
			}
			//Array address
			String[] address = new String[]{}; 
			Integer it = 0;
			if(TeamMemberSubscription.size() > 10){
				for(Integer i =0; i < TeamMemberSubscription.size(); i++ ){	
					if(it < 10 || i == TeamMemberSubscription.size() ){
						address.add(TeamMemberSubscription[i].User__r.Email);
						it ++;
					}else{
						SendMail(address, TeamMemberSubscription[0].Team__r, emailMsj, emailSub);
						it = 0;
					}
				}
			}else if(TeamMemberSubscription.size() > 0 && TeamMemberSubscription != null){	
				for(TeamSubscription__c ts : TeamMemberSubscription){
					address.add(ts.User__r.Email);
				}
				SendMail(address, TeamMemberSubscription[0].Team__r, emailMsj, emailSub);
			}
		}else if (mf != null){
			//////////////////////////////////////
			//////		TEAM MEMBER		//////////
			if (mf.Type__c == 'PeopleChangeStatus') {
				//Sub: {name} is {status}
				//Body: Your team mate {name} has just updated thier status to {status} 
				
				List<String> TeamIdList = new List<String>();
				for (TeamMember__c iterMember : [select Team__c from TeamMember__c where User__c =: mf.User__c]) {
					TeamIdList.add(iterMember.Team__c);
				}
				
				String memberName = mf.User__r.Name;
				String newStatus = mf.Message__c;
				
				emailMsj = 'Your team mate ' + memberName + ' has just updated their status to ' + newStatus;
				emailSub = memberName + ' ' + newStatus;
				
				TeamMemberSubscription = [Select 
						t.WikiPageUpdated__c, 
						t.WikiNewPage__c, 
						t.WikiCreatedByMeUpdated__c, 
						t.User__c, 
						t.User__r.Id,
						t.User__r.Name,
						t.User__r.Email,
						t.Team__c,
						t.Team__r.Name,
						t.Team__r.ContactEmail__c,
						t.Team__r.Id, 
						t.TeamMemberStatusUpdated__c, 
						t.TeamMemberJoinLeave__c, 
						t.ProjectTaskDeleted__c, 
						t.ProjectTaskChanged__c, 
						t.ProjectTaskAssignedToMe__c, 
						t.ProjectTaskAssignToMeChanged__c,
						t.Id, 
						t.DiscussionReplyToMe__c, 
						t.DiscussionNewTopic__c, 
						t.DiscussionNewReply__c
					From TeamSubscription__c t
					where Team__c in: TeamIdList and User__c !=: mf.User__c and TeamMemberStatusUpdated__c = true];
			}	
			
			String[] address = new String[]{}; 
			Integer it = 0;
			if(TeamMemberSubscription.size() > 10){
				for(Integer i =0; i < TeamMemberSubscription.size(); i++ ){	
					if(it < 10 || i == TeamMemberSubscription.size() ){
						address.add(TeamMemberSubscription[i].User__r.Email);
						it ++;
					}else{
						SendMail(address, TeamMemberSubscription[0].Team__r, emailMsj, emailSub);
						it = 0;
					}
				}
			}else if(TeamMemberSubscription.size() > 0 && TeamMemberSubscription != null){	
				for(TeamSubscription__c ts : TeamMemberSubscription){
					address.add(ts.User__r.Email);
				}
				SendMail(address, TeamMemberSubscription[0].Team__r, emailMsj, emailSub);
			}	
		}
	}
	
	/**
	 * SEND MAIL
	 * @toAddresses  - Array of E-Mail
	 * @team - Team__c Object
	 * @Message - Message String
	*/
	Boolean alreadySent = false;
	public void SendMail(String[] toAddresses , Team__c team,  String Message, String subject) {
 		// Assign thsetReplyToe addresses for the To and CC lists to the mail object.
		mail.setToAddresses(toAddresses);
		// Specify the address used when the recipients reply to the email.
		if(team.ContactEmail__c != null){
			mail.setReplyTo(team.ContactEmail__c);
		}else{
			mail.setReplyTo('forwardtosfdc@gmail.com');
		}
		// Specify the name used as the display name.
		mail.setSenderDisplayName('Team Subscribe');  
		//Specify the subject line for your email address.
		mail.setSubject(subject);

		mail.setSenderDisplayName(team.Name);
		// Set to True if you want to BCC yourself on the email.
		mail.setBccSender(false);
		// Optionally append the salesforce.com email signature to the email.
		// The email address of the user executing the Apex Code will be used.
		mail.setUseSignature(true); 
		//Set Content Mail
		mail.setHtmlBody(Message);
		// Send the email you have created.
        if(!alreadySent)
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    	alreadySent = true;
    }
}
trigger TeamAfterUpdate on Team__c bulk (after update) {
	if (!TeamUtil.currentlyExeTrigger) {
		try {
			
			List<String> groupsNames = new List<String>();
			List<String> idsTeam = new List<String>();
			for (Team__c iterTeam : Trigger.new) {
				groupsNames.add('teamSharing' + iterTeam.Id);
				idsTeam.add(iterTeam.Id);
			}
			List<Group> groupList = [select id, name from Group where name in:groupsNames];
			List<GroupMember> groupMemberList = [select UserOrGroupId, GroupId, id from GroupMember where GroupId in:groupList];
			List<Group> go = [Select g.Type, g.Name from Group g where Type = 'Organization'];
			List<TeamMember__c> teamMemberList = [select team__c, id, User__c from TeamMember__c where team__c in:idsTeam];
			
			for (Integer it = 0; it < Trigger.new.size(); it++) {
				
				Team__c oldTeam = Trigger.old[it];
				Team__c newTeam = Trigger.new[it];
				
				//If old team was open or close
				if(oldTeam.PublicProfile__c != null || oldTeam.NewMemberProfile__c != null){
					if(newTeam.PublicProfile__c == null && newTeam.NewMemberProfile__c == null){
						String groupName = 'teamSharing' + newTeam.Id;
						Group teamGroup;
						Boolean findGroup = false;
						Integer countGroup = 0;
						while (!findGroup && countGroup < groupList.size()) {
							if (groupList[countGroup].Name == groupName) {
								findGroup = true;	
								teamGroup = groupList[countGroup];
							}
							else {
								countGroup++;
							}	
						}
						
						//Delete Everyone Member
						Boolean findGM = false;
						Integer countGM = 0;
						GroupMember gm;
						while (!findGM && countGM < groupMemberList.size()) {
							if (groupMemberList[countGM].UserOrGroupId == go[0].id && groupMemberList[countGM].GroupId == teamGroup.Id) {
								findGM = true;
								gm = groupMemberList[countGM]; 
							}
							else {
								countGM++;	
							}	
						}
						delete gm;
						
						//Create GroupMember for all Team Members
						List<GroupMember> groupMembers = new List<GroupMember>();
						for (TeamMember__c iterMember : teamMemberList) {
							if (iterMember.team__c == newTeam.Id) {	
								GroupMember newGroupMember = new GroupMember();
								newGroupMember.GroupId = teamGroup.Id;
								newGroupMember.UserOrGroupId = iterMember.User__c;
								groupMembers.add(newGroupMember); 
							}
						}
						insert groupMembers;
					}
				}else{
					if(newTeam.PublicProfile__c != null || newTeam.NewMemberProfile__c != null){
						String groupName = 'teamSharing' + newTeam.Id;
						Group teamGroup;
						Boolean findGroup = false;
						Integer countGroup = 0;
						while (!findGroup && countGroup < groupList.size()) {
							if (groupList[countGroup].Name == groupName) {
								findGroup = true;	
								teamGroup = groupList[countGroup];
							}
							else {
								countGroup++;
							}	
						}				
		
						//Delete all GroupMembers
						Boolean findGM = false;
						Integer countGM = 0;
						List<GroupMember> groupMembers = new List<GroupMember>();
						for (GroupMember groupMemberIter : groupMemberList) {
							if (groupMemberIter.GroupId == teamGroup.Id) {
								groupMembers.add(groupMemberIter);
							}	
						}
						delete groupMembers;
						
						//Create Everyone Member
						GroupMember newGroupMember = new GroupMember();
						newGroupMember.GroupId = teamGroup.Id;
						newGroupMember.UserOrGroupId = go[0].Id;
						insert newGroupMember;
					
					}
				}
			}
		} finally {
        	TeamUtil.currentlyExeTrigger = false;
		}
	}			
}
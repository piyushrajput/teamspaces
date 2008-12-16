public class TeamUtil {
	public static Boolean currentlyExeTrigger = false;
	
	/**
	* Tests if current user belongs to the Admin Team
	*/
	public static void isAdminMemberUser(){
		
		Group gr = [select id from Group where name = 'Team Admin' limit 1];
		List<GroupMember> grMembers = new List<GroupMember>();
		
		grMembers = [select id	from GroupMember 
								where UserOrGroupId =: UserInfo.getUserId() AND GroupId =: gr.id ];
		
		if (grMembers.size() == 0){
			throw new CustomException('Insufficient privileges');
		}
	}
	
	public static Group orgGroup;
	
	public static Group getOrganizationGroup() {
		
		if(orgGroup == null) {
				
				List<Group> go = [Select g.Type, g.Name from Group g where Type = 'Organization'];
				
				if(go.size() > 0)
					orgGroup = go[0];
				else
					throw new CustomException('TeamUtil: There is no organization group');
		}
		
		return orgGroup;
	}
		
	public class CustomException extends Exception {}
}
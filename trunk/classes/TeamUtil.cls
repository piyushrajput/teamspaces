public class TeamUtil { 
	public static Boolean currentlyExeTrigger = false;
	public static Boolean isTest = false;
	public static Boolean alreadyGenEnv = false;
	/**
	* Tests if current user belongs to the Admin Team
	*/
	public static void isAdminMemberUser(){
		List<User> teamAdmin = [Select id, Profile.PermissionsModifyAllData, ProfileId, Name From User where id =:UserInfo.getUserId() limit 1];
		
		if (!teamAdmin[0].Profile.PermissionsModifyAllData)
			throw new CustomException('Insufficient privileges');
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
	
	/**
	* Return the Namespace Prefix
	*/
	public static String getNamespace () {
		String namespace = '';
        String fullName = Schema.SObjectType.WikiPage__c.getName();
        String localName = Schema.SObjectType.WikiPage__c.getLocalName();
        if (fullName != localName) {
           namespace = fullName.replaceAll(localName,'');
           namespace = namespace .replaceAll('__','');
        }
        return namespace;	
	}
}
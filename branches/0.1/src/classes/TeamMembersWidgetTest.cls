public class TeamMembersWidgetTest {
	public static testMethod void testTeam() {
		try{
			TeamMembersWidgetController team = new TeamMembersWidgetController();
			team.setTypeList('adminList');
			String result = team.getComponentHeader ();
			Boolean render = team.getRenderLinkAction ();
			TeamMember__c m = new TeamMember__c();
			TeamMembersWidgetController.TeamMember teamMember= new TeamMembersWidgetController.TeamMember(m, null);
	    	
		}catch(Exception e){
			throw e;
		}
	}
}
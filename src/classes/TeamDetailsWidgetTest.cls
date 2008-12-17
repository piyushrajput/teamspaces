public class TeamDetailsWidgetTest {
	public static testMethod void testTeam() {
		TeamDetailsWidgetController team = new TeamDetailsWidgetController();
		Team__c teamspace = team.getTeamspace();
		boolean  isTeamMember= team.getIsTeamMember();
		String member = team.getTeamMemberId();
		boolean  isTeamAdmin= team.getIsTeamAdmin();
	}
}
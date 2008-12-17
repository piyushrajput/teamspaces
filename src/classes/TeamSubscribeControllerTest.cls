@IsTest private class TeamSubscribeControllerTest {
	public static testMethod void test(){
		TeamSubscribeController suscribe = new TeamSubscribeController();
		suscribe.setTeam('');
		suscribe.getTeam();
	}
}
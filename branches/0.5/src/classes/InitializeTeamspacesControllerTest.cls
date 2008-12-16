@IsTest private class InitializeTeamspacesControllerTest {
	public static testMethod void test() {
		GenerateEnvironmentTest.gen();
		
		Test.startTest();
		
		InitializeTeamspacesController iniTeams = new InitializeTeamspacesController();
		
		Widget__c newWidget = new Widget__c();
		newWidget.Name = 'Foo Widget';
		newWidget.Type__c = 'Widget';
		newWidget.WidgetUrl__c = 'Foo Url';
		insert newWidget; 
		
		iniTeams.initialize();
		iniTeams.createProfile('Team Administrator');
		iniTeams.createProfile('Read Only');
		iniTeams.createProfile('Individual Contributor');
		
		Test.stopTest();
	}
}
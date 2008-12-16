public class TeamsCreateNewTeamTest {
	
	public static testMethod void testTeam() {
	TeamsCreateNewTeamController team = new TeamsCreateNewTeamController();
    List<SelectOption> optionType = team.getTypes();
    System.assert(optionType.size()==0,' No tiene opciones el type');
	List<SelectOption>  optionProfile = team.getProfiles();
	System.assert(optionType.size()==0,' No tiene opciones el profile');
   	}
}
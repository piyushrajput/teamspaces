public class TeamMembersListTest {

    public static String idTeam = System.currentPageReference().getParameters().get('id');
	public static Boolean sortByDesc = false;
	
	public static String sortBy = 'User__r.Name';
	
	public static testMethod void testTeam() {
	    TeamMembersListController team = new TeamMembersListController();
		team.getRemoveMessage ();
		team.assignRemoveId ();
		PageReference page = team.removeMember ();
		System.assert(page==null,'No se pudo eliminar');
		team.assignEditId ();	
		PageReference pageEdit=team.editMemberAction ();
		System.assert(pageEdit == null,'No se pudo editar');
		List<SelectOption> option= team.getProfilesOptions ();	
		System.assert(option.size()==0,'El member no tiene opciones con ese profile');
		TeamMembersListController.Member member= new TeamMembersListController.Member();
		team.genMembers ();
		TeamMembersListController.Letters letter= new TeamMembersListController.Letters();
		List<TeamMembersListController.Letters> letterList= team.getLetterFilter ();
	    String sortBye=  team.getSortBy ();
		System.assert(sortBye=='name','OK');
		team.sortList ();
		
	}
}
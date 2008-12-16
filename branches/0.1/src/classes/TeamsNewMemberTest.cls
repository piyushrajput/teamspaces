public class TeamsNewMemberTest {
   
   
    
    public static testMethod void testTeam() {
    TeamsNewMemberController team = new TeamsNewMemberController();
    List<SelectOption> option=team.getProfilesOptions ();
	TeamsNewMemberController.Member member = new TeamsNewMemberController.Member();
	
	try
	{
		team.saveMembersNew ();
	} catch (DmlException e) {
			System.assert(false,'No se pudo salvar al member')	;
		}
		
	try
	{
	PageReference page= team.saveMembers ();
	} catch (DmlException e) {
			System.assert(false,'No se pudo salvar al member')	;
	}	
     team.SendMail(new User(),'Hola mundo');	
	
       }
  
}
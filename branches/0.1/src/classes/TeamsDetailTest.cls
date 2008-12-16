public class TeamsDetailTest {
   public static String USERID =  UserInfo.getUserId();
   
   public static testMethod void testTeam() {
   	TeamsDetailController team = new TeamsDetailController();
   	 Team__c teamC=team.getTeamspace();
   	try{
   	team.joinTeam();
    } catch (DmlException e) {
			System.assert(false,'No se pudo insertar')	;
		}
	try{	
    team.leaveTeam();
  	} catch (DmlException e) {
			System.assert(false,'No se pudo eliminar')	;
		} 
		
  
  }
  	
}
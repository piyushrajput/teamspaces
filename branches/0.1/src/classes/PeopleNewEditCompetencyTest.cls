public class PeopleNewEditCompetencyTest {
	public static testMethod void testPeople() {
	ApexPages.StandardController controller ;
	PeopleNewEditCompetencyController people= new PeopleNewEditCompetencyController(controller);
	PeopleProfile__c peopleProfile = people.getMySidebarProfile();
	PeopleNewEditCompetencyController.Status status= new PeopleNewEditCompetencyController.Status();
	DateTime now = System.now();
	status.setModified(now);
	people.getCompetency();
	try{
		PageReference page= people.saveCompetency();
	} catch (DmlException e) {
			System.assert(false,'No se pudo insertar')	;
		}
	try{
		PageReference page2= people.deleteCompetency();
	} catch (DmlException e) {
			System.assert(false,'No se pudo eliminar')	;
		}
	}
}
public class PeopleEditEducationHistoryTest {
	public static testMethod void testPeople() {
	PeopleEditEducationHistoryController people = new PeopleEditEducationHistoryController();
	PeopleEditEducationHistoryController.PeopleSearch reference = new PeopleEditEducationHistoryController.PeopleSearch();
    PeopleProfile__c peopleProfile = people.getMySidebarProfile();
	PeopleEditEducationHistoryController.Status status= new PeopleEditEducationHistoryController.Status();
	DateTime now = System.now();
	status.setModified(now);
	try{
		boolean exito= people.getDbOperation();
	} catch (Exception e) {
	}
	try{
		PageReference page= people.save();
	} catch (DmlException e) {
			System.assert(false,'No se pudo actualizar el mensaje')	;
	}
	
	try{
		PageReference page2= people.remove();
	} catch (DmlException e) {
			System.assert(false,'No se pudo actualizar el mensaje')	;
	}
	
	try{
		PageReference page3= people.saveAndAddAnother();
	} catch (DmlException e) {
			System.assert(false,'No se pudo actualizar el mensaje')	;
		}
	PeopleEditEducationHistoryController.EducationItemObj education= new PeopleEditEducationHistoryController.EducationItemObj();
	
	}
}
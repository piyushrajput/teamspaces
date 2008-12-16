public class PeopleEditEmploymentHistoryTest {

  public static testMethod void testPeople() {
    PeopleEditEmploymentHistoryController people = new PeopleEditEmploymentHistoryController();
	PeopleEditEmploymentHistoryController.PeopleSearch search = new PeopleEditEmploymentHistoryController.PeopleSearch();
    PeopleProfile__c peopleProfile = people.getMySidebarProfile();
	PeopleEditEmploymentHistoryController.Status status= new PeopleEditEmploymentHistoryController.Status();
	DateTime now = System.now();
	status.setModified(now);
	try{
		boolean exito= people.getDbOperation();
	} catch (DmlException e) {
			System.assert(false,'No se pudo realizar la transaccion')	;
		}
	try{
		PageReference page= people.remove();
	} catch (DmlException e) {
			System.assert(false,'No se pudo actualizar el mensaje')	;
		}
	try{
		PageReference page2= people.saveAndAddAnother();
	} catch (DmlException e) {
			System.assert(false,'No se pudo actualizar el mensaje')	;
		}
	
	try{
		PageReference page3= people.save();
	} catch (DmlException e) {
			System.assert(false,'No se pudo actualizar el mensaje')	;
		}	
	PeopleEditEmploymentHistoryController.EmploymentItemObj education= new PeopleEditEmploymentHistoryController.EmploymentItemObj();

  }
}
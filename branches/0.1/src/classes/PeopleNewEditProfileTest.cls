public class PeopleNewEditProfileTest {
 public static testMethod void testPeople() {
	 	ApexPages.StandardController controller;
		PeopleNewEditProfileController people = new PeopleNewEditProfileController(controller);
	 	PeopleProfile__c peopleProfile = people.getMySidebarProfile();
		PeopleNewEditProfileController.Status status= new PeopleNewEditProfileController.Status();
		DateTime now = System.now();
		status.setModified(now);
		people.getPeopleProfile(); 
	}
    
}
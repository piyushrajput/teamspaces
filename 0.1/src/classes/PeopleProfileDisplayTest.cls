public class PeopleProfileDisplayTest {

	public static testMethod void testPeople() {
	PeopleProfileDisplayController people= new PeopleProfileDisplayController();
	PeopleProfileDisplayController.PeopleSearch search= new PeopleProfileDisplayController.PeopleSearch();
	PeopleProfileDisplayController.Profile profile = people.getProfile();
    PeopleProfileDisplayController.Profile profile2= new PeopleProfileDisplayController.Profile();     
	PeopleProfileDisplayController.Status status= new PeopleProfileDisplayController.Status();
	DateTime now = System.now();
	status.setModified(now);
	List<PeopleProfileDisplayController.educationHistories> listEducationHistories= people.getEducationHistories();
	PeopleProfileDisplayController.educationHistories educationHistories= new PeopleProfileDisplayController.educationHistories();
	List<PeopleProfileDisplayController.employmentHistory> listEmploymentHistories = people.getEmploymentHistories();
    PeopleProfileDisplayController.employmentHistory employmentHistory= new PeopleProfileDisplayController.employmentHistory();
    List<PeopleProfileDisplayController.PersonProfile> listDirectReports = people.getDirectReports();
    //PeopleProfileDisplayController.PersonProfile personProfile= new PeopleProfileDisplayController.PersonProfile();
	List<PeopleProfileDisplayController.miniFeed> listMiniFeeds = people.getMiniFeeds();
	PeopleProfileDisplayController.miniFeed miniFeed= new PeopleProfileDisplayController.miniFeed();
	List<PeopleProfileDisplayController.ExternalNetworks> listOtherNetworks = people.getOtherNetworks();
	PeopleProfileDisplayController.ExternalNetworks externalNetworks= new PeopleProfileDisplayController.ExternalNetworks();
    List<PeopleProfileDisplayController.TeamMember> listTeamspaces = people.getTeamspaces();
    PeopleProfileDisplayController.TeamMember teamMember= new PeopleProfileDisplayController.TeamMember();
 	}

}
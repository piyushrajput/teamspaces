public without sharing class TeamsMembersRemoveController {
	
	public String idTeam = System.currentPageReference().getParameters().get('id');
	public String removeMemberId = System.currentPageReference().getParameters().get('delId');
	
	public void assignRemoveId () {
		removeMemberId = System.currentPageReference().getParameters().get('delId');
	}
	
	public void removeMember () {	}
}
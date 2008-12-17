@IsTest private class TeamsSidebarProfileControllerTest {
	public static testMethod void test(){
		try{
			GenerateEnvironmentTest.gen();
            Test.startTest(); 
			
			TeamsSidebarProfileController people = new TeamsSidebarProfileController();
			people.getPeopleProfile();
			people.getCurrentTime();
			people.EditStatus();
			people.getMyPicture();
			people.getMySidebarProfile();
			people.getShowStatus();
			people.getStatus();
			people.getCountSubscribedToMe();
			people.getCountImSubscribedTo();
			
			TeamsSidebarProfileController.Status status = new TeamsSidebarProfileController.Status();
			
			status.getMessage();
            status.setModified(System.now());
            
            Datetime myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day(), System.now().hour(), System.now().minute() - 1, System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day(), System.now().hour(), System.now().minute() - 2, System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day(), System.now().hour() - 2, System.now().minute(), System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day() - 2, System.now().hour(), System.now().minute(), System.now().second());
            status.setModified(myDate);
            
            myDate = datetime.newInstance(System.now().year(), System.now().month(), System.now().day() - 8, System.now().hour(), System.now().minute(), System.now().second());
            status.setModified(myDate);
            
            status.getModified();  
			
			people.getShowSubscribedPeople();
			people.getCountSubscribedToMe();
			people.getCountImSubscribedTo();
			
			Test.stopTest();
		}catch(Exception e){
			throw e;
		}
	}
}
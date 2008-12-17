@IsTest private class PeopleEditEmploymentHistoryTest {
    public static testMethod void testPeople() {
        try{
			GenerateEnvironmentPeopleTest.gen();
			Test.startTest();

            PeopleEditEmploymentHistoryController people = new PeopleEditEmploymentHistoryController();
            
            PeopleEditEmploymentHistoryController.PeopleSearch search = new PeopleEditEmploymentHistoryController.PeopleSearch();
            search.getKeyword();
            search.setKeyword('word'); 
            
            PeopleProfile__c peopleProfile = people.getMySidebarProfile();
            
            PeopleEditEmploymentHistoryController.EmploymentItemObj employ = new PeopleEditEmploymentHistoryController.EmploymentItemObj();
            employ.setEmployerLocationCity('');
            employ.getEmployerLocationState();
            employ.getEmployerLocationCity();
            
            Date myDate = date.newinstance(1960, 2, 17);
            employ.setworkedTo(myDate);
            employ.setworkedFrom(myDate);
            
            employ.setEmployerLocationState('');
            employ.getYearFrom();
            employ.setYearFrom(1);
            employ.getYearTo();
            employ.setYearTo(1);
            employ.getWorkedFromMonth();
            employ.setWorkedFromMonth('');
            employ.getWorkedToMonth();
            employ.setWorkedToMonth('');
            employ.getworkedTo();
            employ.getworkedFrom();
            employ.setDescription('');
            employ.getDescription();
            employ.setEmployer('');
            employ.getEmployer();
            employ.setTitle('');
            employ.getTitle();
            employ.setCurrentJob(true);
            employ.getCurrentJob();
                    
            people.getStatus();
            people.getMonthNumber('');
            people.getCurrentTime();
            people.getStates();
            people.getIsNewRecord();
            people.setEmploymentItem(new EmploymentHistory__c());
            people.getEm();
            people.getEmployer();
            
            for(Integer it = 1; it <= 12; it++){
                people.getMonthName(it);
            }
            
            people.getMonthNumber('Jan');
            people.getMonthNumber('Feb');
            people.getMonthNumber('Mar');
            people.getMonthNumber('Apr');
            people.getMonthNumber('May');
            people.getMonthNumber('Jun');
            people.getMonthNumber('Jul');
            people.getMonthNumber('Aug');
            people.getMonthNumber('Sep');
            people.getMonthNumber('Oct');
            people.getMonthNumber('Nov');
            people.getMonthNumber('Dec');
            
            //Status Inner class
            PeopleEditEmploymentHistoryController.Status status = new PeopleEditEmploymentHistoryController.Status();
            status.setMessage('Hello world');
            status.getMessage();
            status.getModified();
            
            people.getPeopleSearchObj();
            people.findPeople();
            people.getMyPicture();
            people.getShowStatus(); 
            people.getError();
            people.getMonths();   
            
            DateTime mod = DateTime.newInstance(2008,11,10,5,50,30);
	        DateTime mod2 = DateTime.newInstance(2008,11,12,1,50,30);
	        DateTime mod3 = DateTime.newInstance(2008,11,12,4,0,30);
	        DateTime mod4 = DateTime.newInstance(2008,11,12,6,13,30);
	        DateTime now = System.now();
	        status.setModified(mod);
	        status.setModified(mod2);
	        status.setModified(mod3);
	        status.setModified(mod4);
	        status.setModified(now);
	        status.getModified();
            List<EmploymentHistory__c> eh = [select Id from EmploymentHistory__c limit 1];
            
            if (eh.size() > 0) { 
	            people.setParam(eh[0].Id); 
	            status.setModified(mod);
		        status.setModified(mod2);
		        status.setModified(mod3);
	            status.setModified(now);
	            people.getEmploymentHistory(eh[0].Id);
	            boolean exito= people.getDbOperation();
	            PageReference page= people.remove();
	            people.setEmploymentItem(new EmploymentHistory__c());
	           	people.isNewRecord = true;
	            PageReference page2= people.saveAndAddAnother();
	            
	            people.setEmploymentItem(new EmploymentHistory__c());
            	PageReference page3= people.save();
            }
            PageReference page4 = people.forwardTo('/apex/TeamsOverview');
            people.cancel();

			Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}
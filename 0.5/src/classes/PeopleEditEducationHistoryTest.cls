@IsTest private class PeopleEditEducationHistoryTest {
    public static testMethod void testPeople() {
        try{
			GenerateEnvironmentPeopleTest.gen();
			Test.startTest();
            PeopleEditEducationHistoryController people = new PeopleEditEducationHistoryController();
            EducationHistory__c edh = [select Id from EducationHistory__c limit 1];
            people.setParam(edh.Id);
            people.getPeopleSearchObj();
            people.getShowStatus();
            people.getError();
            
            PeopleEditEducationHistoryController.EducationItemObj education= new PeopleEditEducationHistoryController.EducationItemObj();
            people.setEd(education);
            
            people.getEducationHistory(edh.Id);
            PeopleEditEducationHistoryController.PeopleSearch reference = new PeopleEditEducationHistoryController.PeopleSearch();
            reference.setKeyword('keyword');
            PeopleProfile__c peopleProfile = people.getMySidebarProfile();
            
            PeopleEditEducationHistoryController.Status status= new PeopleEditEducationHistoryController.Status();
	        DateTime now = System.now();
	        DateTime mod0 = DateTime.newInstance(now.year(),now.month(),now.day(),now.hour(),now.minute(),(now.second()-5));
	        DateTime mod1 = DateTime.newInstance(now.year(),now.month(),now.day(),now.hour(),(now.minute()-1),0);
	        DateTime mod2 = DateTime.newInstance(now.year(),now.month(),now.day(),now.hour(),(now.minute()-5),0);
	        DateTime mod3 = DateTime.newInstance(now.year(),now.month(),now.day(),(now.hour()-4),0,0);
	        DateTime mod4 = DateTime.newInstance(now.year(),now.month(),(now.day()-3),0,0,0);
	        DateTime mod5 = DateTime.newInstance(now.year(),now.month(),(now.day()-8),0,0,0);
	        System.debug('#####################################');
	        System.debug('now[' + now + '] mod0[' + mod0 + '] mod1[' + mod1 + '] mod2[' + mod2 + '] mod3[' + mod3 + '] mod4[' + mod4 + '] mod5[' + mod5 + ']');
	        System.debug('#####################################');
	        status.setModified(now);
	        status.setModified(mod0);
	        status.setModified(mod1);
	        status.setModified(mod2);
	        status.setModified(mod3);
	        status.setModified(mod4);
	        status.setModified(mod5);
	        status.getModified();
            status.setMessage ('Some Message');
            String s8 = status.getMessage();
            people.getStatus();
            
            boolean exito= people.getDbOperation();
            String currentDate = people.getCurrentTime();
            String picture = people.getMyPicture();
            
            people.setEducationItem(new EducationHistory__c());
            PageReference page = people.save();
            
            people.setEducationItem(new EducationHistory__c());         
            PageReference page3 = people.saveAndAddAnother();
            PageReference page2 = people.remove();

            people.setIsNewRecord(false);
            
            people.setEducationItem(new EducationHistory__c());
            PageReference page7 = people.save();
            
            people.setEducationItem(new EducationHistory__c());         
            PageReference page8 = people.saveAndAddAnother();           
            
            PageReference page4 = people.cancel();
            PageReference page5 = people.forwardTo('/apex/teamsOverview');
            PageReference page6 = people.findPeople();
                        
            education.setSchoolLocationState('School State');
            String s1 = education.getSchoolLocationState();
            
            education.setSchoolLocationCity('Some City');
            String s2 = education.getSchoolLocationCity();
            
            education.setSchool('School Name');
            String s3 = education.getSchool();
            
            education.setFieldsOfStudy('Some fields');
            String s4 = education.getFieldsOfStudy();
            
            education.setDegree('Degree');
            String s5 = education.getDegree();
            
            education.setAdditionalNotes('Some notes add');
            String s6 = education.getAdditionalNotes();
            
            education.setActivities('Some Activities');
            String s7 = education.getActivities();
            
            education.setAttendedTo(12.5);
            education.setAttendedFrom(20.3);
            Double d = education.getAttendedTo();
            PeopleEditEducationHistoryController.EducationItemObj eD = people.getEd();
            people.setIsNewRecord(false);
            eD.getAttendedFrom();
            boolean isNew = people.getIsNewRecord();
            School__c sC = people.getSchool();
            
            List<SelectOption> so = people.getStates();
 			
			Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }
}
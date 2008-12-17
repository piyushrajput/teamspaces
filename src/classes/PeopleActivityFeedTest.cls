@IsTest private class PeopleActivityFeedTest {

    public static testMethod void testPeople() {
		
		GenerateEnvironmentTest.runLite = true; 
		GenerateEnvironmentTest.gen();
		GenerateEnvironmentPeopleTest.gen();
		Test.startTest();

        PeopleActivityFeedController people = new PeopleActivityFeedController();
        people.getMyPicture();
        PeopleProfile__c peopleProfile = people.getMySidebarProfile();
        PeopleActivityFeedController.Status status= new PeopleActivityFeedController.Status();
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
        //String modified = status.getModified();
        status.setMessage('Message');
        //String message = status.getMessage();
        status = people.getStatus();
        String message = status.getMessage();
        String modified = status.getModified();
        System.currentPageReference().getParameters().put('id',null);
        PeopleActivityFeedController.Profile profile = new PeopleActivityFeedController.Profile();  
        System.currentPageReference().getParameters().put('mfTypeObj','mfTypeObj');
	    System.currentPageReference().getParameters().put('mfTypeStr','mfTypeStr');
        List<PeopleActivityFeedController.miniFeed> listMiniFeeds = people.getMiniFeeds();  
        System.currentPageReference().getParameters().put('mfTypeObj','');
	    System.currentPageReference().getParameters().put('mfTypeStr','');
        List<PeopleActivityFeedController.miniFeed> listMiniFeeds2 = people.getMiniFeeds();  
        PeopleActivityFeedController.miniFeed miniFeed = new PeopleActivityFeedController.miniFeed();
        String str = miniFeed.getTypeOfFeed();
        String str2 = miniFeed.getName();
        miniFeed.setName('Joe');
        miniFeed.setUser('Joe');
        String str3 = miniFeed.getUser();
        miniFeed.setMessage('Message');
        String str4 = miniFeed.getMessage();
        miniFeed.setFeedDate(System.now());
        Datetime d = miniFeed.getFeedDate();
        miniFeed.setFeedDateString('2008-01-01');
        String dStr = miniFeed.getFeedDateString();
        miniFeed.setFeedDateClass('Class');
        String dCls = miniFeed.getFeedDateClass();
        PeopleActivityFeedController.Profile p = people.getProfile();
        p.setId(p.getId());
        Id id = p.getId();
        p.setFirstName('Joe');
        String nStr = p.getFirstName();
        PeopleActivityFeedController.PeopleSearch ps = new PeopleActivityFeedController.PeopleSearch ();
        ps.setKeyword('Java');
        String keyStr = ps.getKeyword();
        PageReference pr = people.findPeople();
        String pic = people.getMyPicture();
        Boolean b = people.getShowStatus();
        people.setMiniFeedCount(5);
        Integer mfCount = people.getMiniFeedCount();
        

        people.getStatus();
        people.getPeopleSearchObj();

		Test.stopTest();
    }
}
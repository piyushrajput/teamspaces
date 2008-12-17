@IsTest private class DiscussionTopicTest {
    
    public static testMethod void testDiscussion() {
        try{
        	GenerateEnvironmentTest.gen();
    		Test.startTest();
			
            DiscussionTopicsController dis= new DiscussionTopicsController();
            
            DiscussionTopic__c dt = GenerateEnvironmentTest.newTopic;
            
            dis.getForumData();
            dis.getForum();
            
            dis.setTEAMID(GenerateEnvironmentTest.newTeam.Id);
            dis.refreshList();
            Boolean b = dis.getNoTopics();
            List<DiscussionTopicsController.TopicList> topics = dis.getTopicList();
			
			dis.getForumData();
			
            DiscussionTopicsController.updateviewCount upd = new DiscussionTopicsController.updateviewCount();
            String topicId = upd.getTopicId();
            upd.setTopicId(GenerateEnvironmentTest.newTopic.Id);
            upd.updateviewCountRedirect();
            PageReference pr = upd.getTopicPage();
            
            PageReference pr2 = dis.openTopic();
            
            DiscussionTopicsController.TopicList topicList = new DiscussionTopicsController.TopicList();
            
            topicList.setId('Some Id');
            topicList.setAuthorId('Some Id');
            topicList.setAuthorName('Some Name');
            topicList.setName('Some Name');
            topicList.setTeamName('Team Name');
            topicList.setTeamId('Some team');
            topicList.setNumberOfMessages(1);
            topicList.setNumberOfViews(1);

            DiscussionMessage__c dsMessage = GenerateEnvironmentTest.newMessage;
            topicList.setLastPostMessage(dsMessage.Id);
            topicList.setFirstMessageCreated(dsMessage);
            topicList.setAuthorPicture('Some Author');
            topicList.setEnableActions('Some Id', false);
            topicList.setEnableActions('Some Id', true);
            
            topicList.setAuthorId(UserInfo.getUserId());
            topicList.getIsAuthor();
            topicList.setAuthorId('Some Id');
            
            topicList.lastPostInfoString(null);
            Boolean b2 = topicList.getEnableActions();
            String pic = topicList.getAuthorPicture();
            
            topicList.getFirstMessageCreated();

            String id = topicList.getId();
            String author = topicList.getAuthorId();
            String fuulAuthor = topicList.getFullAuthorName();
            
            topicList.setAuthorName('Some Large Large Name');
            String authorName = topicList.getAuthorName();
            topicList.setAuthorName('Some Name');
            authorName = topicList.getAuthorName();
            
            String name = topicList.getName();
            String shortName = topicList.getShortName();
            String teamName = topicList.getTeamName();
            String teamId = topicList.getTeamId();
            Integer nMessage = topicList.getNumberOfMessages();
            Integer nView = topicList.getNumberOfViews();
            String lastPost = topicList.getLastPostMessage();
            Boolean isAuthor = topicList.getIsAuthor();
            
            dis.getPrevPageLinkShow();
            dis.nextPage();
            dis.getNextPageLinkShow();
            dis.getNextPageShow ();
            dis.getPrevPageShow();
            dis.getPrevPageShow();
            dis.getPrevPageLinkShow();
            dis.prevPage();

            dis.genCntPagination();

            Integer nAux = dis.getCurrentPagination();
            nAux = dis.getNumberOfItemsToShow();
            nAux = dis.getFirstRow();
            Boolean bAux = dis.getPrevPageLinkShow();
            bAux = dis.getPrevPageShow();
            bAux = dis.getNextPageLinkShow();
            bAux = dis.getNextPageShow();
            
            topicList.getFirstMessageId();
            
            topicList.setFirstMessageCreated(null);
            topicList.getFirstMessageCreated();
            topicList.getFirstMessageId();
            
            System.currentPageReference().getParameters().put('id',GenerateEnvironmentTest.newTopic.id);
            dis.updateReadCount();
            
            dis.setTEAMID(dt.Team__c);
            dis.saveTopic();
            DiscussionForum__c forum = dis.getForum();
            dis.fillTopicList();
            dis.getMostRead();
            dis.genPermissions();
            dis.getUserPermissions();
            
            String sortBy = null;
            
            dis.setSortBy('Name');
            dis.setSortByDesc(false);
            dis.sortList();
            
            TeamUtil.isTest = true;
            
            dis.setSortByDesc(true);
            dis.sortList();
            sortBy = dis.getSortBy();
            
            dis.setSortBy('PostedBy__r.Name');
            dis.setSortByDesc(false);
            dis.sortList();
            
           
            dis.setSortByDesc(true);
            dis.sortList();         
            sortBy = dis.getSortBy();
            
            dis.setSortBy('ViewCount__c');
            dis.sortList();
            sortBy = dis.getSortBy();
            
            dis.setSortBy('MessageCount__c');
            dis.setSortByDesc(false);
            dis.sortList();
            
            dis.setSortByDesc(true);
            dis.sortList();                                     
            sortBy = dis.getSortBy();
            
            dis.setSortBy('LastPostedMessage__c');
            dis.setSortByDesc(false);
            dis.sortList();
            
            dis.setSortByDesc(true);
            dis.sortList();  
            
            
            dis.setSortByDesc(false);
            dis.setSortBy('Name');
            System.currentPageReference().getParameters().put('sb','Name');
            dis.sortList();
            
            dis.setSortByDesc(false);
            dis.setSortBy('PostedBy__r.Name');
            System.currentPageReference().getParameters().put('sb','PostedBy__r.Name');
            dis.sortList();
           
            dis.setSortByDesc(false);
            dis.setSortBy('ViewCount__c');
            System.currentPageReference().getParameters().put('sb','ViewCount__c');
            dis.sortList();
            
            dis.setSortByDesc(false);
            dis.setSortBy('LastPostedMessage__c');
            System.currentPageReference().getParameters().put('sb','LastPostedMessage__c');
            dis.sortList();
            
            dis.setSortByDesc(false);
            dis.setSortBy('MessageCount__c');
            System.currentPageReference().getParameters().put('sb','MessageCount__c');
            dis.sortList();
            
            TeamUtil.isTest = false;
           
            sortBy = dis.getSortBy();
			dis.refreshPages();
			Integer cntPag = dis.getCntPagination();
			Boolean isTmAdMm = dis.getIsTeamAdminMember();
			Boolean srtByDesc = dis.getSortByDesc();
            
            topicList.setName(null);
            topicList.getShortName();
            
            dis.setTeamId('id0001');
            dis.saveTopic();
            dis.refreshList();
            
        	Test.stopTest();
        }catch(Exception e){
            throw e;
        }
    }   
}
public class BlogOverlayNewEditController {
		/**
        * The new announcement
        */
        Wrapper wrapper;
        
        /**
        * Constructor
        */
        public BlogOverlayNewEditController(ApexPages.StandardController controller) {
                wrapper = new Wrapper();
        }
        
        public String getCriteria() {
                return null;
        }
        
        public Wrapper getWrapper() {
                return wrapper;
        }
        
        public void setWrapper(Wrapper w) {
                wrapper = w;
        }
        
        
        /**
        * Return a list of teamspaces for Announce to teamspace
        */
        private PageReference getAnnouncementsListPage() {
                PageReference announcementsList = new PageReference('test');
                announcementsList.setRedirect(true);
                return announcementsList;
        }
       
        
        /**
        * Redirect to AnnouncementsPosts
        */
        public PageReference cancel() {
                return getAnnouncementsListPage();
        }
        
        public String getMainTitle() {
                if (System.currentPageReference().getParameters().get('id') == null) {
                        /* Adding new */
                        return 'New Announcement';
                } else {
                        /* Editing */
                        return 'Announcement Edit';
                }
        }
        
        /**
        * Save the new announcement and redirect to AnnouncementsPosts
        */
        public PageReference save() {
                if (wrapper.getAnnouncement() != null) {
                if (System.currentPageReference().getParameters().get('id') == null) {
                        /* Adding new */
                        wrapper.doSave();
                } else {
                        /* Editing */
                        wrapper.doUpdate();
                }
        }
                
                return getAnnouncementsListPage();
        }
        
        /**
    * Return a list of teamspaces for Announce to teamspace
    */
    public List<SelectOption> getComboTeamspaces(){
        List<SelectOption> options = new List<SelectOption>();

        for(Team__c t:[SELECT id, Name
                      FROM Team__c
                      ORDER BY Name ASC]) {

                options.add( new SelectOption(t.id, t.Name));
        }

        return options;
    }
    
        public class Wrapper {
        
                BlogEntry__c announcement;
                String teamspaceId;
                
                public Wrapper() {
            if (System.currentPageReference().getParameters().get('id') == null) {
                /* Adding new */                
                announcement = new BlogEntry__c();
            } else {
                /* Editing */
                                /* The object is loaded from database */
                                announcement = [SELECT s.Title__c,
                                        s.Team__c,
                                        s.Notify__c,
                                        s.Message__c,
                                        s.Id
                                        FROM BlogEntry__c s
                                        WHERE id=:System.currentPageReference().getParameters().get('id')];                            
            }
                }
                
                /**
                * Return a new Announcement
                */
                public BlogEntry__c getAnnouncement() {
                        return announcement;
                }
                
                public void setAnnouncement(BlogEntry__c a) {
                        announcement = a;
                }
                
                public String getTeamspaceId() {
                        return teamspaceId;
                }
                
                public void setTeamspaceId(String id) {
                        teamspaceId = id;
                }
                
                public void doSave() {
                        announcement.Team__c = [
                                SELECT Id 
                                FROM Team__c 
                                WHERE Id =: teamspaceId].Id;
                        insert announcement;
                }
                
                public void doUpdate() {
                        update announcement;
                }
        }
}
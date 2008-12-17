trigger TeamBeforeDelete on Team__c bulk (before delete) {
    

        
    Team__c[] t = Trigger.old;      
        
                
    //Remove Members from the Team 
    List<TeamMember__c> members = [SELECT Id FROM TeamMember__c WHERE Team__c in :Trigger.old];
    delete members;     

    //Remove Wiki Pages from the Team 
    // commenting for now untill we're ready for deleting wiki pages.
    List<Wikipage__c> pages = [SELECT Id FROM WikiPage__c WHERE Team__c in :Trigger.old];
    delete pages; 
    
    //Remove Project2__c
     List<Project2__c> project2 = [SELECT Id FROM Project2__c WHERE Team__c in :Trigger.old];
     delete project2;  
       
    //Remove BlogEntry__c
    List<BlogEntry__c> blogs = [SELECT Id FROM BlogEntry__c WHERE Team__c in :Trigger.old];                
    delete blogs;   
        
    //Remove Bookmark__c
    List<Bookmark__c> bookmarks = [SELECT Id FROM Bookmark__c WHERE Team__c in :Trigger.old];               
    delete bookmarks;                  
    
    
    //Remove Discussion Forum from the Team 
    List<DiscussionForum__c> forum = [Select d.Id From DiscussionForum__c d where d.Team__c in :Trigger.old];
    delete forum;
        
    //Remove Minifeeds
    List<MiniFeed__c> minifeeds = [SELECT Id FROM MiniFeed__c WHERE Team__c in :Trigger.old];                     
    delete minifeeds;   
        
    //Remove SubTeams
    List<Team__c> subteams = [SELECT Id FROM Team__c WHERE ParentTeam__c in :Trigger.old];                     
    delete subteams;                
    
    
    
}
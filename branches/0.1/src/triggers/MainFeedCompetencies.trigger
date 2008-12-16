trigger MainFeedCompetencies on UserCompetencies__c (after update, after insert, after delete) {

if(trigger.isUpdate){

    List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.old.size(); i++) {

        UserCompetencies__c o = Trigger.old[i];
        UserCompetencies__c n = Trigger.new[i];

        // We need to:
        if((n.Rating__c != o.Rating__c) ||
           (n.Name != o.Name)) {

            minifeed.add( new MiniFeed__c( Type__c='PeopleCompetencyChange',
                                           User__c=n.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their competency list' ));}

    }

    insert minifeed;

  }

if(trigger.isInsert){

  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.new.size(); i++) {

        UserCompetencies__c n = Trigger.new[i];

        // We need to:
        minifeed.add( new MiniFeed__c( Type__c='PeopleCompetencyChange',
                                           User__c=n.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their competency list' ));
    }
    insert minifeed;
}

if(trigger.isDelete){

  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.old.size(); i++) {

        UserCompetencies__c o = Trigger.old[i];

        // We need to:
        minifeed.add( new MiniFeed__c( Type__c='PeopleCompetencyChange',
                                           User__c=o.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their competency list' ));
    }
    insert minifeed;
}



}
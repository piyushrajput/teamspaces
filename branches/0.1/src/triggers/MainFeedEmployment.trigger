trigger MainFeedEmployment on EmploymentHistory__c (after update, after insert, after delete) {

/////////////////////////////////////////////////////////////////////
// This happens after updates
/////////////////////////////////////////////////////////////////////
if(Trigger.isUpdate){

    List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.old.size(); i++) {

        EmploymentHistory__c o = Trigger.old[i];
        EmploymentHistory__c n = Trigger.new[i];

        // We need to:
        if((n.WorkedTo__c != o.WorkedTo__c) ||
           (n.WorkedFrom__c != o.WorkedFrom__c) || 
           (n.Position__c != o.Position__c) ||
           (n.Name != o.Name) ||
           (n.EmployerCityTown__c != o.EmployerCityTown__c) ||
           (n.Description__c != o.Description__c)) {

            minifeed.add( new MiniFeed__c( Type__c='PeopleEmploymentChange',
                                           User__c=n.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their employment history ' ));}

    }

    insert minifeed;

  }

/////////////////////////////////////////////////////////////////////
// This happens after insert
////////////////////////////////////////////////////////////////////
if(trigger.isInsert){

  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.new.size(); i++) {

        EmploymentHistory__c n = Trigger.new[i];

        // We need to:
        minifeed.add( new MiniFeed__c( Type__c='PeopleEmploymentChange',
                                           User__c=n.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their employment history' ));
    }
    insert minifeed;
}


/////////////////////////////////////////////////////////////////////
// This happens after delete
////////////////////////////////////////////////////////////////////
if(trigger.isDelete){

  List<MiniFeed__c> minifeed = new List<MiniFeed__c>();

    for(Integer i = 0; i < Trigger.old.size(); i++) {

        EmploymentHistory__c o = Trigger.old[i];

        // We need to:
        minifeed.add( new MiniFeed__c( Type__c='PeopleEmploymentChange',
                                           User__c=o.User__c,
                                           FeedDate__c=System.now(),
                                           Message__c='has updated their employment history' ));
    }
    insert minifeed;
}


}
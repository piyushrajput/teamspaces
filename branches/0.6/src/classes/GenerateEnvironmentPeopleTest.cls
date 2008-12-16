public class GenerateEnvironmentPeopleTest {

	public static testMethod void gen(){
		
		TeamUtil.isTest = true;
		
		Competency__c newComp = new Competency__c();
		newComp.Name = 'Test Competency';
		newComp.Count__c = 1;
		insert newComp;
		
		// Create a new User
		Profile p = [select id from profile where name='System Administrator'];
		User newUser = new User(alias = 'standt', email='standarduser@testorg.com', 
								emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
								localesidkey='en_US', profileid = p.Id, 
								timezonesidkey='America/Los_Angeles', username='standarduser@testorg.com');
		insert newUser;
		
		UserCompetencies__c userComp = new UserCompetencies__c();
		userComp.Competency__c = newComp.Id;
		userComp.User__c = newUser.Id;//UserInfo.getUserId();
		userComp.Name = 'Test User Competency';
		userComp.rating__c = 5;
		insert userComp;
		
        Employer__c emp = new Employer__c();
		emp.Name = 'Test Employer';
		emp.Count__c = 1;
		insert emp;
		
		EmploymentHistory__c empHist = new EmploymentHistory__c();
		empHist.Employer__c = emp.Id;
		empHist.User__c = newUser.Id;
		empHist.Name = 'Test Employment History';
		empHist.WorkedFrom__c = System.today();
		empHist.WorkedTo__c = System.today();
		insert empHist;	
		
		PeopleProfile__c peopProf = new PeopleProfile__c();
		peopProf.User__c = UserInfo.getUserId();
		peopProf.Name = 'Test People Profile';
		insert peopProf;
		
        School__c scl = new School__c();
		scl.Name = 'Test School';
		scl.Count__c = 1;
		insert scl;
		
		EducationHistory__c educHist = new EducationHistory__c();
		educHist.School__c = scl.Id;
		educHist.User__c = newUser.Id;//UserInfo.getUserId();
		educHist.Name = 'Test Education History'; 
		educHist.DateAttendedTo__c = 0;
		educHist.DateAttendedFrom__c = 0;
		insert educHist;
		
		PeopleSubscription__c peopSubs = new PeopleSubscription__c();
		peopSubs.Person__c = newUser.Id;//UserInfo.getUserId();
		peopSubs.Name = 'Test People Subscription';
		insert peopSubs;
	}

}
# Teams administration configuration #

## Describe the concept of a team ##
> A teams represents a group of people who come together to have a common interaction. This interaction could be goal oriented like a project or could be based on a expertise or a concept. The team is where all the interaction takes place. To help with this interaction the application can introduce different collaborative components into a team area like wiki, project tasks, or discussion. What determines what component is in the team is the Team Type. So when you create a team you will be asked what type of team you want to create. For example a project team, deal team, or scrum team. Need to work widgets into opening paragraph.

**Administering Teams is very easy you only need to understand 3 concepts: Team Types, Team Widgets, and Team Profiles**

### Team Type: ###
> Team types are templates for how a team area should look. In a team type you specify the team widgets that will show and how they will show in any team created from this team type. For example you can create a team type called "project" which will include the task, milestone, and wiki widget. So if you wanted to create a "project" team you would specify this team type in the create new team flow.

### Team Widgets: ###
> Team Widgets are the building blocks of a team area. Widgets are very similar to the iGoogle or Apple Desktop widget concept. A team widget can be either a Salesforce Component with a team attribute or a Google Gadget. The application comes loaded with a handful of useful widgets plus the entire library of Google Gadgets. You can create new widgets by leveraging the platform Component infrastructure. To create a custome widget you component will have to take in a attribute "team" which will be the Id of the team you are viewing. Once your component is completed you will need to register it with the widget catolog.

### Team Profile: ###
> Team Profiles are the access control for each member of the team. When a team member is added you will assign a team profile to that user. The team profile will determine what level of access that users has in this team. The permissions range from managing the team members list to being able to add comments to a wiki. To createa team profile go to the setup area under the teams tab. You will need to be a teams admin in order to create/edit new profiles.
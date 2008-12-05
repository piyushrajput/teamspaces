@IsTest private class TeamsWidgetGadgetHolderControllerTest {
	public static testMethod void test(){
		TeamsWidgetGadgetHolderController holder = new TeamsWidgetGadgetHolderController();
		holder.getSource();
		holder.setSource('source');
		holder.setName('Name');
		holder.getName();
		holder.setSidebar(false);
		holder.getSidebar();
	}	
}
package net.bigpoint.darkorbit.mvc.application.controller
{
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.application.view.ClientSelectionView;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ClientSelectionCommand extends DOAbstractAsyncCommand
   {
      
      public function ClientSelectionCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(Settings.userType == Settings.USER_TYPE_NOT_SELECTED || Settings.userType == Settings.USER_TYPE_NEW && Settings.has3DCapabilities == false)
         {
            assetsProxy.loadAndCall("clientSelection",this.displaySelection,[]);
         }
         else if(Settings.userType == Settings.USER_TYPE_NEW && Settings.has3DCapabilities)
         {
            Settings.FORCE_2D.value = false;
            commandComplete();
         }
         else
         {
            Settings.FORCE_2D.value = Settings.userType == Settings.USER_TYPE_2D;
            commandComplete();
         }
      }
      
      public function displaySelection() : void
      {
         var _loc1_:ClientSelectionView = new ClientSelectionView();
         _loc1_.addEventListener(ClientSelectionView.Selected2D,this.handleSelected2D);
         _loc1_.addEventListener(ClientSelectionView.Selected3D,this.handleSelected3D);
         _loc1_.addEventListener(ClientSelectionView.SelectedFAQ,this.handleSelectedFRQ);
         screenManager.stage.addChild(_loc1_);
      }
      
      private function handleSelected3D(param1:Event) : void
      {
         (param1.target as ClientSelectionView).removeEventListener(ClientSelectionView.Selected2D,this.handleSelected2D);
         (param1.target as ClientSelectionView).removeEventListener(ClientSelectionView.Selected3D,this.handleSelected3D);
         (param1.target as ClientSelectionView).removeEventListener(ClientSelectionView.SelectedFAQ,this.handleSelected3D);
         Settings.FORCE_2D.value = false;
         commandComplete();
      }
      
      private function handleSelected2D(param1:Event) : void
      {
         (param1.target as ClientSelectionView).removeEventListener(ClientSelectionView.Selected2D,this.handleSelected2D);
         (param1.target as ClientSelectionView).removeEventListener(ClientSelectionView.Selected3D,this.handleSelected3D);
         (param1.target as ClientSelectionView).removeEventListener(ClientSelectionView.SelectedFAQ,this.handleSelected3D);
         Settings.FORCE_2D.value = true;
         commandComplete();
      }
      
      private function handleSelectedFRQ(param1:Event) : void
      {
         JavascriptProxy.call(JavascriptProxy.FUNCTION_REFER_TO_EXTERNAL_URL_IN_NEW_WINDOW,[BPLocale.getItem("client_selection_faq_link")]);
      }
   }
}


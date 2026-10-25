package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.view.ContactsWindow;
   import net.bigpoint.darkorbit.mvc.contactsWindow.view.ContactsWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateContactsWindowCommand extends AbstractContactWindowCommand
   {
      
      public function CreateContactsWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:String = param1.getName();
         facade.removeCommand(_loc2_);
         this.loadAndBuildWindow();
      }
      
      private function loadAndBuildWindow() : void
      {
         sendNotification(AssetNotifications.LOAD_ASSET,["contacts_baseWindow",this.handleContentXMLLoaded]);
      }
      
      public function handleContentXMLLoaded(param1:XMLFinisher) : void
      {
         var _loc3_:ContactsWindow = null;
         var _loc4_:Sprite = null;
         var _loc2_:SimpleWindow = this.createSimpleWindow();
         _loc3_ = new ContactsWindow(_loc2_);
         _loc4_ = _loc2_.getUIContainer() as Sprite;
         _loc4_.x = 0;
         _loc4_.y = 0;
         _loc4_.addChild(_loc3_);
         var _loc5_:XML = param1.getXML();
         UISystem.getInstance().loadAndBuild(_loc5_,_loc3_,this.handleWindowContentCreated,[_loc3_]);
      }
      
      private function handleWindowContentCreated(param1:ContactsWindow) : void
      {
         if(retrieveMediator(ContactsWindowMediator.NAME) != null)
         {
            throw new Error("tried to create another ContactsWindow");
         }
         registerMediator(new ContactsWindowMediator(param1));
         param1.handleWindowContentCreated();
         if(contactProxy)
         {
            contactProxy.resendDataToView();
         }
      }
      
      protected function createSimpleWindow() : SimpleWindow
      {
         var _loc1_:SimpleWindow = guiManager.getWindow(GuiConstants.CONTACTLIST_WINDOW);
         if(_loc1_ == null)
         {
            _loc1_ = guiManager.createWindow(GuiConstants.CONTACTLIST_WINDOW) as SimpleWindow;
         }
         return _loc1_;
      }
   }
}


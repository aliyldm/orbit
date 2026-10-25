package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.model.ItemsControlMenuProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ActivateSlotCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "activateSlot";
      
      public function ActivateSlotCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         var _loc3_:int = int(param2[0]);
         _loc3_++;
         if(Boolean(Hero.premium) && Boolean(this.menuProxy.proActionBarVisible) && Settings.proActionBarKeyboardInputEnabled)
         {
            GameFacade.getInstance().sendNotification(ItemsControlMenuNotifications.SEND_HOT_KEY_ACTION_REQUEST,_loc3_,ItemsControlMenuConstants.PRO_ACTION_BAR);
            if(Settings.proActionBarAutohideEnabled)
            {
               TweenLite.delayedCall(0.25,this.closeProActionBar);
            }
         }
         else
         {
            GameFacade.getInstance().sendNotification(ItemsControlMenuNotifications.SEND_HOT_KEY_ACTION_REQUEST,_loc3_,ItemsControlMenuConstants.STANDARD_SLOT_BAR);
         }
         new PlaySoundEffectCommand().execute(param1,new <String>["25"]);
      }
      
      private function closeProActionBar() : void
      {
         if(this.menuProxy.proActionBarVisible)
         {
            GameFacade.getInstance().sendNotification(ItemsControlMenuNotifications.TOGGLE_PRO_ACTION_BUTTON);
         }
      }
      
      private function get menuProxy() : ItemsControlMenuProxy
      {
         return GameFacade.getInstance().retrieveProxy(ItemsControlMenuProxy.NAME) as ItemsControlMenuProxy;
      }
   }
}


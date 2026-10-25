package net.bigpoint.darkorbit.managers.keyboardManager.commands
{
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuNotifications;
   
   public class ActivatePremiumSlotCommand implements IKeyboardCommand
   {
      
      public static const NAME:String = "activatePremiumSlot";
      
      public function ActivatePremiumSlotCommand()
      {
         super();
      }
      
      public function execute(param1:Map, param2:Vector.<String>) : void
      {
         var _loc3_:int = int(param2[0]);
         _loc3_++;
         GameFacade.getInstance().sendNotification(ItemsControlMenuNotifications.SEND_HOT_KEY_ACTION_REQUEST,_loc3_,ItemsControlMenuConstants.PREMIUM_SLOT_BAR);
         new PlaySoundEffectCommand().execute(param1,new <String>["25"]);
      }
   }
}


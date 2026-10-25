package net.bigpoint.darkorbit.net.netty.handlers.jackpot
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.LMJackpotLeftShipsCommand;
   import net.bigpoint.darkorbit.com.module.LogMessengerPriorityModule;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class LMJackpotLeftShipsHandler extends BaseHandler
   {
      
      public function LMJackpotLeftShipsHandler()
      {
         super();
      }
      
      public static function run(param1:LMJackpotLeftShipsCommand) : void
      {
         var _loc5_:String = null;
         var _loc2_:uint = uint(param1.leftShips);
         var _loc3_:LogMessengerPriorityModule = param1.priorityMode;
         var _loc4_:int = _loc3_.priorityModeValue;
         switch(_loc4_)
         {
            case LogMessengerPriorityModule.PRIORITYMODE_STANDARD:
               _loc5_ = LogMessageProfileVOFactory.STANDARD_MESSAGE;
               break;
            case LogMessengerPriorityModule.PRIORITYMODE_HIGH_PRIORITY:
               _loc5_ = LogMessageProfileVOFactory.HIGH_PRIORITY_MESSAGE;
         }
         _facade.sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("msg_jackpot_players_left").replace(/%COUNT%/,_loc2_)).setType(_loc5_));
      }
   }
}


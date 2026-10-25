package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.TdmResultCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TDMResultHandler extends SimpleCommand
   {
      
      private static const losReg:RegExp = /%LOSER%/;
      
      private static const winReg:RegExp = /%WINNER%/;
      
      private static const pointsWinReg:RegExp = /%POINTS_WINNER%/;
      
      private static const pointsLosReg:RegExp = /%POINTS_LOSER%/;
      
      private static const time:RegExp = /%TIME%/;
      
      public function TDMResultHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:TdmResultCommand = param1.getBody() as TdmResultCommand;
         var _loc3_:InGameCatalog = InGameCatalog.getInstance();
         var _loc4_:String = _loc3_.factions_names_by_FactionModule[_loc2_.loser.faction];
         var _loc5_:String = _loc3_.factions_names_by_FactionModule[_loc2_.winner.faction];
         var _loc6_:String = TimeFormatter.formatTime(_loc2_.matchDurationInSeconds);
         var _loc7_:String = BPLocale.getItem("tdm_result_msg");
         _loc7_ = _loc7_.replace(losReg,_loc4_).replace(winReg,_loc5_).replace(pointsWinReg,_loc2_.winnerScore).replace(pointsLosReg,_loc2_.loserScore).replace(time,_loc6_);
         sendNotification(GuiNotifications.ADD_GLOBAL_NOTIFICATION_MESSAGE,new MessageCommandParams().setMessage(_loc7_));
      }
   }
}


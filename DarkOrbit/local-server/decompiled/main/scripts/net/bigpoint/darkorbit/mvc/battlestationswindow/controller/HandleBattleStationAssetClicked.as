package net.bigpoint.darkorbit.mvc.battlestationswindow.controller
{
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HandleBattleStationAssetClicked extends SimpleCommand
   {
      
      public function HandleBattleStationAssetClicked()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Array = param1.getBody() as Array;
         var _loc3_:int = int(_loc2_[0]);
         var _loc4_:String = _loc2_[1];
         sendNotification(BattleStationNotification.INIT_BATTLESTATION_UI,_loc4_);
      }
   }
}


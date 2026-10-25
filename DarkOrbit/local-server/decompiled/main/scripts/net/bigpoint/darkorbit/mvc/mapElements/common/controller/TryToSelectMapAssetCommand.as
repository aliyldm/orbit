package net.bigpoint.darkorbit.mvc.mapElements.common.controller
{
   import net.bigpoint.darkorbit.com.module.ShipSelectRequest;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TryToSelectMapAssetCommand extends SimpleCommand
   {
      
      public function TryToSelectMapAssetCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:ShipSelectRequest = null;
         var _loc2_:Array = param1.getBody() as Array;
         if(_loc2_ == null || _loc2_.length != 8)
         {
            return;
         }
         var _loc3_:int = int(_loc2_[0]);
         _loc2_[1] = int(_loc2_[1]);
         _loc2_[2] = int(_loc2_[2]);
         _loc2_[3] = int(_loc2_[3]);
         _loc2_[4] = int(_loc2_[4]);
         _loc4_ = new ShipSelectRequest(_loc3_);
         _loc4_.targetX = _loc2_[1];
         _loc4_.targetY = _loc2_[2];
         _loc4_.posX = _loc2_[3];
         _loc4_.posY = _loc2_[4];
         _loc4_.clickX = _loc2_[5];
         _loc4_.clickY = _loc2_[6];
         _loc4_.radius = _loc2_[7];
         _loc4_.targetY -= (_loc4_.targetX + _loc4_.targetY + _loc4_.posY + _loc4_.posX) % 8;
         facade.sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,_loc4_);
      }
   }
}


package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.RemoveMineCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RemoveMineHandler extends SimpleCommand
   {
      
      public function RemoveMineHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:RemoveMineCommand = param1.getBody() as RemoveMineCommand;
         var _loc3_:Map = ScreenManager.getInstance().map;
         if(_loc3_)
         {
            _loc3_.removeEntityByHash(_loc2_.hash);
         }
      }
   }
}


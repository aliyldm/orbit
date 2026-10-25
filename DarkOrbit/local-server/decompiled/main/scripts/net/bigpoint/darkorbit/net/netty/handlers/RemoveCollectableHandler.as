package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.RemoveCollectableCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.env.collectable.Collectable;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RemoveCollectableHandler extends SimpleCommand
   {
      
      public function RemoveCollectableHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:Collectable = null;
         var _loc2_:RemoveCollectableCommand = param1.getBody() as RemoveCollectableCommand;
         var _loc3_:Map = ScreenManager.getInstance().map;
         if(_loc3_)
         {
            _loc4_ = _loc3_.getEntityByHash(_loc2_.hash) as Collectable;
            if(_loc4_)
            {
               if(_loc2_.collected)
               {
                  _loc4_.collect();
               }
               _loc3_.removeEntity(_loc4_);
            }
         }
      }
   }
}


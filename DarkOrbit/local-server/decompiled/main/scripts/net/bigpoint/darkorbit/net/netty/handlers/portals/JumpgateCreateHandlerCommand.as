package net.bigpoint.darkorbit.net.netty.handlers.portals
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.JumpgateCreateCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.env.Portal;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class JumpgateCreateHandlerCommand extends SimpleCommand
   {
      
      public function JumpgateCreateHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:JumpgateCreateCommand = param1.getBody() as JumpgateCreateCommand;
         var _loc3_:Map = ScreenManager.getInstance().map;
         if(!_loc3_.getEntityById(_loc2_.gateId))
         {
            _loc3_.addEntity(new Portal(_loc2_.gateId,new PointLite(_loc2_.x,_loc2_.y),_loc2_.designId,_loc2_.showBubble,_loc2_.isVisibleOnMinimap));
         }
      }
   }
}


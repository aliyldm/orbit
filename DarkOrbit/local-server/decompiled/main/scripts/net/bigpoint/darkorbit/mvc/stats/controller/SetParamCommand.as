package net.bigpoint.darkorbit.mvc.stats.controller
{
   import net.bigpoint.darkorbit.mvc.stats.model.StatsProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SetParamCommand extends SimpleCommand implements ICommand
   {
      
      public function SetParamCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Array = null;
         _loc2_ = param1.getBody() as Array;
         var _loc3_:String = String(_loc2_[0]);
         var _loc4_:String = String(_loc2_[1]);
         var _loc5_:StatsProxy = facade.retrieveProxy(StatsProxy.NAME) as StatsProxy;
         _loc5_.setParam(_loc3_,_loc4_);
      }
   }
}


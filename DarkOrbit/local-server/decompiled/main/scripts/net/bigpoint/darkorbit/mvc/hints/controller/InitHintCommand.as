package net.bigpoint.darkorbit.mvc.hints.controller
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.hints.HintsNotifications;
   import net.bigpoint.darkorbit.mvc.hints.model.HintsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitHintCommand extends DOAbstractSimpleCommand
   {
      
      public function InitHintCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Boolean = Boolean(param1.getBody());
         var _loc3_:String = param1.getType();
         if(_loc2_ && !this.hintsProxy.currentHintId)
         {
            this.hintsProxy.currentHintId = _loc3_;
            sendNotification(HintsNotifications.SHOW_HINT,_loc3_);
         }
         else if(!_loc2_ && Boolean(this.hintsProxy.currentHintId))
         {
            sendNotification(HintsNotifications.HIDE_HINT,_loc3_);
            this.hintsProxy.currentHintId = null;
         }
      }
      
      private function get hintsProxy() : HintsProxy
      {
         return facade.retrieveProxy(HintsProxy.NAME) as HintsProxy;
      }
   }
}


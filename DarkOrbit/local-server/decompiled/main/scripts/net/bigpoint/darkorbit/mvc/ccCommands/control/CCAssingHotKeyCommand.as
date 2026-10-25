package net.bigpoint.darkorbit.mvc.ccCommands.control
{
   import net.bigpoint.darkorbit.com.module.CCommandRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.ccCommands.model.CCCommandsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CCAssingHotKeyCommand extends DOAbstractSimpleCommand
   {
      
      public function CCAssingHotKeyCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:CCommandRequest = param1.getBody()["cmd"] as CCommandRequest;
         var _loc3_:uint = param1.getBody()["key"] as uint;
         var _loc4_:CCCommandsProxy = retrieveProxy(CCCommandsProxy.NAME) as CCCommandsProxy;
         _loc4_.assignHotKeyToHistory(_loc3_,_loc2_);
      }
   }
}


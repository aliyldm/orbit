package net.bigpoint.darkorbit.mvc.hintSystem.controller.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.HintWindowListInitCommand;
   import net.bigpoint.darkorbit.com.module.HintWindowModule;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.HintSystemContentProvider;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.HintSystemWindowsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemInitWindowListCommand extends SimpleCommand
   {
      
      public function HintSystemInitWindowListCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc7_:HintWindowModule = null;
         var _loc8_:uint = 0;
         var _loc9_:IHintSystemContentDescription = null;
         super.execute(param1);
         var _loc2_:HintWindowListInitCommand = param1.getBody() as HintWindowListInitCommand;
         var _loc3_:HintSystemWindowsProxy = facade.retrieveProxy(HintSystemWindowsProxy.NAME) as HintSystemWindowsProxy;
         var _loc4_:uint = _loc2_.windows.length;
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = _loc2_.windows[_loc6_] as HintWindowModule;
            _loc8_ = uint(_loc7_.content);
            _loc9_ = HintSystemContentProvider.get(_loc8_);
            _loc5_[_loc8_] = _loc9_;
            _loc6_++;
         }
         _loc3_.windows = _loc5_;
      }
   }
}


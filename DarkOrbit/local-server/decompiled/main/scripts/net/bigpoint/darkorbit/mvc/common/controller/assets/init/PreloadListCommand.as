package net.bigpoint.darkorbit.mvc.common.controller.assets.init
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PreloadListCommand extends DOAbstractSimpleCommand
   {
      
      public function PreloadListCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.execute(param1);
         switch(param1.getType())
         {
            case AssetNotifications.TYPE_PRELOAD_LIST_TYPE_PATTERN_KEY:
               _loc2_ = PatternManager.getHighPrioPreloadList(param1.getBody() as String);
               break;
            default:
               _loc2_ = param1.getBody() as Vector.<String>;
         }
         if(_loc2_)
         {
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               assetsProxy.addToPreloadList(_loc2_[_loc4_]);
               _loc4_++;
            }
         }
      }
   }
}


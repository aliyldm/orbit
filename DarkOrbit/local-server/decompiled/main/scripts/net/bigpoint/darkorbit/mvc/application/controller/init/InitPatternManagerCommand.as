package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import com.adobe.crypto.MD5;
   import flash.utils.ByteArray;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.common.model.pattern.proxy.PatternManagerProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitPatternManagerCommand extends DOAbstractAsyncCommand
   {
      
      private static const GAME_XML_FILE:Class = InitPatternManagerCommand_GAME_XML_FILE;
      
      public function InitPatternManagerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PatternManagerProxy = facade.retrieveProxy(PatternManagerProxy.NAME) as PatternManagerProxy;
         var _loc3_:ByteArray = new GAME_XML_FILE() as ByteArray;
         var _loc4_:String = _loc3_.readUTFBytes(_loc3_.length);
         var _loc5_:String = MD5.hash(_loc4_);
         if(Settings.gameXMLHash == _loc5_)
         {
            _loc2_.init(new XML(_loc4_));
            commandComplete();
         }
         else
         {
            EventStreamClient.track("flash.violation",{"reason":"game.xml is manipulated"});
         }
      }
   }
}


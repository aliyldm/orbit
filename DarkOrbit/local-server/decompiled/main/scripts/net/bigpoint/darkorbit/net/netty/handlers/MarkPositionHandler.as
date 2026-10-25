package net.bigpoint.darkorbit.net.netty.handlers
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.com.module.MarkPositionCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MarkPositionHandler extends BaseHandler
   {
      
      private static var activePositionClips:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private static const crossRadius:int = 40;
      
      public function MarkPositionHandler()
      {
         super();
      }
      
      public static function run(param1:MarkPositionCommand) : void
      {
      }
      
      public static function removeAll() : void
      {
         while(activePositionClips.length > 0)
         {
         }
      }
   }
}


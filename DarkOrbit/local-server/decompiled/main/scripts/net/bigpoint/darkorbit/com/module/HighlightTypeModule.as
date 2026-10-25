package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HighlightTypeModule implements IModule
   {
      
      private static var _instance:HighlightTypeModule;
      
      public static const HIGHLIGHTTYPE_FLASH:int = 0;
      
      public static const HIGHLIGHTTYPE_FLASH_WINDOW:int = 1;
      
      public static const HIGHLIGHTTYPE_ARROW:int = 2;
      
      public static const HIGHLIGHTTYPE_FLASH_AND_ARROW:int = 3;
      
      public static const HIGHLIGHTTYPE_FLASH_AND_SOUND:int = 4;
      
      public static const HIGHLIGHTTYPE_RED_BLINK:int = 5;
      
      public static const HIGHLIGHTTYPE_ACTIVE:int = 6;
      
      public static const HIGHLIGHTTYPE_RED_DOT:int = 7;
      
      public static const HIGHLIGHTTYPE_PROGRESS_BAR:int = 8;
      
      public static const HIGHLIGHTTYPE__MAX:int = 9;
      
      public var type:int = 0;
      
      public function HighlightTypeModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : HighlightTypeModule
      {
         return _instance || (_instance = new HighlightTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24341;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24341);
         param1.writeShort(this.type);
      }
   }
}


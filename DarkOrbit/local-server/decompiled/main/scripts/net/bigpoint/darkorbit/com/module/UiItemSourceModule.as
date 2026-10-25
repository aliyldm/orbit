package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UiItemSourceModule implements IModule
   {
      
      private static var _instance:UiItemSourceModule;
      
      public static const ITEMSOURCE_MENU_ITEM_BARS:int = 0;
      
      public static const ITEMSOURCE_FEATURE_BARS:int = 1;
      
      public static const ITEMSOURCE_WINDOW:int = 2;
      
      public static const ITEMSOURCE__MAX:int = 3;
      
      public var itemSource:int = 0;
      
      public function UiItemSourceModule(param1:int = 0)
      {
         super();
         this.itemSource = param1;
      }
      
      public static function get instance() : UiItemSourceModule
      {
         return _instance || (_instance = new UiItemSourceModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14725;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemSource = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14725);
         param1.writeShort(this.itemSource);
      }
   }
}


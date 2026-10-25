package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderProbabilityModule implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderProbabilityModule;
      
      public static const CATEGORY_INVALID:int = 0;
      
      public static const CATEGORY_AMMUNITION:int = 1;
      
      public static const CATEGORY_RESOURCE:int = 2;
      
      public static const CATEGORY_VOUCHER:int = 3;
      
      public static const CATEGORY_PART:int = 4;
      
      public static const CATEGORY_SPECIAL:int = 5;
      
      public static const CATEGORY_LOGFILE:int = 6;
      
      public static const CATEGORY__MAX:int = 7;
      
      public var category:int = 0;
      
      public var percentage:int = 0;
      
      public function GalaxyGateBuilderProbabilityModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.category = param1;
         this.percentage = param2;
      }
      
      public static function get instance() : GalaxyGateBuilderProbabilityModule
      {
         return _instance || (_instance = new GalaxyGateBuilderProbabilityModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17946;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.category = param1.readShort();
         this.percentage = param1.readByte();
         this.percentage = 0xFF & ((0xFF & this.percentage) << 14 % 8 | (0xFF & this.percentage) >>> 8 - 14 % 8);
         this.percentage = this.percentage > 127 ? int(this.percentage - 256) : this.percentage;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17946);
         param1.writeShort(this.category);
         param1.writeByte(0xFF & ((0xFF & this.percentage) >>> 14 % 8 | (0xFF & this.percentage) << 8 - 14 % 8));
      }
   }
}


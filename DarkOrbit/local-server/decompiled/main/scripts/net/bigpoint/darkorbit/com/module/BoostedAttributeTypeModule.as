package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BoostedAttributeTypeModule implements IModule
   {
      
      private static var _instance:BoostedAttributeTypeModule;
      
      public static const ATTRIBUTETYPE_EP:int = 0;
      
      public static const ATTRIBUTETYPE_HONOUR:int = 1;
      
      public static const ATTRIBUTETYPE_DAMAGE:int = 2;
      
      public static const ATTRIBUTETYPE_SHIELD:int = 3;
      
      public static const ATTRIBUTETYPE_REPAIR:int = 4;
      
      public static const ATTRIBUTETYPE_SHIELDRECHARGE:int = 5;
      
      public static const ATTRIBUTETYPE_RESOURCE:int = 6;
      
      public static const ATTRIBUTETYPE_MAXHP:int = 7;
      
      public static const ATTRIBUTETYPE_ABILITY_COOLDOWN:int = 8;
      
      public static const ATTRIBUTETYPE_BONUSBOXES:int = 9;
      
      public static const ATTRIBUTETYPE_QUESTREWARD:int = 10;
      
      public static const ATTRIBUTETYPE_CHANCE:int = 11;
      
      public static const ATTRIBUTETYPE_NEWRESOURCE:int = 12;
      
      public static const ATTRIBUTETYPE__MAX:int = 13;
      
      public var typeValue:int = 0;
      
      public function BoostedAttributeTypeModule(param1:int = 0)
      {
         super();
         this.typeValue = param1;
      }
      
      public static function get instance() : BoostedAttributeTypeModule
      {
         return _instance || (_instance = new BoostedAttributeTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1311;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.typeValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1311);
         param1.writeShort(this.typeValue);
      }
   }
}


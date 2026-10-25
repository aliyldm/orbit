package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderItemModule implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderItemModule;
      
      public static const ITEMTYPE_INVALID:int = 0;
      
      public static const ITEMTYPE_BATTERY:int = 1;
      
      public static const ITEMTYPE_ROCKET:int = 2;
      
      public static const ITEMTYPE_MINE:int = 3;
      
      public static const ITEMTYPE_ORE:int = 4;
      
      public static const ITEMTYPE_VOUCHER:int = 5;
      
      public static const ITEMTYPE_PART:int = 6;
      
      public static const ITEMTYPE_HITPOINTS:int = 7;
      
      public static const ITEMTYPE_LOGFILE:int = 8;
      
      public static const ITEMTYPE_MULTIPLIER:int = 9;
      
      public static const ITEMTYPE__MAX:int = 10;
      
      public var type:int = 0;
      
      public var date:Number = 0;
      
      public function GalaxyGateBuilderItemModule(param1:int = 0, param2:Number = 0)
      {
         super();
         this.type = param1;
         this.date = param2;
      }
      
      public static function get instance() : GalaxyGateBuilderItemModule
      {
         return _instance || (_instance = new GalaxyGateBuilderItemModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22394;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
         this.date = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22394);
         param1.writeShort(this.type);
         param1.writeDouble(this.date);
      }
   }
}


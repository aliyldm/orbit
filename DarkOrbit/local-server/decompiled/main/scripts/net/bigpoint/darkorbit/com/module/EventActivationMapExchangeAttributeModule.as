package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class EventActivationMapExchangeAttributeModule extends EventActivationAttributeModule
   {
      
      private static var _instance:EventActivationMapExchangeAttributeModule;
      
      public static const REPLACEMENTTYPE_FOOTBALL_4_4:int = 0;
      
      public static const REPLACEMENTTYPE_FOOTBALL_TDM:int = 1;
      
      public static const REPLACEMENTTYPE_FOOTBALL_INVASION:int = 2;
      
      public static const REPLACEMENTTYPE__MAX:int = 3;
      
      public var mapId:int = 0;
      
      public var replacement:int = 0;
      
      public function EventActivationMapExchangeAttributeModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.mapId = param1;
         this.replacement = param2;
      }
      
      public static function get instance() : EventActivationMapExchangeAttributeModule
      {
         return _instance || (_instance = new EventActivationMapExchangeAttributeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -238;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.mapId = param1.readInt();
         this.mapId = this.mapId >>> 12 % 32 | this.mapId << 32 - 12 % 32;
         this.replacement = param1.readShort();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-238);
         super.write(param1);
         param1.writeInt(this.mapId << 12 % 32 | this.mapId >>> 32 - 12 % 32);
         param1.writeShort(this.replacement);
      }
   }
}


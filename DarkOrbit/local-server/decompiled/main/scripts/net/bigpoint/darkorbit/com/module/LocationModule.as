package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class LocationModule extends PlayerAttributeModule
   {
      
      private static var _instance:LocationModule;
      
      public var y:int = 0;
      
      public var mapId:int = 0;
      
      public var x:int = 0;
      
      public function LocationModule(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.y = param3;
         this.mapId = param1;
         this.x = param2;
      }
      
      public static function get instance() : LocationModule
      {
         return _instance || (_instance = new LocationModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -6449;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.y = param1.readInt();
         this.y = this.y << 11 % 32 | this.y >>> 32 - 11 % 32;
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 5 % 32 | this.mapId >>> 32 - 5 % 32;
         this.x = param1.readInt();
         this.x = this.x << 13 % 32 | this.x >>> 32 - 13 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6449);
         super.write(param1);
         param1.writeInt(this.y >>> 11 % 32 | this.y << 32 - 11 % 32);
         param1.writeInt(this.mapId >>> 5 % 32 | this.mapId << 32 - 5 % 32);
         param1.writeInt(this.x >>> 13 % 32 | this.x << 32 - 13 % 32);
      }
   }
}


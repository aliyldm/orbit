package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnequipModuleRequest implements IModule
   {
      
      private static var _instance:UnequipModuleRequest;
      
      public var battleStationId:int = 0;
      
      public var itemId:int = 0;
      
      public function UnequipModuleRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.battleStationId = param1;
         this.itemId = param2;
      }
      
      public static function get instance() : UnequipModuleRequest
      {
         return _instance || (_instance = new UnequipModuleRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6018;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId << 12 % 32 | this.battleStationId >>> 32 - 12 % 32;
         this.itemId = param1.readInt();
         this.itemId = this.itemId << 3 % 32 | this.itemId >>> 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6018);
         param1.writeInt(this.battleStationId >>> 12 % 32 | this.battleStationId << 32 - 12 % 32);
         param1.writeInt(this.itemId >>> 3 % 32 | this.itemId << 32 - 3 % 32);
      }
   }
}


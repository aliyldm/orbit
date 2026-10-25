package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipAutoBuyCpuAmmoRequest implements IModule
   {
      
      private static var _instance:HangarShipAutoBuyCpuAmmoRequest;
      
      public var itemId:Number = 0;
      
      public var ammoLootId:String = "";
      
      public function HangarShipAutoBuyCpuAmmoRequest(param1:Number = 0, param2:String = "")
      {
         super();
         this.itemId = param1;
         this.ammoLootId = param2;
      }
      
      public static function get instance() : HangarShipAutoBuyCpuAmmoRequest
      {
         return _instance || (_instance = new HangarShipAutoBuyCpuAmmoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31905;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemId = param1.readDouble();
         this.ammoLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31905);
         param1.writeDouble(this.itemId);
         param1.writeUTF(this.ammoLootId);
      }
   }
}


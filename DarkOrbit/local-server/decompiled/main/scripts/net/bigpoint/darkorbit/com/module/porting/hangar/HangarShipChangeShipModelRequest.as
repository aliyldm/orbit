package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipChangeShipModelRequest implements IModule
   {
      
      private static var _instance:HangarShipChangeShipModelRequest;
      
      public var shipId:Number = 0;
      
      public var lootId:String = "";
      
      public function HangarShipChangeShipModelRequest(param1:Number = 0, param2:String = "")
      {
         super();
         this.shipId = param1;
         this.lootId = param2;
      }
      
      public static function get instance() : HangarShipChangeShipModelRequest
      {
         return _instance || (_instance = new HangarShipChangeShipModelRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23923;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.shipId = param1.readDouble();
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23923);
         param1.writeDouble(this.shipId);
         param1.writeUTF(this.lootId);
      }
   }
}


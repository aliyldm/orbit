package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HangarShipUnlockSlotRequest implements IModule
   {
      
      private static var _instance:HangarShipUnlockSlotRequest;
      
      public var slotset:String = "";
      
      public function HangarShipUnlockSlotRequest(param1:String = "")
      {
         super();
         this.slotset = param1;
      }
      
      public static function get instance() : HangarShipUnlockSlotRequest
      {
         return _instance || (_instance = new HangarShipUnlockSlotRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1542;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.slotset = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1542);
         param1.writeUTF(this.slotset);
      }
   }
}


package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InstantRepairRequest implements IModule
   {
      
      private static var _instance:InstantRepairRequest;
      
      public var repairAssetId:int = 0;
      
      public function InstantRepairRequest(param1:int = 0)
      {
         super();
         this.repairAssetId = param1;
      }
      
      public static function get instance() : InstantRepairRequest
      {
         return _instance || (_instance = new InstantRepairRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13736;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.repairAssetId = param1.readInt();
         this.repairAssetId = this.repairAssetId >>> 3 % 32 | this.repairAssetId << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-13736);
         param1.writeInt(this.repairAssetId << 3 % 32 | this.repairAssetId >>> 32 - 3 % 32);
      }
   }
}


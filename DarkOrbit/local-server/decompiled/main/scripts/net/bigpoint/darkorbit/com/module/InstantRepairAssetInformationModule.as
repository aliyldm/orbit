package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class InstantRepairAssetInformationModule extends AssetInformationModule
   {
      
      private static var _instance:InstantRepairAssetInformationModule;
      
      public var instantRepairCount:int = 0;
      
      public function InstantRepairAssetInformationModule(param1:int = 0)
      {
         super();
         this.instantRepairCount = param1;
      }
      
      public static function get instance() : InstantRepairAssetInformationModule
      {
         return _instance || (_instance = new InstantRepairAssetInformationModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -19955;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.instantRepairCount = param1.readInt();
         this.instantRepairCount = this.instantRepairCount << 13 % 32 | this.instantRepairCount >>> 32 - 13 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19955);
         super.write(param1);
         param1.writeInt(this.instantRepairCount >>> 13 % 32 | this.instantRepairCount << 32 - 13 % 32);
      }
   }
}


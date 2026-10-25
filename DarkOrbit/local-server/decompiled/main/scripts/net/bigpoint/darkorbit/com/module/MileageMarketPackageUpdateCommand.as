package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketPackageUpdateCommand implements IModule
   {
      
      private static var _instance:MileageMarketPackageUpdateCommand;
      
      public var isBought:Boolean = false;
      
      public var claimedDiscountSteps:int = 0;
      
      public var packageID:String = "";
      
      public function MileageMarketPackageUpdateCommand(param1:String = "", param2:int = 0, param3:Boolean = false)
      {
         super();
         this.isBought = param3;
         this.claimedDiscountSteps = param2;
         this.packageID = param1;
      }
      
      public static function get instance() : MileageMarketPackageUpdateCommand
      {
         return _instance || (_instance = new MileageMarketPackageUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24357;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 7;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isBought = param1.readBoolean();
         this.claimedDiscountSteps = param1.readInt();
         this.claimedDiscountSteps = this.claimedDiscountSteps >>> 13 % 32 | this.claimedDiscountSteps << 32 - 13 % 32;
         this.packageID = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24357);
         param1.writeBoolean(this.isBought);
         param1.writeInt(this.claimedDiscountSteps << 13 % 32 | this.claimedDiscountSteps >>> 32 - 13 % 32);
         param1.writeUTF(this.packageID);
      }
   }
}


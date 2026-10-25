package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketPackageModule implements IModule
   {
      
      private static var _instance:MileageMarketPackageModule;
      
      public var packagePrice:String = "";
      
      public var isBought:Boolean = false;
      
      public var imageKey:String = "";
      
      public var maxDiscountSteps:int = 0;
      
      public var claimedDiscountSteps:int = 0;
      
      public var packageId:String = "";
      
      public var discountPerStep:Number = 0;
      
      public var priority:int = 0;
      
      public function MileageMarketPackageModule(param1:String = "", param2:String = "", param3:String = "", param4:Number = 0, param5:int = 0, param6:int = 0, param7:Boolean = false, param8:int = 0)
      {
         super();
         this.packagePrice = param3;
         this.isBought = param7;
         this.imageKey = param1;
         this.maxDiscountSteps = param5;
         this.claimedDiscountSteps = param6;
         this.packageId = param2;
         this.discountPerStep = param4;
         this.priority = param8;
      }
      
      public static function get instance() : MileageMarketPackageModule
      {
         return _instance || (_instance = new MileageMarketPackageModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4818;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 23;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.packagePrice = param1.readUTF();
         this.isBought = param1.readBoolean();
         this.imageKey = param1.readUTF();
         this.maxDiscountSteps = param1.readInt();
         this.maxDiscountSteps = this.maxDiscountSteps << 11 % 32 | this.maxDiscountSteps >>> 32 - 11 % 32;
         this.claimedDiscountSteps = param1.readInt();
         this.claimedDiscountSteps = this.claimedDiscountSteps << 13 % 32 | this.claimedDiscountSteps >>> 32 - 13 % 32;
         this.packageId = param1.readUTF();
         this.discountPerStep = param1.readFloat();
         this.priority = param1.readInt();
         this.priority = this.priority << 5 % 32 | this.priority >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4818);
         param1.writeUTF(this.packagePrice);
         param1.writeBoolean(this.isBought);
         param1.writeUTF(this.imageKey);
         param1.writeInt(this.maxDiscountSteps >>> 11 % 32 | this.maxDiscountSteps << 32 - 11 % 32);
         param1.writeInt(this.claimedDiscountSteps >>> 13 % 32 | this.claimedDiscountSteps << 32 - 13 % 32);
         param1.writeUTF(this.packageId);
         param1.writeFloat(this.discountPerStep);
         param1.writeInt(this.priority >>> 5 % 32 | this.priority << 32 - 5 % 32);
      }
   }
}


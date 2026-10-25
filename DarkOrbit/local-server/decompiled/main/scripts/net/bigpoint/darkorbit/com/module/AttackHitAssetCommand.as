package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttackHitAssetCommand implements IModule
   {
      
      private static var _instance:AttackHitAssetCommand;
      
      public var assetId:int = 0;
      
      public var hitpointsMax:Number = 0;
      
      public var hitpointsNow:Number = 0;
      
      public function AttackHitAssetCommand(param1:int = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.assetId = param1;
         this.hitpointsMax = param2;
         this.hitpointsNow = param3;
      }
      
      public static function get instance() : AttackHitAssetCommand
      {
         return _instance || (_instance = new AttackHitAssetCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.assetId = param1.readInt();
         this.assetId = this.assetId >>> 3 % 32 | this.assetId << 32 - 3 % 32;
         this.hitpointsMax = param1.readDouble();
         this.hitpointsNow = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5);
         param1.writeInt(this.assetId << 3 % 32 | this.assetId >>> 32 - 3 % 32);
         param1.writeDouble(this.hitpointsMax);
         param1.writeDouble(this.hitpointsNow);
      }
   }
}


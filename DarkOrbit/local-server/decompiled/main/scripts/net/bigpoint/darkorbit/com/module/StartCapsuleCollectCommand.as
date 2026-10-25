package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StartCapsuleCollectCommand implements IModule
   {
      
      private static var _instance:StartCapsuleCollectCommand;
      
      public var collectorId:int = 0;
      
      public var assetId:int = 0;
      
      public var timer:int = 0;
      
      public function StartCapsuleCollectCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.collectorId = param1;
         this.assetId = param2;
         this.timer = param3;
      }
      
      public static function get instance() : StartCapsuleCollectCommand
      {
         return _instance || (_instance = new StartCapsuleCollectCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18803;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.collectorId = param1.readInt();
         this.collectorId = this.collectorId << 1 % 32 | this.collectorId >>> 32 - 1 % 32;
         this.assetId = param1.readInt();
         this.assetId = this.assetId << 4 % 32 | this.assetId >>> 32 - 4 % 32;
         this.timer = param1.readInt();
         this.timer = this.timer >>> 3 % 32 | this.timer << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18803);
         param1.writeInt(this.collectorId >>> 1 % 32 | this.collectorId << 32 - 1 % 32);
         param1.writeInt(this.assetId >>> 4 % 32 | this.assetId << 32 - 4 % 32);
         param1.writeInt(this.timer << 3 % 32 | this.timer >>> 32 - 3 % 32);
      }
   }
}


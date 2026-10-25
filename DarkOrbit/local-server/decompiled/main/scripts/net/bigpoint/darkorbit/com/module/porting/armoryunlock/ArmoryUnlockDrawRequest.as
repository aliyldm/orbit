package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArmoryUnlockDrawRequest implements IModule
   {
      
      private static var _instance:ArmoryUnlockDrawRequest;
      
      public var count:int = 0;
      
      public var type:int = 0;
      
      public function ArmoryUnlockDrawRequest(param1:int = 0, param2:int = 0)
      {
         super();
         this.count = param2;
         this.type = param1;
      }
      
      public static function get instance() : ArmoryUnlockDrawRequest
      {
         return _instance || (_instance = new ArmoryUnlockDrawRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -32404;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.count = param1.readInt();
         this.count = this.count >>> 14 % 32 | this.count << 32 - 14 % 32;
         this.type = param1.readInt();
         this.type = this.type << 6 % 32 | this.type >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-32404);
         param1.writeInt(this.count << 14 % 32 | this.count >>> 32 - 14 % 32);
         param1.writeInt(this.type >>> 6 % 32 | this.type << 32 - 6 % 32);
      }
   }
}


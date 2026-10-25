package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateKeyInfoCommand implements IModule
   {
      
      private static var _instance:EternalGateKeyInfoCommand;
      
      public var keyCount:int = 0;
      
      public function EternalGateKeyInfoCommand(param1:int = 0)
      {
         super();
         this.keyCount = param1;
      }
      
      public static function get instance() : EternalGateKeyInfoCommand
      {
         return _instance || (_instance = new EternalGateKeyInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -32107;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.keyCount = param1.readInt();
         this.keyCount = this.keyCount >>> 9 % 32 | this.keyCount << 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-32107);
         param1.writeInt(this.keyCount << 9 % 32 | this.keyCount >>> 32 - 9 % 32);
      }
   }
}


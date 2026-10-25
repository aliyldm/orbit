package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PayloadEscortKeyInfoCommand implements IModule
   {
      
      private static var _instance:PayloadEscortKeyInfoCommand;
      
      public var keyCount:int = 0;
      
      public function PayloadEscortKeyInfoCommand(param1:int = 0)
      {
         super();
         this.keyCount = param1;
      }
      
      public static function get instance() : PayloadEscortKeyInfoCommand
      {
         return _instance || (_instance = new PayloadEscortKeyInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 30582;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.keyCount = param1.readInt();
         this.keyCount = this.keyCount << 10 % 32 | this.keyCount >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(30582);
         param1.writeInt(this.keyCount >>> 10 % 32 | this.keyCount << 32 - 10 % 32);
      }
   }
}


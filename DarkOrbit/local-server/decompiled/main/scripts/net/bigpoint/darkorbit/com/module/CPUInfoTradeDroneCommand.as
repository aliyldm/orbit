package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CPUInfoTradeDroneCommand implements IModule
   {
      
      private static var _instance:CPUInfoTradeDroneCommand;
      
      public var chargesLeft:int = 0;
      
      public function CPUInfoTradeDroneCommand(param1:int = 0)
      {
         super();
         this.chargesLeft = param1;
      }
      
      public static function get instance() : CPUInfoTradeDroneCommand
      {
         return _instance || (_instance = new CPUInfoTradeDroneCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 62;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.chargesLeft = param1.readInt();
         this.chargesLeft = this.chargesLeft >>> 8 % 32 | this.chargesLeft << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(62);
         param1.writeInt(this.chargesLeft << 8 % 32 | this.chargesLeft >>> 32 - 8 % 32);
      }
   }
}


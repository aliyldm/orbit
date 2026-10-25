package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CPUInfoCloakCommand implements IModule
   {
      
      private static var _instance:CPUInfoCloakCommand;
      
      public var cloakChargesLeft:int = 0;
      
      public function CPUInfoCloakCommand(param1:int = 0)
      {
         super();
         this.cloakChargesLeft = param1;
      }
      
      public static function get instance() : CPUInfoCloakCommand
      {
         return _instance || (_instance = new CPUInfoCloakCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 59;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.cloakChargesLeft = param1.readInt();
         this.cloakChargesLeft = this.cloakChargesLeft << 5 % 32 | this.cloakChargesLeft >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(59);
         param1.writeInt(this.cloakChargesLeft >>> 5 % 32 | this.cloakChargesLeft << 32 - 5 % 32);
      }
   }
}


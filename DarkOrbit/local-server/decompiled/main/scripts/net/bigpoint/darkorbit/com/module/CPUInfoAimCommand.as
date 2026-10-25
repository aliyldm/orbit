package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CPUInfoAimCommand implements IModule
   {
      
      private static var _instance:CPUInfoAimCommand;
      
      public var possibleChargesLeft:int = 0;
      
      public var isActive:Boolean = false;
      
      public function CPUInfoAimCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.possibleChargesLeft = param1;
         this.isActive = param2;
      }
      
      public static function get instance() : CPUInfoAimCommand
      {
         return _instance || (_instance = new CPUInfoAimCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 58;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.possibleChargesLeft = param1.readInt();
         this.possibleChargesLeft = this.possibleChargesLeft << 9 % 32 | this.possibleChargesLeft >>> 32 - 9 % 32;
         this.isActive = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(58);
         param1.writeInt(this.possibleChargesLeft >>> 9 % 32 | this.possibleChargesLeft << 32 - 9 % 32);
         param1.writeBoolean(this.isActive);
      }
   }
}


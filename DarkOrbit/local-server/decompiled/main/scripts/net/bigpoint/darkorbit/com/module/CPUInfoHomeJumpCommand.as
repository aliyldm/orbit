package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CPUInfoHomeJumpCommand implements IModule
   {
      
      private static var _instance:CPUInfoHomeJumpCommand;
      
      public var level:int = 0;
      
      public var homeMapId:int = 0;
      
      public var chargesLeft:int = 0;
      
      public function CPUInfoHomeJumpCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.level = param1;
         this.homeMapId = param2;
         this.chargesLeft = param3;
      }
      
      public static function get instance() : CPUInfoHomeJumpCommand
      {
         return _instance || (_instance = new CPUInfoHomeJumpCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 57;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.level = param1.readInt();
         this.level = this.level << 15 % 32 | this.level >>> 32 - 15 % 32;
         this.homeMapId = param1.readInt();
         this.homeMapId = this.homeMapId >>> 10 % 32 | this.homeMapId << 32 - 10 % 32;
         this.chargesLeft = param1.readInt();
         this.chargesLeft = this.chargesLeft << 4 % 32 | this.chargesLeft >>> 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(57);
         param1.writeInt(this.level >>> 15 % 32 | this.level << 32 - 15 % 32);
         param1.writeInt(this.homeMapId << 10 % 32 | this.homeMapId >>> 32 - 10 % 32);
         param1.writeInt(this.chargesLeft >>> 4 % 32 | this.chargesLeft << 32 - 4 % 32);
      }
   }
}


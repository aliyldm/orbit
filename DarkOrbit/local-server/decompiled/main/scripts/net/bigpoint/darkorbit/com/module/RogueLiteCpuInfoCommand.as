package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteCpuInfoCommand implements IModule
   {
      
      private static var _instance:RogueLiteCpuInfoCommand;
      
      public var keys:int = 0;
      
      public var showCpu:Boolean = false;
      
      public function RogueLiteCpuInfoCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.keys = param1;
         this.showCpu = param2;
      }
      
      public static function get instance() : RogueLiteCpuInfoCommand
      {
         return _instance || (_instance = new RogueLiteCpuInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8355;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.keys = param1.readInt();
         this.keys = this.keys << 5 % 32 | this.keys >>> 32 - 5 % 32;
         this.showCpu = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8355);
         param1.writeInt(this.keys >>> 5 % 32 | this.keys << 32 - 5 % 32);
         param1.writeBoolean(this.showCpu);
      }
   }
}


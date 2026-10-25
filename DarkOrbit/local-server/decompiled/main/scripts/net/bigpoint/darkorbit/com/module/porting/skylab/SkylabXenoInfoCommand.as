package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabXenoInfoCommand implements IModule
   {
      
      private static var _instance:SkylabXenoInfoCommand;
      
      public var activeEfficiency:int = 0;
      
      public var activeConsumption:int = 0;
      
      public var inactiveConsumption:int = 0;
      
      public var activeEnergy:int = 0;
      
      public function SkylabXenoInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this.activeEfficiency = param3;
         this.activeConsumption = param2;
         this.inactiveConsumption = param1;
         this.activeEnergy = param4;
      }
      
      public static function get instance() : SkylabXenoInfoCommand
      {
         return _instance || (_instance = new SkylabXenoInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14525;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.activeEfficiency = param1.readInt();
         this.activeEfficiency = this.activeEfficiency >>> 7 % 32 | this.activeEfficiency << 32 - 7 % 32;
         this.activeConsumption = param1.readInt();
         this.activeConsumption = this.activeConsumption << 3 % 32 | this.activeConsumption >>> 32 - 3 % 32;
         this.inactiveConsumption = param1.readInt();
         this.inactiveConsumption = this.inactiveConsumption >>> 5 % 32 | this.inactiveConsumption << 32 - 5 % 32;
         this.activeEnergy = param1.readInt();
         this.activeEnergy = this.activeEnergy << 9 % 32 | this.activeEnergy >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14525);
         param1.writeInt(this.activeEfficiency << 7 % 32 | this.activeEfficiency >>> 32 - 7 % 32);
         param1.writeInt(this.activeConsumption >>> 3 % 32 | this.activeConsumption << 32 - 3 % 32);
         param1.writeInt(this.inactiveConsumption << 5 % 32 | this.inactiveConsumption >>> 32 - 5 % 32);
         param1.writeInt(this.activeEnergy >>> 9 % 32 | this.activeEnergy << 32 - 9 % 32);
      }
   }
}


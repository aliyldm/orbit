package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabMainViewModuleCommand implements IModule
   {
      
      private static var _instance:SkylabMainViewModuleCommand;
      
      public var maxLevel:int = 0;
      
      public var state:String = "";
      
      public var moduleType:String = "";
      
      public var efficiency:int = 0;
      
      public var currentPower:int = 0;
      
      public var maxPower:int = 0;
      
      public var level:int = 0;
      
      public function SkylabMainViewModuleCommand(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:String = "", param7:int = 0)
      {
         super();
         this.maxLevel = param3;
         this.state = param6;
         this.moduleType = param1;
         this.efficiency = param7;
         this.currentPower = param4;
         this.maxPower = param5;
         this.level = param2;
      }
      
      public static function get instance() : SkylabMainViewModuleCommand
      {
         return _instance || (_instance = new SkylabMainViewModuleCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14075;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.maxLevel = param1.readInt();
         this.maxLevel = this.maxLevel >>> 8 % 32 | this.maxLevel << 32 - 8 % 32;
         this.state = param1.readUTF();
         this.moduleType = param1.readUTF();
         this.efficiency = param1.readInt();
         this.efficiency = this.efficiency << 11 % 32 | this.efficiency >>> 32 - 11 % 32;
         this.currentPower = param1.readInt();
         this.currentPower = this.currentPower >>> 3 % 32 | this.currentPower << 32 - 3 % 32;
         this.maxPower = param1.readInt();
         this.maxPower = this.maxPower >>> 14 % 32 | this.maxPower << 32 - 14 % 32;
         this.level = param1.readInt();
         this.level = this.level << 5 % 32 | this.level >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14075);
         param1.writeInt(this.maxLevel << 8 % 32 | this.maxLevel >>> 32 - 8 % 32);
         param1.writeUTF(this.state);
         param1.writeUTF(this.moduleType);
         param1.writeInt(this.efficiency >>> 11 % 32 | this.efficiency << 32 - 11 % 32);
         param1.writeInt(this.currentPower << 3 % 32 | this.currentPower >>> 32 - 3 % 32);
         param1.writeInt(this.maxPower << 14 % 32 | this.maxPower >>> 32 - 14 % 32);
         param1.writeInt(this.level >>> 5 % 32 | this.level << 32 - 5 % 32);
      }
   }
}


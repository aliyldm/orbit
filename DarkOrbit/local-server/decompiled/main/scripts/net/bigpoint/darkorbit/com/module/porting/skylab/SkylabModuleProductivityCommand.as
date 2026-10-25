package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SkylabModuleProductivityCommand implements IModule
   {
      
      private static var _instance:SkylabModuleProductivityCommand;
      
      public var type1Price:SkylabRobotPriceCommand;
      
      public var efficienty:int = 0;
      
      public var active:int = 0;
      
      public var robotsLeftTimeList:Vector.<SkylabActiveRobotsLeftTimeCommand>;
      
      public var type2Price:SkylabRobotPriceCommand;
      
      public var bonus:int = 0;
      
      public var maxActive:int = 0;
      
      public var inStorage:int = 0;
      
      public function SkylabModuleProductivityCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:SkylabRobotPriceCommand = null, param7:SkylabRobotPriceCommand = null, param8:Vector.<SkylabActiveRobotsLeftTimeCommand> = null)
      {
         super();
         if(param6 == null)
         {
            this.type1Price = new SkylabRobotPriceCommand();
         }
         else
         {
            this.type1Price = param6;
         }
         this.efficienty = param1;
         this.active = param3;
         if(param8 == null)
         {
            this.robotsLeftTimeList = new Vector.<SkylabActiveRobotsLeftTimeCommand>();
         }
         else
         {
            this.robotsLeftTimeList = param8;
         }
         if(param7 == null)
         {
            this.type2Price = new SkylabRobotPriceCommand();
         }
         else
         {
            this.type2Price = param7;
         }
         this.bonus = param2;
         this.maxActive = param4;
         this.inStorage = param5;
      }
      
      public static function get instance() : SkylabModuleProductivityCommand
      {
         return _instance || (_instance = new SkylabModuleProductivityCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16096;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SkylabActiveRobotsLeftTimeCommand = null;
         this.type1Price = SkylabRobotPriceCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type1Price)
         {
            this.type1Price.read(param1);
         }
         this.efficienty = param1.readInt();
         this.efficienty = this.efficienty >>> 8 % 32 | this.efficienty << 32 - 8 % 32;
         this.active = param1.readInt();
         this.active = this.active >>> 3 % 32 | this.active << 32 - 3 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.robotsLeftTimeList.length > 0)
         {
            this.robotsLeftTimeList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SkylabActiveRobotsLeftTimeCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.robotsLeftTimeList.push(_loc4_);
            _loc2_++;
         }
         this.type2Price = SkylabRobotPriceCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.type2Price)
         {
            this.type2Price.read(param1);
         }
         this.bonus = param1.readInt();
         this.bonus = this.bonus >>> 8 % 32 | this.bonus << 32 - 8 % 32;
         this.maxActive = param1.readInt();
         this.maxActive = this.maxActive << 10 % 32 | this.maxActive >>> 32 - 10 % 32;
         this.inStorage = param1.readInt();
         this.inStorage = this.inStorage << 15 % 32 | this.inStorage >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SkylabActiveRobotsLeftTimeCommand = null;
         param1.writeShort(16096);
         if(null != this.type1Price)
         {
            this.type1Price.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.efficienty << 8 % 32 | this.efficienty >>> 32 - 8 % 32);
         param1.writeInt(this.active << 3 % 32 | this.active >>> 32 - 3 % 32);
         param1.writeByte(this.robotsLeftTimeList.length);
         for each(_loc2_ in this.robotsLeftTimeList)
         {
            _loc2_.write(param1);
         }
         if(null != this.type2Price)
         {
            this.type2Price.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.bonus << 8 % 32 | this.bonus >>> 32 - 8 % 32);
         param1.writeInt(this.maxActive >>> 10 % 32 | this.maxActive << 32 - 10 % 32);
         param1.writeInt(this.inStorage >>> 15 % 32 | this.inStorage << 32 - 15 % 32);
      }
   }
}


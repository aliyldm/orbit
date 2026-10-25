package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class ResetSkillTreeCommand implements IModule
   {
      
      private static var _instance:ResetSkillTreeCommand;
      
      public var resetPrice:int = 0;
      
      public var stack:BaseStackCommand;
      
      public var list:Vector.<SkillTreeInfoCommand>;
      
      public var logFiles:int = 0;
      
      public var researchPoints:int = 0;
      
      public var resetCount:int = 0;
      
      public var success:Boolean = false;
      
      public function ResetSkillTreeCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:Vector.<SkillTreeInfoCommand> = null)
      {
         super();
         this.resetPrice = param6;
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
         if(param7 == null)
         {
            this.list = new Vector.<SkillTreeInfoCommand>();
         }
         else
         {
            this.list = param7;
         }
         this.logFiles = param3;
         this.researchPoints = param4;
         this.resetCount = param5;
         this.success = param1;
      }
      
      public static function get instance() : ResetSkillTreeCommand
      {
         return _instance || (_instance = new ResetSkillTreeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 25633;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 21;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SkillTreeInfoCommand = null;
         this.resetPrice = param1.readInt();
         this.resetPrice = this.resetPrice >>> 4 % 32 | this.resetPrice << 32 - 4 % 32;
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SkillTreeInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.list.push(_loc4_);
            _loc2_++;
         }
         this.logFiles = param1.readInt();
         this.logFiles = this.logFiles >>> 13 % 32 | this.logFiles << 32 - 13 % 32;
         this.researchPoints = param1.readInt();
         this.researchPoints = this.researchPoints << 2 % 32 | this.researchPoints >>> 32 - 2 % 32;
         this.resetCount = param1.readInt();
         this.resetCount = this.resetCount >>> 16 % 32 | this.resetCount << 32 - 16 % 32;
         this.success = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SkillTreeInfoCommand = null;
         param1.writeShort(25633);
         param1.writeInt(this.resetPrice << 4 % 32 | this.resetPrice >>> 32 - 4 % 32);
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.logFiles << 13 % 32 | this.logFiles >>> 32 - 13 % 32);
         param1.writeInt(this.researchPoints >>> 2 % 32 | this.researchPoints << 32 - 2 % 32);
         param1.writeInt(this.resetCount << 16 % 32 | this.resetCount >>> 32 - 16 % 32);
         param1.writeBoolean(this.success);
      }
   }
}


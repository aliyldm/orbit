package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SkillTreeListCommand implements IModule
   {
      
      private static var _instance:SkillTreeListCommand;
      
      public var resetPrice:int = 0;
      
      public var list:Vector.<SkillTreeInfoCommand>;
      
      public var researchPoints:int = 0;
      
      public var resetCount:int = 0;
      
      public var logFiles:int = 0;
      
      public var required:int = 0;
      
      public function SkillTreeListCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Vector.<SkillTreeInfoCommand> = null)
      {
         super();
         this.resetPrice = param4;
         if(param6 == null)
         {
            this.list = new Vector.<SkillTreeInfoCommand>();
         }
         else
         {
            this.list = param6;
         }
         this.researchPoints = param2;
         this.resetCount = param3;
         this.logFiles = param1;
         this.required = param5;
      }
      
      public static function get instance() : SkillTreeListCommand
      {
         return _instance || (_instance = new SkillTreeListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26180;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SkillTreeInfoCommand = null;
         this.resetPrice = param1.readInt();
         this.resetPrice = this.resetPrice >>> 15 % 32 | this.resetPrice << 32 - 15 % 32;
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
         this.researchPoints = param1.readInt();
         this.researchPoints = this.researchPoints >>> 16 % 32 | this.researchPoints << 32 - 16 % 32;
         this.resetCount = param1.readInt();
         this.resetCount = this.resetCount << 2 % 32 | this.resetCount >>> 32 - 2 % 32;
         this.logFiles = param1.readInt();
         this.logFiles = this.logFiles >>> 7 % 32 | this.logFiles << 32 - 7 % 32;
         this.required = param1.readInt();
         this.required = this.required << 13 % 32 | this.required >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SkillTreeInfoCommand = null;
         param1.writeShort(26180);
         param1.writeInt(this.resetPrice << 15 % 32 | this.resetPrice >>> 32 - 15 % 32);
         param1.writeByte(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.researchPoints << 16 % 32 | this.researchPoints >>> 32 - 16 % 32);
         param1.writeInt(this.resetCount >>> 2 % 32 | this.resetCount << 32 - 2 % 32);
         param1.writeInt(this.logFiles << 7 % 32 | this.logFiles >>> 32 - 7 % 32);
         param1.writeInt(this.required >>> 13 % 32 | this.required << 32 - 13 % 32);
      }
   }
}


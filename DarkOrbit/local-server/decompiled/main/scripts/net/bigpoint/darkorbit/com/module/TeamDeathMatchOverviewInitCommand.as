package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchOverviewInitCommand implements IModule
   {
      
      private static var _instance:TeamDeathMatchOverviewInitCommand;
      
      public var minLevel:int = 0;
      
      public var maxLevel:int = 0;
      
      public var queuedForMatch:int = 0;
      
      public var overviewModules:Vector.<TeamDeathMatchOverviewModule>;
      
      public function TeamDeathMatchOverviewInitCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:Vector.<TeamDeathMatchOverviewModule> = null)
      {
         super();
         this.minLevel = param1;
         this.maxLevel = param2;
         this.queuedForMatch = param3;
         if(param4 == null)
         {
            this.overviewModules = new Vector.<TeamDeathMatchOverviewModule>();
         }
         else
         {
            this.overviewModules = param4;
         }
      }
      
      public static function get instance() : TeamDeathMatchOverviewInitCommand
      {
         return _instance || (_instance = new TeamDeathMatchOverviewInitCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2521;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TeamDeathMatchOverviewModule = null;
         this.minLevel = param1.readInt();
         this.minLevel = this.minLevel << 7 % 32 | this.minLevel >>> 32 - 7 % 32;
         this.maxLevel = param1.readInt();
         this.maxLevel = this.maxLevel << 2 % 32 | this.maxLevel >>> 32 - 2 % 32;
         this.queuedForMatch = param1.readInt();
         this.queuedForMatch = this.queuedForMatch << 3 % 32 | this.queuedForMatch >>> 32 - 3 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.overviewModules.length > 0)
         {
            this.overviewModules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TeamDeathMatchOverviewModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.overviewModules.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TeamDeathMatchOverviewModule = null;
         param1.writeShort(2521);
         param1.writeInt(this.minLevel >>> 7 % 32 | this.minLevel << 32 - 7 % 32);
         param1.writeInt(this.maxLevel >>> 2 % 32 | this.maxLevel << 32 - 2 % 32);
         param1.writeInt(this.queuedForMatch >>> 3 % 32 | this.queuedForMatch << 32 - 3 % 32);
         param1.writeByte(this.overviewModules.length);
         for each(_loc2_ in this.overviewModules)
         {
            _loc2_.write(param1);
         }
      }
   }
}


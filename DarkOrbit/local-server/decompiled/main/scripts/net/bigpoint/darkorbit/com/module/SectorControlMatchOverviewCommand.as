package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchOverviewCommand implements IModule
   {
      
      private static var _instance:SectorControlMatchOverviewCommand;
      
      public var minLevel:int = 0;
      
      public var maxLevel:int = 0;
      
      public var minPlayersPerTeam:int = 0;
      
      public var queuedForMatch:int = 0;
      
      public var overviewModules:Vector.<SectorControlMatchOverviewModule>;
      
      public function SectorControlMatchOverviewCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Vector.<SectorControlMatchOverviewModule> = null)
      {
         super();
         this.minLevel = param1;
         this.maxLevel = param2;
         this.minPlayersPerTeam = param3;
         this.queuedForMatch = param4;
         if(param5 == null)
         {
            this.overviewModules = new Vector.<SectorControlMatchOverviewModule>();
         }
         else
         {
            this.overviewModules = param5;
         }
      }
      
      public static function get instance() : SectorControlMatchOverviewCommand
      {
         return _instance || (_instance = new SectorControlMatchOverviewCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 521;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SectorControlMatchOverviewModule = null;
         this.minLevel = param1.readInt();
         this.minLevel = this.minLevel >>> 2 % 32 | this.minLevel << 32 - 2 % 32;
         this.maxLevel = param1.readInt();
         this.maxLevel = this.maxLevel << 7 % 32 | this.maxLevel >>> 32 - 7 % 32;
         this.minPlayersPerTeam = param1.readInt();
         this.minPlayersPerTeam = this.minPlayersPerTeam << 11 % 32 | this.minPlayersPerTeam >>> 32 - 11 % 32;
         this.queuedForMatch = param1.readInt();
         this.queuedForMatch = this.queuedForMatch >>> 3 % 32 | this.queuedForMatch << 32 - 3 % 32;
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
            _loc4_ = SectorControlMatchOverviewModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.overviewModules.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SectorControlMatchOverviewModule = null;
         param1.writeShort(521);
         param1.writeInt(this.minLevel << 2 % 32 | this.minLevel >>> 32 - 2 % 32);
         param1.writeInt(this.maxLevel >>> 7 % 32 | this.maxLevel << 32 - 7 % 32);
         param1.writeInt(this.minPlayersPerTeam >>> 11 % 32 | this.minPlayersPerTeam << 32 - 11 % 32);
         param1.writeInt(this.queuedForMatch << 3 % 32 | this.queuedForMatch >>> 32 - 3 % 32);
         param1.writeByte(this.overviewModules.length);
         for each(_loc2_ in this.overviewModules)
         {
            _loc2_.write(param1);
         }
      }
   }
}


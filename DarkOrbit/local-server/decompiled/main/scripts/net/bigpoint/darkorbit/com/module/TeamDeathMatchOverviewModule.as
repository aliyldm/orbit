package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchOverviewModule implements IModule
   {
      
      private static var _instance:TeamDeathMatchOverviewModule;
      
      public static const MATCHSTATE_MATCH_MAKING:int = 0;
      
      public static const MATCHSTATE_RUNNING:int = 1;
      
      public static const MATCHSTATE__MAX:int = 2;
      
      public var matchId:int = 0;
      
      public var opponent:FactionModule;
      
      public var matchState:int = 0;
      
      public var playersInOwnTeam:int = 0;
      
      public var maxPlayerPerTeam:int = 0;
      
      public var pointsOfOwnTeam:int = 0;
      
      public var pointsOfOpponentTeam:int = 0;
      
      public var playersInQueue:int = 0;
      
      public function TeamDeathMatchOverviewModule(param1:int = 0, param2:FactionModule = null, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0)
      {
         super();
         this.matchId = param1;
         if(param2 == null)
         {
            this.opponent = new FactionModule();
         }
         else
         {
            this.opponent = param2;
         }
         this.matchState = param3;
         this.playersInOwnTeam = param4;
         this.maxPlayerPerTeam = param5;
         this.pointsOfOwnTeam = param6;
         this.pointsOfOpponentTeam = param7;
         this.playersInQueue = param8;
      }
      
      public static function get instance() : TeamDeathMatchOverviewModule
      {
         return _instance || (_instance = new TeamDeathMatchOverviewModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1523;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.matchId = param1.readInt();
         this.matchId = this.matchId << 14 % 32 | this.matchId >>> 32 - 14 % 32;
         this.opponent = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.opponent)
         {
            this.opponent.read(param1);
         }
         this.matchState = param1.readShort();
         this.playersInOwnTeam = param1.readInt();
         this.playersInOwnTeam = this.playersInOwnTeam << 7 % 32 | this.playersInOwnTeam >>> 32 - 7 % 32;
         this.maxPlayerPerTeam = param1.readInt();
         this.maxPlayerPerTeam = this.maxPlayerPerTeam << 10 % 32 | this.maxPlayerPerTeam >>> 32 - 10 % 32;
         this.pointsOfOwnTeam = param1.readInt();
         this.pointsOfOwnTeam = this.pointsOfOwnTeam >>> 13 % 32 | this.pointsOfOwnTeam << 32 - 13 % 32;
         this.pointsOfOpponentTeam = param1.readInt();
         this.pointsOfOpponentTeam = this.pointsOfOpponentTeam << 11 % 32 | this.pointsOfOpponentTeam >>> 32 - 11 % 32;
         this.playersInQueue = param1.readInt();
         this.playersInQueue = this.playersInQueue >>> 4 % 32 | this.playersInQueue << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1523);
         param1.writeInt(this.matchId >>> 14 % 32 | this.matchId << 32 - 14 % 32);
         if(null != this.opponent)
         {
            this.opponent.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.matchState);
         param1.writeInt(this.playersInOwnTeam >>> 7 % 32 | this.playersInOwnTeam << 32 - 7 % 32);
         param1.writeInt(this.maxPlayerPerTeam >>> 10 % 32 | this.maxPlayerPerTeam << 32 - 10 % 32);
         param1.writeInt(this.pointsOfOwnTeam << 13 % 32 | this.pointsOfOwnTeam >>> 32 - 13 % 32);
         param1.writeInt(this.pointsOfOpponentTeam >>> 11 % 32 | this.pointsOfOpponentTeam << 32 - 11 % 32);
         param1.writeInt(this.playersInQueue << 4 % 32 | this.playersInQueue >>> 32 - 4 % 32);
      }
   }
}


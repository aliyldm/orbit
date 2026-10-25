package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchDetailCommand implements IModule
   {
      
      private static var _instance:TeamDeathMatchDetailCommand;
      
      public var matchId:int = 0;
      
      public var ownFaction:FactionModule;
      
      public var opponentFaction:FactionModule;
      
      public var playersInOwnTeam:int = 0;
      
      public var playersInOpponentTeam:int = 0;
      
      public var pointsOfOwnTeam:int = 0;
      
      public var pointsOfOpponentTeam:int = 0;
      
      public var minPlayersPerTeam:int = 0;
      
      public var maxPlayersPerTeam:int = 0;
      
      public var remainingTimeInSecs:int = 0;
      
      public var maxTimeInSecs:int = 0;
      
      public function TeamDeathMatchDetailCommand(param1:int = 0, param2:FactionModule = null, param3:FactionModule = null, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0)
      {
         super();
         this.matchId = param1;
         if(param2 == null)
         {
            this.ownFaction = new FactionModule();
         }
         else
         {
            this.ownFaction = param2;
         }
         if(param3 == null)
         {
            this.opponentFaction = new FactionModule();
         }
         else
         {
            this.opponentFaction = param3;
         }
         this.playersInOwnTeam = param4;
         this.playersInOpponentTeam = param5;
         this.pointsOfOwnTeam = param6;
         this.pointsOfOpponentTeam = param7;
         this.minPlayersPerTeam = param8;
         this.maxPlayersPerTeam = param9;
         this.remainingTimeInSecs = param10;
         this.maxTimeInSecs = param11;
      }
      
      public static function get instance() : TeamDeathMatchDetailCommand
      {
         return _instance || (_instance = new TeamDeathMatchDetailCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1527;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 36;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.matchId = param1.readInt();
         this.matchId = this.matchId << 7 % 32 | this.matchId >>> 32 - 7 % 32;
         this.ownFaction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.ownFaction)
         {
            this.ownFaction.read(param1);
         }
         this.opponentFaction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.opponentFaction)
         {
            this.opponentFaction.read(param1);
         }
         this.playersInOwnTeam = param1.readInt();
         this.playersInOwnTeam = this.playersInOwnTeam << 12 % 32 | this.playersInOwnTeam >>> 32 - 12 % 32;
         this.playersInOpponentTeam = param1.readInt();
         this.playersInOpponentTeam = this.playersInOpponentTeam >>> 3 % 32 | this.playersInOpponentTeam << 32 - 3 % 32;
         this.pointsOfOwnTeam = param1.readInt();
         this.pointsOfOwnTeam = this.pointsOfOwnTeam << 8 % 32 | this.pointsOfOwnTeam >>> 32 - 8 % 32;
         this.pointsOfOpponentTeam = param1.readInt();
         this.pointsOfOpponentTeam = this.pointsOfOpponentTeam >>> 9 % 32 | this.pointsOfOpponentTeam << 32 - 9 % 32;
         this.minPlayersPerTeam = param1.readInt();
         this.minPlayersPerTeam = this.minPlayersPerTeam << 4 % 32 | this.minPlayersPerTeam >>> 32 - 4 % 32;
         this.maxPlayersPerTeam = param1.readInt();
         this.maxPlayersPerTeam = this.maxPlayersPerTeam >>> 11 % 32 | this.maxPlayersPerTeam << 32 - 11 % 32;
         this.remainingTimeInSecs = param1.readInt();
         this.remainingTimeInSecs = this.remainingTimeInSecs << 4 % 32 | this.remainingTimeInSecs >>> 32 - 4 % 32;
         this.maxTimeInSecs = param1.readInt();
         this.maxTimeInSecs = this.maxTimeInSecs << 14 % 32 | this.maxTimeInSecs >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1527);
         param1.writeInt(this.matchId >>> 7 % 32 | this.matchId << 32 - 7 % 32);
         if(null != this.ownFaction)
         {
            this.ownFaction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.opponentFaction)
         {
            this.opponentFaction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.playersInOwnTeam >>> 12 % 32 | this.playersInOwnTeam << 32 - 12 % 32);
         param1.writeInt(this.playersInOpponentTeam << 3 % 32 | this.playersInOpponentTeam >>> 32 - 3 % 32);
         param1.writeInt(this.pointsOfOwnTeam >>> 8 % 32 | this.pointsOfOwnTeam << 32 - 8 % 32);
         param1.writeInt(this.pointsOfOpponentTeam << 9 % 32 | this.pointsOfOpponentTeam >>> 32 - 9 % 32);
         param1.writeInt(this.minPlayersPerTeam >>> 4 % 32 | this.minPlayersPerTeam << 32 - 4 % 32);
         param1.writeInt(this.maxPlayersPerTeam << 11 % 32 | this.maxPlayersPerTeam >>> 32 - 11 % 32);
         param1.writeInt(this.remainingTimeInSecs >>> 4 % 32 | this.remainingTimeInSecs << 32 - 4 % 32);
         param1.writeInt(this.maxTimeInSecs >>> 14 % 32 | this.maxTimeInSecs << 32 - 14 % 32);
      }
   }
}


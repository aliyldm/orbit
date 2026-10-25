package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArenaStatusCommand implements IModule
   {
      
      private static var _instance:ArenaStatusCommand;
      
      public static const MATCHSTATUS_SCHEDULED:int = 0;
      
      public static const MATCHSTATUS_WAITING_FOR_PLAYERS:int = 1;
      
      public static const MATCHSTATUS_COUNTDOWN:int = 2;
      
      public static const MATCHSTATUS_FIGHTING:int = 3;
      
      public static const MATCHSTATUS_RADIATION_ACTIVE:int = 4;
      
      public static const MATCHSTATUS_DONE:int = 5;
      
      public static const MATCHSTATUS_DESTROYABLE:int = 6;
      
      public static const MATCHSTATUS_NONE:int = 7;
      
      public static const MATCHSTATUS__MAX:int = 8;
      
      public static const ARENATYPE_JACKPOT:int = 0;
      
      public static const ARENATYPE__MAX:int = 1;
      
      public var opponentId:int = 0;
      
      public var opponentInstanceId:int = 0;
      
      public var warpWarningOffsetSeconds:int = 0;
      
      public var status:int = 0;
      
      public var arenaType:int = 0;
      
      public var opponentName:String = "";
      
      public var secondsLeftInPhase:int = 0;
      
      public var currentRound:int = 0;
      
      public var participants:int = 0;
      
      public var survivors:int = 0;
      
      public function ArenaStatusCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:String = "", param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0)
      {
         super();
         this.opponentId = param7;
         this.opponentInstanceId = param8;
         this.warpWarningOffsetSeconds = param10;
         this.status = param2;
         this.arenaType = param1;
         this.opponentName = param6;
         this.secondsLeftInPhase = param9;
         this.currentRound = param3;
         this.participants = param5;
         this.survivors = param4;
      }
      
      public static function get instance() : ArenaStatusCommand
      {
         return _instance || (_instance = new ArenaStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1736;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 30;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.opponentId = param1.readInt();
         this.opponentId = this.opponentId >>> 14 % 32 | this.opponentId << 32 - 14 % 32;
         this.opponentInstanceId = param1.readInt();
         this.opponentInstanceId = this.opponentInstanceId >>> 8 % 32 | this.opponentInstanceId << 32 - 8 % 32;
         this.warpWarningOffsetSeconds = param1.readInt();
         this.warpWarningOffsetSeconds = this.warpWarningOffsetSeconds << 13 % 32 | this.warpWarningOffsetSeconds >>> 32 - 13 % 32;
         this.status = param1.readShort();
         this.arenaType = param1.readShort();
         this.opponentName = param1.readUTF();
         this.secondsLeftInPhase = param1.readInt();
         this.secondsLeftInPhase = this.secondsLeftInPhase >>> 13 % 32 | this.secondsLeftInPhase << 32 - 13 % 32;
         this.currentRound = param1.readInt();
         this.currentRound = this.currentRound >>> 4 % 32 | this.currentRound << 32 - 4 % 32;
         this.participants = param1.readInt();
         this.participants = this.participants >>> 16 % 32 | this.participants << 32 - 16 % 32;
         this.survivors = param1.readInt();
         this.survivors = this.survivors << 10 % 32 | this.survivors >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1736);
         param1.writeInt(this.opponentId << 14 % 32 | this.opponentId >>> 32 - 14 % 32);
         param1.writeInt(this.opponentInstanceId << 8 % 32 | this.opponentInstanceId >>> 32 - 8 % 32);
         param1.writeInt(this.warpWarningOffsetSeconds >>> 13 % 32 | this.warpWarningOffsetSeconds << 32 - 13 % 32);
         param1.writeShort(this.status);
         param1.writeShort(this.arenaType);
         param1.writeUTF(this.opponentName);
         param1.writeInt(this.secondsLeftInPhase << 13 % 32 | this.secondsLeftInPhase >>> 32 - 13 % 32);
         param1.writeInt(this.currentRound << 4 % 32 | this.currentRound >>> 32 - 4 % 32);
         param1.writeInt(this.participants << 16 % 32 | this.participants >>> 32 - 16 % 32);
         param1.writeInt(this.survivors >>> 10 % 32 | this.survivors << 32 - 10 % 32);
      }
   }
}


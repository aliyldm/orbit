package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchOverviewModule implements IModule
   {
      
      private static var _instance:SectorControlMatchOverviewModule;
      
      public static const MATCHSTATE_MATCH_MAKING:int = 0;
      
      public static const MATCHSTATE_RUNNING:int = 1;
      
      public static const MATCHSTATE__MAX:int = 2;
      
      public var matchId:int = 0;
      
      public var matchState:int = 0;
      
      public var playersOfOwnFaction:int = 0;
      
      public var maxPlayerPerFaction:int = 0;
      
      public var remainingTickets:int = 0;
      
      public var totalTickets:int = 0;
      
      public var playersInQueue:int = 0;
      
      public function SectorControlMatchOverviewModule(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0)
      {
         super();
         this.matchId = param1;
         this.matchState = param2;
         this.playersOfOwnFaction = param3;
         this.maxPlayerPerFaction = param4;
         this.remainingTickets = param5;
         this.totalTickets = param6;
         this.playersInQueue = param7;
      }
      
      public static function get instance() : SectorControlMatchOverviewModule
      {
         return _instance || (_instance = new SectorControlMatchOverviewModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 523;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.matchId = param1.readInt();
         this.matchId = this.matchId >>> 9 % 32 | this.matchId << 32 - 9 % 32;
         this.matchState = param1.readShort();
         this.playersOfOwnFaction = param1.readInt();
         this.playersOfOwnFaction = this.playersOfOwnFaction >>> 12 % 32 | this.playersOfOwnFaction << 32 - 12 % 32;
         this.maxPlayerPerFaction = param1.readInt();
         this.maxPlayerPerFaction = this.maxPlayerPerFaction << 8 % 32 | this.maxPlayerPerFaction >>> 32 - 8 % 32;
         this.remainingTickets = param1.readInt();
         this.remainingTickets = this.remainingTickets >>> 1 % 32 | this.remainingTickets << 32 - 1 % 32;
         this.totalTickets = param1.readInt();
         this.totalTickets = this.totalTickets << 1 % 32 | this.totalTickets >>> 32 - 1 % 32;
         this.playersInQueue = param1.readInt();
         this.playersInQueue = this.playersInQueue >>> 7 % 32 | this.playersInQueue << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(523);
         param1.writeInt(this.matchId << 9 % 32 | this.matchId >>> 32 - 9 % 32);
         param1.writeShort(this.matchState);
         param1.writeInt(this.playersOfOwnFaction << 12 % 32 | this.playersOfOwnFaction >>> 32 - 12 % 32);
         param1.writeInt(this.maxPlayerPerFaction >>> 8 % 32 | this.maxPlayerPerFaction << 32 - 8 % 32);
         param1.writeInt(this.remainingTickets << 1 % 32 | this.remainingTickets >>> 32 - 1 % 32);
         param1.writeInt(this.totalTickets >>> 1 % 32 | this.totalTickets << 32 - 1 % 32);
         param1.writeInt(this.playersInQueue << 7 % 32 | this.playersInQueue >>> 32 - 7 % 32);
      }
   }
}


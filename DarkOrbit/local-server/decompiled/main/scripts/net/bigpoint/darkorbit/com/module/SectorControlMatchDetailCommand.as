package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchDetailCommand implements IModule
   {
      
      private static var _instance:SectorControlMatchDetailCommand;
      
      public var matchId:int = 0;
      
      public var ticketCounts:Vector.<SectorControlTicketCountCommand>;
      
      public var playerCounts:Vector.<SectorControlPlayerCountModule>;
      
      public var runningTimeInSecs:int = 0;
      
      public function SectorControlMatchDetailCommand(param1:int = 0, param2:Vector.<SectorControlTicketCountCommand> = null, param3:Vector.<SectorControlPlayerCountModule> = null, param4:int = 0)
      {
         super();
         this.matchId = param1;
         if(param2 == null)
         {
            this.ticketCounts = new Vector.<SectorControlTicketCountCommand>();
         }
         else
         {
            this.ticketCounts = param2;
         }
         if(param3 == null)
         {
            this.playerCounts = new Vector.<SectorControlPlayerCountModule>();
         }
         else
         {
            this.playerCounts = param3;
         }
         this.runningTimeInSecs = param4;
      }
      
      public static function get instance() : SectorControlMatchDetailCommand
      {
         return _instance || (_instance = new SectorControlMatchDetailCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 527;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SectorControlTicketCountCommand = null;
         var _loc5_:SectorControlPlayerCountModule = null;
         this.matchId = param1.readInt();
         this.matchId = this.matchId >>> 11 % 32 | this.matchId << 32 - 11 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ticketCounts.length > 0)
         {
            this.ticketCounts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SectorControlTicketCountCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ticketCounts.push(_loc4_);
            _loc2_++;
         }
         while(this.playerCounts.length > 0)
         {
            this.playerCounts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = SectorControlPlayerCountModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.playerCounts.push(_loc5_);
            _loc2_++;
         }
         this.runningTimeInSecs = param1.readInt();
         this.runningTimeInSecs = this.runningTimeInSecs << 12 % 32 | this.runningTimeInSecs >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SectorControlTicketCountCommand = null;
         var _loc3_:SectorControlPlayerCountModule = null;
         param1.writeShort(527);
         param1.writeInt(this.matchId << 11 % 32 | this.matchId >>> 32 - 11 % 32);
         param1.writeByte(this.ticketCounts.length);
         for each(_loc2_ in this.ticketCounts)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.playerCounts.length);
         for each(_loc3_ in this.playerCounts)
         {
            _loc3_.write(param1);
         }
         param1.writeInt(this.runningTimeInSecs >>> 12 % 32 | this.runningTimeInSecs << 32 - 12 % 32);
      }
   }
}


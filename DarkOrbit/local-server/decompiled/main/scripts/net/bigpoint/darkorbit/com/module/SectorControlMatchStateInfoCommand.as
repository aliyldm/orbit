package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchStateInfoCommand implements IModule
   {
      
      private static var _instance:SectorControlMatchStateInfoCommand;
      
      public var bonusInformation:Vector.<SectorControlBonusCommand>;
      
      public var ticketCounts:Vector.<SectorControlTicketCountCommand>;
      
      public var playerCounts:Vector.<SectorControlPlayerCountModule>;
      
      public function SectorControlMatchStateInfoCommand(param1:Vector.<SectorControlBonusCommand> = null, param2:Vector.<SectorControlTicketCountCommand> = null, param3:Vector.<SectorControlPlayerCountModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.bonusInformation = new Vector.<SectorControlBonusCommand>();
         }
         else
         {
            this.bonusInformation = param1;
         }
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
      }
      
      public static function get instance() : SectorControlMatchStateInfoCommand
      {
         return _instance || (_instance = new SectorControlMatchStateInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6667;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SectorControlBonusCommand = null;
         var _loc5_:SectorControlTicketCountCommand = null;
         var _loc6_:SectorControlPlayerCountModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.bonusInformation.length > 0)
         {
            this.bonusInformation.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SectorControlBonusCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.bonusInformation.push(_loc4_);
            _loc2_++;
         }
         while(this.ticketCounts.length > 0)
         {
            this.ticketCounts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = SectorControlTicketCountCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.ticketCounts.push(_loc5_);
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
            _loc6_ = SectorControlPlayerCountModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.playerCounts.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SectorControlBonusCommand = null;
         var _loc3_:SectorControlTicketCountCommand = null;
         var _loc4_:SectorControlPlayerCountModule = null;
         param1.writeShort(6667);
         param1.writeByte(this.bonusInformation.length);
         for each(_loc2_ in this.bonusInformation)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.ticketCounts.length);
         for each(_loc3_ in this.ticketCounts)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.playerCounts.length);
         for each(_loc4_ in this.playerCounts)
         {
            _loc4_.write(param1);
         }
      }
   }
}


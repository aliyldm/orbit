package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlTicketCountCommand implements IModule
   {
      
      private static var _instance:SectorControlTicketCountCommand;
      
      public var faction:FactionModule;
      
      public var ticketCount:int = 0;
      
      public var maxTickets:int = 0;
      
      public function SectorControlTicketCountCommand(param1:FactionModule = null, param2:int = 0, param3:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.faction = new FactionModule();
         }
         else
         {
            this.faction = param1;
         }
         this.ticketCount = param2;
         this.maxTickets = param3;
      }
      
      public static function get instance() : SectorControlTicketCountCommand
      {
         return _instance || (_instance = new SectorControlTicketCountCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6669;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.faction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.faction)
         {
            this.faction.read(param1);
         }
         this.ticketCount = param1.readInt();
         this.ticketCount = this.ticketCount << 9 % 32 | this.ticketCount >>> 32 - 9 % 32;
         this.maxTickets = param1.readInt();
         this.maxTickets = this.maxTickets << 5 % 32 | this.maxTickets >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6669);
         if(null != this.faction)
         {
            this.faction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.ticketCount >>> 9 % 32 | this.ticketCount << 32 - 9 % 32);
         param1.writeInt(this.maxTickets >>> 5 % 32 | this.maxTickets << 32 - 5 % 32);
      }
   }
}


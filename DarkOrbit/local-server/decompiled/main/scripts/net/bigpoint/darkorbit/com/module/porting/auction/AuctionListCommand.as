package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class AuctionListCommand implements IModule
   {
      
      private static var _instance:AuctionListCommand;
      
      public var weekSubSec:int = 0;
      
      public var hourSubSec:int = 0;
      
      public var historyList:Vector.<AuctionHistoryCommand>;
      
      public var daySubSec:int = 0;
      
      public var myBidList:Vector.<AuctionDataCommand>;
      
      public var auctionList:Vector.<AuctionDataCommand>;
      
      public function AuctionListCommand(param1:Vector.<AuctionDataCommand> = null, param2:Vector.<AuctionDataCommand> = null, param3:Vector.<AuctionHistoryCommand> = null, param4:int = 0, param5:int = 0, param6:int = 0)
      {
         super();
         this.weekSubSec = param6;
         this.hourSubSec = param4;
         if(param3 == null)
         {
            this.historyList = new Vector.<AuctionHistoryCommand>();
         }
         else
         {
            this.historyList = param3;
         }
         this.daySubSec = param5;
         if(param2 == null)
         {
            this.myBidList = new Vector.<AuctionDataCommand>();
         }
         else
         {
            this.myBidList = param2;
         }
         if(param1 == null)
         {
            this.auctionList = new Vector.<AuctionDataCommand>();
         }
         else
         {
            this.auctionList = param1;
         }
      }
      
      public static function get instance() : AuctionListCommand
      {
         return _instance || (_instance = new AuctionListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13360;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AuctionHistoryCommand = null;
         var _loc5_:AuctionDataCommand = null;
         var _loc6_:AuctionDataCommand = null;
         this.weekSubSec = param1.readInt();
         this.weekSubSec = this.weekSubSec << 12 % 32 | this.weekSubSec >>> 32 - 12 % 32;
         this.hourSubSec = param1.readInt();
         this.hourSubSec = this.hourSubSec << 3 % 32 | this.hourSubSec >>> 32 - 3 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.historyList.length > 0)
         {
            this.historyList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AuctionHistoryCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.historyList.push(_loc4_);
            _loc2_++;
         }
         this.daySubSec = param1.readInt();
         this.daySubSec = this.daySubSec >>> 4 % 32 | this.daySubSec << 32 - 4 % 32;
         while(this.myBidList.length > 0)
         {
            this.myBidList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = AuctionDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.myBidList.push(_loc5_);
            _loc2_++;
         }
         while(this.auctionList.length > 0)
         {
            this.auctionList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = AuctionDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.auctionList.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AuctionHistoryCommand = null;
         var _loc3_:AuctionDataCommand = null;
         var _loc4_:AuctionDataCommand = null;
         param1.writeShort(13360);
         param1.writeInt(this.weekSubSec >>> 12 % 32 | this.weekSubSec << 32 - 12 % 32);
         param1.writeInt(this.hourSubSec >>> 3 % 32 | this.hourSubSec << 32 - 3 % 32);
         param1.writeByte(this.historyList.length);
         for each(_loc2_ in this.historyList)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.daySubSec << 4 % 32 | this.daySubSec >>> 32 - 4 % 32);
         param1.writeByte(this.myBidList.length);
         for each(_loc3_ in this.myBidList)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.auctionList.length);
         for each(_loc4_ in this.auctionList)
         {
            _loc4_.write(param1);
         }
      }
   }
}


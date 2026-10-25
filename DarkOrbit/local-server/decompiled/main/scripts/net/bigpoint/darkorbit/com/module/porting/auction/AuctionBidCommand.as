package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class AuctionBidCommand implements IModule
   {
      
      private static var _instance:AuctionBidCommand;
      
      public var success:Boolean = false;
      
      public var myBid:AuctionDataCommand;
      
      public var curBid:AuctionDataCommand;
      
      public var stack:BaseStackCommand;
      
      public function AuctionBidCommand(param1:Boolean = false, param2:BaseStackCommand = null, param3:AuctionDataCommand = null, param4:AuctionDataCommand = null)
      {
         super();
         this.success = param1;
         if(param4 == null)
         {
            this.myBid = new AuctionDataCommand();
         }
         else
         {
            this.myBid = param4;
         }
         if(param3 == null)
         {
            this.curBid = new AuctionDataCommand();
         }
         else
         {
            this.curBid = param3;
         }
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
      }
      
      public static function get instance() : AuctionBidCommand
      {
         return _instance || (_instance = new AuctionBidCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25207;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.myBid = AuctionDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.myBid)
         {
            this.myBid.read(param1);
         }
         this.curBid = AuctionDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.curBid)
         {
            this.curBid.read(param1);
         }
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25207);
         param1.writeBoolean(this.success);
         if(null != this.myBid)
         {
            this.myBid.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.curBid)
         {
            this.curBid.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}


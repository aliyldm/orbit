package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class AuctionQuickBuyCommand implements IModule
   {
      
      private static var _instance:AuctionQuickBuyCommand;
      
      public var success:Boolean = false;
      
      public var stack:BaseStackCommand;
      
      public function AuctionQuickBuyCommand(param1:Boolean = false, param2:BaseStackCommand = null)
      {
         super();
         this.success = param1;
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
      }
      
      public static function get instance() : AuctionQuickBuyCommand
      {
         return _instance || (_instance = new AuctionQuickBuyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22423;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.success = param1.readBoolean();
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22423);
         param1.writeBoolean(this.success);
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


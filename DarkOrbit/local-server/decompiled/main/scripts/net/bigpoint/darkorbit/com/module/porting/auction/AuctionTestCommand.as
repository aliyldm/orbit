package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AuctionTestCommand implements IModule
   {
      
      private static var _instance:AuctionTestCommand;
      
      public var args:Vector.<String>;
      
      public function AuctionTestCommand(param1:Vector.<String> = null)
      {
         super();
         if(param1 == null)
         {
            this.args = new Vector.<String>();
         }
         else
         {
            this.args = param1;
         }
      }
      
      public static function get instance() : AuctionTestCommand
      {
         return _instance || (_instance = new AuctionTestCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16273;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.args.length > 0)
         {
            this.args.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.args.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(-16273);
         param1.writeByte(this.args.length);
         for each(_loc2_ in this.args)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}


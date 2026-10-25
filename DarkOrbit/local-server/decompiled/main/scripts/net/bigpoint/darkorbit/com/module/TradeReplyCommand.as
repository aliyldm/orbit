package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TradeReplyCommand implements IModule
   {
      
      private static var _instance:TradeReplyCommand;
      
      public var priceInfos:Vector.<OrePriceModule>;
      
      public function TradeReplyCommand(param1:Vector.<OrePriceModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.priceInfos = new Vector.<OrePriceModule>();
         }
         else
         {
            this.priceInfos = param1;
         }
      }
      
      public static function get instance() : TradeReplyCommand
      {
         return _instance || (_instance = new TradeReplyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 130;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:OrePriceModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.priceInfos.length > 0)
         {
            this.priceInfos.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = OrePriceModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.priceInfos.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:OrePriceModule = null;
         param1.writeShort(130);
         param1.writeByte(this.priceInfos.length);
         for each(_loc2_ in this.priceInfos)
         {
            _loc2_.write(param1);
         }
      }
   }
}


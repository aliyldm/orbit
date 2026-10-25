package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketInfoUpdateCommand implements IModule
   {
      
      private static var _instance:MileageMarketInfoUpdateCommand;
      
      public var coinCount:int = 0;
      
      public function MileageMarketInfoUpdateCommand(param1:int = 0)
      {
         super();
         this.coinCount = param1;
      }
      
      public static function get instance() : MileageMarketInfoUpdateCommand
      {
         return _instance || (_instance = new MileageMarketInfoUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16954;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.coinCount = param1.readInt();
         this.coinCount = this.coinCount << 11 % 32 | this.coinCount >>> 32 - 11 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16954);
         param1.writeInt(this.coinCount >>> 11 % 32 | this.coinCount << 32 - 11 % 32);
      }
   }
}


package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassKeyExchangeRequest implements IModule
   {
      
      private static var _instance:BattlePassKeyExchangeRequest;
      
      public var exchangeReward:String = "";
      
      public function BattlePassKeyExchangeRequest(param1:String = "")
      {
         super();
         this.exchangeReward = param1;
      }
      
      public static function get instance() : BattlePassKeyExchangeRequest
      {
         return _instance || (_instance = new BattlePassKeyExchangeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16874;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.exchangeReward = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16874);
         param1.writeUTF(this.exchangeReward);
      }
   }
}


package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassCollectRequest implements IModule
   {
      
      private static var _instance:BattlePassCollectRequest;
      
      public function BattlePassCollectRequest()
      {
         super();
      }
      
      public static function get instance() : BattlePassCollectRequest
      {
         return _instance || (_instance = new BattlePassCollectRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4688;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-4688);
      }
   }
}


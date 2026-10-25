package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteSelectRewardRequest implements IModule
   {
      
      private static var _instance:RogueLiteSelectRewardRequest;
      
      public var lootId:String = "";
      
      public function RogueLiteSelectRewardRequest(param1:String = "")
      {
         super();
         this.lootId = param1;
      }
      
      public static function get instance() : RogueLiteSelectRewardRequest
      {
         return _instance || (_instance = new RogueLiteSelectRewardRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4336;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-4336);
         param1.writeUTF(this.lootId);
      }
   }
}


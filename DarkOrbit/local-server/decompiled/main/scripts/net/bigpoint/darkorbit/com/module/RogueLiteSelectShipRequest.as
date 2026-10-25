package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteSelectShipRequest implements IModule
   {
      
      private static var _instance:RogueLiteSelectShipRequest;
      
      public var loadoutId:String = "";
      
      public function RogueLiteSelectShipRequest(param1:String = "")
      {
         super();
         this.loadoutId = param1;
      }
      
      public static function get instance() : RogueLiteSelectShipRequest
      {
         return _instance || (_instance = new RogueLiteSelectShipRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12101;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.loadoutId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12101);
         param1.writeUTF(this.loadoutId);
      }
   }
}


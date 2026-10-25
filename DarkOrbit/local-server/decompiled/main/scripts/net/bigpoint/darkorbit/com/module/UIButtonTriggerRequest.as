package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIButtonTriggerRequest implements IModule
   {
      
      private static var _instance:UIButtonTriggerRequest;
      
      public var itemId:String = "";
      
      public function UIButtonTriggerRequest(param1:String = "")
      {
         super();
         this.itemId = param1;
      }
      
      public static function get instance() : UIButtonTriggerRequest
      {
         return _instance || (_instance = new UIButtonTriggerRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24564;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24564);
         param1.writeUTF(this.itemId);
      }
   }
}


package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReturneeLoginBundleBuyRequest implements IModule
   {
      
      private static var _instance:ReturneeLoginBundleBuyRequest;
      
      public var packageId:String = "";
      
      public function ReturneeLoginBundleBuyRequest(param1:String = "")
      {
         super();
         this.packageId = param1;
      }
      
      public static function get instance() : ReturneeLoginBundleBuyRequest
      {
         return _instance || (_instance = new ReturneeLoginBundleBuyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10262;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.packageId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10262);
         param1.writeUTF(this.packageId);
      }
   }
}


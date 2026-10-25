package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MileageMarketPackageBuyRequest implements IModule
   {
      
      private static var _instance:MileageMarketPackageBuyRequest;
      
      public var packageId:String = "";
      
      public function MileageMarketPackageBuyRequest(param1:String = "")
      {
         super();
         this.packageId = param1;
      }
      
      public static function get instance() : MileageMarketPackageBuyRequest
      {
         return _instance || (_instance = new MileageMarketPackageBuyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11778;
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
         param1.writeShort(-11778);
         param1.writeUTF(this.packageId);
      }
   }
}


package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GetNamFIagRequest implements IModule
   {
      
      private static var _instance:GetNamFIagRequest;
      
      public function GetNamFIagRequest()
      {
         super();
      }
      
      public static function get instance() : GetNamFIagRequest
      {
         return _instance || (_instance = new GetNamFIagRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8408;
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
         param1.writeShort(8408);
      }
   }
}


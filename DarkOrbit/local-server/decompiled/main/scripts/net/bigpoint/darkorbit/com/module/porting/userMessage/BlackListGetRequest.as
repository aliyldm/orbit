package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BlackListGetRequest implements IModule
   {
      
      private static var _instance:BlackListGetRequest;
      
      public function BlackListGetRequest()
      {
         super();
      }
      
      public static function get instance() : BlackListGetRequest
      {
         return _instance || (_instance = new BlackListGetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22343;
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
         param1.writeShort(-22343);
      }
   }
}


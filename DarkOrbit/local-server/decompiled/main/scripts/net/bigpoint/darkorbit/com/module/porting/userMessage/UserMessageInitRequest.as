package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageInitRequest implements IModule
   {
      
      private static var _instance:UserMessageInitRequest;
      
      public function UserMessageInitRequest()
      {
         super();
      }
      
      public static function get instance() : UserMessageInitRequest
      {
         return _instance || (_instance = new UserMessageInitRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28994;
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
         param1.writeShort(28994);
      }
   }
}


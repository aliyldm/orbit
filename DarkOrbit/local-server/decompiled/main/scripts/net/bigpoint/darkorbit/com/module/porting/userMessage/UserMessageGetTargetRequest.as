package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UserMessageGetTargetRequest implements IModule
   {
      
      private static var _instance:UserMessageGetTargetRequest;
      
      public function UserMessageGetTargetRequest()
      {
         super();
      }
      
      public static function get instance() : UserMessageGetTargetRequest
      {
         return _instance || (_instance = new UserMessageGetTargetRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -26127;
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
         param1.writeShort(-26127);
      }
   }
}


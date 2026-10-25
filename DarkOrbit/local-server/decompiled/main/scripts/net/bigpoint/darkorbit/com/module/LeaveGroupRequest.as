package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LeaveGroupRequest implements IModule
   {
      
      private static var _instance:LeaveGroupRequest;
      
      public function LeaveGroupRequest()
      {
         super();
      }
      
      public static function get instance() : LeaveGroupRequest
      {
         return _instance || (_instance = new LeaveGroupRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11779;
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
         param1.writeShort(11779);
      }
   }
}


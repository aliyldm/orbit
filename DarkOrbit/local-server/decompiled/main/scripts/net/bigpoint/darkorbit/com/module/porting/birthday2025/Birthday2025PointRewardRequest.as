package net.bigpoint.darkorbit.com.module.porting.birthday2025
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class Birthday2025PointRewardRequest implements IModule
   {
      
      private static var _instance:Birthday2025PointRewardRequest;
      
      public var openWindow:Boolean = false;
      
      public function Birthday2025PointRewardRequest(param1:Boolean = false)
      {
         super();
         this.openWindow = param1;
      }
      
      public static function get instance() : Birthday2025PointRewardRequest
      {
         return _instance || (_instance = new Birthday2025PointRewardRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31954;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.openWindow = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31954);
         param1.writeBoolean(this.openWindow);
      }
   }
}


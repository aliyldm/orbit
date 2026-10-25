package net.bigpoint.darkorbit.com.module.liveops.europeanCup
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReqDroneBoostInfo implements IModule
   {
      
      private static var _instance:ReqDroneBoostInfo;
      
      public function ReqDroneBoostInfo()
      {
         super();
      }
      
      public static function get instance() : ReqDroneBoostInfo
      {
         return _instance || (_instance = new ReqDroneBoostInfo());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5738;
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
         param1.writeShort(5738);
      }
   }
}


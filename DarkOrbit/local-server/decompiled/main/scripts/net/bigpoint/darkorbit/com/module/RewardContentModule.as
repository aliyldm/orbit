package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RewardContentModule implements IModule
   {
      
      private static var _instance:RewardContentModule;
      
      public function RewardContentModule()
      {
         super();
      }
      
      public static function get instance() : RewardContentModule
      {
         return _instance || (_instance = new RewardContentModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5305;
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
         param1.writeShort(5305);
      }
   }
}


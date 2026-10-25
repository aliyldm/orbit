package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlMatchOverviewRequest implements IModule
   {
      
      private static var _instance:SectorControlMatchOverviewRequest;
      
      public function SectorControlMatchOverviewRequest()
      {
         super();
      }
      
      public static function get instance() : SectorControlMatchOverviewRequest
      {
         return _instance || (_instance = new SectorControlMatchOverviewRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 520;
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
         param1.writeShort(520);
      }
   }
}


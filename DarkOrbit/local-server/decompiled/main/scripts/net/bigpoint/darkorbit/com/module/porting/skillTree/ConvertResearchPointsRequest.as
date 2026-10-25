package net.bigpoint.darkorbit.com.module.porting.skillTree
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ConvertResearchPointsRequest implements IModule
   {
      
      private static var _instance:ConvertResearchPointsRequest;
      
      public function ConvertResearchPointsRequest()
      {
         super();
      }
      
      public static function get instance() : ConvertResearchPointsRequest
      {
         return _instance || (_instance = new ConvertResearchPointsRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31223;
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
         param1.writeShort(-31223);
      }
   }
}


package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CompanyHierarchyRequest implements IModule
   {
      
      private static var _instance:CompanyHierarchyRequest;
      
      public function CompanyHierarchyRequest()
      {
         super();
      }
      
      public static function get instance() : CompanyHierarchyRequest
      {
         return _instance || (_instance = new CompanyHierarchyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6009;
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
         param1.writeShort(6009);
      }
   }
}


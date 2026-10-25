package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCAbstractRangeModule implements IModule
   {
      
      private static var _instance:CCAbstractRangeModule;
      
      public function CCAbstractRangeModule()
      {
         super();
      }
      
      public static function get instance() : CCAbstractRangeModule
      {
         return _instance || (_instance = new CCAbstractRangeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28819;
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
         param1.writeShort(28819);
      }
   }
}


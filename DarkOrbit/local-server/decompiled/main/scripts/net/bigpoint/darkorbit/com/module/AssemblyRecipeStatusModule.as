package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeStatusModule implements IModule
   {
      
      private static var _instance:AssemblyRecipeStatusModule;
      
      public function AssemblyRecipeStatusModule()
      {
         super();
      }
      
      public static function get instance() : AssemblyRecipeStatusModule
      {
         return _instance || (_instance = new AssemblyRecipeStatusModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20425;
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
         param1.writeShort(20425);
      }
   }
}


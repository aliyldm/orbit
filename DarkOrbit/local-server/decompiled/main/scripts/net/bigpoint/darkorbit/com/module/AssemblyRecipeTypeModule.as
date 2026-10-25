package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeTypeModule implements IModule
   {
      
      private static var _instance:AssemblyRecipeTypeModule;
      
      public function AssemblyRecipeTypeModule()
      {
         super();
      }
      
      public static function get instance() : AssemblyRecipeTypeModule
      {
         return _instance || (_instance = new AssemblyRecipeTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 30536;
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
         param1.writeShort(30536);
      }
   }
}


package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AssemblyRecipeRegularTypeModule extends AssemblyRecipeTypeModule
   {
      
      private static var _instance:AssemblyRecipeRegularTypeModule;
      
      public function AssemblyRecipeRegularTypeModule()
      {
         super();
      }
      
      public static function get instance() : AssemblyRecipeRegularTypeModule
      {
         return _instance || (_instance = new AssemblyRecipeRegularTypeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 14903;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14903);
         super.write(param1);
      }
   }
}


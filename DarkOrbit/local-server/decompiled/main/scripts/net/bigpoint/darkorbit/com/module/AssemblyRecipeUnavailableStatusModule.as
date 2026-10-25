package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AssemblyRecipeUnavailableStatusModule extends AssemblyRecipeStatusModule
   {
      
      private static var _instance:AssemblyRecipeUnavailableStatusModule;
      
      public static const RECIPEUNAVAILABLETYPE_ALREADY_OWNS_ITEM_MAX_AMOUNT:int = 0;
      
      public static const RECIPEUNAVAILABLETYPE_ALREADY_USED_RECIPE:int = 1;
      
      public static const RECIPEUNAVAILABLETYPE_ALREADY_USED_RECIPE_LIMIT:int = 2;
      
      public static const RECIPEUNAVAILABLETYPE__MAX:int = 3;
      
      public var type:int = 0;
      
      public function AssemblyRecipeUnavailableStatusModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : AssemblyRecipeUnavailableStatusModule
      {
         return _instance || (_instance = new AssemblyRecipeUnavailableStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -11096;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.type = param1.readShort();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11096);
         super.write(param1);
         param1.writeShort(this.type);
      }
   }
}


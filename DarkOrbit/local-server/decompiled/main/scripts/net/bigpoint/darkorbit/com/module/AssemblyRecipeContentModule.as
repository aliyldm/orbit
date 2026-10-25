package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeContentModule implements IModule
   {
      
      private static var _instance:AssemblyRecipeContentModule;
      
      public var recipes:Vector.<AssemblyRecipeModule>;
      
      public function AssemblyRecipeContentModule(param1:Vector.<AssemblyRecipeModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.recipes = new Vector.<AssemblyRecipeModule>();
         }
         else
         {
            this.recipes = param1;
         }
      }
      
      public static function get instance() : AssemblyRecipeContentModule
      {
         return _instance || (_instance = new AssemblyRecipeContentModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1655;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AssemblyRecipeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.recipes.length > 0)
         {
            this.recipes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = AssemblyRecipeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.recipes.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AssemblyRecipeModule = null;
         param1.writeShort(-1655);
         param1.writeShort(this.recipes.length);
         for each(_loc2_ in this.recipes)
         {
            _loc2_.write(param1);
         }
      }
   }
}


package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyRecipeRemoveCommand implements IModule
   {
      
      private static var _instance:AssemblyRecipeRemoveCommand;
      
      public var recipes:Vector.<AssemblyRecipeKeyModule>;
      
      public function AssemblyRecipeRemoveCommand(param1:Vector.<AssemblyRecipeKeyModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.recipes = new Vector.<AssemblyRecipeKeyModule>();
         }
         else
         {
            this.recipes = param1;
         }
      }
      
      public static function get instance() : AssemblyRecipeRemoveCommand
      {
         return _instance || (_instance = new AssemblyRecipeRemoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16092;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:AssemblyRecipeKeyModule = null;
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
            _loc4_ = AssemblyRecipeKeyModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.recipes.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:AssemblyRecipeKeyModule = null;
         param1.writeShort(-16092);
         param1.writeShort(this.recipes.length);
         for each(_loc2_ in this.recipes)
         {
            _loc2_.write(param1);
         }
      }
   }
}


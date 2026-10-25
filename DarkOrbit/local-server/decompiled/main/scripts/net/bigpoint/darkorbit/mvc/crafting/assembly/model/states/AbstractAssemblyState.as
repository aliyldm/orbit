package net.bigpoint.darkorbit.mvc.crafting.assembly.model.states
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeStatusModule;
   
   public class AbstractAssemblyState
   {
      
      private var _status:AssemblyRecipeStatusModule;
      
      public function AbstractAssemblyState(param1:AssemblyRecipeStatusModule)
      {
         super();
         this._status = param1;
      }
      
      public function get status() : AssemblyRecipeStatusModule
      {
         return this._status;
      }
      
      public function dispose() : void
      {
      }
   }
}


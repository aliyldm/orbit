package net.bigpoint.darkorbit.mvc.crafting.assembly.model.states
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeAvailableStatusModule;
   
   public class AssemblyAvailableState extends AbstractAssemblyState
   {
      
      private var _triggerd:Boolean;
      
      public function AssemblyAvailableState(param1:AssemblyRecipeAvailableStatusModule)
      {
         super(param1);
      }
      
      public function get isTriggerd() : Boolean
      {
         return this._triggerd;
      }
      
      public function triggerd() : void
      {
         this._triggerd = true;
      }
   }
}


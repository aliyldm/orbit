package net.bigpoint.darkorbit.mvc.crafting.assembly.model.types
{
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeTypeModule;
   
   public class AbstractAssemblyType
   {
      
      private var _type:AssemblyRecipeTypeModule;
      
      public function AbstractAssemblyType(param1:AssemblyRecipeTypeModule)
      {
         super();
         this._type = param1;
      }
   }
}


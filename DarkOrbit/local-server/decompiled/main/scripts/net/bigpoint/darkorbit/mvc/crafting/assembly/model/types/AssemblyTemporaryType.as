package net.bigpoint.darkorbit.mvc.crafting.assembly.model.types
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeTemporaryTypeModule;
   
   public class AssemblyTemporaryType extends AbstractAssemblyType
   {
      
      public const time:BindableCountDown = new BindableCountDown();
      
      public function AssemblyTemporaryType(param1:AssemblyRecipeTemporaryTypeModule)
      {
         this.time.value = param1.remainingTimeMillis * 0.001;
         super(param1);
      }
   }
}


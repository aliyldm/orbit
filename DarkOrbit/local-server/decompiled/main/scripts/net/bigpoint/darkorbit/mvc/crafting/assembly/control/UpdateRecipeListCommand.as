package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdateRecipeListCommand extends SimpleCommand
   {
      
      public function UpdateRecipeListCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AssemblyProxy = facade.retrieveProxy(AssemblyProxy.NAME) as AssemblyProxy;
         _loc2_.filterRecipes();
      }
   }
}


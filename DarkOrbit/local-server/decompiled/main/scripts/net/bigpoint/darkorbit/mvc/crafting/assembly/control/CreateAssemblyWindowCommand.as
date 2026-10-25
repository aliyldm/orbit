package net.bigpoint.darkorbit.mvc.crafting.assembly.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.RecipeUserSettingsFilterProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.view.AssemblyWindowMediator;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingOverviewWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateAssemblyWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateAssemblyWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(AssemblyConsts.ASSEMBLY_XML_RES_KEY,_loc2_,this.handleBuildComplete,[_loc2_]);
      }
      
      private function handleBuildComplete(param1:Sprite) : void
      {
         registerCommand(AssemblyNotifications.FILTER_CHANGED,UpdateRecipeListCommand);
         registerCommand(AssemblyNotifications.SAVE_ASSEMBLY_FILTER_SETTINGS,SaveAssemblyFilterSettingsCommand);
         var _loc2_:Container = param1.getChildAt(0) as Container;
         var _loc3_:SimpleWindow = (guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) ? guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) : guiManager.createWindow(GuiConstants.ASSEMBLY_WINDOW)) as SimpleWindow;
         var _loc4_:AssemblyWindowMediator = new AssemblyWindowMediator(_loc2_,_loc3_);
         registerMediator(_loc4_);
         var _loc5_:RecipeUserSettingsFilterProxy = retrieveProxy(RecipeUserSettingsFilterProxy.NAME) as RecipeUserSettingsFilterProxy;
         _loc4_.itemFilterSettings = _loc5_.filterSettingsVO;
         var _loc6_:CraftingOverviewWindowMediator = retrieveMediator(CraftingOverviewWindowMediator.NAME) as CraftingOverviewWindowMediator;
         _loc6_.assemblyView = _loc2_;
         var _loc7_:AssemblyProxy = retrieveProxy(AssemblyProxy.NAME) as AssemblyProxy;
         _loc7_.filterRecipes();
         commandComplete();
      }
   }
}


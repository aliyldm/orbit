package net.bigpoint.darkorbit.mvc.crafting.overview.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingConst;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingOverviewWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateCraftingOverviewWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateCraftingOverviewWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) ? guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) : guiManager.createWindow(GuiConstants.ASSEMBLY_WINDOW)) as SimpleWindow;
         _loc2_.setSize(520,480);
         var _loc3_:SimpleContainer = _loc2_.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(CraftingConst.XML_RES_KEY,_loc4_,this.handleBuildComplete,[_loc2_,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:Container = param2.getChildAt(0) as Container;
         var _loc4_:CraftingOverviewWindowMediator = new CraftingOverviewWindowMediator(_loc3_,param1);
         registerMediator(_loc4_);
         commandComplete();
      }
   }
}


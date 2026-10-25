package net.bigpoint.darkorbit.mvc.crafting.reroll.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingOverviewWindowMediator;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.RerollConsts;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.RerollWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateRerollWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateRerollWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) || guiManager.createWindow(GuiConstants.ASSEMBLY_WINDOW)) as SimpleWindow;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(RerollConsts.REROLL_XML_RES_KEY,_loc3_,this.handleBuildComplete,[_loc2_,_loc3_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:Container = param2.getChildAt(0) as Container;
         var _loc4_:RerollWindowMediator = new RerollWindowMediator(_loc3_,param1);
         registerMediator(_loc4_);
         var _loc5_:CraftingOverviewWindowMediator = retrieveMediator(CraftingOverviewWindowMediator.NAME) as CraftingOverviewWindowMediator;
         _loc5_.rerollView = _loc3_;
         commandComplete();
      }
   }
}


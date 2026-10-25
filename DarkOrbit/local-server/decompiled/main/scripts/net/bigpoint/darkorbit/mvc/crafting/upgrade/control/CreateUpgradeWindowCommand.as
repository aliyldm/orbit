package net.bigpoint.darkorbit.mvc.crafting.upgrade.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingOverviewWindowMediator;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.UpgradeNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeUserSettingsFilterProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.UpgradeWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateUpgradeWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateUpgradeWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) || guiManager.createWindow(GuiConstants.ASSEMBLY_WINDOW)) as SimpleWindow;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(AssemblyConsts.UPGRADE_XML_RES_KEY,_loc3_,this.handleBuildComplete,[_loc2_,_loc3_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         registerCommand(UpgradeNotifications.SAVE_UPGRADE_FILTER_SETTINGS,SaveUpgradeFilterSettingsCommand);
         var _loc3_:Container = param2.getChildAt(0) as Container;
         var _loc4_:UpgradeWindowMediator = new UpgradeWindowMediator(_loc3_,param1);
         registerMediator(_loc4_);
         var _loc5_:UpgradeTypeUserSettingsFilterProxy = retrieveProxy(UpgradeTypeUserSettingsFilterProxy.NAME) as UpgradeTypeUserSettingsFilterProxy;
         _loc4_.itemFilterSettings = _loc5_.filterSettingsVO;
         var _loc6_:CraftingOverviewWindowMediator = retrieveMediator(CraftingOverviewWindowMediator.NAME) as CraftingOverviewWindowMediator;
         _loc6_.upgradeView = _loc3_;
         commandComplete();
      }
   }
}


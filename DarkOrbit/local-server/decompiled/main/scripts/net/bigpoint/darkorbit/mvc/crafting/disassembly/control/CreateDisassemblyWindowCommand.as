package net.bigpoint.darkorbit.mvc.crafting.disassembly.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.DisassemblyNotifications;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.filter.DisassembleUserSettingsFilterProxy;
   import net.bigpoint.darkorbit.mvc.crafting.disassembly.view.DisassemblyMediator;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingOverviewWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateDisassemblyWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateDisassemblyWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.ASSEMBLY_WINDOW) || guiManager.createWindow(GuiConstants.ASSEMBLY_WINDOW)) as SimpleWindow;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(AssemblyConsts.DISASSEMBLY_XML_RES_KEY,_loc3_,this.handleBuildComplete,[_loc2_,_loc3_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:Container = param2.getChildAt(0) as Container;
         var _loc4_:DisassemblyMediator = new DisassemblyMediator(_loc3_,param1);
         registerMediator(_loc4_);
         var _loc5_:DisassembleUserSettingsFilterProxy = retrieveProxy(DisassembleUserSettingsFilterProxy.NAME) as DisassembleUserSettingsFilterProxy;
         _loc4_.itemFilterSettings = _loc5_.filterSettingsVO;
         var _loc6_:CraftingOverviewWindowMediator = retrieveMediator(CraftingOverviewWindowMediator.NAME) as CraftingOverviewWindowMediator;
         _loc6_.disassemblyView = _loc3_;
         registerCommand(DisassemblyNotifications.SAVE_DISASSEMBLY_FILTER_SETTINGS,SaveDisassemblyFilterSettingsCommand);
         commandComplete();
      }
   }
}


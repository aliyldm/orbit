package net.bigpoint.darkorbit.mvc.influenceWindow.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowConsts;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.influenceWindow.view.InfluenceWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateInfluenceWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateInfluenceWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.INFLUENCE_WINDOW) ? guiManager.getWindow(GuiConstants.INFLUENCE_WINDOW) : guiManager.createWindow(GuiConstants.INFLUENCE_WINDOW)) as SimpleWindow;
         var _loc3_:SimpleContainer = _loc2_.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(InfluenceWindowConsts.XML_RES_KEY,_loc4_,this.handleBuildComplete,[_loc2_,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:Container = param2.getChildAt(0) as Container;
         var _loc4_:InfluenceWindowMediator = new InfluenceWindowMediator(_loc3_,param1);
         registerMediator(_loc4_);
         param1.autoSize();
         sendNotification(InfluenceWindowNotifications.UPDATE_VIEW_FULL);
         registerCommand(InfluenceWindowNotifications.CLEANUP,CleanupInfluenceWindowCommand);
         commandComplete();
      }
   }
}


package net.bigpoint.darkorbit.mvc.plagueWindow.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.plagueWindow.PlagueWindowConsts;
   import net.bigpoint.darkorbit.mvc.plagueWindow.PlagueWindowNotifications;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueWindowProxy;
   import net.bigpoint.darkorbit.mvc.plagueWindow.view.PlagueWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreatePlagueWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreatePlagueWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         sendNotification(AssetNotifications.PRELOAD_LIST,"plague",AssetNotifications.TYPE_PRELOAD_LIST_TYPE_PATTERN_KEY);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.PLAGUE_WINDOW) ? guiManager.getWindow(GuiConstants.PLAGUE_WINDOW) : guiManager.createWindow(GuiConstants.PLAGUE_WINDOW)) as SimpleWindow;
         var _loc3_:SimpleContainer = _loc2_.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(PlagueWindowConsts.XML_RES_KEY,_loc4_,this.handleBuildComplete,[_loc2_,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:Container = param2.getChildAt(0) as Container;
         registerMediator(new PlagueWindowMediator(_loc3_,param1,this.getSubContentByResKey(PlagueWindowConsts.XML_RES_KEY_PROGRESS),this.getSubContentByResKey(PlagueWindowConsts.XML_RES_KEY_IMG),this.getSubContentByResKey(PlagueWindowConsts.XML_RES_KEY_OTHER_MAP)));
         param1.autoSize();
         var _loc4_:PlagueWindowProxy = retrieveProxy(PlagueWindowProxy.NAME) as PlagueWindowProxy;
         _loc4_.updateView();
         registerCommand(PlagueWindowNotifications.CLEANUP,CleanupPlagueWindowCommand);
         commandComplete();
      }
      
      private function getSubContentByResKey(param1:String) : Container
      {
         var _loc2_:XML = (assetsProxy.getLib(param1) as XMLFinisher).getXML();
         var _loc3_:Sprite = new Sprite();
         UISystem.getInstance().build(_loc2_,_loc3_);
         return _loc3_.getChildAt(0) as Container;
      }
   }
}


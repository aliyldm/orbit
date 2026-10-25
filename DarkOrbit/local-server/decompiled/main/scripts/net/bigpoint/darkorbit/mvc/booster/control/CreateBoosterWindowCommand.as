package net.bigpoint.darkorbit.mvc.booster.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.booster.BoosterConsts;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterModel;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterProxy;
   import net.bigpoint.darkorbit.mvc.booster.view.BoosterWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateBoosterWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateBoosterWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.BOOSTER_WINDOW) ? guiManager.getWindow(GuiConstants.BOOSTER_WINDOW) : guiManager.createWindow(GuiConstants.BOOSTER_WINDOW)) as SimpleWindow;
         var _loc3_:SimpleContainer = _loc2_.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(BoosterConsts.XML_RES_KEY,_loc4_,this.handleBuildComplete,[_loc2_,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:Container = param2.getChildAt(0) as Container;
         var _loc4_:BoosterWindowMediator = new BoosterWindowMediator(_loc3_,param1);
         registerMediator(_loc4_);
         var _loc5_:BoosterProxy = retrieveProxy(BoosterProxy.NAME) as BoosterProxy;
         _loc4_.data = _loc5_.getData() as BoosterModel;
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


package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockInfoRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler.ArmoryUnlockInfoData;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.handler.ArmoryUnlockInfoProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab1.ArmoryUnlockTab1Mediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab1.ArmoryUnlockTab1View;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab2.ArmoryUnlockTab2Mediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab2.ArmoryUnlockTab2View;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab3.ArmoryUnlockTab3Mediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab3.ArmoryUnlockTab3View;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class ArmoryUnlockUIMediator extends SimpleWindowMediator
   {
      
      private var _view:ArmoryUnlockUIView;
      
      private var ex01Btn:Button;
      
      private var ex10Btn:Button;
      
      private var cardsContainer:Coreponent;
      
      private var tab1:ArmoryUnlockTab1View;
      
      private var tab2:ArmoryUnlockTab2View;
      
      private var tab3:ArmoryUnlockTab3View;
      
      private var tab1Mediator:ArmoryUnlockTab1Mediator;
      
      private var tab2Mediator:ArmoryUnlockTab2Mediator;
      
      private var tab3Mediator:ArmoryUnlockTab3Mediator;
      
      private var viewData:ArmoryUnlockInfoData;
      
      private var _loadCounter:int = 0;
      
      public function ArmoryUnlockUIMediator(param1:String, param2:SimpleWindow)
      {
         param2.setSize(800,634);
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.tab1Mediator = new ArmoryUnlockTab1Mediator(GuiConstants.ARMORY_UNLOCK_TAB1,simpleWindow);
         facade.registerMediator(this.tab1Mediator);
         this.tab2Mediator = new ArmoryUnlockTab2Mediator(GuiConstants.ARMORY_UNLOCK_TAB2,simpleWindow);
         facade.registerMediator(this.tab2Mediator);
         this.tab3Mediator = new ArmoryUnlockTab3Mediator(GuiConstants.ARMORY_UNLOCK_TAB3,simpleWindow);
         facade.registerMediator(this.tab3Mediator);
         var _loc1_:ArmoryUnlockInfoProxy = new ArmoryUnlockInfoProxy(GuiConstants.ARMORY_UNLOCK);
         facade.registerProxy(_loc1_);
         this.viewData = _loc1_.viewData;
         this.viewData.changed.add(this.onViewDataChanged);
         this.viewData.countdownTimer.changed.add(this.onCountdownUpdate);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         simpleWindow.getUIContainer().visible = false;
         this.loadAndBuildWithResKey(GuiConstants.ARMORY_UNLOCK_TAB1,param1);
         this.loadAndBuildWithResKey(GuiConstants.ARMORY_UNLOCK_TAB2,param1);
         this.loadAndBuildWithResKey(GuiConstants.ARMORY_UNLOCK_TAB3,param1);
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param1);
         }
      }
      
      protected function handleFinalContentLoaded(param1:Array) : void
      {
         var _tabView:ArmoryUnlockTabView;
         var mediator:* = undefined;
         var callbackParams:Array = param1;
         simpleWindow.getUIContainer().visible = true;
         super.handleLoadAndBuildContentCallback(callbackParams);
         mediator = this;
         this._view = new ArmoryUnlockUIView(simpleWindow);
         this.ex01Btn = this._view.ex01Btn;
         this.ex10Btn = this._view.ex10Btn;
         this.ex10Btn.visible = false;
         this.ex01Btn.visible = false;
         this.cardsContainer = this._view.cardsContainer;
         this.cardsContainer.visible = false;
         this._view.testButtonRight.visible = false;
         this._view.testButtonLef.visible = false;
         this._view.testButtonLef.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            simpleWindow.minimize();
            mediator.clear(GuiConstants.ARMORY_UNLOCK);
            mediator.clear(GuiConstants.ARMORY_UNLOCK_TAB1);
            mediator.clear(GuiConstants.ARMORY_UNLOCK_TAB2);
            mediator.clear(GuiConstants.ARMORY_UNLOCK_TAB3);
            mediator.clear(GuiConstants.ARMORY_UNLOCK_ALERT);
         });
         this._view.root;
         this.tab1 = new ArmoryUnlockTab1View(this._view.root);
         this.tab2 = new ArmoryUnlockTab2View(this._view.root);
         this.tab3 = new ArmoryUnlockTab3View(this._view.root);
         _tabView = new ArmoryUnlockTabView(simpleWindow.getUIContainer(),AmoryUnlockTabAssigner);
         _tabView.tabItems = new <ITabItem>[this.tab1,this.tab2,this.tab3];
         this.tab1Mediator.setView(this.tab1);
         this.tab2Mediator.setView(this.tab2);
         this.tab3Mediator.setView(this.tab3);
         _tabView.tabChanged.add(this.tsbChanged);
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ArmoryUnlockInfoRequest());
      }
      
      private function loadAndBuildWithResKey(param1:String, param2:Array) : void
      {
         ++this._loadCounter;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc3_,this._internalHandleBuildComplete,[_loc3_,param2]);
      }
      
      private function _internalHandleBuildComplete(param1:Sprite, param2:Array) : void
      {
         var _loc3_:DisplayObjectContainer = window.getUIContainer().getChildByName("root") as DisplayObjectContainer;
         var _loc4_:Container = param1.getChildAt(0) as Container;
         _loc3_.addChild(_loc4_.getChildAt(0));
         --this._loadCounter;
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param2);
         }
      }
      
      private function onViewDataChanged() : void
      {
         this.tab1Mediator.updateData(this.viewData);
         this.tab2Mediator.updateData(this.viewData);
         this.tab3Mediator.updateData(this.viewData);
      }
      
      private function onCountdownUpdate() : void
      {
         if(this.viewData.countdownTimer.value > 0)
         {
            this._view.timeLabel.text = BPLocale.getItem("window_event_progress_label_timeleft") + " " + TimeFormatter.getSmartFormatedTime(this.viewData.countdownTimer.value);
         }
         else
         {
            this._view.timeLabel.text = "";
         }
      }
      
      private function tsbChanged(param1:*) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ArmoryUnlockInfoRequest());
      }
   }
}


package net.bigpoint.darkorbit.mvc.gui.windows.killUI.view
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.killUI.KillUINotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.killUI.model.KillUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.killUI.model.KillUIWindowProxy;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class KillUIWindowMediator extends SimpleWindowMediator
   {
      
      private const HIGHLIGHT_TEXT_COLOR:Number = 16777215;
      
      private var _killUIContainer:Container;
      
      private var _titleLabel:Label;
      
      private var _pointsLabel:Label;
      
      private var _progressbar:ProgressBar;
      
      private var _killsLabel:Label;
      
      private var _onMapLabel:Label;
      
      private var _alertContainer:Container;
      
      private var _titleAlertLabel:Label;
      
      private var _messageAlertLabel:Label;
      
      private var _stressTestable:Boolean = false;
      
      private var _proxy:KillUIWindowProxy;
      
      public function KillUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override protected function mapNotificationsToMethods() : void
      {
         mapNotificationToMethod(KillUINotifications.VIEW_DATA_CHANGED,this.handleViewDataChanged);
      }
      
      override public function loadAndBuildContent(param1:String) : void
      {
         super.loadAndBuildContent(param1);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         this.assignUIComponents();
         super.handleLoadAndBuildContentCallback(param1);
         this.onContentLoadedUpdateViewComponentFromModel();
      }
      
      private function assignUIComponents() : void
      {
         this._killUIContainer = FuiComponentSelectorUtil.selectComponent("root.contentContainer",UIContentContainer) as Container;
         this._titleLabel = FuiComponentSelectorUtil.selectComponent("root.contentContainer.title",UIContentContainer) as Label;
         this._pointsLabel = FuiComponentSelectorUtil.selectComponent("root.contentContainer.points",UIContentContainer) as Label;
         this._progressbar = FuiComponentSelectorUtil.selectComponent("root.contentContainer.progressbar",UIContentContainer) as ProgressBar;
         this._killsLabel = FuiComponentSelectorUtil.selectComponent("root.contentContainer.killsleft",UIContentContainer) as Label;
         this._onMapLabel = FuiComponentSelectorUtil.selectComponent("root.contentContainer.onmap",UIContentContainer) as Label;
         this._alertContainer = FuiComponentSelectorUtil.selectComponent("root.alertContainer",UIContentContainer) as Container;
         this._titleAlertLabel = FuiComponentSelectorUtil.selectComponent("root.alertContainer.title",UIContentContainer) as Label;
         this._messageAlertLabel = FuiComponentSelectorUtil.selectComponent("root.alertContainer.message",UIContentContainer) as Label;
      }
      
      private function onContentLoadedUpdateViewComponentFromModel() : void
      {
         this.update();
      }
      
      private function handleViewDataChanged(param1:INotification = null) : void
      {
         this.update();
      }
      
      public function update() : void
      {
         if(Boolean(this.data) && isUIReady())
         {
            if(this.data.currentViewState == KillUIData.INFO_VIEW)
            {
               this.showInfoView(this.data);
            }
            else if(this.data.currentViewState == KillUIData.FULL_VIEW)
            {
               this.showFullView(this.data);
            }
         }
      }
      
      private function get data() : KillUIData
      {
         if(this._proxy == null)
         {
            this._proxy = facade.retrieveProxy(GuiConstants.KILL_UI_WINDOW) as KillUIWindowProxy;
         }
         return this._proxy.viewData;
      }
      
      private function showFullView(param1:KillUIData) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         this._killUIContainer.visible = false;
         this._alertContainer.visible = true;
         (this.window as SimpleWindow).setHeight(52);
         if(this._titleAlertLabel)
         {
            this._titleAlertLabel.text = BPLocale.getItem("kill_progress_window_plague_alert");
         }
         if(this._messageAlertLabel)
         {
            _loc2_ = this.getNpcName(param1.npcId);
            _loc3_ = BPLocale.getItem("kill_progress_window_npc_count_2");
            _loc3_ = _loc3_.replace("%AMOUNT%",HtmlTextUtils.coloriseText(this.HIGHLIGHT_TEXT_COLOR,"<b>" + String(param1.totalAmountOfNpcOnMap) + "</b>"));
            _loc3_ = _loc3_.replace("%NPC_NAME%",HtmlTextUtils.coloriseText(this.HIGHLIGHT_TEXT_COLOR,"<b>" + _loc2_ + "</b>"));
            this._messageAlertLabel.text = this._stressTestable ? TextUtils.getRandomLengthText(100,500) : _loc3_;
         }
         this._alertContainer.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT],true);
         this.simpleWindow.setHeight(this._alertContainer.getExplicitHeight() + SimpleWindow.UICONTAINER_Y);
      }
      
      private function showInfoView(param1:KillUIData) : void
      {
         this._killUIContainer.visible = true;
         this._alertContainer.visible = false;
         var _loc2_:uint = param1.maxNpcAmountForMap - param1.currentNpcKills;
         var _loc3_:String = this.getNpcName(param1.killNpcId);
         var _loc4_:String = this.getNpcName(param1.spawnNpcId);
         var _loc5_:String = BPLocale.getItem("kill_progress_window_kills_left");
         _loc5_ = _loc5_.replace("%AMOUNT%",HtmlTextUtils.coloriseText(this.HIGHLIGHT_TEXT_COLOR,"<b>" + _loc2_ + "</b>"));
         _loc5_ = _loc5_.replace("%KILL_NAME%",HtmlTextUtils.coloriseText(this.HIGHLIGHT_TEXT_COLOR,"<b>" + _loc3_ + "</b>"));
         _loc5_ = _loc5_.replace("%SPAWN_NAME%",HtmlTextUtils.coloriseText(this.HIGHLIGHT_TEXT_COLOR,"<b>" + _loc4_ + "</b>"));
         this._killsLabel.text = this._stressTestable ? TextUtils.getRandomLengthText(100,500) : _loc5_;
         var _loc6_:String = BPLocale.getItem("kill_progress_window_npc_count");
         _loc6_ = _loc6_.replace("%AMOUNT%",HtmlTextUtils.coloriseText(this.HIGHLIGHT_TEXT_COLOR,"<b>" + param1.currentNpcOnMap + "</b>"));
         _loc6_ = _loc6_.replace("%NPC_NAME%",HtmlTextUtils.coloriseText(this.HIGHLIGHT_TEXT_COLOR,"<b>" + _loc4_ + "</b>"));
         this._onMapLabel.text = this._stressTestable ? TextUtils.getRandomLengthText(100,500) : _loc6_;
         this._pointsLabel.text = param1.currentNpcKills + "/" + param1.maxNpcAmountForMap;
         this._progressbar.maxValue = param1.maxNpcAmountForMap;
         this._progressbar.minValue = 0;
         this._progressbar.currentValue = param1.currentNpcKills;
         this._killUIContainer.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT],true);
         this.simpleWindow.setHeight(this._killUIContainer.getExplicitHeight() + SimpleWindow.UICONTAINER_Y);
      }
      
      private function getNpcName(param1:int) : String
      {
         var _loc2_:String = "FooSkater";
         if(param1 > 0)
         {
            _loc2_ = InGameCatalog.getInstance().getNpcName(param1);
         }
         return _loc2_;
      }
      
      public function set stressTestable(param1:Boolean) : void
      {
         this._stressTestable = param1;
      }
   }
}


package net.bigpoint.darkorbit.mvc.plagueWindow.view
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.filters.GlowFilter;
   import flash.text.GridFitType;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.utils.ClassUtils;
   import net.bigpoint.darkorbit.mvc.influenceWindow.InfluenceWindowNotifications;
   import net.bigpoint.darkorbit.mvc.plagueWindow.PlagueWindowNotifications;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.AbstractSummonState;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.MinionsSummonState;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.NothingSummonState;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.OnOtherMapSummonState;
   import net.bigpoint.darkorbit.mvc.plagueWindow.model.PlagueModel;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PlagueWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "PlagueWindowMediator";
      
      private const FILTER:Array = [new GlowFilter(43263,1,4,4)];
      
      private const BUFF_DMG:String = "+10%";
      
      private const BUFF_SPEED:String = "-10%";
      
      private const BUFF_HULL:String = "-15%";
      
      private const NO_BUFF:String = "0%";
      
      private var _plagueOtherMapView:Container;
      
      private var _plagueGenericImg:Container;
      
      private var _plagueProgressView:Container;
      
      private var _window:SimpleWindow;
      
      private var _updates:Object = {};
      
      private var _infectedText:String;
      
      private var _notInfectedText:String;
      
      public function PlagueWindowMediator(param1:Object, param2:SimpleWindow, param3:Container, param4:Container, param5:Container)
      {
         super(NAME,param1);
         this._updates[MinionsSummonState] = this.updateToMinionSummonState;
         this._updates[OnOtherMapSummonState] = this.updateToOnOtherMapSummonState;
         this._updates[NothingSummonState] = this.updateToOnNothingSummonState;
         TooltipControl.getInstance().addToolTip(this.header,BPLocale.getItem("ttip_plague_header"));
         TooltipControl.getInstance().addToolTip(this.footer,BPLocale.getItem("ttip_plague_footer"));
         TooltipControl.getInstance().addToolTip(this.center,BPLocale.getItem("ttip_plague_center"));
         this._plagueProgressView = param3;
         this._plagueGenericImg = param4;
         this._plagueOtherMapView = param5;
         this._plagueProgressView.forceRedraw(InvalidationType.SIZE);
         this._plagueGenericImg.forceRedraw(InvalidationType.SIZE);
         this._plagueOtherMapView.forceRedraw(InvalidationType.SIZE);
         mapNotificationToMethod(PlagueWindowNotifications.UPDATE_VIEW,this.fullUpdate);
         mapNotificationToMethod(PlagueWindowNotifications.UPDATE_TIMER,this.fullUpdate);
         this.infectedPoints.filters = this.notInfectedPoints.filters = this.FILTER;
         this._infectedText = BPLocale.getItem("plague_window_infected");
         this._notInfectedText = BPLocale.getItem("plague_window_healthy");
         this.buffLabelDMG.text = this.BUFF_DMG;
         this.buffLabelHP.text = this.BUFF_HULL;
         this.buffLabelSpeed.text = this.BUFF_SPEED;
         this._window = param2;
      }
      
      private function get progressbar() : ProgressBar
      {
         return FuiComponentSelectorUtil.selectComponent("progressbar",this._plagueProgressView) as ProgressBar;
      }
      
      private function get progressScore() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("score",this._plagueProgressView) as Label;
      }
      
      private function get otherMapLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("label",this._plagueOtherMapView) as Label;
      }
      
      private function get timer() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("header.timer",this.viewContainer) as Label;
      }
      
      private function get infectedLabel() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("header.infected",this.viewContainer) as Label;
      }
      
      private function get footer() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("footer",this.viewContainer) as Container;
      }
      
      private function get header() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("header",this.viewContainer) as Container;
      }
      
      private function get infectedPoints() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("footer.infectedContainer.points",this.viewContainer) as Label;
      }
      
      private function get notInfectedPoints() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("footer.notInfectedContainer.points",this.viewContainer) as Label;
      }
      
      private function get center() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("center",this.viewContainer) as Container;
      }
      
      private function get buffLabelSpeed() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("header.buffs.speed_container.label",this.viewContainer) as Label;
      }
      
      private function get buffContainer() : Container
      {
         return FuiComponentSelectorUtil.selectComponent("header.buffs",this.viewContainer) as Container;
      }
      
      private function get buffLabelDMG() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("header.buffs.dmg_container.label",this.viewContainer) as Label;
      }
      
      private function get buffLabelHP() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("header.buffs.hp_container.label",this.viewContainer) as Label;
      }
      
      private function get viewContainer() : Container
      {
         return viewComponent as Container;
      }
      
      override public function onRegister() : void
      {
         this.addListeners();
         super.onRegister();
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         sendNotification(InfluenceWindowNotifications.CLEANUP);
         super.onRemove();
      }
      
      private function setBuffs(param1:Boolean) : void
      {
         this.buffContainer.visible = param1;
      }
      
      private function updateToOnNothingSummonState(param1:NothingSummonState) : void
      {
         MovieClipUtils.removeDisplayObject(this._plagueProgressView);
         MovieClipUtils.removeDisplayObject(this._plagueGenericImg);
         MovieClipUtils.removeDisplayObject(this._plagueOtherMapView);
         this.center.addChild(this._plagueGenericImg);
      }
      
      private function updateToOnOtherMapSummonState(param1:OnOtherMapSummonState) : void
      {
         MovieClipUtils.removeDisplayObject(this._plagueProgressView);
         MovieClipUtils.removeDisplayObject(this._plagueGenericImg);
         MovieClipUtils.removeDisplayObject(this._plagueOtherMapView);
         var _loc2_:Vector.<int> = param1.maps;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:Vector.<String> = new Vector.<String>(0);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_.push(Map.getMissionMapName(_loc2_[_loc5_]));
            _loc5_++;
         }
         this.otherMapLabel.useHTML = true;
         this.otherMapLabel.text = _loc4_.join(", ").replace(/-/g,String.fromCharCode(8209));
         (this.otherMapLabel.skin as LabelSkin).textField.gridFitType = GridFitType.NONE;
         this.center.addChild(this._plagueOtherMapView);
      }
      
      private function updateToMinionSummonState(param1:MinionsSummonState) : void
      {
         MovieClipUtils.removeDisplayObject(this._plagueProgressView);
         MovieClipUtils.removeDisplayObject(this._plagueGenericImg);
         MovieClipUtils.removeDisplayObject(this._plagueOtherMapView);
         this.progressScore.visible = this.progressbar.visible = !param1.currentWave.bossActive;
         this.progressbar.maxValue = param1.currentWave.counterMax;
         this.progressbar.currentValue = param1.currentWave.counter;
         this.progressScore.text = param1.currentWave.counter + "/" + param1.currentWave.counterMax;
         this.center.addChild(this._plagueProgressView);
      }
      
      private function fullUpdate(param1:INotification) : void
      {
         var _loc2_:PlagueModel = param1.getBody() as PlagueModel;
         this.setBuffs(_loc2_.infected);
         this.infectedLabel.text = _loc2_.infected ? this._infectedText : this._notInfectedText;
         this.updateTimer(param1);
         this.setStateView(_loc2_.currentState.value as AbstractSummonState);
         this.infectedPoints.text = _loc2_.infectedPoints.toString();
         this.notInfectedPoints.text = _loc2_.notInfectedPoints.toString();
         this.viewContainer.invalidate(InvalidationType.SIZE);
         this.viewContainer.invalidate(InvalidationType.LAYOUT);
         setTimeout(this._window.autoSize,20);
      }
      
      private function updateTimer(param1:INotification) : void
      {
         var _loc2_:PlagueModel = param1.getBody() as PlagueModel;
         this.timer.text = TimeFormatter.formatTime(_loc2_.timeLeft.value);
         this.timer.visible = _loc2_.timeLeft.value > 0;
      }
      
      private function setStateView(param1:AbstractSummonState) : void
      {
         this._updates[ClassUtils.getClass(param1)](param1);
         if(this.center.numChildren > 0)
         {
            this.center.height = this.center.getChildAt(0).height;
         }
         this.center.forceRedraws([InvalidationType.SIZE,InvalidationType.LAYOUT]);
      }
      
      private function addListeners() : void
      {
         this._window.addEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
      }
      
      private function removeListeners() : void
      {
         this._window.removeEventListener(SimpleWindowEvent.ON_CLOSE,this.handleWindowClosed);
      }
      
      private function handleWindowClosed(param1:SimpleWindowEvent) : void
      {
         facade.removeMediator(this.getMediatorName());
      }
   }
}


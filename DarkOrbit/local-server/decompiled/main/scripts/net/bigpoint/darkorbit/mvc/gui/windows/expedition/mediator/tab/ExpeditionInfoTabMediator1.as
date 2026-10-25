package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoCommand;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.ExpeditionInfoProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo.OverViewVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView1;
   import net.bigpoint.darkorbit.utils.time.TimeUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExpeditionInfoTabMediator1 extends SimpleWindowMediator
   {
      
      private var _view:ExpeditionInfoTabView1;
      
      private var _timeLimit:int = 0;
      
      private var _timeInterval:Number = 0;
      
      private var _targetTime:Number;
      
      private var _lastLevel:int = -1;
      
      public function ExpeditionInfoTabMediator1(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      public function setView(param1:ExpeditionInfoTabView1) : void
      {
         this._view = param1;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ExpeditionNotification.START_INSTANCE,ExpeditionNotification.END_INSTANCE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ExpeditionNotification.START_INSTANCE:
               this._timeLimit = int(param1.getBody());
               this._targetTime = new Date().time + this._timeLimit * 1000;
               clearInterval(this._timeInterval);
               this.showTimeLimit();
               this._timeInterval = setInterval(this.showTimeLimit,1000);
               break;
            case ExpeditionNotification.END_INSTANCE:
               clearInterval(this._timeInterval);
         }
      }
      
      private function showTimeLimit() : void
      {
         if(Boolean(this._view) && Boolean(this._view.timeLimitLabel))
         {
            if(this._timeLimit > 0)
            {
               this._view.timeLimitLabel.visible = true;
               this._timeLimit = (this._targetTime - new Date().time) / 1000;
               this._view.timeLimitLabel.text = BPLocale.getItem("window_dse_limited_time").replace("%VALUE%","" + TimeUtils.formatTime(this._timeLimit));
            }
            else
            {
               this._view.timeLimitLabel.visible = false;
            }
         }
      }
      
      public function update() : void
      {
         var _loc2_:ExpeditionInfoCommand = null;
         var _loc5_:String = null;
         if(!ExpeditionInfoProxy.getProxy(this.facade).viewData.availabled)
         {
            return;
         }
         var _loc1_:Vector.<OverViewVo> = ExpeditionInfoProxy.getProxy(this.facade).viewData.overviewReward;
         _loc2_ = ExpeditionInfoProxy.getProxy(this.facade).viewData.infoCommand;
         var _loc3_:int = ExpeditionInfoProxy.getProxy(this.facade).viewData.infoCommand.curLevel;
         if(_loc3_ != this._lastLevel && this._lastLevel != -1)
         {
            clearInterval(this._timeInterval);
         }
         this._lastLevel = _loc3_;
         this._view.currentLevelLabel.text = BPLocale.getItem("window_dse_current_level").replace("%VALUE%",_loc2_.curLevel);
         this._view.highestLevelLabel.text = BPLocale.getItem("window_dse_level_clear").replace("%VALUE%",_loc2_.maxLevel);
         if(_loc2_.timeLimit > 0)
         {
            this._view.timeLimitLabel.visible = true;
            this._view.timeLimitLabel.text = BPLocale.getItem("window_dse_limited_time").replace("%VALUE%","" + TimeUtils.formatTime(_loc2_.timeLimit));
         }
         else
         {
            this._view.timeLimitLabel.visible = false;
         }
         if(_loc2_.conditionNpcId > 0)
         {
            _loc5_ = InGameCatalog.instance.getNpcName(int(_loc2_.conditionNpcId));
            this._view.conditionLabel1.text = BPLocale.getItem("window_dse_vic") + "" + BPLocale.getItem(_loc2_.victoryCondition).replace("%VALUE%",_loc5_);
         }
         else
         {
            this._view.conditionLabel1.text = BPLocale.getItem("window_dse_vic") + "" + BPLocale.getItem(_loc2_.victoryCondition);
         }
         this._view.conditionLabel2.text = BPLocale.getItem("window_dse_failure") + "" + BPLocale.getItem(_loc2_.failureCondition);
         var _loc4_:ItemVO = ItemDataProviderHelper.getItem("resource_key_access-dse");
         if(_loc4_)
         {
            IconVOLoader.getInstance().loadIcon(this._view.costIcon,_loc4_,"100x100",AssetsProxy.ITEMS);
            this._view.costNameLabel.text = "" + _loc4_.fullname;
            this._view.costNumLabel.text = "" + _loc2_.keyCount;
            this._view.costTip.tooltipData = "" + _loc4_.rawDescription;
            this._view.costIcon.tooltipData = "" + _loc4_.rawDescription;
         }
         this._view.infoLabel.text = BPLocale.getItem("window_dse_entry_info");
         this._view.rewardList = _loc1_;
      }
   }
}


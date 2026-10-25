package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.view
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model.TitleFrenzyUIOverviewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model.TitleFrenzyVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class TitleFrenzyUIOverviewMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private const _scheduleTimerActiveHeader:String = BPLocale.getItem("titlefrenzy_remaining-time");
      
      private const _scheduleTimerInactiveHeader:String = BPLocale.getItem("titlefrenzy_nextround-time");
      
      private const _rankingTimerHeader:String = BPLocale.getItem("titlefrenzy_ranking-time");
      
      private const _titleStatus:String = BPLocale.getItem("titlefrenzy_window-status");
      
      private const _scheduleInactive:String = "&lt;" + BPLocale.getItem("titefrenzy_window-inactive") + "&gt;";
      
      private const _noOwner:String = "&lt;" + BPLocale.getItem("titlefrenzy_window-unassigned") + "&gt;";
      
      private const _tab:String = "    ";
      
      private var _data:TitleFrenzyUIOverviewData;
      
      private var _view:TitleFrenzyUIOverviewView;
      
      private var _description:String;
      
      public function TitleFrenzyUIOverviewMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:TitleFrenzyUIOverviewData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.activeStatusUpdated.remove(this.updateInfoText);
            this._data.scheduleTimer.changed.remove(this.onScheduleTimerUpdated);
            this._data.eventEndTimer.changed.remove(this.onRankingTimerUpdated);
            this._data.ownersUpdated.remove(this.updateInfoText);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.activeStatusUpdated.add(this.updateInfoText);
            this._data.scheduleTimer.changed.add(this.onScheduleTimerUpdated);
            this._data.eventEndTimer.changed.add(this.onRankingTimerUpdated);
            this._data.ownersUpdated.add(this.updateInfoText);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new TitleFrenzyUIOverviewView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as TitleFrenzyUIOverviewData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      public function manualLoad(param1:TitleFrenzyUIOverviewView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as TitleFrenzyUIOverviewData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelInfo.useHTML = true;
         this.updateDescription();
         this.onScheduleTimerUpdated();
         this.onRankingTimerUpdated();
         this.updateInfoText();
      }
      
      private function updateDescription() : void
      {
         this._description = BPLocale.getItem("titlefrenzy_window-description") + "\n\n";
         this._description = this._description.replace("%TITLE_NAME%",BPLocale.getItemInCategory("achievements",this._data.titleKey));
         this._description += "<b>";
         var _loc1_:int = 0;
         while(_loc1_ < this._data.npcList.length)
         {
            this._description += InGameCatalog.getInstance().getNpcName(this._data.npcList[_loc1_]);
            this._description += _loc1_ == this._data.npcList.length - 1 ? "" : ", ";
            _loc1_++;
         }
         this._description += "</b>";
      }
      
      private function get ownersInfo() : String
      {
         var _loc3_:TitleFrenzyVO = null;
         var _loc4_:String = null;
         var _loc1_:String = "";
         var _loc2_:int = 0;
         for each(_loc3_ in this._data.owners)
         {
            _loc2_ += _loc3_.hasOwner ? 1 : 0;
            _loc4_ = _loc3_.hasOwner ? "<b>" + _loc3_.infoText + "</b>" : this._noOwner;
            _loc1_ += this._tab + _loc4_ + "\n";
         }
         return _loc2_ == 0 ? this._scheduleInactive : _loc1_;
      }
      
      private function updateInfoText() : void
      {
         var _loc1_:String = this._description + "\n\n" + this._titleStatus + "\n\n" + "<font color=\"#0ffbf13\">";
         if(this._data.scheduleInactive || this._data.owners == null || this._data.owners.length == 0)
         {
            _loc1_ += this._tab + this._scheduleInactive;
         }
         else
         {
            _loc1_ += this.ownersInfo;
         }
         _loc1_ += "</font>";
         this._view.labelInfo.text = _loc1_;
      }
      
      private function onScheduleTimerUpdated() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelScheduleTimerHeader.text = this._data.scheduleInactive ? this._scheduleTimerInactiveHeader : this._scheduleTimerActiveHeader;
         this._view.labelScheduleTimerValue.text = TimeFormatter.getSmartFormatedTime(this._data.scheduleTimer.value);
      }
      
      private function onRankingTimerUpdated() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelRankingTimer.text = this._rankingTimerHeader + "\n" + TimeFormatter.getSmartFormatedTime(this._data.eventEndTimer.value);
      }
   }
}


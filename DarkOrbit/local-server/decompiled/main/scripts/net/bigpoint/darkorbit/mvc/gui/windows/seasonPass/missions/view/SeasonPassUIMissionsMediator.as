package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.view
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.SeasonPassUIMissionsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.missions.model.vo.SeasonPassMissionVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SeasonPassUIMissionsMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:SeasonPassUIMissionsData;
      
      private var _view:SeasonPassUIMissionsView;
      
      private var _selectButton:Button;
      
      public function SeasonPassUIMissionsMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:SeasonPassUIMissionsData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.missionCompleted.remove(this.missionCompleted);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.missionCompleted.add(this.missionCompleted);
            this.update();
         }
      }
      
      public function get data() : SeasonPassUIMissionsData
      {
         return this._data;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new SeasonPassUIMissionsView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as SeasonPassUIMissionsData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
         this._view.btnDaily.addEventListener(MouseEvent.CLICK,this.onSideTabClicked);
         this._view.btnWeekly.addEventListener(MouseEvent.CLICK,this.onSideTabClicked);
         this._view.btnSeason.addEventListener(MouseEvent.CLICK,this.onSideTabClicked);
      }
      
      private function removeListeners() : void
      {
         this._view.btnDaily.removeEventListener(MouseEvent.CLICK,this.onSideTabClicked);
         this._view.btnWeekly.removeEventListener(MouseEvent.CLICK,this.onSideTabClicked);
         this._view.btnSeason.removeEventListener(MouseEvent.CLICK,this.onSideTabClicked);
      }
      
      public function manualLoad(param1:SeasonPassUIMissionsView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as SeasonPassUIMissionsData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         var _loc1_:Button = !this._view.btnSeason.isEnabled() ? this._view.btnSeason : (!this._view.btnWeekly.isEnabled() ? this._view.btnWeekly : this._view.btnDaily);
         this.updateRefreshTimes(_loc1_);
         this.setSideTab(_loc1_);
      }
      
      public function updateRefreshTimes(param1:Button) : void
      {
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         this._view.textRefresh.visible = true;
         this._view.refreshHintLabel.visible = true;
         if(param1 == this._view.btnSeason)
         {
            this._view.textRefresh.visible = false;
            this._view.refreshHintLabel.visible = false;
         }
         else if(param1 == this._view.btnWeekly)
         {
            _loc2_ = this._data.weeklyMaxCount;
            _loc3_ = this._data.weeklyUsedCount;
         }
         else
         {
            _loc2_ = this._data.dailyMaxCount;
            _loc3_ = this._data.dailyUsedCount;
         }
         this._data.CurMaxCount = _loc2_;
         this._data.CurUsedCount = _loc3_;
         this._view.textRefresh.text = _loc3_ + "/" + _loc2_;
      }
      
      public function get view() : SeasonPassUIMissionsView
      {
         return this._view;
      }
      
      public function get selectButton() : Button
      {
         return this._selectButton;
      }
      
      private function setSideTab(param1:Button) : void
      {
         var selectedBtn:Button = param1;
         this._view.btnDaily.enabled = true;
         this._view.btnWeekly.enabled = true;
         this._view.btnSeason.enabled = true;
         selectedBtn.enabled = false;
         this._selectButton = selectedBtn;
         this._view.missionList = selectedBtn == this._view.btnWeekly ? this._data.weeklyMissionItems : (selectedBtn == this._view.btnSeason ? this._data.seasonMissionItems : this._data.dailyMissionItems);
         this.updateRefreshTimes(selectedBtn);
         this._data.seasonMissionItems.forEach(function(param1:SeasonPassMissionVO, param2:int, param3:*):*
         {
            param1.oncePreMission = true;
         });
      }
      
      private function onSideTabClicked(param1:MouseEvent) : *
      {
         this.setSideTab(param1.currentTarget as Button);
      }
      
      private function missionCompleted() : *
      {
         this._data.sortData();
         var _loc1_:Button = !this._view.btnDaily.isEnabled() ? this._view.btnDaily : (!this._view.btnWeekly.isEnabled() ? this._view.btnWeekly : this._view.btnSeason);
         this.setSideTab(_loc1_);
      }
   }
}


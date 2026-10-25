package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.model.WorldBossUIOverviewData;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class WorldBossUIOverviewMediator extends SimpleWindowMediator
   {
      
      private static const PERCENT_CONVERTER:Number = 100;
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:WorldBossUIOverviewData;
      
      private var _view:WorldBossUIOverviewView;
      
      public function WorldBossUIOverviewMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      private static function roundDecimal(param1:Number, param2:int) : Number
      {
         return int(param1 * Math.pow(10,param2)) / Math.pow(10,param2);
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this._data = null;
      }
      
      public function set data(param1:WorldBossUIOverviewData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.bossHealth.changed.remove(this.onHealthUpdated);
            this._data.currTier.changed.remove(this.onCurrTierUpdated);
            this._data.endTime.changed.remove(this.onEndTimeUpdated);
            this._data.attemptsLeft.changed.remove(this.onAttemptsUpdated);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.bossHealth.changed.add(this.onHealthUpdated);
            this._data.currTier.changed.add(this.onCurrTierUpdated);
            this._data.endTime.changed.add(this.onEndTimeUpdated);
            this._data.attemptsLeft.changed.add(this.onAttemptsUpdated);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new WorldBossUIOverviewView(simpleWindow);
         this.data = retrieveWindowProxy().getData() as WorldBossUIOverviewData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      public function manualLoad(param1:WorldBossUIOverviewView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.data = retrieveWindowProxy().getData() as WorldBossUIOverviewData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this.setHealthTitle();
         this.onHealthUpdated();
         this.onCurrTierUpdated();
         this.onEndTimeUpdated();
         this.onAttemptsUpdated();
         this.setBannerIcon();
         this.setLocaleText();
      }
      
      private function setHealthTitle() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         var _loc1_:String = BPLocale.getItem("worldBoss_overview_overall_health");
         if(_loc1_ != "")
         {
            _loc1_ = BPLocale.getItem("worldboss_overview_total_damage");
         }
         this._view.labelHealth.text = _loc1_;
      }
      
      private function onHealthUpdated() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.progressBar.maxValue = PERCENT_CONVERTER;
         this._view.progressBar.currentValue = roundDecimal(this._data.bossHealth.value / this._data.bossHealth.maxValue * PERCENT_CONVERTER,2);
         this._view.labelPercent.text = this._view.progressBar.currentValue + "%";
      }
      
      private function onCurrTierUpdated() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelCurrTier.text = TextFormatter.roundInteger(this._data.currTier.value);
      }
      
      private function onEndTimeUpdated() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelEndTime.text = TimeFormatter.getSmartFormatedTime(this._data.endTime.value);
      }
      
      private function onAttemptsUpdated() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.openTimeLabel.visible = this._view.labelAttemptsLeft.visible = !this._data.inRaiding;
         this._view.labelAttemptsLeft.text = TimeFormatter.getSmartFormatedTime(this._data.attemptsLeft.value);
      }
      
      private function setBannerIcon() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.iconBanner.loadResource(this._data.bannerKey,this.handleBannerLoaded,this.handleBannerLoadError,AssetsProxy.EVENTS);
      }
      
      private function handleBannerLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.iconBanner);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._view.iconBanner.width;
         _loc2_.height = this._view.iconBanner.height;
         this._view.iconBanner.addChild(_loc2_);
      }
      
      private function handleBannerLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._view.iconBanner);
      }
      
      private function setLocaleText() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelSlogan.text = BPLocale.getItem(this._data.sloganKey);
         this._view.labelDescription.text = BPLocale.getItem(this._data.descriptionKey);
      }
   }
}


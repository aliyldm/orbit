package net.bigpoint.darkorbit.mvc.battlestationswindow.view.ratings.components
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.MouseEvent;
   import mx.controls.ProgressBar;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.BattleStationVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import spark.components.Button;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   
   public class RatingsBase extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _1121609362ratingsTitleLabel:Label;
      
      private var _451917317attackRating:StatItem;
      
      private var _975810061defenceRating:StatItem;
      
      private var _188604534repairRating:StatItem;
      
      private var _1971720286honourRating:StatItem;
      
      private var _1307886040epRating:StatItem;
      
      private var _1359312414damageBoosterRating:StatItem;
      
      private var _364294868deflectorStatusTitle:Label;
      
      private var _180754677deflectorTimeLabel:Label;
      
      private var _189999986deflectorTimeValue:Label;
      
      private var _1747110887deflectorTimeProgressBar:ProgressBar;
      
      private var _1772252831deflectorTimeRegRateLabel:Label;
      
      private var _1781498140deflectorTimeRegRateValue:Label;
      
      private var _1225326616deflectorToggleButton:Button;
      
      private var _battleStationVO:BattleStationVO;
      
      protected var _275223558_regenerationTooltipText:String;
      
      public function RatingsBase()
      {
         super();
      }
      
      protected function handleCreationComplete() : void
      {
         callLater(this.initIconsAndTexts);
      }
      
      private function initIconsAndTexts() : void
      {
         this.ratingsTitleLabel.text = BPLocale.getItem("label_bswin_station_ratings");
         this.attackRating.init("attack_icon","tooltip_ratings_attack");
         this.defenceRating.init("defense_icon","tooltip_ratings_defense");
         this.repairRating.init("repair_icon","tooltip_ratings_repair");
         this.honourRating.init("honor_icon","tooltip_ratings_honor");
         this.epRating.init("booster_icon","tooltip_ratings_ep_booster");
         this.damageBoosterRating.init("damage_icon","tooltip_ratings_damage_booster");
         this.deflectorStatusTitle.text = BPLocale.getItem("label_bswin_deflector_status");
         this.deflectorTimeLabel.text = BPLocale.getItem("label_bswin_deflector_time");
         this.deflectorTimeRegRateLabel.text = BPLocale.getItem("label_bswin_deflector_reg_rate");
         this.deflectorToggleButton.label = BPLocale.getItem("btn_bswin_deactivate_deflector");
         this._regenerationTooltipText = BPLocale.getItem("tooltip_deflector_status");
      }
      
      public function updateDeflectorTimeProgress(param1:Boolean, param2:Number, param3:Number, param4:Number) : void
      {
         this.deflectorTimeProgressBar.setProgress(param2,param3);
         this.deflectorTimeValue.text = TimeFormatter.formatTime(param2);
         var _loc5_:String = BPLocale.getItem("abbreviation_minutes").replace("%VALUE%",param4);
         this.deflectorTimeRegRateValue.text = "+" + _loc5_ + " / " + BPLocale.getItem("abbreviation_hours").replace("%VALUE%","");
         if(param1 == false && param4 == 0)
         {
            this.deflectorTimeProgressEnability = false;
         }
      }
      
      protected function handleDeflectorShieldToggle(param1:MouseEvent) : void
      {
         dispatchEvent(new BattleStationWindowEvent(BattleStationWindowEvent.SHOW_DEFLECTOR_DEACTIVATION_POPUP));
      }
      
      public function set battleStationVO(param1:BattleStationVO) : void
      {
         this._battleStationVO = param1;
         this.attackRating.value = this._battleStationVO.attackRating;
         this.defenceRating.value = this._battleStationVO.defenceRating;
         this.repairRating.value = this._battleStationVO.repairRating;
         this.honourRating.value = this._battleStationVO.honorBoosterRating;
         this.epRating.value = this._battleStationVO.experienceBoosterRating;
         this.damageBoosterRating.value = this._battleStationVO.damageBoosterRating;
         this.updateDeflectorTimeProgress(this._battleStationVO.deflectorShieldActive,this._battleStationVO.deflectorStatusVO.deflectorShieldSeconds,this._battleStationVO.deflectorStatusVO.deflectorShieldSecondsMax,this._battleStationVO.deflectorShieldRate);
         this.deflectorTimeValue.text = TimeFormatter.formatTime(this._battleStationVO.deflectorStatusVO.deflectorShieldSeconds);
         this.deflectorToggleButton.enabled = this._battleStationVO.deflectorShieldActive;
      }
      
      private function set deflectorTimeProgressEnability(param1:Boolean) : void
      {
         this.deflectorTimeProgressBar.enabled = param1;
         this.deflectorTimeValue.enabled = param1;
         this.deflectorTimeRegRateValue.enabled = param1;
         this.deflectorTimeLabel.alpha = this.deflectorTimeProgressBar.alpha = this.deflectorTimeValue.alpha = this.deflectorTimeRegRateLabel.alpha = this.deflectorTimeRegRateValue.alpha = param1 ? 1 : 0.3;
      }
      
      public function get battleStationVO() : BattleStationVO
      {
         return this._battleStationVO;
      }
      
      [Bindable(event="propertyChange")]
      public function get ratingsTitleLabel() : Label
      {
         return this._1121609362ratingsTitleLabel;
      }
      
      public function set ratingsTitleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1121609362ratingsTitleLabel;
         if(_loc2_ !== param1)
         {
            this._1121609362ratingsTitleLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ratingsTitleLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get attackRating() : StatItem
      {
         return this._451917317attackRating;
      }
      
      public function set attackRating(param1:StatItem) : void
      {
         var _loc2_:Object = this._451917317attackRating;
         if(_loc2_ !== param1)
         {
            this._451917317attackRating = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attackRating",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get defenceRating() : StatItem
      {
         return this._975810061defenceRating;
      }
      
      public function set defenceRating(param1:StatItem) : void
      {
         var _loc2_:Object = this._975810061defenceRating;
         if(_loc2_ !== param1)
         {
            this._975810061defenceRating = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"defenceRating",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get repairRating() : StatItem
      {
         return this._188604534repairRating;
      }
      
      public function set repairRating(param1:StatItem) : void
      {
         var _loc2_:Object = this._188604534repairRating;
         if(_loc2_ !== param1)
         {
            this._188604534repairRating = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"repairRating",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get honourRating() : StatItem
      {
         return this._1971720286honourRating;
      }
      
      public function set honourRating(param1:StatItem) : void
      {
         var _loc2_:Object = this._1971720286honourRating;
         if(_loc2_ !== param1)
         {
            this._1971720286honourRating = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"honourRating",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get epRating() : StatItem
      {
         return this._1307886040epRating;
      }
      
      public function set epRating(param1:StatItem) : void
      {
         var _loc2_:Object = this._1307886040epRating;
         if(_loc2_ !== param1)
         {
            this._1307886040epRating = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"epRating",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get damageBoosterRating() : StatItem
      {
         return this._1359312414damageBoosterRating;
      }
      
      public function set damageBoosterRating(param1:StatItem) : void
      {
         var _loc2_:Object = this._1359312414damageBoosterRating;
         if(_loc2_ !== param1)
         {
            this._1359312414damageBoosterRating = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"damageBoosterRating",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deflectorStatusTitle() : Label
      {
         return this._364294868deflectorStatusTitle;
      }
      
      public function set deflectorStatusTitle(param1:Label) : void
      {
         var _loc2_:Object = this._364294868deflectorStatusTitle;
         if(_loc2_ !== param1)
         {
            this._364294868deflectorStatusTitle = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deflectorStatusTitle",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deflectorTimeLabel() : Label
      {
         return this._180754677deflectorTimeLabel;
      }
      
      public function set deflectorTimeLabel(param1:Label) : void
      {
         var _loc2_:Object = this._180754677deflectorTimeLabel;
         if(_loc2_ !== param1)
         {
            this._180754677deflectorTimeLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deflectorTimeLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deflectorTimeValue() : Label
      {
         return this._189999986deflectorTimeValue;
      }
      
      public function set deflectorTimeValue(param1:Label) : void
      {
         var _loc2_:Object = this._189999986deflectorTimeValue;
         if(_loc2_ !== param1)
         {
            this._189999986deflectorTimeValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deflectorTimeValue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deflectorTimeProgressBar() : ProgressBar
      {
         return this._1747110887deflectorTimeProgressBar;
      }
      
      public function set deflectorTimeProgressBar(param1:ProgressBar) : void
      {
         var _loc2_:Object = this._1747110887deflectorTimeProgressBar;
         if(_loc2_ !== param1)
         {
            this._1747110887deflectorTimeProgressBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deflectorTimeProgressBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deflectorTimeRegRateLabel() : Label
      {
         return this._1772252831deflectorTimeRegRateLabel;
      }
      
      public function set deflectorTimeRegRateLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1772252831deflectorTimeRegRateLabel;
         if(_loc2_ !== param1)
         {
            this._1772252831deflectorTimeRegRateLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deflectorTimeRegRateLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deflectorTimeRegRateValue() : Label
      {
         return this._1781498140deflectorTimeRegRateValue;
      }
      
      public function set deflectorTimeRegRateValue(param1:Label) : void
      {
         var _loc2_:Object = this._1781498140deflectorTimeRegRateValue;
         if(_loc2_ !== param1)
         {
            this._1781498140deflectorTimeRegRateValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deflectorTimeRegRateValue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deflectorToggleButton() : Button
      {
         return this._1225326616deflectorToggleButton;
      }
      
      public function set deflectorToggleButton(param1:Button) : void
      {
         var _loc2_:Object = this._1225326616deflectorToggleButton;
         if(_loc2_ !== param1)
         {
            this._1225326616deflectorToggleButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deflectorToggleButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      protected function get _regenerationTooltipText() : String
      {
         return this._275223558_regenerationTooltipText;
      }
      
      protected function set _regenerationTooltipText(param1:String) : void
      {
         var _loc2_:Object = this._275223558_regenerationTooltipText;
         if(_loc2_ !== param1)
         {
            this._275223558_regenerationTooltipText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_regenerationTooltipText",_loc2_,param1));
            }
         }
      }
   }
}


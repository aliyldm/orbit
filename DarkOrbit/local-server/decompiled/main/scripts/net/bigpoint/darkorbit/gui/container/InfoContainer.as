package net.bigpoint.darkorbit.gui.container
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.data.RankedHuntingEventData;
   import net.bigpoint.darkorbit.data.vo.RankedHuntStatsVO;
   import net.bigpoint.darkorbit.gui.BarStatesCollection;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.elements.InfoField;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.LifeCounterComponent;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class InfoContainer extends SimpleContainer
   {
      
      private var _component:DisplayObject;
      
      public function InfoContainer(param1:GuiManager, param2:int)
      {
         super(param1,param2);
      }
      
      public function setInfoField(param1:int, param2:String) : void
      {
         var _loc4_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < elements.length)
         {
            _loc4_ = elements[_loc3_];
            if(_loc4_ is InfoField)
            {
               if(InfoField(_loc4_).getID() == param1)
               {
                  InfoField(_loc4_).setText(param2);
               }
            }
            _loc3_++;
         }
      }
      
      public function updateInfoFieldView() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < elements.length)
         {
            _loc2_ = elements[_loc1_];
            if(_loc2_ is InfoField)
            {
               InfoField(_loc2_).updateView();
            }
            _loc1_++;
         }
      }
      
      public function updateInfoField(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RankedHuntStatsVO = null;
         var _loc5_:Object = null;
         var _loc6_:InfoField = null;
         var _loc7_:Ship = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:String = null;
         var _loc32_:int = 0;
         var _loc33_:Bitmap = null;
         var _loc34_:Boolean = false;
         var _loc35_:BarComponent = null;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:BarComponent = null;
         var _loc4_:int = 0;
         for(; _loc4_ < elements.length; _loc4_++)
         {
            _loc5_ = elements[_loc4_];
            if(!(_loc5_ is InfoField))
            {
               continue;
            }
            _loc6_ = _loc5_ as InfoField;
            if(_loc6_.getID() != param1)
            {
               continue;
            }
            switch(param1)
            {
               case SimpleElement.TYPE_CONFIGURATION:
                  _loc8_ = Settings.selectedConfiguration;
                  _loc6_.setLabel(_loc8_.toString());
                  _loc6_.setText(_loc8_.toString(),false);
                  break;
               case SimpleElement.TYPE_HITPOINTS:
                  if(this.map != null)
                  {
                     _loc7_ = this.map.hero;
                     if(_loc7_ != null)
                     {
                        _loc21_ = _loc7_.hp.hp.value;
                        _loc22_ = _loc7_.hp.maxHP.value;
                        _loc6_.setLabel(TextFormatter.roundInteger(_loc21_));
                        _loc6_.setText(TextFormatter.roundInteger(_loc21_) + InfoField.FIELD_SEPERATOR + TextFormatter.roundInteger(_loc22_));
                        _loc6_.setCounterbar(_loc21_,_loc22_);
                        if(BarStatesCollection.getBarState(SimpleElement.TYPE_HITPOINTS))
                        {
                           _loc6_.setViewMode(BarStatesCollection.getBarState(SimpleElement.TYPE_HITPOINTS).stateID);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_NANOHULL:
                  if(this.map != null)
                  {
                     _loc7_ = this.map.hero;
                     if(_loc7_ != null)
                     {
                        _loc23_ = _loc7_.hp.nanohullHP.value;
                        _loc24_ = _loc7_.hp.nanohullMaxHP.value;
                        _loc6_.setLabel(TextFormatter.roundInteger(_loc23_));
                        _loc6_.setText(TextFormatter.roundInteger(_loc23_) + InfoField.FIELD_SEPERATOR + TextFormatter.roundInteger(_loc24_));
                        if(_loc24_ > 0)
                        {
                           _loc6_.setCounterbar(_loc23_,_loc24_);
                        }
                        else
                        {
                           _loc6_.setCounterbar(_loc23_,1);
                        }
                        if(BarStatesCollection.getBarState(SimpleElement.TYPE_NANOHULL))
                        {
                           _loc6_.setViewMode(BarStatesCollection.getBarState(SimpleElement.TYPE_NANOHULL).stateID);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_SHIELD:
                  if(this.map != null)
                  {
                     _loc7_ = this.map.hero;
                     if(_loc7_ != null)
                     {
                        _loc25_ = _loc7_.hp.shield.value;
                        _loc26_ = _loc7_.hp.maxShield.value;
                        if(_loc26_ == 0 && _loc6_.visible)
                        {
                           _loc6_.visible = false;
                        }
                        else if(_loc26_ != 0 && !_loc6_.visible)
                        {
                           _loc6_.visible = true;
                        }
                        _loc6_.setLabel(TextFormatter.roundInteger(_loc25_));
                        _loc6_.setText(TextFormatter.roundInteger(_loc25_) + InfoField.FIELD_SEPERATOR + TextFormatter.roundInteger(_loc26_));
                        if(_loc26_ > 0)
                        {
                           _loc6_.setCounterbar(_loc25_,_loc26_);
                        }
                        else
                        {
                           _loc6_.setCounterbar(_loc25_,1);
                        }
                        if(BarStatesCollection.getBarState(SimpleElement.TYPE_SHIELD))
                        {
                           _loc6_.setViewMode(BarStatesCollection.getBarState(SimpleElement.TYPE_SHIELD).stateID);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_CARGO:
                  if(this.map != null)
                  {
                     _loc7_ = this.map.hero;
                     if(_loc7_ != null)
                     {
                        _loc27_ = Hero.cargo.value;
                        _loc28_ = Hero.maxCargo.value;
                        _loc6_.setLabel(TextFormatter.roundInteger(_loc27_));
                        _loc6_.setText(TextFormatter.roundInteger(_loc27_) + InfoField.FIELD_SEPERATOR + TextFormatter.roundInteger(_loc28_));
                        _loc6_.setCounterbar(_loc27_,_loc28_);
                        if(BarStatesCollection.getBarState(SimpleElement.TYPE_CARGO))
                        {
                           _loc6_.setViewMode(BarStatesCollection.getBarState(SimpleElement.TYPE_CARGO).stateID);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_SPEED:
                  _loc6_.setLabel(TextFormatter.roundInteger(Hero.shownSpeed));
                  break;
               case SimpleElement.TYPE_CREDITS:
                  _loc9_ = Hero.creditsAmount;
                  _loc6_.setLabel(TextFormatter.roundInteger(_loc9_));
                  _loc6_.setText(TextFormatter.roundInteger(_loc9_));
                  break;
               case SimpleElement.TYPE_URIDIUM:
                  _loc10_ = Hero.uridiumAmount;
                  _loc6_.setLabel(TextFormatter.roundInteger(_loc10_));
                  _loc6_.setText(TextFormatter.roundInteger(_loc10_));
                  break;
               case SimpleElement.TYPE_CAPTAIN_ENERGY:
                  if(this.map != null)
                  {
                     _loc7_ = this.map.hero;
                     if(_loc7_ != null)
                     {
                        _loc29_ = Hero.captainEnergy.value;
                        _loc30_ = Hero.maxCaptainEnergy.value;
                        _loc31_ = Hero.captainPerkInfo.value;
                        if(_loc30_ == 0 && _loc6_.visible)
                        {
                           _loc6_.visible = false;
                        }
                        else if(_loc30_ != 0 && !_loc6_.visible)
                        {
                           _loc6_.visible = true;
                        }
                        _loc6_.setLabel(TextFormatter.roundInteger(_loc29_));
                        _loc6_.setText(TextFormatter.roundInteger(_loc29_) + InfoField.FIELD_SEPERATOR + TextFormatter.roundInteger(_loc30_) + _loc31_);
                        _loc6_.setCounterbar(_loc29_,_loc30_);
                        if(BarStatesCollection.getBarState(SimpleElement.TYPE_CAPTAIN_ENERGY))
                        {
                           _loc6_.setViewMode(BarStatesCollection.getBarState(SimpleElement.TYPE_CAPTAIN_ENERGY).stateID);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_BOOTY_KEYS:
                  _loc11_ = Hero.bootyKeysAmount + Hero.bootyKeysBlueAmount + Hero.bootyKeysRedAmount + Hero.bootyKeysSilverAmount + Hero.bootyKeysMasqueAmount + Hero.bootyKeysPrometheusAmount + Hero.bootyKeysBlackAmount + Hero.bootyKeysBlacklightCipherAmount + Hero.bootyKeysBlacklightDecoderAmount + Hero.bootyKeysProsperousAmount + Hero.bootyKeysAstralAmount + Hero.bootyKeysAstralPrimeAmount + Hero.bootyKeysEmpyrianAmount + Hero.bootyKeysLucentAmount + Hero.bootyKeysPerseusAmount + Hero.bootyKeysLaurelAmount + Hero.bootyKeysEchoBlueAmount + Hero.bootyKeysEchoGreenAmount + Hero.bootyKeysEchoPurpleAmount + Hero.bootyKeysEchoRedAmount;
                  _loc12_ = String(_loc11_);
                  _loc6_.setLabel(_loc12_);
                  _loc13_ = "\n";
                  if(_loc11_ > 0)
                  {
                     if(Hero.bootyKeysAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-green").replace(/%AMOUNT%/,String(Hero.bootyKeysAmount)) + "\n";
                     }
                     if(Hero.bootyKeysBlueAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-blue").replace(/%AMOUNT%/,String(Hero.bootyKeysBlueAmount)) + "\n";
                     }
                     if(Hero.bootyKeysRedAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-red").replace(/%AMOUNT%/,String(Hero.bootyKeysRedAmount)) + "\n";
                     }
                     if(Hero.bootyKeysSilverAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-silver").replace(/%AMOUNT%/,String(Hero.bootyKeysSilverAmount)) + "\n";
                     }
                     if(Hero.bootyKeysMasqueAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-masque").replace(/%AMOUNT%/,String(Hero.bootyKeysMasqueAmount)) + "\n";
                     }
                     if(Hero.bootyKeysPrometheusAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-prometheus").replace(/%AMOUNT%/,String(Hero.bootyKeysPrometheusAmount)) + "\n";
                     }
                     if(Hero.bootyKeysBlackAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-black").replace(/%AMOUNT%/,String(Hero.bootyKeysBlackAmount)) + "\n";
                     }
                     if(Hero.bootyKeysBlacklightCipherAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-blacklight-cipher").replace(/%AMOUNT%/,String(Hero.bootyKeysBlacklightCipherAmount)) + "\n";
                     }
                     if(Hero.bootyKeysBlacklightDecoderAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-blacklight-decoder").replace(/%AMOUNT%/,String(Hero.bootyKeysBlacklightDecoderAmount)) + "\n";
                     }
                     if(Hero.bootyKeysProsperousAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-prosperous").replace(/%AMOUNT%/,String(Hero.bootyKeysProsperousAmount)) + "\n";
                     }
                     if(Hero.bootyKeysAstralAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-astral").replace(/%AMOUNT%/,String(Hero.bootyKeysAstralAmount)) + "\n";
                     }
                     if(Hero.bootyKeysAstralPrimeAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-astral-prime").replace(/%AMOUNT%/,String(Hero.bootyKeysAstralPrimeAmount)) + "\n";
                     }
                     if(Hero.bootyKeysEmpyrianAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-empyrian").replace(/%AMOUNT%/,String(Hero.bootyKeysEmpyrianAmount)) + "\n";
                     }
                     if(Hero.bootyKeysLucentAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-lucent").replace(/%AMOUNT%/,String(Hero.bootyKeysLucentAmount)) + "\n";
                     }
                     if(Hero.bootyKeysPerseusAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-perseus").replace(/%AMOUNT%/,String(Hero.bootyKeysPerseusAmount)) + "\n";
                     }
                     if(Hero.bootyKeysLaurelAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_booty-key-laurel").replace(/%AMOUNT%/,String(Hero.bootyKeysLaurelAmount)) + "\n";
                     }
                     if(Hero.bootyKeysEchoBlueAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_echo-key-blue").replace(/%AMOUNT%/,String(Hero.bootyKeysEchoBlueAmount)) + "\n";
                     }
                     if(Hero.bootyKeysEchoGreenAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_echo-key-green").replace(/%AMOUNT%/,String(Hero.bootyKeysEchoGreenAmount)) + "\n";
                     }
                     if(Hero.bootyKeysEchoPurpleAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_echo-key-purple").replace(/%AMOUNT%/,String(Hero.bootyKeysEchoPurpleAmount)) + "\n";
                     }
                     if(Hero.bootyKeysEchoRedAmount > 0)
                     {
                        _loc13_ += BPLocale.getItem("ttip_echo-key-red").replace(/%AMOUNT%/,String(Hero.bootyKeysEchoRedAmount)) + "\n";
                     }
                  }
                  _loc6_.setText(_loc13_,false);
                  break;
               case SimpleElement.TYPE_JUMP_VOUCHERS:
                  _loc14_ = Hero.jumpVouchersAmount;
                  _loc6_.setLabel(TextFormatter.roundInteger(_loc14_));
                  _loc6_.setText(TextFormatter.roundInteger(_loc14_),false);
                  break;
               case SimpleElement.TYPE_EXPERIENCE:
                  _loc15_ = Hero.experiencePoints;
                  _loc6_.setLabel(TextFormatter.roundInteger(_loc15_));
                  _loc6_.setText(TextFormatter.roundInteger(_loc15_));
                  break;
               case SimpleElement.TYPE_HONOR:
                  _loc16_ = Hero.honorPoints;
                  _loc6_.setLabel(TextFormatter.roundInteger(_loc16_));
                  _loc6_.setText(TextFormatter.roundInteger(_loc16_));
                  break;
               case SimpleElement.TYPE_LEVEL:
                  _loc17_ = Hero.level;
                  _loc6_.setLabel(_loc17_.toString());
                  _loc6_.setText(_loc17_.toString(),false);
                  break;
               case SimpleElement.TYPE_RANKED_HUNT_POINTS:
                  _loc2_ = Hero.rankedHuntingEventData.currentID;
                  _loc3_ = Hero.rankedHuntingEventData.eventVOs[_loc2_];
                  if(_loc3_ != null)
                  {
                     _loc32_ = _loc3_.bountyPoints;
                     _loc6_.setLabel(TextFormatter.roundInteger(_loc32_));
                     if(_loc3_.targetVerbose != null)
                     {
                        _loc6_.updateTooltip(BPLocale.getItem(_loc6_.languageKey) + "\n" + _loc3_.targetVerbose);
                     }
                     if(_loc3_.targetList != null)
                     {
                        if(_loc3_.targetList.length > 1 || _loc3_.categoryID == RankedHuntingEventData.CATEGORY_PIRATE_HUNT)
                        {
                           _loc33_ = ResourceManager.getBitmap("ui","rankedHuntIcon_" + InGameCatalog.getInstance().rankedHunt_categories[_loc3_.categoryID]);
                        }
                        else
                        {
                           _loc33_ = ResourceManager.getBitmap("ui","rankedHuntIcon_npc" + _loc3_.targetList[0]);
                        }
                        if(_loc33_ != null)
                        {
                           _loc6_.updateIcon(_loc33_);
                        }
                     }
                  }
                  break;
               case SimpleElement.TYPE_CLAN_RANKED_CLAN_POINTS:
                  _loc2_ = Hero.rankedHuntingEventData.currentID;
                  _loc3_ = Hero.rankedHuntingEventData.eventVOs[_loc2_];
                  if(_loc3_ != null)
                  {
                     _loc34_ = true;
                     if(_loc3_.clanBountyPointsInSync)
                     {
                        _loc6_.setColor(15580416);
                        _loc34_ = false;
                     }
                     else
                     {
                        _loc6_.setColor(int(Styles.infoFieldFmt.color));
                        _loc34_ = _loc34_;
                     }
                     if(_loc34_)
                     {
                        _loc6_.setText(BPLocale.getItem("ttip_clan_bounty_points_updated_in_5_minute_cycle"));
                     }
                     _loc6_.getChildByName("CLOCK_ICON").visible = _loc34_;
                     _loc6_.setLabel(TextFormatter.roundInteger(_loc3_.clanBountyPoints));
                  }
                  break;
               case SimpleElement.TYPE_HSG_TIME_LEFT:
                  _loc18_ = Hero.highScoreGateStatsData.timeLeft;
                  _loc6_.setTimeInSec(_loc18_);
                  break;
               case SimpleElement.TYPE_HSG_POINTS:
                  _loc19_ = Hero.highScoreGateStatsData.points;
                  _loc6_.setLabel(TextFormatter.roundInteger(_loc19_));
                  break;
               case SimpleElement.TYPE_HSG_WAVE:
                  _loc20_ = Hero.highScoreGateStatsData.wave;
                  _loc6_.setLabel(TextFormatter.roundInteger(_loc20_));
                  break;
               case SimpleElement.TYPE_SCF_COMBO:
                  if(this._component)
                  {
                     _loc35_ = this._component as BarComponent;
                     _loc36_ = Hero.scoreFestStatsData.combo - 1;
                     _loc37_ = Hero.scoreFestStatsData.maxCombo - 1;
                     _loc35_.update(_loc36_,_loc37_);
                     _loc35_.updateBarValueSeparately(Hero.scoreFestStatsData.combo);
                     if(_loc36_ > 0)
                     {
                        _loc35_.pulseTheBar(3);
                     }
                  }
                  break;
               case SimpleElement.TYPE_SCF_COMBO_TIMER:
                  if(this._component)
                  {
                     _loc38_ = this._component as BarComponent;
                     _loc38_.flashBelowThreshold = Hero.scoreFestStatsData.comboTimerFlashThreshold;
                     _loc38_.update(Hero.scoreFestStatsData.comboTimer,Hero.scoreFestStatsData.comboTimerMax);
                     if(Hero.scoreFestStatsData.comboTimer > 0)
                     {
                        _loc38_.pulseTheBar(1,0.5);
                        _loc38_.setTimeInSec(Hero.scoreFestStatsData.comboTimer);
                     }
                  }
                  break;
               case SimpleElement.TYPE_SCF_LIVES_LEFT:
                  if(this._component)
                  {
                     (this._component as LifeCounterComponent).setRemainingLives(Hero.scoreFestStatsData.lives,Hero.scoreFestStatsData.maxLives);
                  }
                  break;
               case SimpleElement.TYPE_SCF_SCORE:
                  _loc6_.setLabel(TextFormatter.roundInteger(Hero.scoreFestStatsData.points));
            }
         }
      }
      
      public function get component() : DisplayObject
      {
         return this._component;
      }
      
      public function set component(param1:DisplayObject) : void
      {
         this._component = param1;
         if(!this.contains(this._component))
         {
            this.addChild(this._component);
         }
      }
      
      private function get map() : Map
      {
         return ScreenManager.getInstance().map;
      }
   }
}


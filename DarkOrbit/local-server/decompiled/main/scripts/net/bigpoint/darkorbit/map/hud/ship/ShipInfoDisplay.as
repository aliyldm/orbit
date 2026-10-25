package net.bigpoint.darkorbit.map.hud.ship
{
   import com.adobe.utils.StringUtil;
   import com.bigpoint.utils.PointLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.map.model.traits.MercenaryTeamTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.CrowdedCombatPreset;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   
   public class ShipInfoDisplay extends Sprite implements IDisposable
   {
      
      private static const OUTER_GLOW_FILTER:Array = [new GlowFilter(0,0.7,5,5,6,BitmapFilterQuality.HIGH)];
      
      private static const NO_FILTER:Array = [];
      
      public static const PLAYER_CAMP_NPC_TYPE:String = "PLAYER_CAMP_NPC_TYPE";
      
      private static const CLAN_COLORS_BY_DIPLOMACY:Object = {};
      
      CLAN_COLORS_BY_DIPLOMACY[1] = "allied";
      CLAN_COLORS_BY_DIPLOMACY[2] = "noAttackPact";
      CLAN_COLORS_BY_DIPLOMACY[3] = "atWar";
      
      private var _displaySprite:Sprite = new Sprite();
      
      private var _rankIcon:Bitmap = new Bitmap();
      
      private var _ggIcon:Bitmap = new Bitmap();
      
      private var _factionIcon:Bitmap = new Bitmap();
      
      private var _nameLable:TextField = new TextField();
      
      private var _clanLable:TextField = new TextField();
      
      private var _titleLable:TextField = new TextField();
      
      private var _owner:MapEntity;
      
      private var _cacheStaticText:Boolean;
      
      private var _trait:MapObjectInfoTrait;
      
      private var _hGroup:HorizontalGroup = new HorizontalGroup();
      
      private var _vGroup:VerticalGroup = new VerticalGroup();
      
      private var _hRankGroup:HorizontalGroup = new HorizontalGroup();
      
      private var _pvpReputation:TextField = new TextField();
      
      private var _pvpRankIcon:Bitmap = new Bitmap();
      
      public function ShipInfoDisplay(param1:MapObjectInfoTrait, param2:Boolean = false)
      {
         super();
         this._cacheStaticText = param2;
         this._trait = param1;
         this._owner = param1.owner;
         this._trait.clanTag.changed.add(this.markDirty);
         this._trait.dailyRank.changed.add(this.markDirty);
         this._trait.factionID.changed.add(this.markDirty);
         this._trait.galaxyGatesFinished.changed.add(this.markDirty);
         this._trait.titleID.changed.add(this.markDirty);
         this._trait.username.changed.add(this.markDirty);
         this._trait.pvpReputation.changed.add(this.markDirty);
         this._trait.saeScore.changed.add(this.markDirty);
         addChild(this._displaySprite);
         this._vGroup.gap = 3;
         this._vGroup.addElement(this._ggIcon);
         this._vGroup.addElement(this._rankIcon);
         this._vGroup.alignment = VerticalGroup.CENTER;
         this._hGroup.alignment = HorizontalGroup.CUSTOM;
         this._hGroup.childLayout = HorizontalGroup.CENTER;
         this._hGroup.addElement(this._vGroup);
         this._hGroup.addElement(this._clanLable);
         this._hGroup.addElement(this._nameLable);
         this._hGroup.addElement(this._factionIcon);
         this._hRankGroup.alignment = HorizontalGroup.CUSTOM;
         this._hRankGroup.childLayout = HorizontalGroup.CENTER;
         this._hRankGroup.addElement(this._pvpRankIcon);
         this._hRankGroup.addElement(this._pvpReputation);
         this._hRankGroup.visible = false;
         this._displaySprite.addChild(this._titleLable);
         this._displaySprite.addChild(this._hGroup);
         this._displaySprite.addChild(this._hRankGroup);
         Settings.displayPlayerNames.changed.add(this.settingsChanged);
         CrowdedCombatPreset.changed.add(this.markDirty);
         this.settingsChanged();
         this.markDirty();
      }
      
      public static function setFinishedGalaxyGates(param1:int) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 != 0)
         {
            _loc2_ = [];
            _loc3_ = 0;
            while(_loc3_ < GalaxyGateIconPositions.NUMBER_OF_GATES)
            {
               _loc2_[_loc3_] = false;
               _loc4_ = 1 << _loc3_;
               if((param1 & _loc4_) == _loc4_)
               {
                  _loc2_[_loc3_] = true;
               }
               _loc3_++;
            }
            return _loc2_;
         }
         return [];
      }
      
      private static function getClanColorId(param1:int) : String
      {
         return CLAN_COLORS_BY_DIPLOMACY[param1] || "neutral";
      }
      
      private static function getNameColorID(param1:MapObjectInfoTrait, param2:MapObjectInfoTrait) : String
      {
         var _loc3_:String = null;
         var _loc4_:Pet = null;
         var _loc5_:MercenaryTeamTrait = null;
         var _loc6_:MercenaryTeamTrait = null;
         var _loc7_:MapObjectInfoTrait = null;
         _loc5_ = _loc6_ = null;
         if(param1.owner.id != param2.owner.id)
         {
            _loc4_ = param1.owner as Pet;
            if(_loc4_ != null)
            {
               _loc7_ = ScreenManager.getInstance().map.getTraitById(_loc4_.ownerID,MapObjectInfoTrait) as MapObjectInfoTrait;
               if(_loc7_)
               {
                  param1 = _loc7_;
               }
            }
            _loc5_ = param1.owner.getFirstTrait(MercenaryTeamTrait) as MercenaryTeamTrait;
            _loc6_ = param2.owner.getFirstTrait(MercenaryTeamTrait) as MercenaryTeamTrait;
         }
         if(Map.inSAEMap(ScreenManager.getInstance().map.getMapID()))
         {
            if(param1.owner.id == Hero.userID || param1.owner is Pet && Pet(param1.owner).isHeroPet())
            {
               _loc3_ = "neutral";
            }
            else
            {
               _loc3_ = "enemy";
            }
         }
         else if(param1.owner.id == Hero.userID || param1.owner is Pet && Pet(param1.owner).isHeroPet())
         {
            _loc3_ = "neutral";
         }
         else if(Boolean(_loc5_) && Boolean(_loc6_))
         {
            _loc3_ = _loc5_.teamId == _loc6_.teamId ? "sameFraction" : "enemy";
         }
         else if(param1.owner is Ship && (param1.owner as Ship).isGroupMember.value)
         {
            _loc3_ = "sameGroup";
         }
         else if(param1.clanID.value != 0 && param1.clanID.value == param2.clanID.value || param1.username.value == "-={EM Freighter}=-")
         {
            _loc3_ = "sameClan";
         }
         else if(param1.factionID.value == param2.factionID.value)
         {
            _loc3_ = "sameFraction";
         }
         else if(Boolean(param1.owner is Ship) && Boolean((param1.owner as Ship).shipPattern) && (param1.owner as Ship).shipPattern.isLegendaryEventNPC)
         {
            _loc3_ = "legendary";
         }
         else if(param1.specialType.value == PLAYER_CAMP_NPC_TYPE)
         {
            _loc3_ = "allied";
         }
         else
         {
            _loc3_ = "enemy";
         }
         return _loc3_;
      }
      
      private function updatePositions() : void
      {
         this._hGroup.y = this._ggIcon.visible ? (this._titleLable.visible ? this._titleLable.height : 0) + this._ggIcon.height : (this._titleLable.visible ? this._titleLable.height : 0);
         this._vGroup.y = this._ggIcon.visible ? -this._ggIcon.height : 4;
         this._hRankGroup.y = this._hGroup.y + this._hGroup.height;
         this._vGroup.updateLayout();
         this._hGroup.updateLayout();
         this._hRankGroup.updateLayout();
         this._titleLable.x = -this._titleLable.width / 2;
      }
      
      private function updateTitle() : void
      {
         this._titleLable.visible = Boolean(this._trait.titleID.value);
         if(!this._trait.titleID.value)
         {
            return;
         }
         var _loc1_:String = BPLocaleUtils.hasTranslation(this._trait.titleID.value) ? BPLocale.getItem(this._trait.titleID.value) : BPLocale.getItemInCategory("achievements",this._trait.titleID.value);
         var _loc2_:uint = InGameCatalog.instance.getTitleColor(this._trait.titleID.value);
         this._titleLable.defaultTextFormat = Styles.shipInfoTitleSymbolFmt;
         this._titleLable.embedFonts = Styles.shipInfoTitleSymbolEmbed;
         this._titleLable.antiAliasType = AntiAliasType.ADVANCED;
         this._titleLable.textColor = _loc2_;
         this._titleLable.text = "<" + _loc1_ + ">";
         if(CrowdedCombatPreset.enabled)
         {
            this._titleLable.filters = NO_FILTER;
            this._titleLable.thickness = 0;
         }
         else if(InGameCatalog.instance.isMonthlyTitle(this._trait.titleID.value))
         {
            this._titleLable.filters = [new GlowFilter(16777067,0.7,5,5,6,BitmapFilterQuality.HIGH)];
            this._titleLable.thickness = 200;
         }
         else
         {
            this._titleLable.filters = OUTER_GLOW_FILTER;
            this._titleLable.thickness = 0;
         }
         this._titleLable.autoSize = TextFieldAutoSize.LEFT;
      }
      
      private function updateIcons() : void
      {
         var _loc1_:BitmapData = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:BitmapData = null;
         var _loc11_:PointLite = null;
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("icons"));
         if(this._trait.dailyRank.value != 0)
         {
            this._rankIcon.visible = true;
            this._rankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("rank" + this._trait.dailyRank.value));
         }
         else
         {
            this._rankIcon.visible = false;
         }
         if(this._trait.factionID.value != 0 && !Map.inSAEMap(ScreenManager.getInstance().map.getMapID()))
         {
            try
            {
               _loc1_ = BitmapData(_loc2_.getEmbeddedBitmapData("fraction" + this._trait.factionID.value));
            }
            catch(e:Error)
            {
            }
            this._factionIcon.bitmapData = _loc1_;
            this._factionIcon.visible = true;
         }
         else
         {
            if(this._factionIcon.bitmapData)
            {
               this._factionIcon.bitmapData.dispose();
            }
            this._factionIcon.visible = false;
         }
         if(this._trait.galaxyGatesFinished.value > 0)
         {
            _loc5_ = ResourceManager.getBitmapData("ui","ggIconBg");
            _loc6_ = setFinishedGalaxyGates(this._trait.galaxyGatesFinished.value);
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = Boolean(_loc6_[_loc8_]);
               if(_loc9_)
               {
                  _loc10_ = ResourceManager.getBitmapData("ui",GalaxyGateIconPositions.resKeyFromID[_loc8_]);
                  _loc11_ = GalaxyGateIconPositions.galaxyGateIconsPositionMap[_loc8_];
                  _loc5_.copyPixels(_loc10_,_loc10_.rect,new Point(_loc11_.x,_loc11_.y));
               }
               _loc8_++;
            }
            this._ggIcon.bitmapData = _loc5_;
            this._ggIcon.visible = true;
         }
         else
         {
            this._ggIcon.bitmapData = null;
            this._ggIcon.visible = false;
         }
         var _loc3_:int = this._trait.pvpReputation.value;
         var _loc4_:int = this._trait.saeScore.value;
         if(_loc4_ < 0)
         {
            if(_loc3_ < 0)
            {
               this._hRankGroup.visible = false;
            }
            else if(_loc3_ >= 0 && _loc3_ <= 750)
            {
               this._pvpRankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("reputation_bronze"));
            }
            else if(_loc3_ >= 751 && _loc3_ <= 1000)
            {
               this._pvpRankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("reputation_bronze_plus"));
            }
            else if(_loc3_ >= 1001 && _loc3_ <= 1500)
            {
               this._pvpRankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("reputation_silver"));
            }
            else if(_loc3_ >= 1501 && _loc3_ <= 2000)
            {
               this._pvpRankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("reputation_silver_plus"));
            }
            else if(_loc3_ >= 2001 && _loc3_ <= 2500)
            {
               this._pvpRankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("reputation_gold"));
            }
            else
            {
               this._pvpRankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("reputation_gold_plus"));
            }
         }
         else
         {
            this._pvpRankIcon.bitmapData = BitmapData(_loc2_.getEmbeddedBitmapData("stellar_coin"));
         }
      }
      
      private function updateName() : void
      {
         var _loc1_:Map = ScreenManager.getInstance().map;
         var _loc2_:String = Boolean(_loc1_) && Boolean(_loc1_.hero) ? getNameColorID(this._trait,_loc1_.hero.info) : "";
         var _loc3_:String = PatternManager.colorPatterns[_loc2_] || PatternManager.colorPatterns["enemy"];
         var _loc4_:uint = parseInt("0x" + _loc3_);
         var _loc5_:TextFormat = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,_loc4_,Styles.nickFmt.bold);
         this._nameLable.defaultTextFormat = _loc5_;
         this._nameLable.embedFonts = Styles.nickEmbed;
         this._nameLable.antiAliasType = AntiAliasType.ADVANCED;
         this._nameLable.text = StringUtil.trim(this._trait.username.value);
         this._nameLable.filters = CrowdedCombatPreset.enabled ? NO_FILTER : OUTER_GLOW_FILTER;
         this._nameLable.autoSize = TextFieldAutoSize.LEFT;
      }
      
      private function updateClan() : void
      {
         var _loc1_:String = getClanColorId(this._trait.clanDiplomacy.value);
         var _loc2_:String = PatternManager.colorPatterns[_loc1_] || PatternManager.colorPatterns["enemy"];
         var _loc3_:uint = parseInt("0x" + _loc2_);
         var _loc4_:TextFormat = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,_loc3_,Styles.nickFmt.bold);
         this._clanLable.defaultTextFormat = _loc4_;
         this._clanLable.embedFonts = Styles.nickEmbed;
         this._clanLable.antiAliasType = AntiAliasType.ADVANCED;
         if(Map.inSAEMap(ScreenManager.getInstance().map.getMapID()))
         {
            this._clanLable.text = "";
         }
         else
         {
            this._clanLable.text = this._trait.clanTag.value ? "[" + StringUtil.trim(this._trait.clanTag.value) + "]" : "";
         }
         this._clanLable.filters = CrowdedCombatPreset.enabled ? NO_FILTER : OUTER_GLOW_FILTER;
         this._clanLable.autoSize = TextFieldAutoSize.LEFT;
         this._clanLable.visible = this._trait.clanTag.value != Hero.NO_CLAN && Boolean(this._trait.clanTag.value);
      }
      
      private function updatePvpReputation() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:TextFormat = null;
         if(this._trait.pvpReputation.value >= 0 || this._trait.saeScore.value >= 0)
         {
            _loc1_ = PatternManager.colorPatterns["neutral"];
            _loc2_ = parseInt("0x" + _loc1_);
            _loc3_ = new TextFormat(Styles.nickFmt.font,Styles.nickFontHeight,_loc2_,Styles.nickFmt.bold);
            this._pvpReputation.defaultTextFormat = _loc3_;
            this._pvpReputation.embedFonts = Styles.nickEmbed;
            this._pvpReputation.antiAliasType = AntiAliasType.ADVANCED;
            this._pvpReputation.text = this._trait.saeScore.value >= 0 ? String(this._trait.saeScore.value) : String(this._trait.pvpReputation.value);
            this._pvpReputation.filters = CrowdedCombatPreset.enabled ? NO_FILTER : OUTER_GLOW_FILTER;
            this._pvpReputation.autoSize = TextFieldAutoSize.LEFT;
            this._hRankGroup.visible = true;
         }
         else
         {
            this._hRankGroup.visible = false;
         }
      }
      
      private function markDirty() : void
      {
         if(hasEventListener(Event.ENTER_FRAME))
         {
            return;
         }
         if(!visible)
         {
            return;
         }
         addEventListener(Event.ENTER_FRAME,this.redraw);
      }
      
      private function redraw(param1:Event = null) : void
      {
         if(param1)
         {
            removeEventListener(Event.ENTER_FRAME,arguments.callee);
         }
         this.updateClan();
         this.updateName();
         this.updateIcons();
         this.updateTitle();
         this.updatePvpReputation();
         this.updatePositions();
         StaticHUDTextCache.configure(this._nameLable,this._cacheStaticText);
         StaticHUDTextCache.configure(this._clanLable,this._cacheStaticText);
         StaticHUDTextCache.configure(this._titleLable,this._cacheStaticText);
         StaticHUDTextCache.configure(this._pvpReputation,this._cacheStaticText);
      }
      
      private function settingsChanged() : void
      {
         this.visible = Settings.displayPlayerNames.value;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         Settings.displayPlayerNames.changed.remove(this.settingsChanged);
         CrowdedCombatPreset.changed.remove(this.markDirty);
         this._trait.clanTag.changed.remove(this.markDirty);
         this._trait.dailyRank.changed.remove(this.markDirty);
         this._trait.factionID.changed.remove(this.markDirty);
         this._trait.galaxyGatesFinished.changed.remove(this.markDirty);
         this._trait.titleID.changed.remove(this.markDirty);
         this._trait.username.changed.remove(this.markDirty);
         this._trait.pvpReputation.changed.remove(this.markDirty);
         removeEventListener(Event.ENTER_FRAME,this.redraw);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(visible != param1)
         {
            super.visible = param1;
            this.markDirty();
         }
      }
   }
}


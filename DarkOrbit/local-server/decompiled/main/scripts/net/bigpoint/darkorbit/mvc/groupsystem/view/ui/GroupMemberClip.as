package net.bigpoint.darkorbit.mvc.groupsystem.view.ui
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.GroupMember;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.RaidGateConstants;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.StubShip;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   
   public class GroupMemberClip extends Sprite
   {
      
      private static const NICK_NAME_LABLE_X:int = 24;
      
      private static const RAID_GATE_ICON_BORDERSIZE:int = 1;
      
      private static const RAID_GATE_ICON_BOTTOM_GAP:int = 4;
      
      private var _raidGateIcon:RaidGateIcon;
      
      private var _isSelected:Boolean;
      
      private var _isInRaidGate:Boolean;
      
      private var _raidGateStatus:int;
      
      private var _member:GroupMember;
      
      private var _nickLabel:TextField;
      
      private var _nickName:String;
      
      private var _clanTag:String;
      
      private var _shipType:int;
      
      private var _shipClip:ShipIconWithBarCombonents;
      
      private var _mapID:int;
      
      private var _mapLabel:TextField;
      
      private var _mapLabelTooltip:ToolTipHook;
      
      private var _cloakedState:Boolean;
      
      private var _isOffline:Boolean;
      
      private var _groupUi:GroupUI;
      
      private var _targetOverLay:DisplayObjectContainer = new Sprite();
      
      private var _targetClip:ShipIconWithBarCombonents;
      
      private var _elementOffsetY:int = 0;
      
      private var _reservedHeight:int = 0;
      
      private var _leadIcon:Bitmap;
      
      private var _isLead:Boolean;
      
      private var _stdFormat:TextFormat;
      
      private var _foggyFormat:TextFormat;
      
      private var _inFight:Boolean;
      
      private var _bg:Sprite;
      
      private var _fullClip:Sprite;
      
      private var _editingEnabled:Boolean;
      
      private var _targetingMemberEnabled:Boolean;
      
      private var _tooltipHitpointsBaseLabel:String;
      
      private var _tooltipNanohullBaseLabel:String;
      
      private var _tooltipShieldBaseLabel:String;
      
      private var _target:StubShip = new StubShip();
      
      private var _isSelectedGlowFilter:Array = [new GlowFilter(33023,1,2,2,50,1,true)];
      
      public function GroupMemberClip()
      {
         super();
         this._bg = new Sprite();
         this._bg.addChild(new Bitmap(new BitmapData(216,40,true,0)));
         addChildAt(this._bg,0);
         this._mapLabel = new TextField();
         this._mapLabel.width = 24;
         this._mapLabel.y = 4;
         this._mapLabelTooltip = TooltipControl.getInstance().addToolTip(this._mapLabel,"?");
         addChild(this._mapLabel);
         this._nickLabel = new TextField();
         this._nickLabel.x = NICK_NAME_LABLE_X;
         addChild(this._nickLabel);
         this._fullClip = new Sprite();
         this._fullClip.mouseEnabled = false;
         this._fullClip.mouseChildren = true;
         this.initStyles();
         this._elementOffsetY += Styles.simpleFontHeight + 6;
         this._reservedHeight = (Styles.simpleFontHeight + 10) * 2;
         this._tooltipHitpointsBaseLabel = BPLocale.getItem("label_grp_hitpoints");
         this._tooltipNanohullBaseLabel = BPLocale.getItem("label_grp_nanohull");
         this._tooltipShieldBaseLabel = BPLocale.getItem("label_grp_shield");
         this._fullClip.addChild(this.getOverLayGraphic());
      }
      
      private function getOverLayGraphic() : DisplayObject
      {
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(855671039);
         _loc2_.drawRoundRect(-1,-1,190,45,20);
         return _loc1_;
      }
      
      private function setTargetGraphic(param1:Bitmap) : void
      {
         this._targetOverLay.addChild(param1);
      }
      
      public function disableEditing() : void
      {
         if(!this._editingEnabled)
         {
            return;
         }
         if(contains(this._fullClip))
         {
            removeChild(this._fullClip);
         }
         this._fullClip.removeEventListener(MouseEvent.CLICK,this.memberClickHandler);
         this._fullClip.removeEventListener(MouseEvent.MOUSE_OVER,this.memberRollOverHandler);
         this._fullClip.removeEventListener(MouseEvent.MOUSE_OUT,this.memberRollOutHandler);
         this._editingEnabled = false;
      }
      
      public function enableEditing() : void
      {
         if(this._editingEnabled)
         {
            return;
         }
         if(!contains(this._fullClip))
         {
            addChild(this._fullClip);
            this._fullClip.alpha = 0;
         }
         addEventListener(MouseEvent.CLICK,this.memberClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.memberRollOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.memberRollOutHandler);
         this._editingEnabled = true;
      }
      
      public function dispose() : void
      {
      }
      
      private function initStyles() : void
      {
         this._stdFormat = new TextFormat(Styles.simpleFmt.font,Styles.simpleFontHeight);
         this._stdFormat.color = Styles.WHITE;
         this._foggyFormat = new TextFormat(Styles.simpleFmt.font,Styles.simpleFontHeight);
         this._foggyFormat.color = 10066329;
         var _loc1_:TextFormat = new TextFormat(Styles.simpleFmt.font,Styles.simpleFontHeight * 0.5);
         _loc1_.color = 16777215;
         this.setStyle(this._nickLabel,this._stdFormat,Styles.simpleEmbed);
         var _loc2_:TextFormat = new TextFormat(Styles.infoFieldFmt.font,Styles.infoFieldFontHeight);
         _loc2_.color = 10066329;
         _loc2_.align = TextFormatAlign.CENTER;
         this._mapLabel.height = Styles.infoFieldFontHeight + 6;
         this._mapLabel.embedFonts = Styles.infoFieldEmbed;
         this._mapLabel.defaultTextFormat = _loc2_;
         this._mapLabel.antiAliasType = AntiAliasType.ADVANCED;
         this._mapLabel.selectable = false;
      }
      
      private function setStyle(param1:TextField, param2:TextFormat, param3:Boolean) : void
      {
         param1.height = int(param2.size) + 6;
         param1.embedFonts = param3;
         param1.defaultTextFormat = param2;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.selectable = false;
      }
      
      private function disableTargetingTarget() : void
      {
      }
      
      private function enableTargetingTarget() : void
      {
      }
      
      public function update() : void
      {
         this.updateShip();
         this.updateNickLabel();
         this.updateMap();
         this.updateTarget();
         this.updateShield();
         this.updateHitpoints();
         this.updateNanohull();
         this.updateLead();
         this.updateRaidGateStatus();
      }
      
      private function updateTarget() : void
      {
         this.updateTargetClip();
         this.updateTargetHitpoints();
         this.updateTargetShield();
         this.updateTargetNanohull();
         this.updateTargetNickName();
      }
      
      private function updateTargetNickName() : void
      {
         if(this._target.nickname != this._member.targetObject.nickname)
         {
            this._target.nickname = this._member.targetObject.nickname;
            if(Boolean(this._target.nickname) && Boolean(this._target.nickname.length))
            {
               TooltipControl.getInstance().addToolTip(this._targetOverLay,this._target.nickname);
            }
            else
            {
               TooltipControl.getInstance().addToolTip(this._targetOverLay,"---");
            }
         }
      }
      
      private function updateShip() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this._isOffline != this._member.isOffline)
         {
            this._isOffline = this._member.isOffline;
            _loc1_ = true;
            _loc2_ = true;
         }
         if(this._shipType != this._member.memberObject.shipType)
         {
            this._shipType = this._member.memberObject.shipType;
            _loc1_ = true;
            _loc2_ = true;
         }
         if(this._cloakedState != this._member.isCloaked)
         {
            this._cloakedState = this._member.isCloaked;
            _loc1_ = true;
         }
         if(this._inFight != this._member.fightState)
         {
            this._inFight = this._member.fightState;
            _loc1_ = true;
         }
         if(this._target.shipType != this._member.targetObject.shipType)
         {
            this._target.shipType = this._member.targetObject.shipType;
            _loc1_ = true;
            _loc2_ = true;
         }
         if(_loc1_)
         {
            this.getShipClip(_loc2_).cloaked = this._cloakedState;
            this.getShipClip().inFight = this._inFight;
         }
      }
      
      private function getShipClip(param1:Boolean = false) : ShipIcon
      {
         if(this._shipClip == null)
         {
            if(this._isOffline)
            {
               this._shipClip = new ShipIconWithBarCombonents();
               this._shipClip.isOffline = this._member.isOffline;
               this._shipClip.baseGraphic = this._groupUi.getUiBitmap("disconnect_icon.png");
            }
            else
            {
               this._shipClip = this._groupUi.getShipIconWithBarComponent(this._member.memberObject.shipType);
               this._shipClip.isOffline = this._member.isOffline;
            }
            this._shipClip.x = 4;
            this._shipClip.y = Styles.simpleFontHeight + 8;
            addChildAt(this._shipClip,1);
         }
         else if(param1)
         {
            if(this._isOffline)
            {
               this._shipClip.isOffline = this._member.isOffline;
               this._shipClip.baseGraphic = this._groupUi.getUiBitmap("disconnect_icon.png");
            }
            else
            {
               this._shipClip.baseGraphic = this._groupUi.getShipIconBitmap(this._member.memberObject.shipType);
               this._shipClip.isOffline = this._member.isOffline;
            }
         }
         return this._shipClip;
      }
      
      private function updateTargetClip() : void
      {
         if(Boolean(this._member.targetObject) && this._member.targetObject.shipType == -1)
         {
            if(this._targetClip != null && contains(this._targetClip))
            {
               removeChild(this._targetClip);
            }
            this._targetClip = null;
         }
         else if(this._member.targetObject != null && this._member.targetObject.shipType > 0)
         {
            if(this._targetClip != null && Boolean(this._targetClip.parent))
            {
               this._targetClip.baseGraphic = this._groupUi.getShipIconBitmap(this._member.targetObject.shipType);
            }
            else
            {
               this._targetClip = this._groupUi.getShipIconWithBarComponent(this._member.targetObject.shipType);
               addChildAt(this._targetClip,1);
               this._targetClip.x = this._nickLabel.x + 72;
               this._targetClip.y = Styles.simpleFontHeight + 8;
            }
            if(!this._targetOverLay.parent)
            {
               this._targetClip.addChild(this._targetOverLay);
            }
            this._targetOverLay.x = (this._targetClip.baseGraphic.width - this._targetOverLay.width) * 0.5;
            this._targetOverLay.y = (this._targetClip.baseGraphic.height - this._targetOverLay.height) * 0.5;
            this._targetOverLay.visible = true;
            this.enableTargetingTarget();
         }
         else
         {
            if(this._targetClip != null && contains(this._targetClip))
            {
               this._targetClip.baseGraphic = this._groupUi.getShipIconBitmap(0);
            }
            else
            {
               this._targetClip = this._groupUi.getShipIconWithBarComponent(0);
               addChildAt(this._targetClip,1);
               this._targetClip.x = this._nickLabel.x + 72;
               this._targetClip.y = Styles.simpleFontHeight + 8;
            }
            this._targetOverLay.visible = false;
            this.disableTargetingTarget();
         }
      }
      
      private function updateMap() : void
      {
         var _loc1_:InGameCatalog = null;
         if(this._mapID != this._member.mapID)
         {
            this._mapID = this._member.mapID;
            _loc1_ = InGameCatalog.instance;
            this._mapLabel.text = _loc1_.getGroupSystemMapName(this._mapID);
            this._mapLabelTooltip.updateText(_loc1_.getGroupSystemMapNameToolTip(this._mapID));
         }
         if(this._groupUi != null && this._mapID == this._groupUi.heroMap && !this._isOffline)
         {
            this.getShipClip().foggy = false;
            this._nickLabel.defaultTextFormat = this._stdFormat;
            this.enableTargetingMember();
         }
         else
         {
            this._mapLabel.visible = true;
            this.getShipClip().foggy = true;
            this._nickLabel.defaultTextFormat = this._foggyFormat;
            this.disableTargetingMember();
         }
         this._nickLabel.setTextFormat(this._nickLabel.defaultTextFormat);
      }
      
      private function updateHitpoints() : void
      {
         if(this._member.memberObject.hitPointsMax > 0 && !this._isOffline)
         {
            this._shipClip.hpBar.update(this._member.memberObject.hitPointsCurrent,this._member.memberObject.hitPointsMax);
         }
         else
         {
            this._shipClip.hpBar.update(0,1);
         }
         this._shipClip.hpTooltip.updateText(this._tooltipHitpointsBaseLabel + "\n" + TextFormatter.roundInteger(this._member.memberObject.hitPointsCurrent) + "|" + TextFormatter.roundInteger(this._member.memberObject.hitPointsMax));
      }
      
      private function updateNanohull() : void
      {
         if(this._member.memberObject.nanohullMax > 0 && !this._isOffline)
         {
            this._shipClip.nanohullBar.update(this._member.memberObject.nanohullCurrent,this._member.memberObject.nanohullMax);
         }
         else
         {
            this._shipClip.nanohullBar.update(0,1);
         }
         this._shipClip.nanohullTooltip.updateText(this._tooltipNanohullBaseLabel + "\n" + TextFormatter.roundInteger(this._member.memberObject.nanohullCurrent) + "|" + TextFormatter.roundInteger(this._member.memberObject.nanohullMax));
      }
      
      private function updateShield() : void
      {
         if(this._member.memberObject.shieldMax > 0 && !this._isOffline)
         {
            this._shipClip.shieldBar.update(this._member.memberObject.shieldCurrent,this._member.memberObject.shieldMax);
         }
         else
         {
            this._shipClip.shieldBar.update(0,1);
         }
         this._shipClip.shieldTooltip.updateText(this._tooltipShieldBaseLabel + "\n" + TextFormatter.roundInteger(this._member.memberObject.shieldCurrent) + "|" + TextFormatter.roundInteger(this._member.memberObject.shieldMax));
      }
      
      private function updateTargetHitpoints() : void
      {
         if(this._member.targetObject.hitPointsMax > 0 && !this._isOffline)
         {
            this._targetClip.hpBar.update(this._member.targetObject.hitPointsCurrent,this._member.targetObject.hitPointsMax);
         }
         else
         {
            this._targetClip.hpBar.update(0,1);
         }
         this._targetClip.hpTooltip.updateText(this._tooltipHitpointsBaseLabel + "\n" + TextFormatter.roundInteger(this._member.targetObject.hitPointsCurrent) + "|" + TextFormatter.roundInteger(this._member.targetObject.hitPointsMax));
      }
      
      private function updateTargetNanohull() : void
      {
         if(this._member.targetObject.nanohullMax > 0 && !this._isOffline)
         {
            this._targetClip.nanohullBar.update(this._member.targetObject.nanohullCurrent,this._member.targetObject.nanohullMax);
         }
         else
         {
            this._targetClip.nanohullBar.update(0,1);
         }
         this._targetClip.nanohullTooltip.updateText(this._tooltipNanohullBaseLabel + "\n" + TextFormatter.roundInteger(this._member.targetObject.nanohullCurrent) + "|" + TextFormatter.roundInteger(this._member.targetObject.nanohullMax));
      }
      
      private function updateTargetShield() : void
      {
         if(this._member.targetObject.shieldMax > 0 && !this._isOffline)
         {
            this._targetClip.shieldBar.update(this._member.targetObject.shieldCurrent,this._member.targetObject.shieldMax);
         }
         else
         {
            this._targetClip.shieldBar.update(0,1);
         }
         this._targetClip.shieldTooltip.updateText(this._tooltipShieldBaseLabel + "\n" + TextFormatter.roundInteger(this._member.targetObject.shieldCurrent) + "|" + TextFormatter.roundInteger(this._member.targetObject.shieldMax));
      }
      
      private function updateNickLabel() : void
      {
         if(this._clanTag != this._member.clanTag || this._nickName != this._member.nickName)
         {
            this._clanTag = this._member.clanTag;
            this._nickName = this._member.nickName;
            this._nickLabel.text = this._nickName;
         }
         if(this._isSelected != this._member.isSelected)
         {
            this._isSelected = this._member.isSelected;
            this._nickLabel.filters = this._isSelected ? this._isSelectedGlowFilter : null;
         }
      }
      
      public function set groupUi(param1:GroupUI) : void
      {
         this._groupUi = param1;
         this.initTargetGraphics();
      }
      
      private function initTargetGraphics() : void
      {
         GameFacade.getInstance().sendNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.setTargetGraphic,"ui",new <String>["group_sys_small_target"],Bitmap,null,false));
      }
      
      public function cleanup() : void
      {
         this.disableTargetingMember();
         this.disableTargetingTarget();
      }
      
      private function enableTargetingMember() : void
      {
         if(this._targetingMemberEnabled)
         {
            return;
         }
         this._targetingMemberEnabled = true;
         this._nickLabel.mouseEnabled = this._targetingMemberEnabled;
         this._nickLabel.addEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
         this.getShipClip().addEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
      }
      
      private function disableTargetingMember() : void
      {
         if(!this._targetingMemberEnabled)
         {
            return;
         }
         this._targetingMemberEnabled = false;
         this._nickLabel.mouseEnabled = this._targetingMemberEnabled;
         this._nickLabel.removeEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
         this.getShipClip().removeEventListener(MouseEvent.CLICK,this.takeOverMemberClickHandler);
      }
      
      public function get reservedHeight() : int
      {
         return this._reservedHeight;
      }
      
      public function get isLead() : Boolean
      {
         return this._member.isLead;
      }
      
      public function updateRaidGateStatus(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(this._raidGateStatus != this._member.raidGateStatus || this._member.isInRaidGate != this._isInRaidGate || param1)
         {
            this._raidGateStatus = this._member.raidGateStatus;
            this._isInRaidGate = this._member.isInRaidGate;
            if(this._raidGateStatus == RaidGateConstants.NO_GATE)
            {
               if(this._raidGateIcon != null && Boolean(this._raidGateIcon.parent))
               {
                  this._raidGateIcon.parent.removeChild(this._raidGateIcon);
               }
            }
            else
            {
               if(this._raidGateIcon == null)
               {
                  this._raidGateIcon = new RaidGateIcon();
                  this._raidGateIcon.maxHeight = this._nickLabel.height - RAID_GATE_ICON_BOTTOM_GAP;
                  this._raidGateIcon.borderSize = RAID_GATE_ICON_BORDERSIZE;
               }
               _loc2_ = this.getRaidGateStateIconBackground(this._raidGateStatus);
               _loc3_ = this.getRaidGateIconColor(_loc2_);
               this._raidGateIcon.toolTip = this.getRaidGateToolTip(_loc2_);
               this._raidGateIcon.color = _loc3_;
               this._raidGateIcon.stageNumber = this._raidGateStatus;
               this._raidGateIcon.x = int(this._targetClip.x + this._targetClip.width - this._raidGateIcon.width);
               this._raidGateIcon.y = int(this._nickLabel.y);
               this._raidGateIcon.inGate = this._isInRaidGate;
               if(!contains(this._raidGateIcon))
               {
                  addChildAt(this._raidGateIcon,1);
               }
            }
            this.updateLead(true);
         }
      }
      
      private function getRaidGateToolTip(param1:int) : String
      {
         var _loc2_:String = InGameCatalog.getInstance().getRaidgateToolTipKey(param1);
         return BPLocale.getItem(_loc2_);
      }
      
      private function getRaidGateIconColor(param1:int) : uint
      {
         return InGameCatalog.getInstance().getRaidgateIconColorByState(param1);
      }
      
      private function getRaidGateStateIconBackground(param1:int) : int
      {
         var _loc2_:int = 0;
         if(param1 == RaidGateConstants.NO_GATE)
         {
            _loc2_ = RaidGateConstants.NO_GATE;
         }
         else if(Hero.raidGateStatus == RaidGateConstants.NO_GATE)
         {
            _loc2_ = RaidGateConstants.HERO_NO_GATE;
         }
         else if(param1 == Hero.raidGateStatus)
         {
            _loc2_ = RaidGateConstants.SAME_STAGE;
         }
         else
         {
            _loc2_ = RaidGateConstants.DIFFERENT_STAGE;
         }
         return _loc2_;
      }
      
      private function updateLead(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         if(this._isLead != this._member.isLead || param1)
         {
            this._isLead = this._member.isLead;
            if(!this._isLead)
            {
               if(this._leadIcon != null && Boolean(this._leadIcon.parent))
               {
                  this._leadIcon.parent.removeChild(this._leadIcon);
               }
            }
            else
            {
               if(this._leadIcon == null)
               {
                  this._leadIcon = this._groupUi.getUiBitmap("boss_icon.png");
               }
               if(!contains(this._leadIcon))
               {
                  addChildAt(this._leadIcon,1);
               }
               _loc2_ = this._raidGateIcon ? int(this._raidGateIcon.x) : int(this._targetClip.width + this._targetClip.x);
               this._leadIcon.x = _loc2_ - this._leadIcon.width;
               this._leadIcon.y = this._nickLabel.y;
            }
         }
      }
      
      public function get member() : GroupMember
      {
         return this._member;
      }
      
      public function set member(param1:GroupMember) : void
      {
         this._member = param1;
      }
      
      private function memberRollOutHandler(param1:MouseEvent = null) : void
      {
         TweenLite.to(this._fullClip,0.2,{"alpha":0});
      }
      
      private function memberRollOverHandler(param1:MouseEvent = null) : void
      {
         TweenLite.to(this._fullClip,0.2,{"alpha":0.1});
      }
      
      private function memberClickHandler(param1:MouseEvent = null) : void
      {
         this._groupUi.editMember(this._member);
      }
      
      private function takeOverMemberClickHandler(param1:MouseEvent = null) : void
      {
         if(this._groupUi != null)
         {
            this._groupUi.takeOverMemberTarget(this._member.id);
         }
      }
   }
}


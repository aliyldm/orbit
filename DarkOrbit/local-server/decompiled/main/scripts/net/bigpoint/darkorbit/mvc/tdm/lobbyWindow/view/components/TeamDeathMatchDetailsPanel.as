package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.view.components
{
   import com.greensock.TweenMax;
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.TeamDeathMatchDetailCommand;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOHtmlTooltip;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   
   use namespace mx_internal;
   
   public class TeamDeathMatchDetailsPanel extends SkinnableContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _929134207eic_group:spark.components.Group;
      
      private var _1470841166labelMatchRunning:Label;
      
      private var _467213939labelMessage:Label;
      
      private var _204183281mmo_group:spark.components.Group;
      
      private var _465444938opponentFactionLogo:SkinnableContainer;
      
      private var _949841922opponentPanelBgnd:SkinnableContainer;
      
      private var _224576080opponentPlayerAmoutLabel:Label;
      
      private var _1645805004opponentPointsLabel:Label;
      
      private var _1279130932ownerFactionLogo:SkinnableContainer;
      
      private var _1033666708ownerPanelBgnd:SkinnableContainer;
      
      private var _854909702ownerPlayerAmoutLabel:Label;
      
      private var _832119010ownerPointsLabel:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _minPlayer:int = 5;
      
      private var _52041050toolTipPoints:String;
      
      private var _459843044toolTipPlayerAmount:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TeamDeathMatchDetailsPanel()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._TeamDeathMatchDetailsPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_tdm_lobbyWindow_view_components_TeamDeathMatchDetailsPanelWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return TeamDeathMatchDetailsPanel[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._TeamDeathMatchDetailsPanel_Array1_c);
         this.addEventListener("creationComplete",this.___TeamDeathMatchDetailsPanel_SkinnableContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TeamDeathMatchDetailsPanel._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      protected function handleCreationComplete() : void
      {
         this.toolTipPoints = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_factionpanel_pointslabel");
         this.toolTipPlayerAmount = BPLocale.getItem("ttip_teamdeathmatch_lobbywindow_factionpanel_playeramountlabel");
         this.alpha = 0.2;
      }
      
      private function handleToolTipCreated(param1:ToolTipEvent) : void
      {
         var _loc2_:DOHtmlTooltip = null;
         if(param1.target is UIComponent)
         {
            _loc2_ = new DOHtmlTooltip();
            _loc2_.htmlText = (param1.target as UIComponent).toolTip;
            param1.toolTip = _loc2_;
         }
      }
      
      public function update(param1:TeamDeathMatchDetailCommand) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.updateOwnFactionLogo(param1);
         this.updateOpponentFactionLogo(param1);
         this.updatePlayerAmounts(param1);
         this.updatePlayersPoints(param1);
         this.updateMessageLable(param1);
      }
      
      private function updatePlayersPoints(param1:TeamDeathMatchDetailCommand) : void
      {
         this.ownerPointsLabel.text = param1.pointsOfOwnTeam.toString();
         this.opponentPointsLabel.text = param1.pointsOfOpponentTeam.toString();
      }
      
      private function updatePlayerAmounts(param1:TeamDeathMatchDetailCommand) : void
      {
         this.ownerPlayerAmoutLabel.text = param1.playersInOwnTeam + "/" + param1.maxPlayersPerTeam;
         this.opponentPlayerAmoutLabel.text = param1.playersInOpponentTeam + "/" + param1.maxPlayersPerTeam;
      }
      
      private function updateOpponentFactionLogo(param1:TeamDeathMatchDetailCommand) : void
      {
         switch(param1.opponentFaction.faction)
         {
            case FactionModule.FACTION_EIC:
               this.opponentFactionLogo.styleName = "teamDeathMatchFactionLogoEIC";
               break;
            case FactionModule.FACTION_MMO:
               this.opponentFactionLogo.styleName = "teamDeathMatchFactionLogoMMO";
               break;
            case FactionModule.FACTION_VRU:
               this.opponentFactionLogo.styleName = "teamDeathMatchFactionLogoVRU";
               break;
            default:
               this.opponentFactionLogo.styleName = "";
         }
      }
      
      private function updateOwnFactionLogo(param1:TeamDeathMatchDetailCommand) : void
      {
         switch(param1.ownFaction.faction)
         {
            case FactionModule.FACTION_EIC:
               this.ownerFactionLogo.styleName = "teamDeathMatchFactionLogoEIC";
               break;
            case FactionModule.FACTION_MMO:
               this.ownerFactionLogo.styleName = "teamDeathMatchFactionLogoMMO";
               break;
            case FactionModule.FACTION_VRU:
               this.ownerFactionLogo.styleName = "teamDeathMatchFactionLogoVRU";
               break;
            default:
               this.ownerFactionLogo.styleName = "";
         }
      }
      
      private function updateMessageLable(param1:TeamDeathMatchDetailCommand) : void
      {
         var _loc4_:String = null;
         var _loc2_:Boolean = param1.playersInOwnTeam >= param1.minPlayersPerTeam;
         var _loc3_:Boolean = param1.playersInOpponentTeam >= param1.minPlayersPerTeam;
         if(_loc2_ && _loc3_)
         {
            _loc4_ = "";
         }
         else
         {
            _loc4_ = BPLocale.getItem("teamdeathmatch_lobbywindow_detailpanel_message_playerrequirement");
         }
         this.labelMessage.text = _loc4_;
      }
      
      public function set message(param1:String) : void
      {
         this.labelMessage.text = "";
      }
      
      public function updateTimerLabel(param1:String) : void
      {
         var _loc2_:String = BPLocale.getItem("sectorcontrol_lobby_window_detailpanel_state_timer_message");
         _loc2_ = _loc2_.replace(SectorControlConstants.LOCALIZATION_PLACEHOLDER__TIME,param1);
         this.labelMatchRunning.text = _loc2_;
      }
      
      public function clearTimerLabel() : void
      {
         this.labelMatchRunning.text = "";
      }
      
      public function fadeIn() : void
      {
         TweenMax.to(this,2.5,{"alpha":1});
      }
      
      public function fadeOut() : void
      {
         TweenMax.to(this,0.5,{"alpha":0});
      }
      
      private function _TeamDeathMatchDetailsPanel_Array1_c() : Array
      {
         return [this._TeamDeathMatchDetailsPanel_VGroup1_c()];
      }
      
      private function _TeamDeathMatchDetailsPanel_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.top = 12;
         _loc1_.mxmlContent = [this._TeamDeathMatchDetailsPanel_HGroup1_c(),this._TeamDeathMatchDetailsPanel_Group3_c(),this._TeamDeathMatchDetailsPanel_Label5_i(),this._TeamDeathMatchDetailsPanel_Group4_c(),this._TeamDeathMatchDetailsPanel_Label6_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 40;
         _loc1_.mxmlContent = [this._TeamDeathMatchDetailsPanel_Group1_i(),this._TeamDeathMatchDetailsPanel_Group2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.width = 132;
         _loc1_.height = 56;
         _loc1_.mxmlContent = [this._TeamDeathMatchDetailsPanel_SkinnableContainer2_i(),this._TeamDeathMatchDetailsPanel_SkinnableContainer3_i(),this._TeamDeathMatchDetailsPanel_Label1_i(),this._TeamDeathMatchDetailsPanel_Label2_i()];
         _loc1_.id = "mmo_group";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.mmo_group = _loc1_;
         BindingManager.executeBindings(this,"mmo_group",this.mmo_group);
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_SkinnableContainer2_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "teamDeathMatchFactionLogoPanel";
         _loc1_.id = "ownerPanelBgnd";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ownerPanelBgnd = _loc1_;
         BindingManager.executeBindings(this,"ownerPanelBgnd",this.ownerPanelBgnd);
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_SkinnableContainer3_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.x = 10;
         _loc1_.id = "ownerFactionLogo";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ownerFactionLogo = _loc1_;
         BindingManager.executeBindings(this,"ownerFactionLogo",this.ownerFactionLogo);
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 64;
         _loc1_.y = 6;
         _loc1_.text = "0";
         _loc1_.width = 66;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.addEventListener("toolTipCreate",this.__ownerPointsLabel_toolTipCreate);
         _loc1_.id = "ownerPointsLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ownerPointsLabel = _loc1_;
         BindingManager.executeBindings(this,"ownerPointsLabel",this.ownerPointsLabel);
         return _loc1_;
      }
      
      public function __ownerPointsLabel_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _TeamDeathMatchDetailsPanel_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 35;
         _loc1_.text = "0/0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.addEventListener("toolTipCreate",this.__ownerPlayerAmoutLabel_toolTipCreate);
         _loc1_.id = "ownerPlayerAmoutLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.ownerPlayerAmoutLabel = _loc1_;
         BindingManager.executeBindings(this,"ownerPlayerAmoutLabel",this.ownerPlayerAmoutLabel);
         return _loc1_;
      }
      
      public function __ownerPlayerAmoutLabel_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _TeamDeathMatchDetailsPanel_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.width = 132;
         _loc1_.height = 56;
         _loc1_.mxmlContent = [this._TeamDeathMatchDetailsPanel_SkinnableContainer4_i(),this._TeamDeathMatchDetailsPanel_SkinnableContainer5_i(),this._TeamDeathMatchDetailsPanel_Label3_i(),this._TeamDeathMatchDetailsPanel_Label4_i()];
         _loc1_.addEventListener("toolTipCreate",this.__eic_group_toolTipCreate);
         _loc1_.id = "eic_group";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.eic_group = _loc1_;
         BindingManager.executeBindings(this,"eic_group",this.eic_group);
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_SkinnableContainer4_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.styleName = "teamDeathMatchFactionLogoPanel";
         _loc1_.id = "opponentPanelBgnd";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.opponentPanelBgnd = _loc1_;
         BindingManager.executeBindings(this,"opponentPanelBgnd",this.opponentPanelBgnd);
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_SkinnableContainer5_i() : SkinnableContainer
      {
         var _loc1_:SkinnableContainer = new SkinnableContainer();
         _loc1_.x = 10;
         _loc1_.id = "opponentFactionLogo";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.opponentFactionLogo = _loc1_;
         BindingManager.executeBindings(this,"opponentFactionLogo",this.opponentFactionLogo);
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 6;
         _loc1_.text = "0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.addEventListener("toolTipCreate",this.__opponentPointsLabel_toolTipCreate);
         _loc1_.id = "opponentPointsLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.opponentPointsLabel = _loc1_;
         BindingManager.executeBindings(this,"opponentPointsLabel",this.opponentPointsLabel);
         return _loc1_;
      }
      
      public function __opponentPointsLabel_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _TeamDeathMatchDetailsPanel_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 35;
         _loc1_.text = "0/0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.addEventListener("toolTipCreate",this.__opponentPlayerAmoutLabel_toolTipCreate);
         _loc1_.id = "opponentPlayerAmoutLabel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.opponentPlayerAmoutLabel = _loc1_;
         BindingManager.executeBindings(this,"opponentPlayerAmoutLabel",this.opponentPlayerAmoutLabel);
         return _loc1_;
      }
      
      public function __opponentPlayerAmoutLabel_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      public function __eic_group_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _TeamDeathMatchDetailsPanel_Group3_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.width = 10;
         _loc1_.height = 10;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.y = 20;
         _loc1_.text = "";
         _loc1_.verticalCenter = 0;
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelMatchRunning";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelMatchRunning = _loc1_;
         BindingManager.executeBindings(this,"labelMatchRunning",this.labelMatchRunning);
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_Group4_c() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.width = 10;
         _loc1_.height = 0;
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _TeamDeathMatchDetailsPanel_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.text = "";
         _loc1_.verticalCenter = 0;
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelMessage";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelMessage = _loc1_;
         BindingManager.executeBindings(this,"labelMessage",this.labelMessage);
         return _loc1_;
      }
      
      public function ___TeamDeathMatchDetailsPanel_SkinnableContainer1_creationComplete(param1:FlexEvent) : void
      {
         this.handleCreationComplete();
      }
      
      private function _TeamDeathMatchDetailsPanel_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = toolTipPoints;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"ownerPointsLabel.toolTip");
         result[1] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_TICKETS_FONT_COLOR;
         },function(param1:uint):void
         {
            ownerPointsLabel.setStyle("color",param1);
         },"ownerPointsLabel.color");
         result[2] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            ownerPointsLabel.setStyle("fontSize",param1);
         },"ownerPointsLabel.fontSize");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = toolTipPlayerAmount;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"ownerPlayerAmoutLabel.toolTip");
         result[4] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_PLAYERS_FONT_COLOR;
         },function(param1:uint):void
         {
            ownerPlayerAmoutLabel.setStyle("color",param1);
         },"ownerPlayerAmoutLabel.color");
         result[5] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            ownerPlayerAmoutLabel.setStyle("fontSize",param1);
         },"ownerPlayerAmoutLabel.fontSize");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = toolTipPoints;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"opponentPointsLabel.toolTip");
         result[7] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_TICKETS_FONT_COLOR;
         },function(param1:uint):void
         {
            opponentPointsLabel.setStyle("color",param1);
         },"opponentPointsLabel.color");
         result[8] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            opponentPointsLabel.setStyle("fontSize",param1);
         },"opponentPointsLabel.fontSize");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = toolTipPlayerAmount;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"opponentPlayerAmoutLabel.toolTip");
         result[10] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_PLAYERS_FONT_COLOR;
         },function(param1:uint):void
         {
            opponentPlayerAmoutLabel.setStyle("color",param1);
         },"opponentPlayerAmoutLabel.color");
         result[11] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            opponentPlayerAmoutLabel.setStyle("fontSize",param1);
         },"opponentPlayerAmoutLabel.fontSize");
         result[12] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_MATCHRUNNING_FONT_COLOR;
         },function(param1:uint):void
         {
            labelMatchRunning.setStyle("color",param1);
         },"labelMatchRunning.color");
         result[13] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_MATCHRUNNING_FONT_SIZE;
         },function(param1:Number):void
         {
            labelMatchRunning.setStyle("fontSize",param1);
         },"labelMatchRunning.fontSize");
         result[14] = new Binding(this,function():uint
         {
            return SectorControlConstants.LOBBY_LABEL_COLOR_CRITICAL;
         },function(param1:uint):void
         {
            labelMessage.setStyle("color",param1);
         },"labelMessage.color");
         result[15] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_MESSAGE_FONT_SIZE;
         },function(param1:Number):void
         {
            labelMessage.setStyle("fontSize",param1);
         },"labelMessage.fontSize");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get eic_group() : spark.components.Group
      {
         return this._929134207eic_group;
      }
      
      public function set eic_group(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._929134207eic_group;
         if(_loc2_ !== param1)
         {
            this._929134207eic_group = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eic_group",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelMatchRunning() : Label
      {
         return this._1470841166labelMatchRunning;
      }
      
      public function set labelMatchRunning(param1:Label) : void
      {
         var _loc2_:Object = this._1470841166labelMatchRunning;
         if(_loc2_ !== param1)
         {
            this._1470841166labelMatchRunning = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelMatchRunning",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelMessage() : Label
      {
         return this._467213939labelMessage;
      }
      
      public function set labelMessage(param1:Label) : void
      {
         var _loc2_:Object = this._467213939labelMessage;
         if(_loc2_ !== param1)
         {
            this._467213939labelMessage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelMessage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mmo_group() : spark.components.Group
      {
         return this._204183281mmo_group;
      }
      
      public function set mmo_group(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._204183281mmo_group;
         if(_loc2_ !== param1)
         {
            this._204183281mmo_group = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mmo_group",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentFactionLogo() : SkinnableContainer
      {
         return this._465444938opponentFactionLogo;
      }
      
      public function set opponentFactionLogo(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._465444938opponentFactionLogo;
         if(_loc2_ !== param1)
         {
            this._465444938opponentFactionLogo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentFactionLogo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentPanelBgnd() : SkinnableContainer
      {
         return this._949841922opponentPanelBgnd;
      }
      
      public function set opponentPanelBgnd(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._949841922opponentPanelBgnd;
         if(_loc2_ !== param1)
         {
            this._949841922opponentPanelBgnd = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentPanelBgnd",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentPlayerAmoutLabel() : Label
      {
         return this._224576080opponentPlayerAmoutLabel;
      }
      
      public function set opponentPlayerAmoutLabel(param1:Label) : void
      {
         var _loc2_:Object = this._224576080opponentPlayerAmoutLabel;
         if(_loc2_ !== param1)
         {
            this._224576080opponentPlayerAmoutLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentPlayerAmoutLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get opponentPointsLabel() : Label
      {
         return this._1645805004opponentPointsLabel;
      }
      
      public function set opponentPointsLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1645805004opponentPointsLabel;
         if(_loc2_ !== param1)
         {
            this._1645805004opponentPointsLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opponentPointsLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ownerFactionLogo() : SkinnableContainer
      {
         return this._1279130932ownerFactionLogo;
      }
      
      public function set ownerFactionLogo(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._1279130932ownerFactionLogo;
         if(_loc2_ !== param1)
         {
            this._1279130932ownerFactionLogo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerFactionLogo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ownerPanelBgnd() : SkinnableContainer
      {
         return this._1033666708ownerPanelBgnd;
      }
      
      public function set ownerPanelBgnd(param1:SkinnableContainer) : void
      {
         var _loc2_:Object = this._1033666708ownerPanelBgnd;
         if(_loc2_ !== param1)
         {
            this._1033666708ownerPanelBgnd = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerPanelBgnd",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ownerPlayerAmoutLabel() : Label
      {
         return this._854909702ownerPlayerAmoutLabel;
      }
      
      public function set ownerPlayerAmoutLabel(param1:Label) : void
      {
         var _loc2_:Object = this._854909702ownerPlayerAmoutLabel;
         if(_loc2_ !== param1)
         {
            this._854909702ownerPlayerAmoutLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerPlayerAmoutLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ownerPointsLabel() : Label
      {
         return this._832119010ownerPointsLabel;
      }
      
      public function set ownerPointsLabel(param1:Label) : void
      {
         var _loc2_:Object = this._832119010ownerPointsLabel;
         if(_loc2_ !== param1)
         {
            this._832119010ownerPointsLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ownerPointsLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get toolTipPoints() : String
      {
         return this._52041050toolTipPoints;
      }
      
      private function set toolTipPoints(param1:String) : void
      {
         var _loc2_:Object = this._52041050toolTipPoints;
         if(_loc2_ !== param1)
         {
            this._52041050toolTipPoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolTipPoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get toolTipPlayerAmount() : String
      {
         return this._459843044toolTipPlayerAmount;
      }
      
      private function set toolTipPlayerAmount(param1:String) : void
      {
         var _loc2_:Object = this._459843044toolTipPlayerAmount;
         if(_loc2_ !== param1)
         {
            this._459843044toolTipPlayerAmount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toolTipPlayerAmount",_loc2_,param1));
            }
         }
      }
   }
}


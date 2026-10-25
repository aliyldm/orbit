package net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components
{
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
   import mx.events.PropertyChangeEvent;
   import mx.events.ToolTipEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.SectorControlMatchDetailCommand;
   import net.bigpoint.darkorbit.com.module.SectorControlPlayerCountModule;
   import net.bigpoint.darkorbit.com.module.SectorControlTicketCountCommand;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOHtmlTooltip;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.SectorControlConstants;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import spark.components.Group;
   import spark.components.HGroup;
   import spark.components.Label;
   import spark.components.SkinnableContainer;
   import spark.components.VGroup;
   import spark.primitives.BitmapImage;
   
   use namespace mx_internal;
   
   public class SectorControlLobbyWindowMatchDetailsPanel extends SkinnableContainer implements IBindingClient, ISectorControlLobbyWindowMatchDetailsPanel
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _929134207eic_group:spark.components.Group;
      
      private var _1267211639labelEICPlayersValues:Label;
      
      private var _185164802labelEICTicketsValues:Label;
      
      private var _1093014023labelMMOPlayersValues:Label;
      
      private var _10967186labelMMOTicketsValues:Label;
      
      private var _1470841166labelMatchRunning:Label;
      
      private var _467213939labelMessage:Label;
      
      private var _1183414321labelVRUPlayersValues:Label;
      
      private var _101367484labelVRUTicketsValues:Label;
      
      private var _342483604logoEIC:BitmapImage;
      
      private var _342491428logoMMO:BitmapImage;
      
      private var _342500238logoVRU:BitmapImage;
      
      private var _204183281mmo_group:spark.components.Group;
      
      private var _732111114panelEICBgnd:BitmapImage;
      
      private var _2096417402panelMMOBgnd:BitmapImage;
      
      private var _1744835312panelVRUBgnd:BitmapImage;
      
      private var _1862767609vru_group:spark.components.Group;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _minPlayer:int = 5;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SectorControlLobbyWindowMatchDetailsPanel()
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
         bindings = this._SectorControlLobbyWindowMatchDetailsPanel_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_net_bigpoint_darkorbit_mvc_sectorControlWindow_view_components_SectorControlLobbyWindowMatchDetailsPanelWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },function(param1:String):*
         {
            return SectorControlLobbyWindowMatchDetailsPanel[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContentFactory = new DeferredInstanceFromFunction(this._SectorControlLobbyWindowMatchDetailsPanel_Array1_c);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SectorControlLobbyWindowMatchDetailsPanel._watcherSetupUtil = param1;
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
      
      public function init() : void
      {
         this.intializeComponents();
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
      
      private function intializeComponents() : void
      {
         var _loc2_:BitmapData = null;
         var _loc1_:BitmapData = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,SectorControlConstants.MATCH_DETAIL_PANEL_BGND);
         this.panelEICBgnd.source = _loc1_;
         this.panelVRUBgnd.source = _loc1_;
         this.panelMMOBgnd.source = _loc1_;
         _loc2_ = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,SectorControlConstants.LOBBY_LOGO_EIC);
         this.logoEIC.source = _loc2_;
         _loc2_ = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,SectorControlConstants.LOBBY_LOGO_VRU);
         this.logoVRU.source = _loc2_;
         _loc2_ = ResourceManager.getBitmapData(SectorControlConstants.LIBRARY_NAME,SectorControlConstants.LOBBY_LOGO_MMO);
         this.logoMMO.source = _loc2_;
      }
      
      public function update(param1:SectorControlMatchDetailCommand) : void
      {
         var _loc9_:SectorControlTicketCountCommand = null;
         var _loc10_:FactionModule = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:SectorControlPlayerCountModule = null;
         var _loc15_:FactionModule = null;
         var _loc16_:String = null;
         var _loc2_:Array = InGameCatalog.instance.factions_names_by_FactionModule;
         var _loc3_:Array = InGameCatalog.instance.factions_colours;
         var _loc4_:Vector.<SectorControlTicketCountCommand> = param1.ticketCounts;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc9_ = _loc4_[_loc5_];
            _loc10_ = _loc9_.faction;
            _loc11_ = String(_loc9_.ticketCount);
            _loc12_ = BPLocale.getItem("count_of_total_separator").replace(/%COUNT%/,_loc9_.ticketCount).replace(/%TOTAL%/,_loc9_.maxTickets);
            _loc13_ = BPLocale.getItem("ttip_sectorcontrol_ingame_status_tickets").replace(/%FACTION%/,_loc2_[_loc10_.faction] + " " + _loc12_);
            _loc13_ = HtmlTextUtils.coloriseText(_loc3_[_loc10_.faction],_loc13_);
            switch(_loc10_.faction)
            {
               case FactionModule.FACTION_EIC:
                  this.labelEICTicketsValues.text = _loc11_;
                  this.eic_group.toolTip = _loc13_;
                  break;
               case FactionModule.FACTION_MMO:
                  this.labelMMOTicketsValues.text = _loc11_;
                  this.mmo_group.toolTip = _loc13_;
                  break;
               case FactionModule.FACTION_VRU:
                  this.labelVRUTicketsValues.text = _loc11_;
                  this.vru_group.toolTip = _loc13_;
            }
            _loc5_++;
         }
         var _loc6_:Vector.<SectorControlPlayerCountModule> = param1.playerCounts;
         var _loc7_:uint = _loc6_.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc14_ = _loc6_[_loc8_];
            _loc15_ = _loc14_.faction;
            _loc16_ = BPLocale.getItem("count_of_total_separator").replace(/%COUNT%/,_loc14_.playerCount).replace(/%TOTAL%/,_loc14_.maxPlayers);
            switch(_loc15_.faction)
            {
               case FactionModule.FACTION_EIC:
                  this.labelEICPlayersValues.text = _loc16_;
                  break;
               case FactionModule.FACTION_MMO:
                  this.labelMMOPlayersValues.text = _loc16_;
                  break;
               case FactionModule.FACTION_VRU:
                  this.labelVRUPlayersValues.text = _loc16_;
            }
            _loc8_++;
         }
      }
      
      public function updateMessageLable(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:String = "";
         if(param1)
         {
            _loc3_ = BPLocale.getItem("sectorcontrol_lobby_window_buttonlabel_state_lessplayer_2") + "\n";
         }
         else if(param2)
         {
            _loc3_ = BPLocale.getItem("sectorcontrol_lobby_window_buttonlabel_state_lessplayer_1").replace(/%COUNT%/,this._minPlayer) + "\n";
         }
         this.labelMessage.text = _loc3_;
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
      
      public function updateMinPlayersPerFaction(param1:int) : void
      {
         this._minPlayer = param1;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Array1_c() : Array
      {
         return [this._SectorControlLobbyWindowMatchDetailsPanel_VGroup1_c()];
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.percentWidth = 100;
         _loc1_.top = 12;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindowMatchDetailsPanel_HGroup1_c(),this._SectorControlLobbyWindowMatchDetailsPanel_Group4_c(),this._SectorControlLobbyWindowMatchDetailsPanel_Label7_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Group5_c(),this._SectorControlLobbyWindowMatchDetailsPanel_Label8_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_HGroup1_c() : HGroup
      {
         var _loc1_:HGroup = new HGroup();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.gap = 10;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindowMatchDetailsPanel_Group1_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Group2_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Group3_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Group1_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.width = 132;
         _loc1_.height = 56;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindowMatchDetailsPanel_BitmapImage1_i(),this._SectorControlLobbyWindowMatchDetailsPanel_BitmapImage2_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Label1_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Label2_i()];
         _loc1_.addEventListener("toolTipCreate",this.__mmo_group_toolTipCreate);
         _loc1_.id = "mmo_group";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.mmo_group = _loc1_;
         BindingManager.executeBindings(this,"mmo_group",this.mmo_group);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.initialized(this,"panelMMOBgnd");
         this.panelMMOBgnd = _loc1_;
         BindingManager.executeBindings(this,"panelMMOBgnd",this.panelMMOBgnd);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_BitmapImage2_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.x = 10;
         _loc1_.initialized(this,"logoMMO");
         this.logoMMO = _loc1_;
         BindingManager.executeBindings(this,"logoMMO",this.logoMMO);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 64;
         _loc1_.y = 6;
         _loc1_.text = "0";
         _loc1_.width = 66;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelMMOTicketsValues";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelMMOTicketsValues = _loc1_;
         BindingManager.executeBindings(this,"labelMMOTicketsValues",this.labelMMOTicketsValues);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 35;
         _loc1_.text = "0/0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelMMOPlayersValues";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelMMOPlayersValues = _loc1_;
         BindingManager.executeBindings(this,"labelMMOPlayersValues",this.labelMMOPlayersValues);
         return _loc1_;
      }
      
      public function __mmo_group_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Group2_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.width = 132;
         _loc1_.height = 56;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindowMatchDetailsPanel_BitmapImage3_i(),this._SectorControlLobbyWindowMatchDetailsPanel_BitmapImage4_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Label3_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Label4_i()];
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
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_BitmapImage3_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.initialized(this,"panelEICBgnd");
         this.panelEICBgnd = _loc1_;
         BindingManager.executeBindings(this,"panelEICBgnd",this.panelEICBgnd);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_BitmapImage4_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.x = 9;
         _loc1_.y = 0;
         _loc1_.initialized(this,"logoEIC");
         this.logoEIC = _loc1_;
         BindingManager.executeBindings(this,"logoEIC",this.logoEIC);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 6;
         _loc1_.text = "0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelEICTicketsValues";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelEICTicketsValues = _loc1_;
         BindingManager.executeBindings(this,"labelEICTicketsValues",this.labelEICTicketsValues);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 35;
         _loc1_.text = "0/0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelEICPlayersValues";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelEICPlayersValues = _loc1_;
         BindingManager.executeBindings(this,"labelEICPlayersValues",this.labelEICPlayersValues);
         return _loc1_;
      }
      
      public function __eic_group_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Group3_i() : spark.components.Group
      {
         var _loc1_:spark.components.Group = new spark.components.Group();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.width = 132;
         _loc1_.height = 56;
         _loc1_.mxmlContent = [this._SectorControlLobbyWindowMatchDetailsPanel_BitmapImage5_i(),this._SectorControlLobbyWindowMatchDetailsPanel_BitmapImage6_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Label5_i(),this._SectorControlLobbyWindowMatchDetailsPanel_Label6_i()];
         _loc1_.addEventListener("toolTipCreate",this.__vru_group_toolTipCreate);
         _loc1_.id = "vru_group";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.vru_group = _loc1_;
         BindingManager.executeBindings(this,"vru_group",this.vru_group);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_BitmapImage5_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.initialized(this,"panelVRUBgnd");
         this.panelVRUBgnd = _loc1_;
         BindingManager.executeBindings(this,"panelVRUBgnd",this.panelVRUBgnd);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_BitmapImage6_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.x = 8;
         _loc1_.y = 0;
         _loc1_.initialized(this,"logoVRU");
         this.logoVRU = _loc1_;
         BindingManager.executeBindings(this,"logoVRU",this.logoVRU);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 6;
         _loc1_.text = "0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelVRUTicketsValues";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelVRUTicketsValues = _loc1_;
         BindingManager.executeBindings(this,"labelVRUTicketsValues",this.labelVRUTicketsValues);
         return _loc1_;
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 66;
         _loc1_.y = 35;
         _loc1_.text = "0/0";
         _loc1_.width = 64;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("fontFamily","EurostileT");
         _loc1_.id = "labelVRUPlayersValues";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelVRUPlayersValues = _loc1_;
         BindingManager.executeBindings(this,"labelVRUPlayersValues",this.labelVRUPlayersValues);
         return _loc1_;
      }
      
      public function __vru_group_toolTipCreate(param1:ToolTipEvent) : void
      {
         this.handleToolTipCreated(param1);
      }
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Group4_c() : spark.components.Group
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
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label7_i() : Label
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
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Group5_c() : spark.components.Group
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
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_Label8_i() : Label
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
      
      private function _SectorControlLobbyWindowMatchDetailsPanel_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_TICKETS_FONT_COLOR;
         },function(param1:uint):void
         {
            labelMMOTicketsValues.setStyle("color",param1);
         },"labelMMOTicketsValues.color");
         result[1] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            labelMMOTicketsValues.setStyle("fontSize",param1);
         },"labelMMOTicketsValues.fontSize");
         result[2] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_PLAYERS_FONT_COLOR;
         },function(param1:uint):void
         {
            labelMMOPlayersValues.setStyle("color",param1);
         },"labelMMOPlayersValues.color");
         result[3] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            labelMMOPlayersValues.setStyle("fontSize",param1);
         },"labelMMOPlayersValues.fontSize");
         result[4] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_TICKETS_FONT_COLOR;
         },function(param1:uint):void
         {
            labelEICTicketsValues.setStyle("color",param1);
         },"labelEICTicketsValues.color");
         result[5] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            labelEICTicketsValues.setStyle("fontSize",param1);
         },"labelEICTicketsValues.fontSize");
         result[6] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_PLAYERS_FONT_COLOR;
         },function(param1:uint):void
         {
            labelEICPlayersValues.setStyle("color",param1);
         },"labelEICPlayersValues.color");
         result[7] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            labelEICPlayersValues.setStyle("fontSize",param1);
         },"labelEICPlayersValues.fontSize");
         result[8] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_TICKETS_FONT_COLOR;
         },function(param1:uint):void
         {
            labelVRUTicketsValues.setStyle("color",param1);
         },"labelVRUTicketsValues.color");
         result[9] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            labelVRUTicketsValues.setStyle("fontSize",param1);
         },"labelVRUTicketsValues.fontSize");
         result[10] = new Binding(this,function():uint
         {
            return SectorControlConstants.GAME_DETAILS_PLAYERS_FONT_COLOR;
         },function(param1:uint):void
         {
            labelVRUPlayersValues.setStyle("color",param1);
         },"labelVRUPlayersValues.color");
         result[11] = new Binding(this,function():Number
         {
            return SectorControlConstants.GAME_DETAILS_FONT_SIZE;
         },function(param1:Number):void
         {
            labelVRUPlayersValues.setStyle("fontSize",param1);
         },"labelVRUPlayersValues.fontSize");
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
      public function get labelEICPlayersValues() : Label
      {
         return this._1267211639labelEICPlayersValues;
      }
      
      public function set labelEICPlayersValues(param1:Label) : void
      {
         var _loc2_:Object = this._1267211639labelEICPlayersValues;
         if(_loc2_ !== param1)
         {
            this._1267211639labelEICPlayersValues = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelEICPlayersValues",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelEICTicketsValues() : Label
      {
         return this._185164802labelEICTicketsValues;
      }
      
      public function set labelEICTicketsValues(param1:Label) : void
      {
         var _loc2_:Object = this._185164802labelEICTicketsValues;
         if(_loc2_ !== param1)
         {
            this._185164802labelEICTicketsValues = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelEICTicketsValues",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelMMOPlayersValues() : Label
      {
         return this._1093014023labelMMOPlayersValues;
      }
      
      public function set labelMMOPlayersValues(param1:Label) : void
      {
         var _loc2_:Object = this._1093014023labelMMOPlayersValues;
         if(_loc2_ !== param1)
         {
            this._1093014023labelMMOPlayersValues = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelMMOPlayersValues",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelMMOTicketsValues() : Label
      {
         return this._10967186labelMMOTicketsValues;
      }
      
      public function set labelMMOTicketsValues(param1:Label) : void
      {
         var _loc2_:Object = this._10967186labelMMOTicketsValues;
         if(_loc2_ !== param1)
         {
            this._10967186labelMMOTicketsValues = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelMMOTicketsValues",_loc2_,param1));
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
      public function get labelVRUPlayersValues() : Label
      {
         return this._1183414321labelVRUPlayersValues;
      }
      
      public function set labelVRUPlayersValues(param1:Label) : void
      {
         var _loc2_:Object = this._1183414321labelVRUPlayersValues;
         if(_loc2_ !== param1)
         {
            this._1183414321labelVRUPlayersValues = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelVRUPlayersValues",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get labelVRUTicketsValues() : Label
      {
         return this._101367484labelVRUTicketsValues;
      }
      
      public function set labelVRUTicketsValues(param1:Label) : void
      {
         var _loc2_:Object = this._101367484labelVRUTicketsValues;
         if(_loc2_ !== param1)
         {
            this._101367484labelVRUTicketsValues = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelVRUTicketsValues",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get logoEIC() : BitmapImage
      {
         return this._342483604logoEIC;
      }
      
      public function set logoEIC(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._342483604logoEIC;
         if(_loc2_ !== param1)
         {
            this._342483604logoEIC = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logoEIC",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get logoMMO() : BitmapImage
      {
         return this._342491428logoMMO;
      }
      
      public function set logoMMO(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._342491428logoMMO;
         if(_loc2_ !== param1)
         {
            this._342491428logoMMO = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logoMMO",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get logoVRU() : BitmapImage
      {
         return this._342500238logoVRU;
      }
      
      public function set logoVRU(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._342500238logoVRU;
         if(_loc2_ !== param1)
         {
            this._342500238logoVRU = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logoVRU",_loc2_,param1));
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
      public function get panelEICBgnd() : BitmapImage
      {
         return this._732111114panelEICBgnd;
      }
      
      public function set panelEICBgnd(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._732111114panelEICBgnd;
         if(_loc2_ !== param1)
         {
            this._732111114panelEICBgnd = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"panelEICBgnd",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get panelMMOBgnd() : BitmapImage
      {
         return this._2096417402panelMMOBgnd;
      }
      
      public function set panelMMOBgnd(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._2096417402panelMMOBgnd;
         if(_loc2_ !== param1)
         {
            this._2096417402panelMMOBgnd = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"panelMMOBgnd",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get panelVRUBgnd() : BitmapImage
      {
         return this._1744835312panelVRUBgnd;
      }
      
      public function set panelVRUBgnd(param1:BitmapImage) : void
      {
         var _loc2_:Object = this._1744835312panelVRUBgnd;
         if(_loc2_ !== param1)
         {
            this._1744835312panelVRUBgnd = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"panelVRUBgnd",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get vru_group() : spark.components.Group
      {
         return this._1862767609vru_group;
      }
      
      public function set vru_group(param1:spark.components.Group) : void
      {
         var _loc2_:Object = this._1862767609vru_group;
         if(_loc2_ !== param1)
         {
            this._1862767609vru_group = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"vru_group",_loc2_,param1));
            }
         }
      }
   }
}


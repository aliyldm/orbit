package net.bigpoint.darkorbit.equipment.view.components.shipSelector
{
   import com.greensock.TweenLite;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import mx.core.SpriteAsset;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.model.ShipDetailsViewDataProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import net.bigpoint.darkorbit.equipment.view.Styles;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.AbstractShipSelectorButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorCloseButton;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.buttons.ShipSelectorTabbarButton;
   import net.bigpoint.utils.DisplayObjectHelper;
   
   public class ShipInfoDetailPanel extends Sprite
   {
      
      private static var CONTENT_FILL_HEIGHT:uint;
      
      public static const EVENT_HIDE_SHIP_DETAILS_BUTTON_CLICKED:String = "EVENT_HIDE_SHIP_DETAILS_BUTTON_CLICKED";
      
      public static const ID_SHIP:String = ShipDetailsViewDataProxy.ID_SHIP;
      
      public static const ID_DRONES:String = ShipDetailsViewDataProxy.ID_DRONES;
      
      public static const ID_PET:String = ShipDetailsViewDataProxy.ID_PET;
      
      private static const TEXT_CONTAINER_ID:String = "textContainer";
      
      private const _viewData:Array = [];
      
      private var _viewSizeWidth:uint;
      
      private var _viewSizeHeight:uint;
      
      private var _yPosLine:Number;
      
      private var _tabbarViewContainer:Sprite;
      
      private var _fadeoutOverlayOnBottom:SpriteAsset;
      
      private var fadeoutBottom:Class = ShipInfoDetailPanel_fadeoutBottom;
      
      private var _pageLeftButton:AbstractShipSelectorButton;
      
      private var _pageRightButton:AbstractShipSelectorButton;
      
      private var _currentSelectedTabID:String;
      
      private var _contentCreator:ShipInfoContentCreator;
      
      public function ShipInfoDetailPanel(param1:uint, param2:uint)
      {
         super();
         this._viewSizeWidth = param1;
         this._viewSizeHeight = param2;
         this._contentCreator = new ShipInfoContentCreator();
         this.initViewModel();
         this.createViews();
         this.selectTabbarButton(ID_SHIP);
      }
      
      private function initViewModel() : void
      {
         this._viewData.push({
            "id":ID_SHIP,
            "title":BPLocale.getItem("label_tab_ship"),
            "tooltip":BPLocale.getItem("tooltip_tab_ship"),
            "text":null,
            "view":null,
            "useScrollbar":true,
            "scrollbar":null
         });
         this._viewData.push({
            "id":ID_DRONES,
            "title":BPLocale.getItem("label_tab_drones"),
            "tooltip":BPLocale.getItem("tooltip_tab_drones"),
            "text":null,
            "view":null,
            "useScrollbar":true,
            "scrollbar":null
         });
         this._viewData.push({
            "id":ID_PET,
            "title":BPLocale.getItem("label_tab_pet"),
            "tooltip":BPLocale.getItem("tooltip_tab_pet"),
            "text":null,
            "view":null,
            "useScrollbar":true,
            "scrollbar":null
         });
      }
      
      private function createViews() : void
      {
         this.createTabbar();
         this._fadeoutOverlayOnBottom = new SpriteAsset();
         this._fadeoutOverlayOnBottom.addChild(new this.fadeoutBottom());
         this._fadeoutOverlayOnBottom.width = this._viewSizeWidth - 18;
         this._fadeoutOverlayOnBottom.mouseEnabled = this._fadeoutOverlayOnBottom.mouseChildren = false;
         this._fadeoutOverlayOnBottom.y = this._tabbarViewContainer.height + this._tabbarViewContainer.y - (this._fadeoutOverlayOnBottom.height + 2);
         this.addChild(this._fadeoutOverlayOnBottom);
      }
      
      private function createTabbar() : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:ShipSelectorTabbarButton = null;
         var _loc4_:String = null;
         var _loc5_:ShipSelectorCloseButton = null;
         var _loc6_:Object = null;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:ScrollBar = null;
         var _loc12_:Boolean = false;
         var _loc13_:Sprite = null;
         CONTENT_FILL_HEIGHT = 260;
         this._tabbarViewContainer = new Sprite();
         this.addChild(this._tabbarViewContainer);
         _loc1_ = new TextFormat(Styles.defaultFont);
         _loc1_.align = "center";
         _loc1_.size = 12;
         _loc1_.color = 16711678;
         var _loc3_:uint = 0;
         for(_loc4_ in this._viewData)
         {
            _loc6_ = this._viewData[_loc4_];
            _loc2_ = new ShipSelectorTabbarButton();
            _loc2_.name = _loc6_.id;
            _loc2_.x = _loc3_;
            _loc2_.setWidth(103);
            _loc2_.setHeight(24);
            _loc2_.setText(_loc6_.title,_loc1_);
            _loc2_.setActivation(false);
            _loc2_.addEventListener(MouseEvent.CLICK,this.handleTabbarButtonClicked);
            this.addChild(_loc2_);
            _loc3_ += _loc2_.width;
            _loc7_ = new ContentContainer();
            _loc7_.visible = false;
            _loc7_.name = _loc6_.id;
            _loc8_ = new Sprite();
            _loc8_.name = TEXT_CONTAINER_ID;
            _loc7_.addChild(_loc8_);
            if(_loc6_.useScrollbar)
            {
               _loc9_ = 308;
               _loc10_ = CONTENT_FILL_HEIGHT;
               _loc11_ = new ScrollBar(0,0,_loc9_,_loc10_ - 2,_loc8_);
               _loc11_.name = "scrollbar";
               _loc12_ = _loc11_.setScrollBarConditions();
               if(_loc12_)
               {
                  TweenLite.to(_loc11_,0.3,{"autoAlpha":0});
               }
               else
               {
                  TweenLite.to(_loc11_,0.3,{"autoAlpha":1});
               }
               _loc7_.addChild(_loc11_);
               _loc6_.scrollbar = _loc11_;
               _loc13_ = DisplayObjectHelper.createAndAssignMask(324,CONTENT_FILL_HEIGHT - 2,_loc7_);
               _loc13_.y = _loc2_.height + _loc2_.y;
               addChild(_loc13_);
            }
            this.fillContent(_loc7_.graphics,CONTENT_FILL_HEIGHT);
            _loc6_.view = _loc7_;
            this._tabbarViewContainer.addChild(_loc7_);
         }
         _loc5_ = new ShipSelectorCloseButton();
         _loc5_.x = _loc3_ - 2;
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleCloseDetailsViewClicked);
         this.addChild(_loc5_);
         this._tabbarViewContainer.y = _loc2_.height + _loc2_.y;
      }
      
      private function handleCloseDetailsViewClicked(param1:MouseEvent) : void
      {
         dispatchEvent(new GenericDataEvent(ShipInfoPanelHeaderUIControls.EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED,false));
      }
      
      private function fillContent(param1:Graphics, param2:Number) : void
      {
         if(param2 < CONTENT_FILL_HEIGHT)
         {
            param2 = CONTENT_FILL_HEIGHT;
         }
         param1.clear();
         param1.lineStyle(0,0,0);
         param1.beginFill(0,0.6);
         param1.drawRect(0,0,this._viewSizeWidth + 10,param2);
         param1.endFill();
      }
      
      public function show() : void
      {
         TweenLite.to(this,0.3,{"autoAlpha":1});
      }
      
      public function hide() : void
      {
         TweenLite.to(this,0.3,{"autoAlpha":0});
      }
      
      public function isVisible() : Boolean
      {
         return this.visible;
      }
      
      public function handleTabbarButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         this.selectTabbarButton(_loc2_);
      }
      
      private function selectTabbarButton(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Sprite = null;
         var _loc4_:ShipSelectorTabbarButton = null;
         var _loc5_:ScrollBar = null;
         var _loc6_:Boolean = false;
         for each(_loc2_ in this._viewData)
         {
            _loc3_ = _loc2_.view;
            _loc4_ = this.getChildByName(_loc2_.id) as ShipSelectorTabbarButton;
            if(_loc2_.id == param1)
            {
               this._currentSelectedTabID = param1;
               _loc3_.visible = true;
               _loc4_.setActivation(true);
               _loc5_ = _loc2_.scrollbar as ScrollBar;
               if(_loc5_ != null)
               {
                  _loc6_ = _loc5_.setScrollBarConditions();
                  if(_loc6_)
                  {
                     TweenLite.to(_loc5_,0.3,{"autoAlpha":0});
                  }
                  else
                  {
                     TweenLite.to(_loc5_,0.3,{"autoAlpha":1});
                  }
               }
            }
            else
            {
               _loc3_.visible = false;
               _loc4_.setActivation(false);
            }
         }
      }
      
      public function floodWithData(param1:ShipDetailsViewData) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         _loc2_ = this._tabbarViewContainer.getChildByName(ID_SHIP) as Sprite;
         _loc3_ = _loc2_.getChildByName(TEXT_CONTAINER_ID) as Sprite;
         _loc3_.removeChildren();
         _loc4_ = param1.getShipViewData();
         this._contentCreator.createTextContent(_loc4_,_loc3_);
         _loc2_ = this._tabbarViewContainer.getChildByName(ID_PET) as Sprite;
         _loc3_ = _loc2_.getChildByName(TEXT_CONTAINER_ID) as Sprite;
         _loc3_.removeChildren();
         _loc4_ = param1.getPetViewData();
         this._contentCreator.createTextContent(_loc4_,_loc3_);
         _loc2_ = this._tabbarViewContainer.getChildByName(ID_DRONES) as Sprite;
         _loc3_ = _loc2_.getChildByName(TEXT_CONTAINER_ID) as Sprite;
         _loc3_.removeChildren();
         _loc4_ = param1.getDronesViewData();
         this._contentCreator.createTextContent(_loc4_,_loc3_);
         for(_loc5_ in this._viewData)
         {
            this.getChildByName(this._viewData[_loc5_].id).visible = true;
         }
         this.selectTabbarButton(this._currentSelectedTabID);
      }
   }
}

import flash.display.Sprite;
import flash.events.MouseEvent;
import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
import net.bigpoint.darkorbit.equipment.view.managers.IFocusable;

class ContentContainer extends Sprite implements IFocusable
{
   
   public function ContentContainer()
   {
      super();
      FocusManager.getInstance().add(this);
      this.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
   }
   
   private function handleMouseMoveEvent(param1:MouseEvent) : void
   {
      this.focusing();
   }
   
   public function focusing() : void
   {
      var _loc1_:ScrollBar = this.getChildByName("scrollbar") as ScrollBar;
      if(_loc1_)
      {
         _loc1_.isMouseWheelActivcated = true;
      }
   }
   
   public function unfocusing() : void
   {
      var _loc1_:ScrollBar = this.getChildByName("scrollbar") as ScrollBar;
      if(_loc1_)
      {
         _loc1_.isMouseWheelActivcated = false;
      }
   }
}

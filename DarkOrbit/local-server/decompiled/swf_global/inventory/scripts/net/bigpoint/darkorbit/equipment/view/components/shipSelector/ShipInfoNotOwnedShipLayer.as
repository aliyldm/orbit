package net.bigpoint.darkorbit.equipment.view.components.shipSelector
{
   import com.greensock.TweenMax;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import mx.core.SpriteAsset;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipSkillVO;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.scroller.ScrollBar;
   import net.bigpoint.utils.DisplayObjectHelper;
   
   public class ShipInfoNotOwnedShipLayer extends Sprite
   {
      
      public static const SCROLLBAR_POSITION_CHANGED:String = "ShipInfoNotOwnedShipLayer.SCROLLBAR_POSITION_CHANGED";
      
      private static const CONTENT_YS:uint = 208;
      
      private static const MASK_Y:uint = 30;
      
      private var _scrollbar:ScrollBar;
      
      private var _contentContainer:Sprite;
      
      private var _content:Sprite;
      
      private var fadeoutBottom:Class = ShipInfoNotOwnedShipLayer_fadeoutBottom;
      
      private var _contentBackground:Sprite;
      
      private var _viewSizeWidth:uint;
      
      private var _viewSizeHeigth:uint;
      
      private var _contentCreator:ShipInfoContentCreator;
      
      public function ShipInfoNotOwnedShipLayer()
      {
         super();
         this.initialize();
      }
      
      private function initialize() : void
      {
         this._viewSizeWidth = 310;
         this._viewSizeHeigth = 282;
         this._contentCreator = new ShipInfoContentCreator();
         this.createContentLayers();
         this.createScrollbar();
      }
      
      private function createContentLayers() : void
      {
         this._contentContainer = new Sprite();
         var _loc1_:SpriteAsset = new SpriteAsset();
         _loc1_.addChild(new this.fadeoutBottom());
         _loc1_.width = this._viewSizeWidth;
         _loc1_.height <<= 2;
         _loc1_.y = CONTENT_YS - _loc1_.height;
         _loc1_.mouseEnabled = _loc1_.mouseChildren = false;
         this._contentContainer.addChild(_loc1_);
         this._contentBackground = new Sprite();
         this._contentBackground.y = CONTENT_YS;
         var _loc2_:Graphics = this._contentBackground.graphics;
         _loc2_.beginFill(0);
         _loc2_.drawRect(0,0,this._viewSizeWidth,100);
         _loc2_.endFill();
         this._contentContainer.addChild(this._contentBackground);
         this._content = new Sprite();
         this._content.y = CONTENT_YS;
         this._contentContainer.addChild(this._content);
         addChild(this._contentContainer);
         var _loc3_:Sprite = DisplayObjectHelper.createAndAssignMask(this._viewSizeWidth,this._viewSizeHeigth - MASK_Y,this._contentContainer);
         _loc3_.y = MASK_Y;
         addChild(_loc3_);
      }
      
      private function scrollValueTransformF(param1:Number) : Number
      {
         return 1 - Math.cos(param1 * (Math.PI / 2));
      }
      
      private function createScrollbar() : void
      {
         this._scrollbar = new ScrollBar(0,0,0,this._viewSizeHeigth,this._contentContainer,false);
         this._scrollbar.addEventListener(ScrollBar.EVENT_SCROLL_POSITION_CHANGED,this.handleScrollbarPositionChanged);
         addChild(this._scrollbar);
      }
      
      private function fillBackground() : void
      {
         var _loc1_:Graphics = this.graphics;
         _loc1_.beginFill(0,0.5);
         _loc1_.drawRect(0,0,this._viewSizeWidth,this._viewSizeHeigth);
         _loc1_.endFill();
      }
      
      protected function handleScrollbarPositionChanged(param1:Event) : void
      {
         dispatchEvent(new GenericDataEvent(SCROLLBAR_POSITION_CHANGED,this._scrollbar));
      }
      
      public function show() : void
      {
         TweenMax.to(this,0.3,{"autoAlpha":1});
      }
      
      public function hide() : void
      {
         TweenMax.to(this,0.3,{"autoAlpha":0});
      }
      
      public function setData(param1:ShipDetailsViewData) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:ShipSkillVO = null;
         var _loc5_:Number = NaN;
         var _loc6_:Sprite = null;
         if(param1 != null)
         {
            _loc2_ = param1.getNotOwnedShipViewData();
            _loc3_ = param1.getNotOwnedShipSkills();
            this._content.removeChildren();
            this._contentCreator.createTextContent(_loc2_,this._content);
            if(_loc3_.length > 0)
            {
               _loc6_ = new Sprite();
               _loc6_.graphics.beginFill(0);
               _loc6_.graphics.drawRect(0,0,1,10);
               _loc6_.graphics.endFill();
               _loc6_.y = this._content.height;
               this._content.addChild(_loc6_);
            }
            this._contentBackground.height = this._content.height;
            for each(_loc4_ in _loc3_)
            {
               this._contentCreator.createIconAndTextContent(_loc4_,this._content,this._content.height);
            }
            _loc5_ = this._content.height + CONTENT_YS;
            this._scrollbar.setPercentage(0);
            this._scrollbar.setScrollBarConditions(_loc5_);
            this._scrollbar.checkScrollBarWithinBounds();
         }
      }
      
      private function getTestLineData() : Array
      {
         var _loc3_:Graphics = null;
         var _loc1_:Array = [];
         var _loc2_:uint = 20 + (Math.random() * 4 >> 1);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc1_.push({
               "t":"Attribute ",
               "v":String(Math.random())
            });
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function createTestContent() : void
      {
         var _loc2_:Graphics = null;
         var _loc5_:Sprite = null;
         var _loc6_:TextField = null;
         var _loc1_:uint = 20 + (Math.random() * 4 >> 1);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_)
         {
            _loc5_ = new Sprite();
            _loc2_ = _loc5_.graphics;
            _loc2_.beginFill(16750899,0.5);
            _loc2_.drawRect(0,0,260,20);
            _loc2_.endFill();
            _loc5_.y = _loc3_ * 25;
            _loc6_ = new TextField();
            _loc6_.width = 100;
            _loc6_.height = 18;
            _loc6_.border = true;
            _loc6_.borderColor = 10066329;
            _loc6_.text = (1 + _loc3_).toString() + " - " + _loc1_.toString();
            _loc5_.addChild(_loc6_);
            this._content.addChild(_loc5_);
            _loc3_++;
         }
         this._contentBackground.height = this._content.height;
         var _loc4_:Number = this._content.height + CONTENT_YS;
         this._scrollbar.setScrollBarConditions(_loc4_);
         this._scrollbar.checkScrollBarWithinBounds();
      }
   }
}


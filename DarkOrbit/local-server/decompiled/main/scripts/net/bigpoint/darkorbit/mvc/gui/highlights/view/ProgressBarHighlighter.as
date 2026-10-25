package net.bigpoint.darkorbit.mvc.gui.highlights.view
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.ISkinLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale9BitmapLayer;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   
   public class ProgressBarHighlighter implements IHighLighter
   {
      
      protected static const LIB_ID:String = "uridiumBank";
      
      protected static const LIB_BAR_FILLER_ID:String = "barFrameScale9_blue_inner_small";
      
      protected static const LIB_BAR_BACKGROUND_ID:String = "barFrameScale9_blue_small";
      
      protected static const BAR_FILLER_LAYER_NAME:String = "highlight_border";
      
      protected static const BAR_FILLER_BACKGROUND_NAME:String = "highlight_flash_activation";
      
      protected var _bmpBarFillDisplay:Scale9BitmapLayer;
      
      protected var _bmpBarBackgroundDisplay:Scale9BitmapLayer;
      
      protected var _highlightVO:HighlightItemVO;
      
      protected var _target:DisplayObjectContainer;
      
      internal var _width:Number;
      
      internal var _height:Number;
      
      public function ProgressBarHighlighter()
      {
         super();
      }
      
      public function decorateUiElement(param1:Object, param2:HighlightItemVO) : void
      {
         this._highlightVO = param2;
         var _loc3_:DOAbstractComponentDecorator = param1 as DOAbstractComponentDecorator;
         this._target = _loc3_.view;
         this._width = _loc3_.width;
         this._height = _loc3_.height;
         var _loc4_:BitmapData = ResourceManager.getBitmapData(LIB_ID,LIB_BAR_FILLER_ID);
         var _loc5_:BitmapData = ResourceManager.getBitmapData(LIB_ID,LIB_BAR_BACKGROUND_ID);
         var _loc6_:ISkinLayer = new Scale9BitmapLayer(_loc4_,2,2,5,5);
         var _loc7_:ISkinLayer = new Scale9BitmapLayer(_loc5_,2,2,5,5);
         this._bmpBarFillDisplay = _loc6_ as Scale9BitmapLayer;
         this._bmpBarBackgroundDisplay = _loc7_ as Scale9BitmapLayer;
         if(this._bmpBarBackgroundDisplay)
         {
            if(this._target.getChildByName(BAR_FILLER_BACKGROUND_NAME) == null)
            {
               this._bmpBarBackgroundDisplay.name = BAR_FILLER_BACKGROUND_NAME;
               this._bmpBarBackgroundDisplay.width = this._width;
               this._bmpBarBackgroundDisplay.height = 7;
               this._bmpBarBackgroundDisplay.y += this._height + 1;
               this._target.addChild(this._bmpBarBackgroundDisplay);
            }
         }
         if(this._bmpBarFillDisplay)
         {
            if(this._target.getChildByName(BAR_FILLER_LAYER_NAME) == null)
            {
               this._bmpBarFillDisplay.name = BAR_FILLER_LAYER_NAME;
               this._bmpBarFillDisplay.width = 0;
               this._bmpBarFillDisplay.height = 7;
               this._bmpBarFillDisplay.y += this._height + 1;
               this._target.addChild(this._bmpBarFillDisplay);
            }
         }
      }
      
      public function remove() : void
      {
         if(this._target)
         {
            this.removeBarFillLayer();
            this.removeBarBackgroundLayer();
         }
      }
      
      private function removeBarFillLayer() : void
      {
         var _loc1_:DisplayObject = this._target.getChildByName(BAR_FILLER_LAYER_NAME) as DisplayObject;
         this._target.removeChild(_loc1_);
         this._bmpBarFillDisplay = null;
      }
      
      private function removeBarBackgroundLayer() : void
      {
         var _loc1_:DisplayObject = this._target.getChildByName(BAR_FILLER_BACKGROUND_NAME) as DisplayObject;
         this._target.removeChild(_loc1_);
         this._bmpBarBackgroundDisplay = null;
      }
      
      public function get vo() : HighlightItemVO
      {
         return this._highlightVO;
      }
      
      public function get expectedClass() : Class
      {
         return DOAbstractComponentDecorator;
      }
      
      public function updateValue(param1:Number) : void
      {
         this._bmpBarFillDisplay.width = param1 * (this._width - this._bmpBarFillDisplay.getMinWidth()) + this._bmpBarFillDisplay.getMinWidth();
      }
   }
}


package net.bigpoint.darkorbit.mvc.common.view.components
{
   import com.bigpoint.utils.BitmapAtlas;
   import com.bigpoint.utils.ui.panels.HPanel;
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.ItemsControlMenuConstants;
   
   public class TextureAtlasBitmapFont extends Sprite
   {
      
      private static const COLORIZE_REPEAT_COUNT:int = 3;
      
      private var _bitmapAtlas:BitmapAtlas;
      
      private var _hPanel:HPanel;
      
      private var _fontColor:Number;
      
      private var _lasthighLightColor:Number;
      
      public function TextureAtlasBitmapFont(param1:String = null, param2:String = null, param3:Number = 0)
      {
         super();
         param1 ||= ItemsControlMenuConstants.BITMAP_FONT_TEXTURE;
         param2 ||= ItemsControlMenuConstants.BITMAP_FONT_ATLAS_XML;
         this._fontColor = param3 || ItemsControlMenuConstants.STYLE_BLUE;
         var _loc4_:ImageFinisher = this.getFinisher(param1) as ImageFinisher;
         var _loc5_:XMLFinisher = this.getFinisher(param2) as XMLFinisher;
         this._bitmapAtlas = new BitmapAtlas(_loc4_.getBitmap(),_loc5_.getXML());
         addChild(this._hPanel = new HPanel());
         this.setColor(this._fontColor);
      }
      
      public function setColor(param1:Number) : void
      {
         TweenMax.to(this._hPanel,0,{"colorMatrixFilter":{"colorize":param1}});
      }
      
      public function setValue(param1:String, param2:Number) : void
      {
         var _loc6_:String = null;
         var _loc7_:BitmapData = null;
         var _loc8_:Bitmap = null;
         var _loc9_:int = 0;
         this._hPanel.removeItems();
         var _loc3_:Array = param1.split("");
         if(_loc3_.length >= 7)
         {
            _loc3_ = [">","9","9","9","9","9","9"];
         }
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:int = 0;
         while(_loc5_ != _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc7_ = this._bitmapAtlas.getBitmapDataByName(_loc6_);
            if(_loc7_)
            {
               _loc8_ = new Bitmap(_loc7_);
               if(_loc5_)
               {
                  this._hPanel.addItem(_loc8_,-1,0);
               }
               else
               {
                  this._hPanel.addItem(_loc8_,0,0);
               }
            }
            _loc5_++;
         }
         if(this._fontColor != param2 && this._lasthighLightColor != param2)
         {
            TweenMax.to(this._hPanel,0,{"colorMatrixFilter":{"colorize":13224393}});
            _loc9_ = COLORIZE_REPEAT_COUNT * 2;
            TweenMax.to(this._hPanel,0.4,{
               "colorMatrixFilter":{"colorize":param2},
               "yoyo":true,
               "repeat":_loc9_,
               "ease":Sine.easeIn
            });
            this._lasthighLightColor = param2;
         }
      }
      
      private function getFinisher(param1:String) : FileCollectionFinisher
      {
         return ResourceManager.fileCollection.getFinisher(param1);
      }
      
      private function clear() : void
      {
         while(numChildren)
         {
            removeChildAt(0);
         }
      }
   }
}


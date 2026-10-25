package net.bigpoint.darkorbit.fui.components.text.label
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Linear;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   
   public class MarqueeLabelSkin extends LabelSkin
   {
      
      private static var _skinLayerDefintions:Dictionary = new Dictionary();
      
      _skinLayerDefintions[SkinLayerNames.NORMAL] = {};
      _skinLayerDefintions[SkinLayerNames.DISABLED] = {};
      _skinLayerDefintions[SkinLayerNames.MASK] = {};
      
      public function MarqueeLabelSkin()
      {
         super();
      }
      
      override public function set text(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:TweenMax = null;
         if(Boolean(_msgLabel) && param1 != null)
         {
            _fullText = param1;
            if(_useHTML)
            {
               _msgLabel.htmlText = _fullText;
            }
            else
            {
               _msgLabel.text = _fullText;
            }
            _loc2_ = TweenMax.getTweensOf(_msgLabel);
            _loc3_ = int(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc6_ = _loc2_[_loc4_];
               _loc6_.currentProgress = 0;
               _loc6_.kill();
               _loc4_++;
            }
            doAutoSizeAndAlignment();
            _loc5_ = _width - _msgLabel.width;
            if(_loc5_ < 0)
            {
               TweenMax.to(_msgLabel,Math.abs(_loc5_) * 0.075,{
                  "delay":1,
                  "repeatDelay":3,
                  "x":_loc5_,
                  "yoyo":true,
                  "repeat":-1,
                  "ease":Linear.easeNone
               });
            }
         }
      }
      
      override public function getSkinLayerDefintions() : Dictionary
      {
         return _skinLayerDefintions;
      }
      
      override public function clone() : ISkin
      {
         var _loc1_:LabelSkin = new MarqueeLabelSkin();
         _clone_(_loc1_,_skinLayerDefintions);
         _loc1_.truncateText = this._truncateText;
         return _loc1_;
      }
   }
}


package net.bigpoint.darkorbit.map.hud.effects.impl
{
   import com.bigpoint.utils.TextFormatter;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class DamagedReceivedEffect2D extends AbstractHUDElement
   {
      
      private static const HITPOINTS_FILTER:Array = [new GlowFilter(0,1,2,2,50,3)];
      
      private static const TEXTFIELD:TextField = new TextField();
      
      private static const TEXTFORMAT:TextFormat = new TextFormat(Styles.baseEmbed ? "Tahoma" : null,24,0,true);
      
      private var _effect:DamageReceivedEffect;
      
      private var _bitmapData:BitmapData;
      
      private var _bitmap:Bitmap;
      
      public function DamagedReceivedEffect2D(param1:IMapView, param2:DamageReceivedEffect)
      {
         var _loc6_:String = null;
         super(param1,param2.source.position);
         this._effect = param2;
         var _loc3_:int = int(PatternManager.hitpointColorPatterns[param2.colorId]);
         var _loc4_:TextField = TEXTFIELD;
         var _loc5_:TextFormat = TEXTFORMAT;
         _loc5_.color = _loc3_;
         if(param2.hitpointDelta > 0)
         {
            _loc6_ = "";
            if(param2.useSign)
            {
               _loc6_ = "+";
            }
            _loc4_.text = _loc6_ + TextFormatter.roundInteger(param2.hitpointDelta);
         }
         else if(param2.hitpointDelta == 0)
         {
            if(param2.replaceZeroWithMiss)
            {
               _loc4_.text = BPLocale.getItem("shot_miss");
            }
            else
            {
               _loc4_.text = "0";
            }
         }
         else
         {
            _loc4_.text = BPLocale.getItem("shot_hit");
         }
         _loc4_.setTextFormat(_loc5_);
         _loc4_.filters = HITPOINTS_FILTER;
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         this._bitmapData = new BitmapData(_loc4_.width,_loc4_.height,true,0);
         this._bitmapData.draw(_loc4_);
         this._bitmap = new Bitmap(this._bitmapData);
         this._bitmap.scaleX = 0.3;
         this._bitmap.scaleY = 0.3;
         addChild(this._bitmap);
         if(param2.strike)
         {
            TweenLite.to(this._bitmap,0.2,{
               "scaleX":3,
               "scaleY":3
            });
            TweenLite.to(this._bitmap,0.2,{
               "delay":0.2,
               "scaleX":1,
               "scaleY":1
            });
            TweenLite.to(this._bitmap,1,{
               "y":this._bitmap.y - 100,
               "x":-this._bitmap.width
            });
            TweenLite.to(this._bitmap,1,{
               "delay":0.5,
               "alpha":0,
               "onComplete":this.disposeView
            });
         }
         else
         {
            TweenLite.to(this._bitmap,1,{
               "y":this._bitmap.y - 100,
               "scaleX":1,
               "scaleY":1,
               "x":-this._bitmap.width
            });
            TweenLite.to(this._bitmap,1,{
               "y":this._bitmap.y - 100,
               "x":-this._bitmap.width
            });
            TweenLite.to(this._bitmap,1,{
               "delay":0.5,
               "alpha":0,
               "onComplete":this.disposeView
            });
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenLite.killTweensOf(this._bitmap);
         TweenLite.killDelayedCallsTo(this._bitmap);
         this._bitmapData.dispose();
         super.disposeView(param1);
      }
   }
}


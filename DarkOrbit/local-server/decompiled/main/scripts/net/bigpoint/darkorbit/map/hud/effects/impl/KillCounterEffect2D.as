package net.bigpoint.darkorbit.map.hud.effects.impl
{
   import com.bigpoint.utils.TextFormatter;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.effects.impl.KillCounterEffect;
   
   public class KillCounterEffect2D extends AbstractHUDElement
   {
      
      private static const HITPOINTS_FILTER:GlowFilter = new GlowFilter(0,1,2,2,50,3);
      
      private static const TEXTFIELD:TextField = new TextField();
      
      private static const TEXTFORMAT:TextFormat = new TextFormat(Styles.baseEmbed ? "Tahoma" : null,48,0,true);
      
      private var _effect:KillCounterEffect;
      
      private var _bitmapData:BitmapData;
      
      private var _bitmap:Bitmap;
      
      public function KillCounterEffect2D(param1:IMapView, param2:KillCounterEffect)
      {
         super(param1,param2.source.position);
         this._effect = param2;
         var _loc3_:int = this._effect.colorId;
         var _loc4_:TextField = TEXTFIELD;
         var _loc5_:TextFormat = TEXTFORMAT;
         _loc5_.color = _loc3_;
         if(param2.killCount == 1)
         {
            _loc4_.text = TextFormatter.roundInteger(param2.killCount) + " " + BPLocale.getItem("visualPerk_tyrannos_kill");
         }
         else if(param2.killCount > 1)
         {
            _loc4_.text = TextFormatter.roundInteger(param2.killCount) + " " + BPLocale.getItem("visualPerk_tyrannos_kills");
         }
         _loc4_.setTextFormat(_loc5_);
         var _loc6_:GlowFilter = new GlowFilter();
         _loc6_.inner = false;
         _loc6_.color = this._effect.colorGlow;
         _loc6_.blurX = 10;
         _loc6_.blurY = 10;
         _loc6_.strength = 2;
         var _loc7_:DropShadowFilter = new DropShadowFilter();
         _loc7_.color = 224341762;
         _loc7_.blurX = 20;
         _loc7_.blurY = 20;
         _loc7_.strength = 1;
         _loc4_.filters = [_loc7_,_loc6_];
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         this._bitmapData = new BitmapData(_loc4_.width,_loc4_.height,true,16777215);
         this._bitmapData.draw(_loc4_);
         this._bitmap = new Bitmap(this._bitmapData);
         this._bitmap.scaleX = 0.15;
         this._bitmap.scaleY = 0.15;
         this._bitmap.y -= 50;
         this._bitmap.x -= 1.5 * this._bitmap.width;
         addChild(this._bitmap);
         TweenLite.to(this._bitmap,0.2,{
            "y":this._bitmap.y - 75,
            "x":this._bitmap.x = this._bitmap.x - 0.5 * this._bitmap.width,
            "scaleX":1,
            "scaleY":1
         });
         TweenLite.to(this._bitmap,0.8,{
            "delay":0.2,
            "x":this._bitmap.x = this._bitmap.x + 0.5 * this._bitmap.width,
            "scaleX":0.5,
            "scaleY":0.5
         });
         TweenLite.to(this._bitmap,1,{
            "delay":1,
            "alpha":0,
            "onComplete":this.disposeView
         });
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


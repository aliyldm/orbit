package net.bigpoint.darkorbit.map.model.minimap
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import mx.effects.easing.Linear;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class MapMarker extends Sprite
   {
      
      private static var markers:Array = new Array();
      
      private var mc:MovieClip = null;
      
      public function MapMarker(param1:MarkerVO, param2:Number, param3:Number)
      {
         super();
         this.mc = ResourceManager.getMovieClip("minimap","minimapmarker" + param1.colorAppendix);
         if(Boolean(param1.id) && param1.id != "")
         {
            if(markers[param1.id])
            {
               stopMapMarker(param1.id);
            }
            markers[param1.id] = this;
         }
         x = param1.x * param3;
         y = param1.y * param3;
         mouseEnabled = false;
         mouseChildren = false;
         var _loc4_:int = 1;
         var _loc5_:int = this.mc.framesLoaded;
         var _loc6_:Number = 1;
         if(param1.inverse)
         {
            _loc4_ = _loc5_;
            _loc5_ = 1;
            _loc6_ = 0;
            this.mc.scaleX = param1.scale * 3.5 / param2;
            this.mc.scaleY = param1.scale * 3.5 / param2;
         }
         this.mc.gotoAndStop(_loc4_);
         this.addChild(this.mc);
         TweenMax.to(this.mc,param1.secondsPerMarker,{
            "ease":Linear.easeNone,
            "frame":_loc5_,
            "alpha":_loc6_,
            "onComplete":this.remove,
            "repeat":(param1.count > 0 ? param1.count - 1 : param1.count)
         });
      }
      
      public static function cleanupAllMarkers() : void
      {
         var _loc1_:MapMarker = null;
         for each(_loc1_ in markers)
         {
            if(_loc1_)
            {
               _loc1_.remove();
            }
         }
         markers = [];
      }
      
      public static function stopMapMarker(param1:String) : void
      {
         var _loc2_:MapMarker = markers[param1];
         if(_loc2_ != null)
         {
            _loc2_.remove();
         }
      }
      
      public function remove() : void
      {
         MovieClipUtils.removeDisplayObject(this);
         TweenLite.killTweensOf(this.mc);
         delete markers[this];
      }
   }
}


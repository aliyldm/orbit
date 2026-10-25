package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.com.module.AttackRangeExceededCommand;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.OutOfRangeEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class OutOfRangeEffect2D extends AbstractMapObjectEffect2D
   {
      
      private static var markersActive:Dictionary = new Dictionary();
      
      private static const maxMarkersPerType:uint = 5;
      
      private static const TYPE_2_RESKEY:Object = {};
      
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_LASER] = "Laser";
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_ROCKET] = "Rocket";
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_HELLSTORM] = "Hellstorm";
      TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_MISC] = "Misc";
      
      private const RADTODEG:Number = 57.29577951308232;
      
      public function OutOfRangeEffect2D(param1:MapView2D, param2:OutOfRangeEffect)
      {
         super(param1,param2,false);
         this.addLimitMarker(param2);
         TweenLite.delayedCall(0.33,this.addLimitMarker,[param2]);
         TweenLite.delayedCall(0.66,this.addLimitMarker,[param2]);
      }
      
      private function addLimitMarker(param1:OutOfRangeEffect) : void
      {
         var _loc5_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:PointLite = null;
         var _loc2_:MapEntity = param1.source;
         var _loc3_:MapEntity = param1.target;
         var _loc4_:int = param1.maxRange;
         _loc5_ = param1.type;
         if(!_loc2_ || !_loc3_ || !mapObjectView)
         {
            return;
         }
         if(markersActive[_loc5_] == undefined)
         {
            markersActive[_loc5_] = 0;
         }
         if(markersActive[_loc5_] >= maxMarkersPerType)
         {
            return;
         }
         markersActive[_loc5_] += 1;
         var _loc6_:String = "outOfRangeLimiter" + (TYPE_2_RESKEY[_loc5_] || TYPE_2_RESKEY[AttackRangeExceededCommand.ATTACKTYPE_LASER]);
         _loc7_ = ResourceManager.getMovieClip("ui",_loc6_);
         _loc8_ = new PointLite(_loc3_.position.x - _loc2_.position.x,_loc3_.position.y - _loc2_.position.y);
         _loc8_.normalize(_loc4_);
         _loc7_.x = _loc8_.x;
         _loc7_.y = _loc8_.y;
         _loc7_.rotation = 90 + Math.atan2(_loc8_.y,_loc8_.x) * this.RADTODEG;
         mapObjectView.addChild(_loc7_);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_OUT_OF_RANGE);
         TweenLite.to(_loc7_,2,{
            "alpha":0,
            "onComplete":this.removeAndCount,
            "onCompleteParams":[_loc7_,_loc5_]
         });
      }
      
      private function removeAndCount(param1:DisplayObject, param2:uint) : void
      {
         if(Boolean(param1) && Boolean(param1.parent))
         {
            param1.parent.removeChild(param1);
         }
         markersActive[param2] = markersActive[param2] - 1;
      }
   }
}


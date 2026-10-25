package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class POIZoneExplosionContainerEffect extends Effect
   {
      
      private var _explosionArea:Rectangle;
      
      private var _allocationArea:Rectangle;
      
      private var _explosionMaxStartDelay:Number;
      
      private var _explosionCenter:PointLite;
      
      public function POIZoneExplosionContainerEffect(param1:PointLite, param2:Rectangle, param3:Rectangle, param4:Number = 2)
      {
         super(EffectIDList.POIZONE_EXPLOSION_EFFECT_CONTAINER,NOT_PERSISTANT);
         this._explosionArea = param3;
         this._allocationArea = param2;
         this._explosionMaxStartDelay = param4;
         this._explosionCenter = param1;
      }
      
      public function get explosionArea() : Rectangle
      {
         return this._explosionArea;
      }
      
      public function get allocationArea() : Rectangle
      {
         return this._allocationArea;
      }
      
      public function get explosionMaxStartDelay() : Number
      {
         return this._explosionMaxStartDelay;
      }
      
      public function get explosionCenter() : PointLite
      {
         return this._explosionCenter;
      }
      
      public function createExplosion(param1:PointLite) : void
      {
         ScreenManager.getInstance().map.effects.addEffect(new POIZoneExplosionEffect(param1));
      }
   }
}


package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.mvc.traininggrounds.SimpleShipDisplayTrait;
   import net.bigpoint.darkorbit.pattern.FullResourcePattern;
   
   public class CameraDroneEffect extends MapObjectEffect
   {
      
      private static const RES:FullResourcePattern = new FullResourcePattern(-1,"cameraDrone","mc");
      
      private static const MIN_DISTANCE:int = 200;
      
      private const ID:int = Map.NEXT_FREE_ID;
      
      private var _cameraTrait:SimpleShipDisplayTrait;
      
      private var _intervalPointer:int = -1;
      
      private var _map:Map;
      
      public function CameraDroneEffect(param1:MapEntity, param2:Map)
      {
         this._map = param2;
         super(EffectIDList.CAMERA_DRONE_EFFECT,param1,PERSISTANT);
      }
      
      override public function activate() : Boolean
      {
         this._cameraTrait = new SimpleShipDisplayTrait(RES,true,false);
         var _loc1_:MapEntity = new MapEntity(this.ID,new PointLite(source.x,source.y));
         _loc1_.addTrait(this._cameraTrait);
         source.position.changed.add(this.activateTimer);
         this._map.addEntity(_loc1_);
         this.updateTimer();
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
         clearInterval(this._intervalPointer);
         source.position.changed.remove(this.updateTimer);
         this._map.removeEntityById(this.ID);
      }
      
      public function updateTimer() : void
      {
         var _loc1_:PointLite = this.kalkTarGet();
         if(_loc1_)
         {
            this._cameraTrait.position.x = _loc1_.x;
            this._cameraTrait.position.y = _loc1_.y;
         }
         else
         {
            clearInterval(this._intervalPointer);
            this._intervalPointer = -1;
         }
         this._cameraTrait.rotation.radians = Math.atan2(this._cameraTrait.position.y - source.y,this._cameraTrait.position.x - source.x);
      }
      
      private function activateTimer() : void
      {
         if(this._intervalPointer == -1)
         {
            this._intervalPointer = setInterval(this.updateTimer,1);
         }
      }
      
      private function kalkTarGet() : PointLite
      {
         var _loc1_:PointLite = source.position.subtract(this._cameraTrait.position);
         if(_loc1_.length < MIN_DISTANCE)
         {
            return null;
         }
         var _loc2_:Number = _loc1_.length;
         _loc1_.normalize((_loc2_ - MIN_DISTANCE * 1.25) * 0.1);
         return _loc1_.add(this._cameraTrait.position);
      }
   }
}


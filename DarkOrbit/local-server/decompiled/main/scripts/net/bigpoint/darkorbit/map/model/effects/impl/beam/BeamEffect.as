package net.bigpoint.darkorbit.map.model.effects.impl.beam
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class BeamEffect extends MapObjectEffect
   {
      
      private var _target:MapEntity;
      
      private var _color:uint = 0;
      
      public function BeamEffect(param1:int, param2:MapEntity, param3:MapEntity, param4:int, param5:uint, param6:Number = -1)
      {
         super(param1,param2,TIME_OUT,null,param6);
         this._target = param3;
         timeOutTime = param4;
         this._color = param5;
      }
      
      public function get target() : MapEntity
      {
         return this._target;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._target != null;
      }
      
      public function get sourcePosition() : PointLite
      {
         return source.position;
      }
      
      public function get targetPosition() : PointLite
      {
         return this.target.position;
      }
   }
}


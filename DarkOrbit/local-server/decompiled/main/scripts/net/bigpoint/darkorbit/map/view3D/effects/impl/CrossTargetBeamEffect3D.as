package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class CrossTargetBeamEffect3D extends BeamEffect3D
   {
      
      private var _deltaPosition:PointLite;
      
      protected var particleFilename:String;
      
      public function CrossTargetBeamEffect3D(param1:MapView3D, param2:Effect, param3:MapEntity, param4:MapEntity, param5:String, param6:PointLite)
      {
         this._deltaPosition = param4 ? new PointLite(param4.position.x,param4.y,param4.z) : new PointLite(param6.x,param6.y,param6.z);
         super(param2,param5,param3.position,param4 ? param4.position : param6,0,false,this.distance);
         this.particleFilename = param5;
      }
      
      protected function get distance() : Number
      {
         return 1000;
      }
      
      override public function updateObj(param1:Number) : void
      {
         this.updateTargetPosition();
         super.updateObj(param1);
      }
      
      override protected function get targetPosition() : PointLite
      {
         return this._deltaPosition;
      }
      
      protected function updateTargetPosition() : void
      {
         var _loc1_:Number = _targetPosition.x - _sourcePosition.x;
         var _loc2_:Number = _targetPosition.y - _sourcePosition.y;
         var _loc3_:Number = Math.atan2(_loc2_,_loc1_);
         var _loc4_:Number = Infinity;
         var _loc5_:Number = Infinity;
         if(Math.cos(_loc3_) < 0 && _sourcePosition.x > 0)
         {
            _loc4_ = _sourcePosition.x / Math.abs(Math.cos(_loc3_));
         }
         if(Math.sin(_loc3_) < 0 && _sourcePosition.y > 0)
         {
            _loc5_ = _sourcePosition.y / Math.abs(Math.sin(_loc3_));
         }
         var _loc6_:Number = Math.min(_loc4_,_loc5_,this.distance * 0.9);
         this._deltaPosition.x = _sourcePosition.x + Math.cos(_loc3_) * _loc6_;
         this._deltaPosition.y = _sourcePosition.y + Math.sin(_loc3_) * _loc6_;
      }
   }
}


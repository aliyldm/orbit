package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class BeamEffect3D extends StandaloneParticle3D
   {
      
      protected var _targetPosition:PointLite;
      
      protected var _sourcePosition:PointLite;
      
      protected var _expansionTime:Number = 0;
      
      protected var _currentTime:Number = 0;
      
      protected var _maxDist:Number;
      
      protected var _scaleXOverDistance:Boolean;
      
      protected var _denominatorZ:int = 110;
      
      protected var _denominatorX:int = 250;
      
      private var _uniformScale:Number = 1;
      
      public function BeamEffect3D(param1:Effect, param2:String, param3:PointLite, param4:PointLite, param5:Number = 0, param6:Boolean = false, param7:Number = -1)
      {
         this._scaleXOverDistance = param6;
         this._expansionTime = param5;
         this._sourcePosition = param3;
         this._targetPosition = param4;
         this._maxDist = param7;
         if(this._expansionTime == 0)
         {
            this._currentTime = 1;
         }
         super(param1,param2,param3,null,true);
      }
      
      override protected function applyScale(param1:Number) : void
      {
         this._uniformScale = param1;
         view.scaleY = param1;
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         this.updateDistance(param1);
      }
      
      protected function get targetPosition() : PointLite
      {
         return this._targetPosition;
      }
      
      protected function updateDistance(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(view)
         {
            _loc2_ = this.targetPosition.distanceTo(this._sourcePosition.x,this._sourcePosition.y,this._sourcePosition.z);
            if(this._currentTime < 1)
            {
               this._currentTime += param1 / this._expansionTime;
               if(this._currentTime > 1)
               {
                  this._currentTime = 1;
               }
            }
            if(this._maxDist == -1 || _loc2_ < this._maxDist)
            {
               view.scaleZ = _loc2_ / this._denominatorZ * this._currentTime;
            }
            else
            {
               view.scaleZ = this._uniformScale;
            }
            if(this._scaleXOverDistance)
            {
               view.scaleX = _loc2_ / this._denominatorX * this._currentTime;
            }
            else
            {
               view.scaleX = this._uniformScale;
            }
            view.rotationY = Math.atan2(this.targetPosition.y - this._sourcePosition.y,this.targetPosition.x - this._sourcePosition.x) * FastMath.RADTODEG + 90;
         }
      }
   }
}


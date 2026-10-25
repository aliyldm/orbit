package net.bigpoint.darkorbit.map.view3D.utils
{
   import com.greensock.TweenLite;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   
   public class FloatingData extends Vector3D implements IUpdatable
   {
      
      private var _t:Number = 0;
      
      private var _timeScale:Number = 1;
      
      public function FloatingData(param1:Number, param2:Number = 0)
      {
         super();
         this._timeScale = 1 / param1;
         param2 = param2;
         this._t = param2;
      }
      
      public function updateObj(param1:Number) : void
      {
         this._t += param1 * this._timeScale;
         var _loc2_:Number = Math.sin(this._t);
         var _loc3_:Number = Math.cos(this._t);
         setTo(_loc2_ * _loc3_,_loc2_ * _loc2_,_loc3_ * _loc2_);
      }
      
      public function stop() : void
      {
         this._t = 0;
         TweenLite.to(this,0.5,{
            "x":0,
            "y":0,
            "z":0
         });
      }
   }
}


package net.bigpoint.darkorbit.map.model.traits.weapons
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class RocketLauncher extends AbstractWeapons
   {
      
      private static const RANDOMPOINT:PointLite = new PointLite();
      
      private var _localPosition:PointLite = PointLite.ZERO;
      
      private var _direction:PointLite;
      
      private var _rocketClassId:int;
      
      public function RocketLauncher(param1:int = 0, param2:PointLite = null)
      {
         super();
         this._rocketClassId = param1;
         this._direction = param2;
      }
      
      public function get rocketClassId() : int
      {
         return this._rocketClassId;
      }
      
      public function get direction() : PointLite
      {
         if(this._direction)
         {
            return this._direction;
         }
         RANDOMPOINT.x = FastMath.getRandomCount(-800,800);
         RANDOMPOINT.y = FastMath.getRandomCount(-800,800);
         return RANDOMPOINT;
      }
      
      public function set direction(param1:PointLite) : void
      {
         this._direction = param1;
      }
      
      public function set rocketClassId(param1:int) : void
      {
         this._rocketClassId = param1;
      }
      
      public function get localPosition() : PointLite
      {
         return this._localPosition;
      }
      
      public function set localPosition(param1:PointLite) : void
      {
         this._localPosition = param1;
      }
   }
}


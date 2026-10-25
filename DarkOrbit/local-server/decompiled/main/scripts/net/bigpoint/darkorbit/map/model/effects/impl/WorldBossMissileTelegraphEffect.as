package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class WorldBossMissileTelegraphEffect extends Effect
   {
      
      private var _positions:Vector.<PointLite> = new Vector.<PointLite>();
      
      private var _color:int;
      
      private var _maxDist:Number;
      
      public function WorldBossMissileTelegraphEffect(param1:Array, param2:int = -65536, param3:Number = 2147483647)
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         this._color = param2;
         this._maxDist = param3;
         var _loc4_:int = int(param1.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param1[_loc5_];
            _loc6_ = _loc6_.substring(_loc6_.indexOf("(") + 1,_loc6_.indexOf(")"));
            _loc7_ = _loc6_.split("/");
            this._positions.push(new PointLite(_loc7_[0],_loc7_[1],_loc7_[2]));
            _loc5_++;
         }
         super(EffectIDList.WORLDBOSS_MISSILE_TELEGRAPH_EFFECT,PERSISTANT);
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get maxDist() : Number
      {
         return this._maxDist;
      }
      
      public function get positions() : Vector.<PointLite>
      {
         return this._positions;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._positions != null && this._positions.length >= 2;
      }
   }
}


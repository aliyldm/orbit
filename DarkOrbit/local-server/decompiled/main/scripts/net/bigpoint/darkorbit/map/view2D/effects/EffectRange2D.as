package net.bigpoint.darkorbit.map.view2D.effects
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public final class EffectRange2D
   {
      
      public static const RADIUS:Number = 1000;
      
      public function EffectRange2D()
      {
         super();
      }
      
      public static function near(param1:PointLite, param2:Number = 1000) : Boolean
      {
         var _loc3_:Ship = ScreenManager.getInstance().map ? ScreenManager.getInstance().map.hero : null;
         if(!_loc3_ || !param1)
         {
            return false;
         }
         var _loc4_:Number = param1.x - _loc3_.position.x;
         var _loc5_:Number = param1.y - _loc3_.position.y;
         return _loc4_ * _loc4_ + _loc5_ * _loc5_ <= param2 * param2;
      }
      
      public static function connectsHero(param1:AbstractBoltEffect) : Boolean
      {
         var _loc3_:Object = null;
         var _loc2_:Ship = ScreenManager.getInstance().map ? ScreenManager.getInstance().map.hero : null;
         if(!_loc2_ || !param1)
         {
            return false;
         }
         if(param1.attacker === _loc2_)
         {
            return true;
         }
         for each(_loc3_ in param1.chainArray)
         {
            if(int(_loc3_) == _loc2_.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function ownLink(param1:PointLite, param2:PointLite) : Boolean
      {
         var _loc3_:Ship = ScreenManager.getInstance().map ? ScreenManager.getInstance().map.hero : null;
         return Boolean(_loc3_) && (param1 === _loc3_.position || param2 === _loc3_.position);
      }
      
      public static function link(param1:PointLite, param2:PointLite, param3:Number = 1000) : Boolean
      {
         return ownLink(param1,param2) || near(param1,param3) && near(param2,param3);
      }
   }
}


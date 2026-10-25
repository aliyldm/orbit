package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.glow.AbstractShipGlowEffect;
   
   public class GenericGlowEffect extends AbstractShipGlowEffect
   {
      
      private var _type:int;
      
      private var _count:int;
      
      public function GenericGlowEffect(param1:MapEntity, param2:int, param3:int)
      {
         super(EffectIDList.GENERIC_GLOW,param1);
         this._type = param2;
         this._count = param3;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function get glowType() : int
      {
         return this._type;
      }
   }
}


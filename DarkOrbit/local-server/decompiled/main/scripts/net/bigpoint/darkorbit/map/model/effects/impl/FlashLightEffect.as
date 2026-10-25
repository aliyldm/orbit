package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class FlashLightEffect extends Effect
   {
      
      public static const ID:int = EffectIDList.FLASH_LIGHT;
      
      public var range:Number = 1000;
      
      public function FlashLightEffect(param1:Number = 1000)
      {
         super(ID,PERSISTANT);
         this.range = param1;
      }
   }
}


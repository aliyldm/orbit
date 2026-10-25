package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class RadiationEffect extends Effect
   {
      
      public static const ID:int = EffectIDList.RADIATION_EFFECT;
      
      public const mapGroupsWithoutArrow:Vector.<String> = new <String>["PayloadEscort"];
      
      public function RadiationEffect()
      {
         super(ID,PERSISTANT,null);
      }
   }
}


package net.bigpoint.darkorbit.map.model.effects
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class MapObjectPersistantEffect extends MapObjectEffect
   {
      
      public function MapObjectPersistantEffect(param1:MapEntity, param2:int, param3:int = 1)
      {
         var _loc4_:* = PatternManager.effectPatterns[param2];
         super(param2,param1,param3,_loc4_);
      }
   }
}


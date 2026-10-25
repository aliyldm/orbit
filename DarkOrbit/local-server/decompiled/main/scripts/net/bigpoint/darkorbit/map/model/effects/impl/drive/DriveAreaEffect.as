package net.bigpoint.darkorbit.map.model.effects.impl.drive
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class DriveAreaEffect extends MapObjectEffect
   {
      
      private var _scale:Number = -1;
      
      public function DriveAreaEffect(param1:int, param2:*, param3:MapEntity, param4:Number = 1)
      {
         this._scale = param4;
         super(param1,param3,PERSISTANT,PatternManager.effectPatterns[param2]);
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
   }
}


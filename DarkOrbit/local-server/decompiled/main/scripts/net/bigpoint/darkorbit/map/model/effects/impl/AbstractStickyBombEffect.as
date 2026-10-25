package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class AbstractStickyBombEffect extends MapObjectEffect
   {
      
      public static const NORMAL:String = "normal";
      
      public static const EMPEROR:String = "emperor";
      
      public static const EXPLODING_CHARGING_BLOB:String = "ecb";
      
      private var _bombSource:MapEntity;
      
      private var _stickyBombType:String;
      
      public function AbstractStickyBombEffect(param1:int, param2:MapEntity, param3:MapEntity, param4:String)
      {
         super(param1,param3,PERSISTANT);
         this._bombSource = param2;
         this._stickyBombType = param4;
      }
      
      public function get stickyBombType() : String
      {
         return this._stickyBombType;
      }
      
      public function get bombSource() : MapEntity
      {
         return this._bombSource;
      }
      
      public function get bombTarget() : MapEntity
      {
         return source;
      }
   }
}


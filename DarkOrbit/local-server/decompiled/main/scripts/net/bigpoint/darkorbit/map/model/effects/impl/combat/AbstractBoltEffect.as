package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PetSpawnEffect;
   
   public class AbstractBoltEffect extends MapObjectEffect
   {
      
      private var _attacker:MapEntity;
      
      private var _chainArray:Array;
      
      public function AbstractBoltEffect(param1:int, param2:MapEntity, param3:Array, param4:int)
      {
         super(param1,param2,param4);
         this._attacker = param2;
         this._chainArray = param3;
      }
      
      public function get attacker() : MapEntity
      {
         return this._attacker;
      }
      
      public function get chainArray() : Array
      {
         return this._chainArray;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._attacker != null && this._chainArray.length > 0;
      }
      
      public function addHitEffect(param1:int) : void
      {
         var _loc2_:MapEntity = ScreenManager.getInstance().map.getEntityById(param1);
         ScreenManager.getInstance().map.effects.addMapObjectEffectOnce(new PetSpawnEffect(_loc2_));
      }
      
      override public function get ignoresCloak() : Boolean
      {
         return true;
      }
      
      public function get target() : MapEntity
      {
         if(this.chainArray.length == 0)
         {
            return null;
         }
         return this.chainArray[0];
      }
      
      public function get sourcePosition() : PointLite
      {
         return source.position;
      }
      
      public function get targetPosition() : PointLite
      {
         if(this.target == null)
         {
            return source.position;
         }
         return this.target.position;
      }
   }
}


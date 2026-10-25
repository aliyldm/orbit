package net.bigpoint.darkorbit.map.model.effects
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.pet.Pet;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class MapObjectEffect extends Effect
   {
      
      private var _activateSoundId:int = -1;
      
      private var _source:MapEntity;
      
      public function MapObjectEffect(param1:int, param2:MapEntity, param3:int = 1, param4:EffectPattern = null, param5:int = -1)
      {
         super(param1,param3,param4);
         this._source = param2;
         this._activateSoundId = param5;
      }
      
      public function get source() : MapEntity
      {
         return this._source;
      }
      
      override public function activate() : Boolean
      {
         var _loc1_:Ship = null;
         var _loc2_:Pet = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         if(this._activateSoundId != -1)
         {
            AudioManager.playSoundEffect(this._activateSoundId,false,false,this._source.x,this._source.y,true);
         }
         if(type == PERSISTANT || type == TIME_OUT)
         {
            this._source.entityDeactivated.add(this.deactivate);
            _loc1_ = this._source as Ship;
            _loc2_ = this._source as Pet;
            _loc3_ = (Boolean(_loc1_) && !_loc1_.isHeroShip() || Boolean(_loc2_) && !_loc2_.isHeroPet()) && _loc1_.cloaked.value;
            _loc4_ = _loc3_ ? ignoresCloak : true;
         }
         else
         {
            _loc4_ = true;
         }
         return Boolean(super.activate()) && _loc4_;
      }
      
      override public function deactivate() : void
      {
         this._source.entityDeactivated.remove(this.deactivate);
         super.deactivate();
      }
      
      override public function isValid() : Boolean
      {
         var _loc1_:Ship = this._source as Ship;
         var _loc2_:Pet = this._source as Pet;
         var _loc3_:Boolean = (Boolean(_loc1_) && !_loc1_.isHeroShip() || Boolean(_loc2_) && !_loc2_.isHeroPet()) && _loc1_.cloaked.value;
         var _loc4_:Boolean = _loc3_ && type == Effect.NOT_PERSISTANT ? ignoresCloak : true;
         return Boolean(super.isValid()) && this._source != null && _loc4_;
      }
   }
}


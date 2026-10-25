package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.hud.DamageIconTrait;
   
   public class DMGBuffEffect extends MapObjectEffect
   {
      
      private var _level:int;
      
      public function DMGBuffEffect(param1:MapEntity, param2:int)
      {
         this._level = param2;
         super(EffectIDList.DMG_BUFF_EFFECT,param1,PERSISTANT);
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      override public function reactivate(param1:Effect) : void
      {
         var _loc2_:DamageIconTrait = this.getOrAdd();
         _loc2_.level.value = this._level = (param1 as DMGBuffEffect).level;
      }
      
      override public function deactivate() : void
      {
         this.removeTrait();
         super.deactivate();
      }
      
      override public function activate() : Boolean
      {
         var _loc1_:DamageIconTrait = this.getOrAdd();
         _loc1_.level.value = this.level;
         return super.activate();
      }
      
      private function getOrAdd() : DamageIconTrait
      {
         var _loc1_:DamageIconTrait = source.getFirstTrait(DamageIconTrait) as DamageIconTrait;
         if(!_loc1_)
         {
            _loc1_ = new DamageIconTrait(DamageIconTrait.BUFF);
            source.addTrait(_loc1_);
         }
         _loc1_.type.value = DamageIconTrait.BUFF;
         return _loc1_;
      }
      
      private function removeTrait() : void
      {
         source.removeTraitByType(DamageIconTrait);
      }
   }
}


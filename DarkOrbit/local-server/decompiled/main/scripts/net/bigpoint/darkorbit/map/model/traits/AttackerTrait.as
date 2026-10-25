package net.bigpoint.darkorbit.map.model.traits
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.weapons.LaserCannon;
   import net.bigpoint.darkorbit.map.model.traits.weapons.RocketLauncher;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class AttackerTrait extends EntityTraitBase
   {
      
      public const targetChanged:ISignal = new Signal();
      
      private var _laser:LaserCannon;
      
      private var _rocketLauncher:RocketLauncher;
      
      private var _target:AttackTargetTrait = null;
      
      private var _targetOwner:MapEntity;
      
      public function AttackerTrait(param1:LaserCannon, param2:RocketLauncher)
      {
         super();
         this._laser = param1;
         this._laser.owner = this;
         this._rocketLauncher = param2;
         this._rocketLauncher.owner = this;
         this._laser.fire.add(this.handleLaserFired);
         this._rocketLauncher.fire.add(this.handleRocketLauncherFired);
      }
      
      override public function deactivateTrait() : void
      {
         this.target = null;
         super.deactivateTrait();
      }
      
      private function handleRocketLauncherFired() : void
      {
         var _loc1_:UberDisplayTrait = null;
         if(owner)
         {
            _loc1_ = owner.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
            if(_loc1_)
            {
               _loc1_.playAnimation(this.rocketLauncher.attackAnimationName);
            }
         }
      }
      
      private function handleLaserFired() : void
      {
         var _loc1_:UberDisplayTrait = null;
         if(owner)
         {
            _loc1_ = owner.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
            if(_loc1_)
            {
               _loc1_.playAnimation(this.laser.attackAnimationName);
            }
         }
      }
      
      public function get laser() : LaserCannon
      {
         return this._laser;
      }
      
      public function get rocketLauncher() : RocketLauncher
      {
         return this._rocketLauncher;
      }
      
      public function get target() : AttackTargetTrait
      {
         return this._target;
      }
      
      public function set target(param1:AttackTargetTrait) : void
      {
         if(this._target != param1)
         {
            if(this._targetOwner)
            {
               this._targetOwner.entityDeactivated.remove(this.handleTargetDisposed);
               this._targetOwner = null;
            }
            this._target = param1;
            if(Boolean(this._target) && Boolean(this._target.owner))
            {
               this._targetOwner = this._target.owner;
               this._targetOwner.entityDeactivated.add(this.handleTargetDisposed);
            }
            this.targetChanged.dispatch();
         }
      }
      
      private function handleTargetDisposed() : void
      {
         this.target = null;
      }
   }
}


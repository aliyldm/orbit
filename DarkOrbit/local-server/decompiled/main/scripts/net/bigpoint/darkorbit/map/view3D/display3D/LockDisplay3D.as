package net.bigpoint.darkorbit.map.view3D.display3D
{
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.ParticleGroup;
   import com.greensock.TweenLite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.model.utils.LockManager;
   import org.osflash.signals.Promise;
   
   public class LockDisplay3D extends ObjectContainer3D implements IUpdatable
   {
      
      private static const TYPE_2_URL:Object = {};
      
      TYPE_2_URL[1] = "abstract_ui_mark_target_red.zip";
      TYPE_2_URL[2] = "abstract_ui_mark_target_gray_light.zip";
      TYPE_2_URL[3] = "abstract_ui_mark_target_purple.zip";
      TYPE_2_URL[4] = "abstract_ui_mark_target_gray_dark.zip";
      
      private var _views:Dictionary = new Dictionary();
      
      private var _currentView:ParticleGroup;
      
      private var _target:AttackTargetTrait;
      
      private var _scale:Number = 1;
      
      private var _lockManager:LockManager;
      
      private var _resourcePromise:Promise;
      
      public function LockDisplay3D()
      {
         super();
      }
      
      public function set map(param1:Map) : void
      {
         this.hideLock();
         this._views = new Dictionary();
         if(this._lockManager)
         {
            this._lockManager.targetChanged.remove(this.handleTargetChanged);
         }
         this._lockManager = param1 ? param1.lockManager : null;
         if(this._lockManager)
         {
            this._lockManager.targetChanged.add(this.handleTargetChanged);
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this._target)
         {
            moveTo(this._target.owner.x3D,this._target.owner.y3D,this._target.owner.z3D);
            if(this._currentView)
            {
               this._currentView.animator.time += param1 * 1000;
            }
         }
      }
      
      private function handleTargetChanged(param1:MapEntity) : void
      {
         var _loc2_:UberDisplayTrait = null;
         if(Boolean(this._target) && Boolean(this._target.owner))
         {
            this._target.lockType.changed.remove(this.updateLock);
         }
         this._target = param1 ? param1.getFirstTrait(AttackTargetTrait) as AttackTargetTrait : null;
         if(Boolean(this._target) && Boolean(this._target.owner))
         {
            this._target.lockType.changed.add(this.updateLock);
            _loc2_ = this._target.owner.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
            if(_loc2_)
            {
               this._scale = _loc2_.visualSize3D || 1;
            }
            this.updateLock();
         }
         else
         {
            this.hideLock();
         }
      }
      
      private function updateLock() : void
      {
         if(this._resourcePromise)
         {
            this._resourcePromise.remove(this.particlesReady);
            this._resourcePromise = null;
         }
         if(this._views[this._target.lockType.value])
         {
            this.currentView = this._views[this._target.lockType.value] as ParticleGroup;
         }
         else
         {
            this._resourcePromise = World3D.instance.particleLoader.loadParticleByUrl(TYPE_2_URL[this._target.lockType.value] || TYPE_2_URL[1],World3D.LIFETIME_GLOBAL);
            this._resourcePromise.addOnce(this.particlesReady);
         }
      }
      
      private function hideLock() : void
      {
         if(this._resourcePromise)
         {
            this._resourcePromise.remove(this.particlesReady);
            this._resourcePromise = null;
         }
         this.currentView = null;
      }
      
      private function particlesReady(param1:ParticleGroup) : void
      {
         this._views[this._target.lockType.value] = param1.clone();
         this.currentView = this._views[this._target.lockType.value] as ParticleGroup;
      }
      
      private function set currentView(param1:ParticleGroup) : void
      {
         if(this._currentView)
         {
            this._currentView.parent.removeChild(this._currentView);
            TweenLite.killTweensOf(this);
         }
         this._currentView = param1;
         if(this._currentView)
         {
            this._currentView.animator.time = 0;
            addChild(this._currentView);
            scaleX = scaleY = scaleZ = this._scale * 1.5;
            TweenLite.to(this,0.3,{
               "scaleX":this._scale,
               "scaleY":this._scale,
               "scaleZ":this._scale
            });
         }
      }
   }
}


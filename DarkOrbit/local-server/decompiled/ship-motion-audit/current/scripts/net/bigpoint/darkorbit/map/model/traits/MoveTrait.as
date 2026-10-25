package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableInt;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.bigpoint.utils.bindables.BindableRotation;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class MoveTrait extends EntityTraitBase
   {
      
      public const rotation:BindableRotation = new BindableRotation(Math.random() * 360);
      
      public const moveStarted:ISignal = new Signal();
      
      public const moveStopped:ISignal = new Signal();
      
      public const speed:BindableInt = new BindableInt(0);
      
      private var _onMoveComplete:Function = null;
      
      private var _onMoveCompleteParams:Array = null;
      
      private var _destination:PointLite = null;
      
      private var _gotoAnimator:TweenLite;
      
      private var _allowRotation:Boolean = true;
      
      private var _randomizeNPCRotationId:uint;
      
      private var _attackTarget:MapEntity = null;
      
      private var _persistentStatus:Boolean;
      
      public function MoveTrait(param1:int = 0)
      {
         super();
         this.speed.value = param1;
         this._persistentStatus = false;
      }
      
      override public function activateTrait() : void
      {
         this.speed.changed.add(this.handleSpeedChanged);
         if(this.attackTrait)
         {
            this.attackTrait.targetChanged.add(this.handleAttackTargetChanged);
         }
         if(this._gotoAnimator)
         {
            this._gotoAnimator.resume();
         }
      }
      
      override public function deactivateTrait() : void
      {
         if(this._attackTarget)
         {
            this._attackTarget.position.changed.remove(this.updateRotation);
            this._attackTarget = null;
         }
         if(this._gotoAnimator)
         {
            this._gotoAnimator.kill();
         }
         this.stopRandomRotation();
         if(this.attackTrait)
         {
            this.attackTrait.targetChanged.add(this.handleAttackTargetChanged);
         }
      }
      
      public function goto(param1:int, param2:int, param3:Function = null, param4:Array = null, param5:Number = 0, param6:Number = 0) : void
      {
         this._onMoveComplete = param3;
         this._onMoveCompleteParams = param4;
         if(this._persistentStatus)
         {
            return;
         }
         var _loc7_:Number = Number(param5 || Math.sqrt(Math.pow(param2 - this.position.y,2) + Math.pow(param1 - this.position.x,2)) / this.speed.value);
         if(_loc7_ > 0)
         {
            this._destination = new PointLite(param1,param2);
            this.updateRotation();
            this.moveStarted.dispatch();
            if(this._gotoAnimator == null)
            {
               this._gotoAnimator = TweenLite.to(this.position,_loc7_,{
                  "ease":Linear.easeNone,
                  "onComplete":this.handleMoveComplete
               });
            }
            this._gotoAnimator.vars.x = param1;
            this._gotoAnimator.vars.y = param2;
            this._gotoAnimator.duration = _loc7_;
            this._gotoAnimator.delay = param6;
            this._gotoAnimator.invalidate();
            this._gotoAnimator.restart();
         }
         else
         {
            this.stopMoving();
            this.updateRotation();
            if(this._onMoveComplete != null)
            {
               this._onMoveComplete.apply(null,this._onMoveCompleteParams);
               this._onMoveComplete = null;
               this._onMoveCompleteParams = null;
            }
         }
      }
      
      private function handleMoveComplete() : void
      {
         this._destination = null;
         this.position.changed.dispatch();
         this.moveStopped.dispatch();
         if(this._onMoveComplete != null)
         {
            this._onMoveComplete.apply(null,this._onMoveCompleteParams);
            this._onMoveComplete = null;
            this._onMoveCompleteParams = null;
         }
      }
      
      public function stopMoving() : void
      {
         var _loc1_:Boolean = this._destination != null;
         if(this._gotoAnimator)
         {
            this._gotoAnimator.kill();
         }
         this._destination = null;
         if(_loc1_)
         {
            this.moveStopped.dispatch();
         }
      }
      
      public function lookAt(param1:int, param2:int) : void
      {
         if(!this.isMoving || Math.abs(param1 - this.position.x) > 2 || Math.abs(param2 - this.position.y) > 2)
         {
            this.rotation.radians = Math.atan2(param2 - this.position.y,param1 - this.position.x) + Math.PI;
         }
      }
      
      public function updateRotation() : void
      {
         if(this._allowRotation)
         {
            if(Boolean(this.attackTrait) && this.attackTrait.target != null)
            {
               this.lookAt(this.attackTrait.target.owner.x,this.attackTrait.target.owner.y);
            }
            else if(this._destination)
            {
               this.lookAt(this._destination.x,this._destination.y);
            }
         }
      }
      
      private function startRandomRotation() : void
      {
         this.stopRandomRotation();
         this._randomizeNPCRotationId = setTimeout(this.randomizeNPCRotation,2000 + 5000 * Math.random());
      }
      
      private function stopRandomRotation() : void
      {
         clearTimeout(this._randomizeNPCRotationId);
      }
      
      private function randomizeNPCRotation() : void
      {
         clearTimeout(this._randomizeNPCRotationId);
         if(this._persistentStatus)
         {
            return;
         }
         if(Boolean(this.attackTrait) && this.attackTrait.target == null)
         {
            this.rotation.degrees += (Math.random() - 0.5) * 360;
         }
         this._randomizeNPCRotationId = setTimeout(this.randomizeNPCRotation,2000 + 5000 * Math.random());
      }
      
      public function set randomRotationEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.moveStarted.add(this.stopRandomRotation);
            this.moveStopped.add(this.startRandomRotation);
            if(!this.isMoving)
            {
               this.startRandomRotation();
            }
         }
         else
         {
            this.stopRandomRotation();
            this.moveStarted.remove(this.stopRandomRotation);
            this.moveStopped.remove(this.startRandomRotation);
         }
      }
      
      public function set allowRotation(param1:Boolean) : void
      {
         this._allowRotation = param1;
      }
      
      private function handleSpeedChanged() : void
      {
         if(this._destination)
         {
            this.goto(this._destination.x,this._destination.y);
         }
      }
      
      private function handleAttackTargetChanged() : void
      {
         if(this._attackTarget)
         {
            this._attackTarget.position.changed.remove(this.updateRotation);
         }
         this._attackTarget = this.attackTrait.target ? this.attackTrait.target.owner : null;
         if(this._attackTarget)
         {
            this._attackTarget.position.changed.add(this.updateRotation);
            this.position.changed.add(this.updateRotation);
         }
         else
         {
            this.position.changed.remove(this.updateRotation);
         }
         this.updateRotation();
      }
      
      public function get attackTrait() : AttackerTrait
      {
         return owner.getFirstTrait(AttackerTrait) as AttackerTrait;
      }
      
      private function get position() : BindablePointLite
      {
         return owner.position;
      }
      
      public function get isMoving() : Boolean
      {
         return this._destination != null;
      }
      
      public function get destination() : PointLite
      {
         return this._destination;
      }
      
      public function set persistentStatus(param1:Boolean) : void
      {
         this._persistentStatus = param1;
      }
   }
}


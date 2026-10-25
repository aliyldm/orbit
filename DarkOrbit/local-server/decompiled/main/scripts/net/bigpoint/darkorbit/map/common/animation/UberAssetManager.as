package net.bigpoint.darkorbit.map.common.animation
{
   import com.bigpoint.utils.bindables.BindableString;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IStateAware;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   
   public class UberAssetManager implements IUpdatable, IDisposable
   {
      
      private var _updatables:Vector.<IUpdatable> = new Vector.<IUpdatable>();
      
      private var _disposables:Vector.<IDisposable> = new Vector.<IDisposable>();
      
      private var _stateAwares:Vector.<IStateAware> = new Vector.<IStateAware>();
      
      private var _animationsById:Object = {};
      
      private var _activeAnimation:UberAnimationBase = null;
      
      private var _state:BindableString;
      
      private var _lastAnimationId:String = null;
      
      private var _idleAnimationId:String = null;
      
      private var _onAnimationComplete:Function;
      
      private var _nextViewId:Object = {};
      
      private var _nextAnimationId:int = 0;
      
      private var _debugId:String = null;
      
      private var _callOnCompleteOnInterrupt:Boolean = false;
      
      public function UberAssetManager(param1:BindableString = null)
      {
         super();
         this._state = param1;
         if(this._state)
         {
            this._state.changed.add(this.handleStateChanged);
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:* = int(this._updatables.length - 1);
         while(_loc2_ >= 0)
         {
            this._updatables[_loc2_].updateObj(param1);
            _loc2_--;
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._state)
         {
            this._state.changed.remove(this.handleStateChanged);
         }
         while(this._disposables.length > 0)
         {
            this._disposables.pop().disposeView(param1);
         }
         this._updatables.length = 0;
         this.playAnimation(null);
      }
      
      public function addUpdatable(param1:IUpdatable) : void
      {
         this._updatables.push(param1);
      }
      
      public function removeUpdatable(param1:IUpdatable) : void
      {
         var _loc2_:int = this._updatables.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._updatables.splice(_loc2_,1);
         }
      }
      
      public function addDisposable(param1:IDisposable) : void
      {
         this._disposables.push(param1);
      }
      
      public function removeDisposable(param1:IDisposable) : void
      {
         var _loc2_:int = this._disposables.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._disposables.splice(_loc2_,1);
         }
      }
      
      public function initViewElement(param1:Object) : void
      {
         if(param1 is IUpdatable)
         {
            this._updatables.push(param1 as IUpdatable);
            IUpdatable(param1).updateObj(0);
         }
         if(param1 is IDisposable)
         {
            this._disposables.push(param1 as IDisposable);
         }
         if(param1 is IStateAware)
         {
            this._stateAwares.push(param1 as IStateAware);
            if(this._state)
            {
               IStateAware(param1).handleStateChange(this._state.value);
            }
         }
      }
      
      public function parseAnimations(param1:XML, param2:Class, param3:Object) : void
      {
         var _loc4_:XML = null;
         var _loc5_:UberAnimationBase = null;
         if(param1)
         {
            this._debugId = param3.toString();
            for each(_loc4_ in param1.animation)
            {
               _loc5_ = new param2(String(_loc4_.@id) || this.nextAnimationId(),_loc4_,param3);
               this._animationsById[_loc5_.id] = _loc5_;
               if(_loc5_.autoPlay)
               {
                  if(this._idleAnimationId != null)
                  {
                     this.log("WARNING multiple animations defined as autoPlay:  " + [this._idleAnimationId,_loc5_.id]);
                  }
                  this._idleAnimationId = _loc5_.id;
               }
               this.addDisposable(_loc5_);
            }
            for each(_loc4_ in param1.background_animation)
            {
               _loc5_ = new param2("background_animation",_loc4_,param3);
               this.addUpdatable(_loc5_);
               this.addDisposable(_loc5_);
               _loc5_.play();
            }
            if(this._idleAnimationId)
            {
               this.playAnimation(this._idleAnimationId);
            }
         }
      }
      
      public function playAnimation(param1:String, param2:Function = null, param3:Boolean = false) : void
      {
         var _loc4_:Function = null;
         if(this._activeAnimation)
         {
            this._activeAnimation.completed.remove(this.handleActiveAnimationComplete);
            this._activeAnimation = null;
            if(this._callOnCompleteOnInterrupt && this._onAnimationComplete != null)
            {
               _loc4_ = this._onAnimationComplete;
               this._onAnimationComplete = null;
               this._callOnCompleteOnInterrupt = false;
               _loc4_();
            }
         }
         this._lastAnimationId = param1;
         if(this._lastAnimationId == null)
         {
            this.log("WARNING: animation null not found in " + this._debugId);
            if(param3 && param2 != null)
            {
               param2();
            }
            return;
         }
         if(this._animationsById[param1] == null)
         {
            this._lastAnimationId = null;
            if(param3 && param2 != null)
            {
               param2();
            }
            this.log("WARNING: animation \'" + param1 + "\' not found in " + this._debugId);
            return;
         }
         this._activeAnimation = this._animationsById[param1] as UberAnimationBase;
         this._onAnimationComplete = param2;
         this._callOnCompleteOnInterrupt = param3;
         this.log("playAnimation(" + param1 + ")");
         this._activeAnimation.completed.add(this.handleActiveAnimationComplete);
         this.addUpdatable(this._activeAnimation);
         this._activeAnimation.play();
      }
      
      public function stopCurrentAnimation() : void
      {
         this.playAnimation(this._idleAnimationId);
      }
      
      public function nextViewId(param1:String) : String
      {
         this._nextViewId[param1] = int(this._nextViewId[param1]) + 1;
         return param1 + "_" + this._nextViewId[param1];
      }
      
      protected function log(param1:String) : void
      {
      }
      
      private function nextAnimationId() : String
      {
         ++this._nextAnimationId;
         return "animation_" + this._nextAnimationId;
      }
      
      private function handleActiveAnimationComplete() : void
      {
         var _loc1_:Function = null;
         this.log(this._activeAnimation.id + " completed");
         if(this._onAnimationComplete != null)
         {
            _loc1_ = this._onAnimationComplete;
            this._onAnimationComplete = null;
            this._callOnCompleteOnInterrupt = false;
            _loc1_();
         }
         this.playAnimation(this._idleAnimationId);
      }
      
      private function handleStateChanged() : void
      {
         var _loc1_:* = int(this._stateAwares.length - 1);
         while(_loc1_ >= 0)
         {
            this._stateAwares[_loc1_].handleStateChange(this._state.value);
            _loc1_--;
         }
      }
      
      public function get state() : BindableString
      {
         return this._state;
      }
   }
}


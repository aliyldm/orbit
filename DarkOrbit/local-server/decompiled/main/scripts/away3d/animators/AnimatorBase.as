package away3d.animators
{
   import away3d.animators.nodes.AnimationNodeBase;
   import away3d.animators.states.AnimationStateBase;
   import away3d.animators.states.IAnimationState;
   import away3d.arcane;
   import away3d.entities.Mesh;
   import away3d.events.AnimatorEvent;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.library.assets.NamedAssetBase;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   use namespace arcane;
   
   public class AnimatorBase extends NamedAssetBase implements IAsset
   {
      
      private static var _frameTime:int;
      
      private static var _broadcaster:Sprite = createBroadcaster();
      
      private var _isPlaying:Boolean;
      
      private var _autoUpdate:Boolean = true;
      
      private var _startEvent:AnimatorEvent;
      
      private var _stopEvent:AnimatorEvent;
      
      private var _cycleEvent:AnimatorEvent;
      
      private var _time:int;
      
      private var _playbackSpeed:Number = 1;
      
      protected var _animationSet:IAnimationSet;
      
      protected var _owners:Vector.<Mesh> = new Vector.<Mesh>();
      
      protected var _activeNode:AnimationNodeBase;
      
      protected var _activeState:IAnimationState;
      
      protected var _activeAnimationName:String;
      
      private var _animationStates:Dictionary = new Dictionary(true);
      
      public var updatePosition:Boolean = true;
      
      private var _lastEnterFrameTimer:int;
      
      public function AnimatorBase(param1:IAnimationSet)
      {
         super();
         this._animationSet = param1;
      }
      
      private static function createBroadcaster() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.addEventListener(Event.ENTER_FRAME,updateFrameTime,false,int.MAX_VALUE);
         return _loc1_;
      }
      
      private static function updateFrameTime(param1:Event) : void
      {
         _frameTime = getTimer();
      }
      
      public function getAnimationState(param1:AnimationNodeBase) : AnimationStateBase
      {
         var _loc2_:Class = param1.stateClass;
         return this._animationStates[param1] = this._animationStates[param1] || new _loc2_(this,param1);
      }
      
      public function getAnimationStateByName(param1:String) : AnimationStateBase
      {
         return this.getAnimationState(this._animationSet.getAnimation(param1));
      }
      
      public function get animationSet() : IAnimationSet
      {
         return this._animationSet;
      }
      
      public function get activeState() : IAnimationState
      {
         return this._activeState;
      }
      
      public function get activeAnimation() : AnimationNodeBase
      {
         return this._animationSet.getAnimation(this._activeAnimationName);
      }
      
      public function get activeAnimationName() : String
      {
         return this._activeAnimationName;
      }
      
      public function get autoUpdate() : Boolean
      {
         return this._autoUpdate;
      }
      
      public function set autoUpdate(param1:Boolean) : void
      {
         if(this._autoUpdate == param1)
         {
            return;
         }
         this._autoUpdate = param1;
         if(this._autoUpdate)
         {
            this.start();
         }
         else
         {
            this.stop();
         }
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(param1:int) : void
      {
         if(this._time == param1)
         {
            return;
         }
         this._time = param1;
         if(this._activeState)
         {
            this._activeState.time = this._time;
            if(this.updatePosition)
            {
               this.applyPositionDelta();
            }
         }
      }
      
      public function get playbackSpeed() : Number
      {
         return this._playbackSpeed;
      }
      
      public function set playbackSpeed(param1:Number) : void
      {
         this._playbackSpeed = param1;
      }
      
      public function start() : void
      {
         if(this._isPlaying || !this._autoUpdate)
         {
            return;
         }
         this.startWithTime(getTimer());
      }
      
      protected function startWithTime(param1:int) : void
      {
         if(this._isPlaying || !this._autoUpdate)
         {
            return;
         }
         this._time = 0;
         this._isPlaying = true;
         this._lastEnterFrameTimer = param1;
         _broadcaster.addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
         if(!hasEventListener(AnimatorEvent.START))
         {
            return;
         }
         dispatchEvent(this._startEvent = this._startEvent || new AnimatorEvent(AnimatorEvent.START,this));
      }
      
      public function stop() : void
      {
         if(!this._isPlaying)
         {
            return;
         }
         this._isPlaying = false;
         _broadcaster.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(!hasEventListener(AnimatorEvent.STOP))
         {
            return;
         }
         dispatchEvent(this._stopEvent || (this._stopEvent = new AnimatorEvent(AnimatorEvent.STOP,this)));
      }
      
      public function reset(param1:String, param2:Number = 0) : void
      {
         this.time = 0;
         this.getAnimationState(this._animationSet.getAnimation(param1)).time = 0;
      }
      
      public function addOwner(param1:Mesh) : void
      {
         this._owners.push(param1);
      }
      
      public function removeOwner(param1:Mesh) : void
      {
         this._owners.splice(this._owners.indexOf(param1),1);
      }
      
      private function onEnterFrame(param1:Event = null) : void
      {
         var _loc2_:int = _frameTime - this._lastEnterFrameTimer;
         if(!this._isPlaying || !this._autoUpdate || _loc2_ <= 0)
         {
            return;
         }
         var _loc3_:int = this._time + _loc2_ * this._playbackSpeed;
         this._lastEnterFrameTimer = _frameTime;
         this.time = _loc3_;
      }
      
      private function applyPositionDelta() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc1_:Vector3D = this._activeState.positionDelta;
         var _loc2_:Number = _loc1_.length;
         if(_loc2_ > 0)
         {
            _loc3_ = this._owners.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this._owners[_loc4_].translateLocal(_loc1_,_loc2_);
               _loc4_++;
            }
         }
      }
      
      public function dispatchCycleEvent() : void
      {
         if(hasEventListener(AnimatorEvent.CYCLE_COMPLETE))
         {
            dispatchEvent(this._cycleEvent || (this._cycleEvent = new AnimatorEvent(AnimatorEvent.CYCLE_COMPLETE,this)));
         }
      }
      
      public function dispose() : void
      {
      }
      
      public function get assetType() : String
      {
         return AssetType.ANIMATOR;
      }
   }
}


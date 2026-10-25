package away3d.animators
{
   import away3d.animators.data.*;
   import away3d.animators.states.ISpriteSheetAnimationState;
   import away3d.animators.states.SpriteSheetAnimationState;
   import away3d.animators.transitions.IAnimationTransition;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.*;
   import away3d.core.managers.*;
   import away3d.materials.*;
   import away3d.materials.passes.*;
   import flash.display3D.Context3DProgramType;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   use namespace arcane;
   
   public class SpriteSheetAnimator extends AnimatorBase implements IAnimator
   {
      
      private var _activeSpriteSheetState:ISpriteSheetAnimationState;
      
      private var _spriteSheetAnimationSet:SpriteSheetAnimationSet;
      
      private var _frame:SpriteSheetAnimationFrame = new SpriteSheetAnimationFrame();
      
      private var _vectorFrame:Vector.<Number>;
      
      private var _fps:uint = 10;
      
      private var _ms:uint = 100;
      
      private var _lastTime:uint;
      
      private var _reverse:Boolean;
      
      private var _backAndForth:Boolean;
      
      private var _specsDirty:Boolean;
      
      private var _mapDirty:Boolean;
      
      public function SpriteSheetAnimator(param1:SpriteSheetAnimationSet)
      {
         super(param1);
         this._spriteSheetAnimationSet = param1;
         this._vectorFrame = new Vector.<Number>();
      }
      
      public function set fps(param1:uint) : void
      {
         this._ms = 1000 / param1;
         this._fps = param1;
      }
      
      public function get fps() : uint
      {
         return this._fps;
      }
      
      public function set reverse(param1:Boolean) : void
      {
         this._reverse = param1;
         this._specsDirty = true;
      }
      
      public function get reverse() : Boolean
      {
         return this._reverse;
      }
      
      public function set backAndForth(param1:Boolean) : void
      {
         this._backAndForth = param1;
         this._specsDirty = true;
      }
      
      public function get backAndForth() : Boolean
      {
         return this._backAndForth;
      }
      
      public function gotoAndPlay(param1:uint) : void
      {
         this.gotoFrame(param1,true);
      }
      
      public function gotoAndStop(param1:uint) : void
      {
         this.gotoFrame(param1,false);
      }
      
      public function get currentFrameNumber() : uint
      {
         return SpriteSheetAnimationState(_activeState).currentFrameNumber;
      }
      
      public function get totalFrames() : uint
      {
         return SpriteSheetAnimationState(_activeState).totalFrames;
      }
      
      public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:int, param4:int, param5:Camera3D) : void
      {
         var _loc8_:Boolean = false;
         var _loc6_:MaterialBase = param2.material;
         if(!_loc6_ || !_loc6_ is TextureMaterial)
         {
            return;
         }
         var _loc7_:SubMesh = param2 as SubMesh;
         if(!_loc7_)
         {
            return;
         }
         if(_loc6_ is SpriteSheetMaterial && this._mapDirty)
         {
            _loc8_ = SpriteSheetMaterial(_loc6_).swap(this._frame.mapID);
         }
         if(!_loc8_)
         {
            this._vectorFrame[0] = this._frame.offsetU;
            this._vectorFrame[1] = this._frame.offsetV;
            this._vectorFrame[2] = this._frame.scaleU;
            this._vectorFrame[3] = this._frame.scaleV;
         }
         param1._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,param3,this._vectorFrame);
      }
      
      public function play(param1:String, param2:IAnimationTransition = null, param3:Number = NaN) : void
      {
         param2 = param2;
         param3 = param3;
         if(_activeAnimationName == param1)
         {
            return;
         }
         _activeAnimationName = param1;
         if(!_animationSet.hasAnimation(param1))
         {
            throw new Error("Animation root node " + param1 + " not found!");
         }
         _activeNode = _animationSet.getAnimation(param1);
         _activeState = getAnimationState(_activeNode);
         this._frame = SpriteSheetAnimationState(_activeState).currentFrameData;
         this._activeSpriteSheetState = _activeState as ISpriteSheetAnimationState;
         start();
      }
      
      override public function set time(param1:int) : void
      {
         if(this._specsDirty)
         {
            SpriteSheetAnimationState(this._activeSpriteSheetState).reverse = this._reverse;
            SpriteSheetAnimationState(this._activeSpriteSheetState).backAndForth = this._backAndForth;
            this._specsDirty = false;
         }
         super.time = param1;
         var _loc2_:int = getTimer();
         if(_loc2_ - this._lastTime > this._ms)
         {
            this._mapDirty = true;
            this._activeSpriteSheetState.time = param1;
            this._frame = SpriteSheetAnimationState(this._activeSpriteSheetState).currentFrameData;
            this._lastTime = _loc2_;
         }
         else
         {
            this._mapDirty = false;
         }
      }
      
      public function testGPUCompatibility(param1:MaterialPassBase) : void
      {
      }
      
      public function clone() : IAnimator
      {
         return new SpriteSheetAnimator(this._spriteSheetAnimationSet);
      }
      
      private function gotoFrame(param1:uint, param2:Boolean) : void
      {
         if(!_activeState)
         {
            return;
         }
         SpriteSheetAnimationState(_activeState).currentFrameNumber = param1 == 0 ? param1 : uint(param1 - 1);
         var _loc3_:uint = this._frame.mapID;
         this._frame = SpriteSheetAnimationState(this._activeSpriteSheetState).currentFrameData;
         if(param2)
         {
            start();
         }
         else if(_loc3_ != this._frame.mapID)
         {
            this._mapDirty = true;
            setTimeout(stop,this._fps);
         }
         else
         {
            stop();
         }
      }
   }
}


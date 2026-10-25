package away3d.animators
{
   import away3d.animators.nodes.VertexClipNode;
   import away3d.animators.states.*;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.*;
   import away3d.core.managers.*;
   import away3d.materials.passes.*;
   import flash.display3D.*;
   
   use namespace arcane;
   
   public class VertexAnimator extends AnimatorBase implements IAnimator
   {
      
      private var _vertexAnimationSet:VertexAnimationSet;
      
      private var _weights:Vector.<Number> = Vector.<Number>([1,0,0,0]);
      
      private var _activeVertexState:VertexClipState;
      
      public function VertexAnimator(param1:VertexAnimationSet)
      {
         super(param1);
         this._vertexAnimationSet = param1;
      }
      
      public function clone() : IAnimator
      {
         return new VertexAnimator(this._vertexAnimationSet);
      }
      
      public function play(param1:String, param2:Number = NaN) : VertexClipNode
      {
         if(_activeAnimationName != param1)
         {
            _activeAnimationName = param1;
            if(!_animationSet.hasAnimation(param1))
            {
               throw new Error("Animation root node " + param1 + " not found!");
            }
            _activeNode = _animationSet.getAnimation(param1);
            _activeState = getAnimationState(_activeNode);
            if(updatePosition)
            {
               _activeState.time = time;
               _activeState.positionDelta;
            }
            this._activeVertexState = _activeState as VertexClipState;
         }
         start();
         if(!isNaN(param2))
         {
            reset(param1,param2);
         }
         return _activeNode as VertexClipNode;
      }
      
      public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:int, param4:int, param5:Camera3D) : void
      {
         if(this._activeVertexState == null || this._activeVertexState.currentGeometry == null || this._activeVertexState.nextGeometry == null)
         {
            this.setNullPose(param1,param2,param3,param4);
            return;
         }
         this._weights[uint(0)] = 1 - (this._weights[uint(1)] = this._activeVertexState.blendWeight);
         param1._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,param3,this._weights,1);
         var _loc6_:SubMesh = SubMesh(param2);
         var _loc7_:ISubGeometry = this._activeVertexState.currentGeometry.subGeometries[_loc6_._index];
         this._activeVertexState.currentGeometry.subGeometries[_loc6_._index].activateVertexBuffer(param4++,param1);
         this._activeVertexState.nextGeometry.subGeometries[_loc6_._index].activateVertexBuffer(param4++,param1);
      }
      
      private function setNullPose(param1:Stage3DProxy, param2:IRenderable, param3:int, param4:int) : void
      {
         param1._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,param3,this._weights,1);
         param2.activateVertexBuffer(param4++,param1);
         param2.activateVertexBuffer(param4++,param1);
      }
      
      public function testGPUCompatibility(param1:MaterialPassBase) : void
      {
      }
      
      override public function dispose() : void
      {
         stop();
         super.dispose();
      }
      
      public function disposeAsset() : void
      {
         var _loc2_:Vector.<VertexClipFrame> = null;
         var _loc3_:VertexClipFrame = null;
         this.dispose();
         var _loc1_:int = 0;
         while(_loc1_ < this._vertexAnimationSet.animations.length)
         {
            _loc2_ = VertexClipNode(this._vertexAnimationSet.animations[_loc1_]).frames;
            for each(_loc3_ in _loc2_)
            {
               _loc3_.geometry.dispose();
            }
            _loc1_++;
         }
      }
   }
}


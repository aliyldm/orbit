package away3d.animators
{
   import away3d.*;
   import away3d.animators.data.*;
   import away3d.animators.nodes.*;
   import away3d.animators.states.*;
   import away3d.cameras.*;
   import away3d.core.base.*;
   import away3d.core.managers.*;
   import away3d.materials.passes.*;
   import flash.display3D.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class ParticleAnimator extends AnimatorBase implements IAnimator
   {
      
      private var _particleAnimationSet:ParticleAnimationSet;
      
      private var _animationParticleStates:Vector.<ParticleStateBase> = new Vector.<ParticleStateBase>();
      
      private var _animatorParticleStates:Vector.<ParticleStateBase> = new Vector.<ParticleStateBase>();
      
      private var _timeParticleStates:Vector.<ParticleStateBase> = new Vector.<ParticleStateBase>();
      
      private var _totalLenOfOneVertex:uint = 0;
      
      private var _animatorSubGeometries:Dictionary = new Dictionary(true);
      
      public function ParticleAnimator(param1:ParticleAnimationSet)
      {
         var _loc2_:ParticleStateBase = null;
         var _loc3_:ParticleNodeBase = null;
         super(param1);
         this._particleAnimationSet = param1;
         for each(_loc3_ in this._particleAnimationSet.particleNodes)
         {
            _loc2_ = getAnimationState(_loc3_) as ParticleStateBase;
            if(_loc3_.mode == ParticlePropertiesMode.LOCAL_DYNAMIC)
            {
               this._animatorParticleStates.push(_loc2_);
               _loc3_.dataOffset = this._totalLenOfOneVertex;
               this._totalLenOfOneVertex += _loc3_.dataLength;
            }
            else
            {
               this._animationParticleStates.push(_loc2_);
            }
            if(_loc2_.needUpdateTime)
            {
               this._timeParticleStates.push(_loc2_);
            }
         }
      }
      
      public function clone() : IAnimator
      {
         return new ParticleAnimator(this._particleAnimationSet);
      }
      
      public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:int, param4:int, param5:Camera3D) : void
      {
         var _loc8_:ParticleStateBase = null;
         var _loc6_:AnimationRegisterCache = this._particleAnimationSet._animationRegisterCache;
         var _loc7_:SubMesh = param2 as SubMesh;
         if(!_loc7_)
         {
            throw new Error("Must be subMesh");
         }
         if(!_loc7_.animationSubGeometry)
         {
            this._particleAnimationSet.generateAnimationSubGeometries(_loc7_.parentMesh);
         }
         var _loc9_:AnimationSubGeometry = _loc7_.animationSubGeometry;
         for each(_loc8_ in this._animationParticleStates)
         {
            _loc8_.setRenderState(param1,param2,_loc9_,_loc6_,param5);
         }
         if(!_loc7_.animatorSubGeometry && Boolean(this._animatorParticleStates.length))
         {
            this.generateAnimatorSubGeometry(_loc7_);
         }
         var _loc10_:AnimationSubGeometry = _loc7_.animatorSubGeometry;
         for each(_loc8_ in this._animatorParticleStates)
         {
            _loc8_.setRenderState(param1,param2,_loc10_,_loc6_,param5);
         }
         param1.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,_loc6_.vertexConstantOffset,_loc6_.vertexConstantData,_loc6_.numVertexConstant);
         if(_loc6_.numFragmentConstant > 0)
         {
            param1.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,_loc6_.fragmentConstantOffset,_loc6_.fragmentConstantData,_loc6_.numFragmentConstant);
         }
      }
      
      public function testGPUCompatibility(param1:MaterialPassBase) : void
      {
      }
      
      override public function start() : void
      {
         var _loc1_:ParticleStateBase = null;
         super.start();
         for each(_loc1_ in this._timeParticleStates)
         {
            _loc1_.time = 0;
         }
      }
      
      override public function set time(param1:int) : void
      {
         var _loc2_:ParticleStateBase = null;
         super.time = param1;
         for each(_loc2_ in this._timeParticleStates)
         {
            _loc2_.time = param1;
         }
      }
      
      public function resetTime(param1:int = 0) : void
      {
         var _loc2_:ParticleStateBase = null;
         for each(_loc2_ in this._timeParticleStates)
         {
            _loc2_.time = 0;
         }
         this.time = time;
      }
      
      override public function dispose() : void
      {
         var _loc1_:AnimationSubGeometry = null;
         stop();
         for each(_loc1_ in this._animatorSubGeometries)
         {
            _loc1_.dispose();
         }
         this._animatorSubGeometries = new Dictionary(true);
      }
      
      private function generateAnimatorSubGeometry(param1:SubMesh) : void
      {
         var _loc2_:ISubGeometry = param1.subGeometry;
         var _loc3_:AnimationSubGeometry = param1.animatorSubGeometry = this._animatorSubGeometries[_loc2_] = new AnimationSubGeometry();
         _loc3_.createVertexData(_loc2_.numVertices,this._totalLenOfOneVertex);
         _loc3_.animationParticles = param1.animationSubGeometry.animationParticles;
      }
   }
}


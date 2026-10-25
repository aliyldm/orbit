package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticleAnimationData;
   import away3d.animators.nodes.ParticleFollowNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.base.Object3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.MathConsts;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleFollowState extends ParticleStateBase
   {
      
      private var _particleFollowNode:ParticleFollowNode;
      
      private var _followTarget:Object3D;
      
      private var _targetPos:Vector3D = new Vector3D();
      
      private var _targetEuler:Vector3D = new Vector3D();
      
      private var _prePos:Vector3D;
      
      private var _preEuler:Vector3D;
      
      private var _smooth:Boolean;
      
      private var temp:Vector3D = new Vector3D();
      
      private var _tmpVector:Vector3D = new Vector3D();
      
      private var _tmpVector2:Vector3D = new Vector3D();
      
      public function ParticleFollowState(param1:ParticleAnimator, param2:ParticleFollowNode)
      {
         super(param1,param2,true);
         this._particleFollowNode = param2;
         this._smooth = param2._smooth;
      }
      
      arcane static function copyTargetPosition(param1:Object3D, param2:Object3D, param3:Vector3D) : void
      {
         var _loc4_:Vector3D = param1.position;
         param3.x = _loc4_.x / param2.scaleX;
         param3.y = _loc4_.y / param2.scaleY;
         param3.z = _loc4_.z / param2.scaleZ;
      }
      
      public function get followTarget() : Object3D
      {
         return this._followTarget;
      }
      
      public function set followTarget(param1:Object3D) : void
      {
         this._followTarget = param1;
      }
      
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         this._smooth = param1;
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         param2 = param2;
         param5 = param5;
         if(this._followTarget)
         {
            if(this._particleFollowNode._usesPosition)
            {
               copyTargetPosition(this._followTarget,param2.sourceEntity,this._targetPos);
            }
            if(this._particleFollowNode._usesRotation)
            {
               this._targetEuler.x = this._followTarget.rotationX;
               this._targetEuler.y = this._followTarget.rotationY;
               this._targetEuler.z = this._followTarget.rotationZ;
               this._targetEuler.scaleBy(MathConsts.DEGREES_TO_RADIANS);
            }
         }
         if(!this._prePos)
         {
            this._prePos = this._targetPos.clone();
         }
         if(!this._preEuler)
         {
            this._preEuler = this._targetEuler.clone();
         }
         var _loc6_:Number = _time / 1000;
         var _loc7_:Number = param3.previousTime;
         var _loc8_:Number = _loc6_ - _loc7_;
         var _loc9_:Boolean = _loc7_ != _loc6_;
         if(this._particleFollowNode._usesPosition && this._particleFollowNode._usesRotation)
         {
            if(_loc9_)
            {
               this.processPositionAndRotation(_loc6_,_loc8_,param3);
            }
            param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleFollowNode.FOLLOW_POSITION_INDEX),this._particleFollowNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
            param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleFollowNode.FOLLOW_ROTATION_INDEX),this._particleFollowNode.dataOffset + 3,param1,Context3DVertexBufferFormat.FLOAT_3);
         }
         else if(this._particleFollowNode._usesPosition)
         {
            if(_loc9_)
            {
               this.processPosition(_loc6_,_loc8_,param3);
            }
            param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleFollowNode.FOLLOW_POSITION_INDEX),this._particleFollowNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
         }
         else if(this._particleFollowNode._usesRotation)
         {
            if(_loc9_)
            {
               this.precessRotation(_loc6_,_loc8_,param3);
            }
            param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleFollowNode.FOLLOW_ROTATION_INDEX),this._particleFollowNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
         }
         this._prePos.copyFrom(this._targetPos);
         this._preEuler.copyFrom(this._targetEuler);
         param3.previousTime = _loc6_;
      }
      
      private function processPosition(param1:Number, param2:Number, param3:AnimationSubGeometry) : void
      {
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:* = 0;
         var _loc14_:uint = 0;
         var _loc4_:Vector.<ParticleAnimationData> = param3.animationParticles;
         var _loc5_:Vector.<Number> = param3.vertexData;
         var _loc6_:Boolean = false;
         var _loc7_:uint = _loc4_.length;
         if(this._smooth)
         {
            _loc9_ = this._prePos.subtract(this._targetPos);
            _loc9_.scaleBy(1 / param2);
            _loc8_ = this._tmpVector;
         }
         else
         {
            _loc8_ = this._targetPos;
         }
         var _loc10_:uint = 0;
         while(_loc10_ < _loc7_)
         {
            _loc11_ = (param1 - _loc4_[_loc10_].startTime) / _loc4_[_loc10_].totalTime;
            _loc12_ = (_loc11_ - Math.floor(_loc11_)) * _loc4_[_loc10_].totalTime;
            if(_loc12_ - param2 <= 0)
            {
               _loc13_ = int(_loc4_[_loc10_].startVertexIndex * param3.totalLenOfOneVertex + this._particleFollowNode.dataOffset);
               if(this._smooth)
               {
                  this.temp.copyFrom(_loc9_);
                  this.temp.scaleBy(_loc12_);
                  _loc8_.x = this._targetPos.x + this.temp.x;
                  _loc8_.y = this._targetPos.y + this.temp.y;
                  _loc8_.z = this._targetPos.z + this.temp.z;
               }
               if(_loc5_[_loc13_] != _loc8_.x || _loc5_[_loc13_ + 1] != _loc8_.y || _loc5_[_loc13_ + 2] != _loc8_.z)
               {
                  _loc6_ = true;
                  _loc14_ = 0;
                  while(_loc14_ < _loc4_[_loc10_].numVertices)
                  {
                     var _loc15_:Number;
                     _loc5_[_loc15_ = _loc13_++] = _loc8_.x;
                     var _loc16_:Number;
                     _loc5_[_loc16_ = _loc13_++] = _loc8_.y;
                     var _loc17_:Number;
                     _loc5_[_loc17_ = _loc13_++] = _loc8_.z;
                     _loc14_++;
                  }
               }
            }
            _loc10_++;
         }
         if(_loc6_)
         {
            param3.invalidateBuffer();
         }
      }
      
      private function precessRotation(param1:Number, param2:Number, param3:AnimationSubGeometry) : void
      {
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:* = 0;
         var _loc14_:uint = 0;
         var _loc4_:Vector.<ParticleAnimationData> = param3.animationParticles;
         var _loc5_:Vector.<Number> = param3.vertexData;
         var _loc6_:Boolean = false;
         var _loc7_:uint = _loc4_.length;
         if(this._smooth)
         {
            _loc9_ = this._preEuler.subtract(this._targetEuler);
            _loc9_.scaleBy(1 / param2);
            _loc8_ = this._tmpVector;
         }
         else
         {
            _loc8_ = this._targetEuler;
         }
         var _loc10_:uint = 0;
         while(_loc10_ < _loc7_)
         {
            _loc11_ = (param1 - _loc4_[_loc10_].startTime) / _loc4_[_loc10_].totalTime;
            _loc12_ = (_loc11_ - Math.floor(_loc11_)) * _loc4_[_loc10_].totalTime;
            if(_loc12_ - param2 <= 0)
            {
               _loc13_ = int(_loc4_[_loc10_].startVertexIndex * param3.totalLenOfOneVertex + this._particleFollowNode.dataOffset);
               if(this._smooth)
               {
                  this.temp.copyFrom(_loc9_);
                  this.temp.scaleBy(_loc12_);
                  _loc8_.x = this._targetEuler.x + this.temp.x;
                  _loc8_.y = this._targetEuler.y + this.temp.y;
                  _loc8_.z = this._targetEuler.z + this.temp.z;
               }
               if(_loc5_[_loc13_] != _loc8_.x || _loc5_[_loc13_ + 1] != _loc8_.y || _loc5_[_loc13_ + 2] != _loc8_.z)
               {
                  _loc6_ = true;
                  _loc14_ = 0;
                  while(_loc14_ < _loc4_[_loc10_].numVertices)
                  {
                     var _loc15_:Number;
                     _loc5_[_loc15_ = _loc13_++] = _loc8_.x;
                     var _loc16_:Number;
                     _loc5_[_loc16_ = _loc13_++] = _loc8_.y;
                     var _loc17_:Number;
                     _loc5_[_loc17_ = _loc13_++] = _loc8_.z;
                     _loc14_++;
                  }
               }
            }
            _loc10_++;
         }
         if(_loc6_)
         {
            param3.invalidateBuffer();
         }
      }
      
      private function processPositionAndRotation(param1:Number, param2:Number, param3:AnimationSubGeometry) : void
      {
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         var _loc10_:Vector3D = null;
         var _loc11_:Vector3D = null;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:* = 0;
         var _loc16_:uint = 0;
         var _loc4_:Vector.<ParticleAnimationData> = param3.animationParticles;
         var _loc5_:Vector.<Number> = param3.vertexData;
         var _loc6_:Boolean = false;
         var _loc7_:uint = _loc4_.length;
         if(this._smooth)
         {
            _loc10_ = this._prePos.subtract(this._targetPos);
            _loc10_.scaleBy(1 / param2);
            _loc11_ = this._preEuler.subtract(this._targetEuler);
            _loc11_.scaleBy(1 / param2);
            _loc8_ = this._tmpVector;
            _loc9_ = this._tmpVector2;
         }
         else
         {
            _loc8_ = this._targetPos;
            _loc9_ = this._targetEuler;
         }
         var _loc12_:uint = 0;
         while(_loc12_ < _loc7_)
         {
            _loc13_ = (param1 - _loc4_[_loc12_].startTime) / _loc4_[_loc12_].totalTime;
            _loc14_ = (_loc13_ - Math.floor(_loc13_)) * _loc4_[_loc12_].totalTime;
            if(_loc14_ - param2 <= 0)
            {
               _loc15_ = int(_loc4_[_loc12_].startVertexIndex * param3.totalLenOfOneVertex + this._particleFollowNode.dataOffset);
               if(this._smooth)
               {
                  this.temp.copyFrom(_loc10_);
                  this.temp.scaleBy(_loc14_);
                  _loc8_.x = this._targetPos.x + this.temp.x;
                  _loc8_.y = this._targetPos.y + this.temp.y;
                  _loc8_.z = this._targetPos.z + this.temp.z;
                  this.temp.copyFrom(_loc11_);
                  this.temp.scaleBy(_loc14_);
                  _loc9_.x = this._targetEuler.x + this.temp.x;
                  _loc9_.y = this._targetEuler.y + this.temp.y;
                  _loc9_.z = this._targetEuler.z + this.temp.z;
               }
               if(_loc5_[_loc15_] != _loc8_.x || _loc5_[_loc15_ + 1] != _loc8_.y || _loc5_[_loc15_ + 2] != _loc8_.z || _loc5_[_loc15_ + 3] != _loc9_.x || _loc5_[_loc15_ + 4] != _loc9_.y || _loc5_[_loc15_ + 5] != _loc9_.z)
               {
                  _loc6_ = true;
                  _loc16_ = 0;
                  while(_loc16_ < _loc4_[_loc12_].numVertices)
                  {
                     var _loc17_:Number;
                     _loc5_[_loc17_ = _loc15_++] = _loc8_.x;
                     var _loc18_:Number;
                     _loc5_[_loc18_ = _loc15_++] = _loc8_.y;
                     var _loc19_:Number;
                     _loc5_[_loc19_ = _loc15_++] = _loc8_.z;
                     var _loc20_:Number;
                     _loc5_[_loc20_ = _loc15_++] = _loc9_.x;
                     var _loc21_:Number;
                     _loc5_[_loc21_ = _loc15_++] = _loc9_.y;
                     var _loc22_:Number;
                     _loc5_[_loc22_ = _loc15_++] = _loc9_.z;
                     _loc16_++;
                  }
               }
            }
            _loc12_++;
         }
         if(_loc6_)
         {
            param3.invalidateBuffer();
         }
      }
   }
}


package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticleAnimationData;
   import away3d.animators.nodes.ParticleNodeBase;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class ParticleStateBase extends AnimationStateBase
   {
      
      private var _particleNode:ParticleNodeBase;
      
      protected var _dynamicProperties:Vector.<Vector3D> = new Vector.<Vector3D>();
      
      protected var _dynamicPropertiesDirty:Dictionary = new Dictionary(true);
      
      protected var _needUpdateTime:Boolean;
      
      public function ParticleStateBase(param1:ParticleAnimator, param2:ParticleNodeBase, param3:Boolean = false)
      {
         super(param1,param2);
         this._particleNode = param2;
         this._needUpdateTime = param3;
      }
      
      public function get needUpdateTime() : Boolean
      {
         return this._needUpdateTime;
      }
      
      public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
      }
      
      protected function updateDynamicProperties(param1:AnimationSubGeometry) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Vector3D = null;
         var _loc11_:ParticleAnimationData = null;
         this._dynamicPropertiesDirty[param1] = true;
         var _loc2_:Vector.<ParticleAnimationData> = param1.animationParticles;
         var _loc3_:Vector.<Number> = param1.vertexData;
         var _loc4_:uint = param1.totalLenOfOneVertex;
         var _loc5_:uint = uint(this._particleNode.dataLength);
         var _loc6_:uint = this._particleNode.dataOffset;
         var _loc12_:uint = this._dynamicProperties.length;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         while(_loc13_ < _loc12_)
         {
            while(true)
            {
               _loc11_ = _loc2_[_loc14_];
               if(!(_loc14_ < _loc12_ && _loc11_.index == _loc13_))
               {
                  break;
               }
               _loc10_ = this._dynamicProperties[_loc13_];
               _loc7_ = _loc11_.numVertices * _loc4_;
               _loc8_ = _loc11_.startVertexIndex * _loc4_ + _loc6_;
               _loc15_ = 0;
               while(_loc15_ < _loc7_)
               {
                  _loc9_ = _loc8_ + _loc15_;
                  _loc15_ = 0;
                  while(_loc15_ < _loc7_)
                  {
                     _loc9_ = _loc8_ + _loc15_;
                     var _loc16_:uint;
                     _loc3_[_loc16_ = _loc9_++] = _loc10_.x;
                     var _loc17_:uint;
                     _loc3_[_loc17_ = _loc9_++] = _loc10_.y;
                     var _loc18_:uint;
                     _loc3_[_loc18_ = _loc9_++] = _loc10_.z;
                     if(_loc5_ == 4)
                     {
                        var _loc19_:uint;
                        _loc3_[_loc19_ = _loc9_++] = _loc10_.w;
                     }
                     _loc15_ += _loc4_;
                  }
                  _loc15_ += _loc4_;
               }
               _loc14_++;
            }
            _loc13_++;
         }
         param1.invalidateBuffer();
      }
   }
}


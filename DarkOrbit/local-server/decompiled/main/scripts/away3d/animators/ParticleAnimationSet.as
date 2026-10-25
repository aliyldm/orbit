package away3d.animators
{
   import away3d.*;
   import away3d.animators.data.*;
   import away3d.animators.nodes.*;
   import away3d.core.base.*;
   import away3d.core.base.data.*;
   import away3d.core.managers.*;
   import away3d.entities.*;
   import away3d.materials.passes.*;
   import flash.display3D.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class ParticleAnimationSet extends AnimationSetBase implements IAnimationSet
   {
      
      public static const POST_PRIORITY:int = 9;
      
      public static const COLOR_PRIORITY:int = 18;
      
      arcane var _animationRegisterCache:AnimationRegisterCache;
      
      private var _timeNode:ParticleTimeNode;
      
      private var _animationSubGeometries:Dictionary = new Dictionary(true);
      
      private var _particleNodes:Vector.<ParticleNodeBase> = new Vector.<ParticleNodeBase>();
      
      private var _localDynamicNodes:Vector.<ParticleNodeBase> = new Vector.<ParticleNodeBase>();
      
      private var _localStaticNodes:Vector.<ParticleNodeBase> = new Vector.<ParticleNodeBase>();
      
      private var _totalLenOfOneVertex:int = 0;
      
      public var hasUVNode:Boolean;
      
      public var needVelocity:Boolean;
      
      public var hasBillboard:Boolean;
      
      public var hasColorMulNode:Boolean;
      
      public var hasColorAddNode:Boolean;
      
      public var initParticleFunc:Function;
      
      public function ParticleAnimationSet(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.addAnimation(this._timeNode = new ParticleTimeNode(param1,param2,param3));
      }
      
      public function get particleNodes() : Vector.<ParticleNodeBase>
      {
         return this._particleNodes;
      }
      
      override public function addAnimation(param1:AnimationNodeBase) : void
      {
         var _loc2_:* = 0;
         var _loc3_:ParticleNodeBase = param1 as ParticleNodeBase;
         _loc3_.processAnimationSetting(this);
         if(_loc3_.mode == ParticlePropertiesMode.LOCAL_STATIC)
         {
            _loc3_.dataOffset = this._totalLenOfOneVertex;
            this._totalLenOfOneVertex += _loc3_.dataLength;
            this._localStaticNodes.push(_loc3_);
         }
         else if(_loc3_.mode == ParticlePropertiesMode.LOCAL_DYNAMIC)
         {
            this._localDynamicNodes.push(_loc3_);
         }
         _loc2_ = int(this._particleNodes.length - 1);
         while(_loc2_ >= 0)
         {
            if(this._particleNodes[_loc2_].priority <= _loc3_.priority)
            {
               break;
            }
            _loc2_--;
         }
         this._particleNodes.splice(_loc2_ + 1,0,_loc3_);
         super.addAnimation(param1);
      }
      
      public function activate(param1:Stage3DProxy, param2:MaterialPassBase) : void
      {
         this._animationRegisterCache = param2.animationRegisterCache;
      }
      
      public function deactivate(param1:Stage3DProxy, param2:MaterialPassBase) : void
      {
         var _loc3_:Context3D = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this._animationRegisterCache)
         {
            _loc3_ = param1.context3D;
            _loc4_ = int(this._animationRegisterCache.vertexAttributesOffset);
            _loc5_ = int(this._animationRegisterCache.numUsedStreams);
            _loc6_ = _loc4_;
            while(_loc6_ < _loc5_)
            {
               _loc3_.setVertexBufferAt(_loc6_,null);
               _loc6_++;
            }
         }
      }
      
      public function getAGALVertexCode(param1:MaterialPassBase, param2:Vector.<String>, param3:Vector.<String>, param4:String) : String
      {
         var _loc6_:ParticleNodeBase = null;
         this._animationRegisterCache = param1.animationRegisterCache = param1.animationRegisterCache || new AnimationRegisterCache(param4);
         this._animationRegisterCache.vertexConstantOffset = param1.numUsedVertexConstants;
         this._animationRegisterCache.vertexAttributesOffset = param1.numUsedStreams;
         this._animationRegisterCache.varyingsOffset = param1.numUsedVaryings;
         this._animationRegisterCache.fragmentConstantOffset = param1.numUsedFragmentConstants;
         this._animationRegisterCache.hasUVNode = this.hasUVNode;
         this._animationRegisterCache.needVelocity = this.needVelocity;
         this._animationRegisterCache.hasBillboard = this.hasBillboard;
         this._animationRegisterCache.sourceRegisters = param2;
         this._animationRegisterCache.targetRegisters = param3;
         this._animationRegisterCache.needFragmentAnimation = param1.needFragmentAnimation;
         this._animationRegisterCache.needUVAnimation = param1.needUVAnimation;
         this._animationRegisterCache.hasColorAddNode = this.hasColorAddNode;
         this._animationRegisterCache.hasColorMulNode = this.hasColorMulNode;
         this._animationRegisterCache.reset();
         var _loc5_:String = "";
         _loc5_ = _loc5_ + this._animationRegisterCache.getInitCode();
         for each(_loc6_ in this._particleNodes)
         {
            if(_loc6_.priority < POST_PRIORITY)
            {
               _loc5_ += _loc6_.getAGALVertexCode(param1,this._animationRegisterCache);
            }
         }
         _loc5_ += this._animationRegisterCache.getCombinationCode();
         for each(_loc6_ in this._particleNodes)
         {
            if(_loc6_.priority >= POST_PRIORITY && _loc6_.priority < COLOR_PRIORITY)
            {
               _loc5_ += _loc6_.getAGALVertexCode(param1,this._animationRegisterCache);
            }
         }
         _loc5_ += this._animationRegisterCache.initColorRegisters();
         for each(_loc6_ in this._particleNodes)
         {
            if(_loc6_.priority >= COLOR_PRIORITY)
            {
               _loc5_ += _loc6_.getAGALVertexCode(param1,this._animationRegisterCache);
            }
         }
         return _loc5_ + this._animationRegisterCache.getColorPassCode();
      }
      
      public function getAGALUVCode(param1:MaterialPassBase, param2:String, param3:String) : String
      {
         var _loc5_:ParticleNodeBase = null;
         var _loc4_:String = "";
         if(this.hasUVNode)
         {
            this._animationRegisterCache.setUVSourceAndTarget(param2,param3);
            _loc4_ += "mov " + this._animationRegisterCache.uvTarget + ".xy," + this._animationRegisterCache.uvAttribute.toString() + "\n";
            for each(_loc5_ in this._particleNodes)
            {
               _loc4_ += _loc5_.getAGALUVCode(param1,this._animationRegisterCache);
            }
            _loc4_ += "mov " + this._animationRegisterCache.uvVar.toString() + "," + this._animationRegisterCache.uvTarget + ".xy\n";
         }
         else
         {
            _loc4_ += "mov " + param3 + "," + param2 + "\n";
         }
         return _loc4_;
      }
      
      public function getAGALFragmentCode(param1:MaterialPassBase, param2:String, param3:String) : String
      {
         return this._animationRegisterCache.getColorCombinationCode(param2);
      }
      
      public function doneAGALCode(param1:MaterialPassBase) : void
      {
         this._animationRegisterCache.setDataLength();
         this._animationRegisterCache.setVertexConst(this._animationRegisterCache.vertexZeroConst.index,0,1,2,0);
      }
      
      override public function get usesCPU() : Boolean
      {
         return false;
      }
      
      override public function cancelGPUCompatibility() : void
      {
      }
      
      override public function dispose() : void
      {
         var _loc1_:AnimationSubGeometry = null;
         for each(_loc1_ in this._animationSubGeometries)
         {
            _loc1_.dispose();
         }
         super.dispose();
      }
      
      arcane function generateAnimationSubGeometries(param1:Mesh) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:AnimationSubGeometry = null;
         var _loc6_:Boolean = false;
         var _loc7_:ISubGeometry = null;
         var _loc8_:SubMesh = null;
         var _loc9_:ParticleNodeBase = null;
         var _loc14_:ParticleData = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Vector.<Number> = null;
         var _loc20_:uint = 0;
         var _loc21_:Vector.<Number> = null;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         if(this.initParticleFunc == null)
         {
            throw new Error("no initParticleFunc set");
         }
         var _loc2_:ParticleGeometry = param1.geometry as ParticleGeometry;
         if(!_loc2_)
         {
            throw new Error("Particle animation can only be performed on a ParticleGeometry object");
         }
         _loc3_ = 0;
         for(; _loc3_ < param1.subMeshes.length; _loc3_++)
         {
            _loc8_ = param1.subMeshes[_loc3_];
            _loc7_ = _loc8_.subGeometry;
            if(param1.shareAnimationGeometry)
            {
               _loc5_ = this._animationSubGeometries[_loc7_];
               if(_loc5_)
               {
                  _loc8_.animationSubGeometry = _loc5_;
                  continue;
               }
            }
            _loc5_ = _loc8_.animationSubGeometry = new AnimationSubGeometry();
            if(param1.shareAnimationGeometry)
            {
               this._animationSubGeometries[_loc7_] = _loc5_;
            }
            _loc6_ = true;
            _loc5_.createVertexData(_loc7_.numVertices,this._totalLenOfOneVertex);
         }
         if(!_loc6_)
         {
            return;
         }
         var _loc10_:Vector.<ParticleData> = _loc2_.particles;
         var _loc11_:uint = _loc10_.length;
         var _loc12_:uint = _loc2_.numParticles;
         var _loc13_:ParticleProperties = new ParticleProperties();
         _loc13_.total = _loc12_;
         _loc13_.startTime = 0;
         _loc13_.duration = 1000;
         _loc13_.delay = 0.1;
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc3_ < _loc12_)
         {
            _loc13_.index = _loc3_;
            this.initParticleFunc(_loc13_);
            for each(_loc9_ in this._localStaticNodes)
            {
               _loc9_.generatePropertyOfOneParticle(_loc13_);
            }
            while(true)
            {
               _loc14_ = _loc10_[_loc4_];
               if(!(_loc4_ < _loc11_ && _loc14_.particleIndex == _loc3_))
               {
                  break;
               }
               for each(_loc8_ in param1.subMeshes)
               {
                  if(_loc8_.subGeometry == _loc14_.subGeometry)
                  {
                     _loc5_ = _loc8_.animationSubGeometry;
                     break;
                  }
               }
               _loc20_ = _loc14_.numVertices;
               _loc21_ = _loc5_.vertexData;
               _loc22_ = _loc20_ * this._totalLenOfOneVertex;
               _loc23_ = _loc5_.numProcessedVertices * this._totalLenOfOneVertex;
               for each(_loc9_ in this._localStaticNodes)
               {
                  _loc19_ = _loc9_.oneData;
                  _loc15_ = _loc9_.dataLength;
                  _loc16_ = _loc23_ + _loc9_.dataOffset;
                  _loc17_ = 0;
                  while(_loc17_ < _loc22_)
                  {
                     _loc24_ = _loc16_ + _loc17_;
                     _loc18_ = 0;
                     while(_loc18_ < _loc15_)
                     {
                        _loc21_[_loc24_ + _loc18_] = _loc19_[_loc18_];
                        _loc18_++;
                     }
                     _loc17_ += this._totalLenOfOneVertex;
                  }
               }
               if(this._localDynamicNodes.length)
               {
                  _loc5_.animationParticles.push(new ParticleAnimationData(_loc3_,_loc13_.startTime,_loc13_.duration,_loc13_.delay,_loc14_));
               }
               _loc5_.numProcessedVertices += _loc20_;
               _loc4_++;
            }
            _loc3_++;
         }
      }
   }
}


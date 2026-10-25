package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleColorNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.ColorTransform;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleColorState extends ParticleStateBase
   {
      
      private var _particleColorNode:ParticleColorNode;
      
      private var _usesMultiplier:Boolean;
      
      private var _usesOffset:Boolean;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      private var _startColor:ColorTransform;
      
      private var _endColor:ColorTransform;
      
      private var _cycleDuration:Number;
      
      private var _cyclePhase:Number;
      
      private var _cycleData:Vector3D;
      
      private var _startMultiplierData:Vector3D;
      
      private var _deltaMultiplierData:Vector3D;
      
      private var _startOffsetData:Vector3D;
      
      private var _deltaOffsetData:Vector3D;
      
      public function ParticleColorState(param1:ParticleAnimator, param2:ParticleColorNode)
      {
         super(param1,param2);
         this._particleColorNode = param2;
         this._usesMultiplier = this._particleColorNode._usesMultiplier;
         this._usesOffset = this._particleColorNode._usesOffset;
         this._usesCycle = this._particleColorNode._usesCycle;
         this._usesPhase = this._particleColorNode._usesPhase;
         this._startColor = this._particleColorNode._startColor;
         this._endColor = this._particleColorNode._endColor;
         this._cycleDuration = this._particleColorNode._cycleDuration;
         this._cyclePhase = this._particleColorNode._cyclePhase;
         this.updateColorData();
      }
      
      public function get startColor() : ColorTransform
      {
         return this._startColor;
      }
      
      public function set startColor(param1:ColorTransform) : void
      {
         this._startColor = param1;
         this.updateColorData();
      }
      
      public function get endColor() : ColorTransform
      {
         return this._endColor;
      }
      
      public function set endColor(param1:ColorTransform) : void
      {
         this._endColor = param1;
         this.updateColorData();
      }
      
      public function get cycleDuration() : Number
      {
         return this._cycleDuration;
      }
      
      public function set cycleDuration(param1:Number) : void
      {
         this._cycleDuration = param1;
         this.updateColorData();
      }
      
      public function get cyclePhase() : Number
      {
         return this._cyclePhase;
      }
      
      public function set cyclePhase(param1:Number) : void
      {
         this._cyclePhase = param1;
         this.updateColorData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:uint = 0;
         param2 = param2;
         param5 = param5;
         if(param4.needFragmentAnimation)
         {
            _loc6_ = this._particleColorNode.dataOffset;
            if(this._usesCycle)
            {
               param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleColorNode.CYCLE_INDEX),this._cycleData.x,this._cycleData.y,this._cycleData.z,this._cycleData.w);
            }
            if(this._usesMultiplier)
            {
               if(this._particleColorNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
               {
                  param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleColorNode.START_MULTIPLIER_INDEX),_loc6_,param1,Context3DVertexBufferFormat.FLOAT_4);
                  _loc6_ += 4;
                  param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleColorNode.DELTA_MULTIPLIER_INDEX),_loc6_,param1,Context3DVertexBufferFormat.FLOAT_4);
                  _loc6_ += 4;
               }
               else
               {
                  param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleColorNode.START_MULTIPLIER_INDEX),this._startMultiplierData.x,this._startMultiplierData.y,this._startMultiplierData.z,this._startMultiplierData.w);
                  param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleColorNode.DELTA_MULTIPLIER_INDEX),this._deltaMultiplierData.x,this._deltaMultiplierData.y,this._deltaMultiplierData.z,this._deltaMultiplierData.w);
               }
            }
            if(this._usesOffset)
            {
               if(this._particleColorNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
               {
                  param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleColorNode.START_OFFSET_INDEX),_loc6_,param1,Context3DVertexBufferFormat.FLOAT_4);
                  _loc6_ += 4;
                  param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleColorNode.DELTA_OFFSET_INDEX),_loc6_,param1,Context3DVertexBufferFormat.FLOAT_4);
                  _loc6_ += 4;
               }
               else
               {
                  param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleColorNode.START_OFFSET_INDEX),this._startOffsetData.x,this._startOffsetData.y,this._startOffsetData.z,this._startOffsetData.w);
                  param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleColorNode.DELTA_OFFSET_INDEX),this._deltaOffsetData.x,this._deltaOffsetData.y,this._deltaOffsetData.z,this._deltaOffsetData.w);
               }
            }
         }
      }
      
      private function updateColorData() : void
      {
         if(this._usesCycle)
         {
            if(this._cycleDuration <= 0)
            {
               throw new Error("the cycle duration must be greater than zero");
            }
            this._cycleData = new Vector3D(Math.PI * 2 / this._cycleDuration,this._cyclePhase * Math.PI / 180,0,0);
         }
         if(this._particleColorNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            if(this._usesCycle)
            {
               if(this._usesMultiplier)
               {
                  this._startMultiplierData = new Vector3D((this._startColor.redMultiplier + this._endColor.redMultiplier) / 2,(this._startColor.greenMultiplier + this._endColor.greenMultiplier) / 2,(this._startColor.blueMultiplier + this._endColor.blueMultiplier) / 2,(this._startColor.alphaMultiplier + this._endColor.alphaMultiplier) / 2);
                  this._deltaMultiplierData = new Vector3D((this._endColor.redMultiplier - this._startColor.redMultiplier) / 2,(this._endColor.greenMultiplier - this._startColor.greenMultiplier) / 2,(this._endColor.blueMultiplier - this._startColor.blueMultiplier) / 2,(this._endColor.alphaMultiplier - this._startColor.alphaMultiplier) / 2);
               }
               if(this._usesOffset)
               {
                  this._startOffsetData = new Vector3D((this._startColor.redOffset + this._endColor.redOffset) / (255 * 2),(this._startColor.greenOffset + this._endColor.greenOffset) / (255 * 2),(this._startColor.blueOffset + this._endColor.blueOffset) / (255 * 2),(this._startColor.alphaOffset + this._endColor.alphaOffset) / (255 * 2));
                  this._deltaOffsetData = new Vector3D((this._endColor.redOffset - this._startColor.redOffset) / (255 * 2),(this._endColor.greenOffset - this._startColor.greenOffset) / (255 * 2),(this._endColor.blueOffset - this._startColor.blueOffset) / (255 * 2),(this._endColor.alphaOffset - this._startColor.alphaOffset) / (255 * 2));
               }
            }
            else
            {
               if(this._usesMultiplier)
               {
                  this._startMultiplierData = new Vector3D(this._startColor.redMultiplier,this._startColor.greenMultiplier,this._startColor.blueMultiplier,this._startColor.alphaMultiplier);
                  this._deltaMultiplierData = new Vector3D(this._endColor.redMultiplier - this._startColor.redMultiplier,this._endColor.greenMultiplier - this._startColor.greenMultiplier,this._endColor.blueMultiplier - this._startColor.blueMultiplier,this._endColor.alphaMultiplier - this._startColor.alphaMultiplier);
               }
               if(this._usesOffset)
               {
                  this._startOffsetData = new Vector3D(this._startColor.redOffset / 255,this._startColor.greenOffset / 255,this._startColor.blueOffset / 255,this._startColor.alphaOffset / 255);
                  this._deltaOffsetData = new Vector3D((this._endColor.redOffset - this._startColor.redOffset) / 255,(this._endColor.greenOffset - this._startColor.greenOffset) / 255,(this._endColor.blueOffset - this._startColor.blueOffset) / 255,(this._endColor.alphaOffset - this._startColor.alphaOffset) / 255);
               }
            }
         }
      }
   }
}


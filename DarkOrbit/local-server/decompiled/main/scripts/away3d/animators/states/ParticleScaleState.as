package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleScaleNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleScaleState extends ParticleStateBase
   {
      
      private var _particleScaleNode:ParticleScaleNode;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      private var _minScale:Number;
      
      private var _maxScale:Number;
      
      private var _cycleDuration:Number;
      
      private var _cyclePhase:Number;
      
      private var _scaleData:Vector3D;
      
      public function ParticleScaleState(param1:ParticleAnimator, param2:ParticleScaleNode)
      {
         super(param1,param2);
         this._particleScaleNode = param2;
         this._usesCycle = this._particleScaleNode._usesCycle;
         this._usesPhase = this._particleScaleNode._usesPhase;
         this._minScale = this._particleScaleNode._minScale;
         this._maxScale = this._particleScaleNode._maxScale;
         this._cycleDuration = this._particleScaleNode._cycleDuration;
         this._cyclePhase = this._particleScaleNode._cyclePhase;
         this.updateScaleData();
      }
      
      public function get minScale() : Number
      {
         return this._minScale;
      }
      
      public function set minScale(param1:Number) : void
      {
         this._minScale = param1;
         this.updateScaleData();
      }
      
      public function get maxScale() : Number
      {
         return this._maxScale;
      }
      
      public function set maxScale(param1:Number) : void
      {
         this._maxScale = param1;
         this.updateScaleData();
      }
      
      public function get cycleDuration() : Number
      {
         return this._cycleDuration;
      }
      
      public function set cycleDuration(param1:Number) : void
      {
         this._cycleDuration = param1;
         this.updateScaleData();
      }
      
      public function get cyclePhase() : Number
      {
         return this._cyclePhase;
      }
      
      public function set cyclePhase(param1:Number) : void
      {
         this._cyclePhase = param1;
         this.updateScaleData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticleScaleNode.SCALE_INDEX);
         if(this._particleScaleNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
         {
            if(this._usesCycle)
            {
               if(this._usesPhase)
               {
                  param3.activateVertexBuffer(_loc6_,this._particleScaleNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_4);
               }
               else
               {
                  param3.activateVertexBuffer(_loc6_,this._particleScaleNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
               }
            }
            else
            {
               param3.activateVertexBuffer(_loc6_,this._particleScaleNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_2);
            }
         }
         else
         {
            param4.setVertexConst(_loc6_,this._scaleData.x,this._scaleData.y,this._scaleData.z,this._scaleData.w);
         }
      }
      
      private function updateScaleData() : void
      {
         if(this._particleScaleNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            if(this._usesCycle)
            {
               if(this._cycleDuration <= 0)
               {
                  throw new Error("the cycle duration must be greater than zero");
               }
               this._scaleData = new Vector3D((this._minScale + this._maxScale) / 2,Math.abs(this._minScale - this._maxScale) / 2,Math.PI * 2 / this._cycleDuration,this._cyclePhase * Math.PI / 180);
            }
            else
            {
               this._scaleData = new Vector3D(this._minScale,this._maxScale - this._minScale,0,0);
            }
         }
      }
   }
}


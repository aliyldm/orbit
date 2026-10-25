package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleUVNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   
   use namespace arcane;
   
   public class ParticleUVState extends ParticleStateBase
   {
      
      private var _particleUVNode:ParticleUVNode;
      
      private var _cycle:Number;
      
      private var _scale:Number;
      
      public function ParticleUVState(param1:ParticleAnimator, param2:ParticleUVNode)
      {
         super(param1,param2);
         this._particleUVNode = param2;
         this._cycle = param2._cycle;
         this._scale = param2._scale;
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:int = 0;
         if(param4.needUVAnimation)
         {
            _loc6_ = param4.getRegisterIndex(_animationNode,ParticleUVNode.UV_INDEX);
            if(this._particleUVNode.mode == ParticlePropertiesMode.GLOBAL)
            {
               switch(this._particleUVNode._formula)
               {
                  case ParticleUVNode.SINE_EASE:
                     param4.setVertexConst(_loc6_,Math.PI * 2 / this._cycle,this._scale);
                     break;
                  case ParticleUVNode.LINEAR_EASE:
                  default:
                     param4.setVertexConst(_loc6_,1 / this._cycle,this._scale);
               }
            }
            else
            {
               param3.activateVertexBuffer(_loc6_,this._particleUVNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_2);
            }
         }
      }
      
      public function get scale() : Number
      {
         return this._scale;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
      }
      
      public function get cycle() : Number
      {
         return this._cycle;
      }
      
      public function set cycle(param1:Number) : void
      {
         this._cycle = param1;
      }
   }
}


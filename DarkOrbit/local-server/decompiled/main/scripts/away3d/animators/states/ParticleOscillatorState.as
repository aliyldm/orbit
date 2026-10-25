package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleOscillatorNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleOscillatorState extends ParticleStateBase
   {
      
      private var _particleOscillatorNode:ParticleOscillatorNode;
      
      private var _oscillator:Vector3D;
      
      private var _oscillatorData:Vector3D;
      
      public function ParticleOscillatorState(param1:ParticleAnimator, param2:ParticleOscillatorNode)
      {
         super(param1,param2);
         this._particleOscillatorNode = param2;
         this._oscillator = this._particleOscillatorNode._oscillator;
         this.updateOscillatorData();
      }
      
      public function get oscillator() : Vector3D
      {
         return this._oscillator;
      }
      
      public function set oscillator(param1:Vector3D) : void
      {
         this._oscillator = param1;
         this.updateOscillatorData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticleOscillatorNode.OSCILLATOR_INDEX);
         if(this._particleOscillatorNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
         {
            param3.activateVertexBuffer(_loc6_,this._particleOscillatorNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_4);
         }
         else
         {
            param4.setVertexConst(_loc6_,this._oscillatorData.x,this._oscillatorData.y,this._oscillatorData.z,this._oscillatorData.w);
         }
      }
      
      private function updateOscillatorData() : void
      {
         if(this._particleOscillatorNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            if(this._oscillator.w <= 0)
            {
               throw new Error("the cycle duration must greater than zero");
            }
            this._oscillatorData = this._oscillatorData || new Vector3D();
            this._oscillatorData.x = this._oscillator.x;
            this._oscillatorData.y = this._oscillator.y;
            this._oscillatorData.z = this._oscillator.z;
            this._oscillatorData.w = Math.PI * 2 / this._oscillator.w;
         }
      }
   }
}


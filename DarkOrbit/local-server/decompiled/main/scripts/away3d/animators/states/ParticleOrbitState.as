package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleOrbitNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleOrbitState extends ParticleStateBase
   {
      
      private var _particleOrbitNode:ParticleOrbitNode;
      
      private var _usesEulers:Boolean;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      private var _radius:Number;
      
      private var _cycleDuration:Number;
      
      private var _cyclePhase:Number;
      
      private var _eulers:Vector3D;
      
      private var _orbitData:Vector3D;
      
      private var _eulersMatrix:Matrix3D;
      
      public function ParticleOrbitState(param1:ParticleAnimator, param2:ParticleOrbitNode)
      {
         super(param1,param2);
         this._particleOrbitNode = param2;
         this._usesEulers = this._particleOrbitNode._usesEulers;
         this._usesCycle = this._particleOrbitNode._usesCycle;
         this._usesPhase = this._particleOrbitNode._usesPhase;
         this._eulers = this._particleOrbitNode._eulers;
         this._radius = this._particleOrbitNode._radius;
         this._cycleDuration = this._particleOrbitNode._cycleDuration;
         this._cyclePhase = this._particleOrbitNode._cyclePhase;
         this.updateOrbitData();
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      public function set radius(param1:Number) : void
      {
         this._radius = param1;
         this.updateOrbitData();
      }
      
      public function get cycleDuration() : Number
      {
         return this._cycleDuration;
      }
      
      public function set cycleDuration(param1:Number) : void
      {
         this._cycleDuration = param1;
         this.updateOrbitData();
      }
      
      public function get cyclePhase() : Number
      {
         return this._cyclePhase;
      }
      
      public function set cyclePhase(param1:Number) : void
      {
         this._cyclePhase = param1;
         this.updateOrbitData();
      }
      
      public function get eulers() : Vector3D
      {
         return this._eulers;
      }
      
      public function set eulers(param1:Vector3D) : void
      {
         this._eulers = param1;
         this.updateOrbitData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticleOrbitNode.ORBIT_INDEX);
         if(this._particleOrbitNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
         {
            if(this._usesPhase)
            {
               param3.activateVertexBuffer(_loc6_,this._particleOrbitNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_4);
            }
            else
            {
               param3.activateVertexBuffer(_loc6_,this._particleOrbitNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
            }
         }
         else
         {
            param4.setVertexConst(_loc6_,this._orbitData.x,this._orbitData.y,this._orbitData.z,this._orbitData.w);
         }
         if(this._usesEulers)
         {
            param4.setVertexConstFromMatrix(param4.getRegisterIndex(_animationNode,ParticleOrbitNode.EULERS_INDEX),this._eulersMatrix);
         }
      }
      
      private function updateOrbitData() : void
      {
         if(this._usesEulers)
         {
            this._eulersMatrix = new Matrix3D();
            this._eulersMatrix.appendRotation(this._eulers.x,Vector3D.X_AXIS);
            this._eulersMatrix.appendRotation(this._eulers.y,Vector3D.Y_AXIS);
            this._eulersMatrix.appendRotation(this._eulers.z,Vector3D.Z_AXIS);
         }
         if(this._particleOrbitNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            this._orbitData = new Vector3D(this._radius,0,this._radius * Math.PI * 2,this._cyclePhase * Math.PI / 180);
            if(this._usesCycle)
            {
               if(this._cycleDuration <= 0)
               {
                  throw new Error("the cycle duration must be greater than zero");
               }
               this._orbitData.y = Math.PI * 2 / this._cycleDuration;
            }
            else
            {
               this._orbitData.y = Math.PI * 2;
            }
         }
      }
   }
}


package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleInitialColorNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.ColorTransform;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleInitialColorState extends ParticleStateBase
   {
      
      private var _particleInitialColorNode:ParticleInitialColorNode;
      
      private var _usesMultiplier:Boolean;
      
      private var _usesOffset:Boolean;
      
      private var _initialColor:ColorTransform;
      
      private var _multiplierData:Vector3D;
      
      private var _offsetData:Vector3D;
      
      public function ParticleInitialColorState(param1:ParticleAnimator, param2:ParticleInitialColorNode)
      {
         super(param1,param2);
         this._particleInitialColorNode = param2;
         this._usesMultiplier = param2._usesMultiplier;
         this._usesOffset = param2._usesOffset;
         this._initialColor = param2._initialColor;
         this.updateColorData();
      }
      
      public function get initialColor() : ColorTransform
      {
         return this._initialColor;
      }
      
      public function set initialColor(param1:ColorTransform) : void
      {
         this._initialColor = param1;
         this.updateColorData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:uint = 0;
         param2 = param2;
         param5 = param5;
         if(param4.needFragmentAnimation)
         {
            if(this._particleInitialColorNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
            {
               _loc6_ = this._particleInitialColorNode.dataOffset;
               if(this._usesMultiplier)
               {
                  param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleInitialColorNode.MULTIPLIER_INDEX),_loc6_,param1,Context3DVertexBufferFormat.FLOAT_4);
                  _loc6_ += 4;
               }
               if(this._usesOffset)
               {
                  param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleInitialColorNode.OFFSET_INDEX),_loc6_,param1,Context3DVertexBufferFormat.FLOAT_4);
               }
            }
            else
            {
               if(this._usesMultiplier)
               {
                  param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleInitialColorNode.MULTIPLIER_INDEX),this._multiplierData.x,this._multiplierData.y,this._multiplierData.z,this._multiplierData.w);
               }
               if(this._usesOffset)
               {
                  param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleInitialColorNode.OFFSET_INDEX),this._offsetData.x,this._offsetData.y,this._offsetData.z,this._offsetData.w);
               }
            }
         }
      }
      
      private function updateColorData() : void
      {
         if(this._particleInitialColorNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            if(this._usesMultiplier)
            {
               this._multiplierData = new Vector3D(this._initialColor.redMultiplier,this._initialColor.greenMultiplier,this._initialColor.blueMultiplier,this._initialColor.alphaMultiplier);
            }
            if(this._usesOffset)
            {
               this._offsetData = new Vector3D(this._initialColor.redOffset / 255,this._initialColor.greenOffset / 255,this._initialColor.blueOffset / 255,this._initialColor.alphaOffset / 255);
            }
         }
      }
   }
}


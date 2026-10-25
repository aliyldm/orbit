package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleSpriteSheetNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   
   use namespace arcane;
   
   public class ParticleSpriteSheetState extends ParticleStateBase
   {
      
      private var _particleSpriteSheetNode:ParticleSpriteSheetNode;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      private var _totalFrames:int;
      
      private var _numColumns:int;
      
      private var _numRows:int;
      
      private var _cycleDuration:Number;
      
      private var _cyclePhase:Number;
      
      private var _spriteSheetData:Vector.<Number>;
      
      public function ParticleSpriteSheetState(param1:ParticleAnimator, param2:ParticleSpriteSheetNode)
      {
         super(param1,param2);
         this._particleSpriteSheetNode = param2;
         this._usesCycle = this._particleSpriteSheetNode._usesCycle;
         this._usesPhase = this._particleSpriteSheetNode._usesPhase;
         this._totalFrames = this._particleSpriteSheetNode._totalFrames;
         this._numColumns = this._particleSpriteSheetNode._numColumns;
         this._numRows = this._particleSpriteSheetNode._numRows;
         this._cycleDuration = this._particleSpriteSheetNode._cycleDuration;
         this._cyclePhase = this._particleSpriteSheetNode._cyclePhase;
         this.updateSpriteSheetData();
      }
      
      public function get cyclePhase() : Number
      {
         return this._cyclePhase;
      }
      
      public function set cyclePhase(param1:Number) : void
      {
         this._cyclePhase = param1;
         this.updateSpriteSheetData();
      }
      
      public function get cycleDuration() : Number
      {
         return this._cycleDuration;
      }
      
      public function set cycleDuration(param1:Number) : void
      {
         this._cycleDuration = param1;
         this.updateSpriteSheetData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:int = 0;
         if(param4.needUVAnimation)
         {
            param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleSpriteSheetNode.UV_INDEX_0),this._spriteSheetData[0],this._spriteSheetData[1],this._spriteSheetData[2],this._spriteSheetData[3]);
            if(this._usesCycle)
            {
               _loc6_ = param4.getRegisterIndex(_animationNode,ParticleSpriteSheetNode.UV_INDEX_1);
               if(this._particleSpriteSheetNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
               {
                  if(this._usesPhase)
                  {
                     param3.activateVertexBuffer(_loc6_,this._particleSpriteSheetNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
                  }
                  else
                  {
                     param3.activateVertexBuffer(_loc6_,this._particleSpriteSheetNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_2);
                  }
               }
               else
               {
                  param4.setVertexConst(_loc6_,this._spriteSheetData[4],this._spriteSheetData[5]);
               }
            }
         }
      }
      
      private function updateSpriteSheetData() : void
      {
         this._spriteSheetData = new Vector.<Number>(8,true);
         var _loc1_:Number = this._totalFrames / this._numColumns;
         this._spriteSheetData[0] = _loc1_;
         this._spriteSheetData[1] = 1 / this._numColumns;
         this._spriteSheetData[2] = 1 / this._numRows;
         if(this._usesCycle)
         {
            if(this._cycleDuration <= 0)
            {
               throw new Error("the cycle duration must be greater than zero");
            }
            this._spriteSheetData[4] = _loc1_ / this._cycleDuration;
            this._spriteSheetData[5] = this._cycleDuration;
            if(this._usesPhase)
            {
               this._spriteSheetData[6] = this._cyclePhase;
            }
         }
      }
   }
}


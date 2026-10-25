package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.nodes.ParticleSegmentedScaleNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleSegmentedScaleState extends ParticleStateBase
   {
      
      private var _startScale:Vector3D;
      
      private var _endScale:Vector3D;
      
      private var _segmentPoints:Vector.<Vector3D>;
      
      private var _numSegmentPoint:int;
      
      private var _scaleData:Vector.<Number>;
      
      public function ParticleSegmentedScaleState(param1:ParticleAnimator, param2:ParticleSegmentedScaleNode)
      {
         super(param1,param2);
         this._startScale = param2._startScale;
         this._endScale = param2._endScale;
         this._segmentPoints = param2._segmentScales;
         this._numSegmentPoint = param2._numSegmentPoint;
         this.updateScaleData();
      }
      
      public function get startScale() : Vector3D
      {
         return this._startScale;
      }
      
      public function set startScale(param1:Vector3D) : void
      {
         this._startScale = param1;
         this.updateScaleData();
      }
      
      public function get endScale() : Vector3D
      {
         return this._endScale;
      }
      
      public function set endScale(param1:Vector3D) : void
      {
         this._endScale = param1;
         this.updateScaleData();
      }
      
      public function get numSegmentPoint() : int
      {
         return this._numSegmentPoint;
      }
      
      public function get segmentPoints() : Vector.<Vector3D>
      {
         return this._segmentPoints;
      }
      
      public function set segmentPoints(param1:Vector.<Vector3D>) : void
      {
         this._segmentPoints = param1;
         this.updateScaleData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         param4.setVertexConstFromVector(param4.getRegisterIndex(_animationNode,ParticleSegmentedScaleNode.START_INDEX),this._scaleData);
      }
      
      private function updateScaleData() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Vector.<Number> = new Vector.<Number>();
         this._scaleData = new Vector.<Number>();
         _loc2_ = 0;
         while(_loc2_ < this._numSegmentPoint)
         {
            if(_loc2_ == 0)
            {
               _loc1_.push(this._segmentPoints[_loc2_].w);
            }
            else
            {
               _loc1_.push(this._segmentPoints[_loc2_].w - this._segmentPoints[_loc2_ - 1].w);
            }
            _loc2_++;
         }
         if(this._numSegmentPoint == 0)
         {
            _loc1_.push(1);
         }
         else
         {
            _loc1_.push(1 - this._segmentPoints[_loc2_ - 1].w);
         }
         this._scaleData.push(this._startScale.x,this._startScale.y,this._startScale.z,0);
         _loc2_ = 0;
         while(_loc2_ < this._numSegmentPoint)
         {
            if(_loc2_ == 0)
            {
               this._scaleData.push((this._segmentPoints[_loc2_].x - this._startScale.x) / _loc1_[_loc2_],(this._segmentPoints[_loc2_].y - this._startScale.y) / _loc1_[_loc2_],(this._segmentPoints[_loc2_].z - this._startScale.z) / _loc1_[_loc2_],_loc1_[_loc2_]);
            }
            else
            {
               this._scaleData.push((this._segmentPoints[_loc2_].x - this._segmentPoints[_loc2_ - 1].x) / _loc1_[_loc2_],(this._segmentPoints[_loc2_].y - this._segmentPoints[_loc2_ - 1].y) / _loc1_[_loc2_],(this._segmentPoints[_loc2_].z - this._segmentPoints[_loc2_ - 1].z) / _loc1_[_loc2_],_loc1_[_loc2_]);
            }
            _loc2_++;
         }
         if(this._numSegmentPoint == 0)
         {
            this._scaleData.push(this._endScale.x - this._startScale.x,this._endScale.y - this._startScale.y,this._endScale.z - this._startScale.z,1);
         }
         else
         {
            this._scaleData.push((this._endScale.x - this._segmentPoints[_loc2_ - 1].x) / _loc1_[_loc2_],(this._endScale.y - this._segmentPoints[_loc2_ - 1].y) / _loc1_[_loc2_],(this._endScale.z - this._segmentPoints[_loc2_ - 1].z) / _loc1_[_loc2_],_loc1_[_loc2_]);
         }
      }
   }
}


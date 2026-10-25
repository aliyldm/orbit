package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ColorSegmentPoint;
   import away3d.animators.nodes.ParticleSegmentedColorNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.geom.ColorTransform;
   
   use namespace arcane;
   
   public class ParticleSegmentedColorState extends ParticleStateBase
   {
      
      private var _usesMultiplier:Boolean;
      
      private var _usesOffset:Boolean;
      
      private var _startColor:ColorTransform;
      
      private var _endColor:ColorTransform;
      
      private var _segmentPoints:Vector.<ColorSegmentPoint>;
      
      private var _numSegmentPoint:int;
      
      private var _timeLifeData:Vector.<Number>;
      
      private var _multiplierData:Vector.<Number>;
      
      private var _offsetData:Vector.<Number>;
      
      public function ParticleSegmentedColorState(param1:ParticleAnimator, param2:ParticleSegmentedColorNode)
      {
         super(param1,param2);
         this._usesMultiplier = param2._usesMultiplier;
         this._usesOffset = param2._usesOffset;
         this._startColor = param2._startColor;
         this._endColor = param2._endColor;
         this._segmentPoints = param2._segmentPoints;
         this._numSegmentPoint = param2._numSegmentPoint;
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
      
      public function get numSegmentPoint() : int
      {
         return this._numSegmentPoint;
      }
      
      public function get segmentPoints() : Vector.<ColorSegmentPoint>
      {
         return this._segmentPoints;
      }
      
      public function set segmentPoints(param1:Vector.<ColorSegmentPoint>) : void
      {
         this._segmentPoints = param1;
         this.updateColorData();
      }
      
      public function get usesMultiplier() : Boolean
      {
         return this._usesMultiplier;
      }
      
      public function get usesOffset() : Boolean
      {
         return this._usesOffset;
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         if(param4.needFragmentAnimation)
         {
            if(this._numSegmentPoint > 0)
            {
               param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleSegmentedColorNode.TIME_DATA_INDEX),this._timeLifeData[0],this._timeLifeData[1],this._timeLifeData[2],this._timeLifeData[3]);
            }
            if(this._usesMultiplier)
            {
               param4.setVertexConstFromVector(param4.getRegisterIndex(_animationNode,ParticleSegmentedColorNode.START_MULTIPLIER_INDEX),this._multiplierData);
            }
            if(this._usesOffset)
            {
               param4.setVertexConstFromVector(param4.getRegisterIndex(_animationNode,ParticleSegmentedColorNode.START_OFFSET_INDEX),this._offsetData);
            }
         }
      }
      
      private function updateColorData() : void
      {
         var _loc1_:int = 0;
         this._timeLifeData = new Vector.<Number>();
         this._multiplierData = new Vector.<Number>();
         this._offsetData = new Vector.<Number>();
         _loc1_ = 0;
         while(_loc1_ < this._numSegmentPoint)
         {
            if(_loc1_ == 0)
            {
               this._timeLifeData.push(this._segmentPoints[_loc1_].life);
            }
            else
            {
               this._timeLifeData.push(this._segmentPoints[_loc1_].life - this._segmentPoints[_loc1_ - 1].life);
            }
            _loc1_++;
         }
         if(this._numSegmentPoint == 0)
         {
            this._timeLifeData.push(1);
         }
         else
         {
            this._timeLifeData.push(1 - this._segmentPoints[_loc1_ - 1].life);
         }
         if(this._usesMultiplier)
         {
            this._multiplierData.push(this._startColor.redMultiplier,this._startColor.greenMultiplier,this._startColor.blueMultiplier,this._startColor.alphaMultiplier);
            _loc1_ = 0;
            while(_loc1_ < this._numSegmentPoint)
            {
               if(_loc1_ == 0)
               {
                  this._multiplierData.push((this._segmentPoints[_loc1_].color.redMultiplier - this._startColor.redMultiplier) / this._timeLifeData[_loc1_],(this._segmentPoints[_loc1_].color.greenMultiplier - this._startColor.greenMultiplier) / this._timeLifeData[_loc1_],(this._segmentPoints[_loc1_].color.blueMultiplier - this._startColor.blueMultiplier) / this._timeLifeData[_loc1_],(this._segmentPoints[_loc1_].color.alphaMultiplier - this._startColor.alphaMultiplier) / this._timeLifeData[_loc1_]);
               }
               else
               {
                  this._multiplierData.push((this._segmentPoints[_loc1_].color.redMultiplier - this._segmentPoints[_loc1_ - 1].color.redMultiplier) / this._timeLifeData[_loc1_],(this._segmentPoints[_loc1_].color.greenMultiplier - this._segmentPoints[_loc1_ - 1].color.greenMultiplier) / this._timeLifeData[_loc1_],(this._segmentPoints[_loc1_].color.blueMultiplier - this._segmentPoints[_loc1_ - 1].color.blueMultiplier) / this._timeLifeData[_loc1_],(this._segmentPoints[_loc1_].color.alphaMultiplier - this._segmentPoints[_loc1_ - 1].color.alphaMultiplier) / this._timeLifeData[_loc1_]);
               }
               _loc1_++;
            }
            if(this._numSegmentPoint == 0)
            {
               this._multiplierData.push(this._endColor.redMultiplier - this._startColor.redMultiplier,this._endColor.greenMultiplier - this._startColor.greenMultiplier,this._endColor.blueMultiplier - this._startColor.blueMultiplier,this._endColor.alphaMultiplier - this._startColor.alphaMultiplier);
            }
            else
            {
               this._multiplierData.push((this._endColor.redMultiplier - this._segmentPoints[_loc1_ - 1].color.redMultiplier) / this._timeLifeData[_loc1_],(this._endColor.greenMultiplier - this._segmentPoints[_loc1_ - 1].color.greenMultiplier) / this._timeLifeData[_loc1_],(this._endColor.blueMultiplier - this._segmentPoints[_loc1_ - 1].color.blueMultiplier) / this._timeLifeData[_loc1_],(this._endColor.alphaMultiplier - this._segmentPoints[_loc1_ - 1].color.alphaMultiplier) / this._timeLifeData[_loc1_]);
            }
         }
         if(this._usesOffset)
         {
            this._offsetData.push(this._startColor.redOffset / 255,this._startColor.greenOffset / 255,this._startColor.blueOffset / 255,this._startColor.alphaOffset / 255);
            _loc1_ = 0;
            while(_loc1_ < this._numSegmentPoint)
            {
               if(_loc1_ == 0)
               {
                  this._offsetData.push((this._segmentPoints[_loc1_].color.redOffset - this._startColor.redOffset) / this._timeLifeData[_loc1_] / 255,(this._segmentPoints[_loc1_].color.greenOffset - this._startColor.greenOffset) / this._timeLifeData[_loc1_] / 255,(this._segmentPoints[_loc1_].color.blueOffset - this._startColor.blueOffset) / this._timeLifeData[_loc1_] / 255,(this._segmentPoints[_loc1_].color.alphaOffset - this._startColor.alphaOffset) / this._timeLifeData[_loc1_] / 255);
               }
               else
               {
                  this._offsetData.push((this._segmentPoints[_loc1_].color.redOffset - this._segmentPoints[_loc1_ - 1].color.redOffset) / this._timeLifeData[_loc1_] / 255,(this._segmentPoints[_loc1_].color.greenOffset - this._segmentPoints[_loc1_ - 1].color.greenOffset) / this._timeLifeData[_loc1_] / 255,(this._segmentPoints[_loc1_].color.blueOffset - this._segmentPoints[_loc1_ - 1].color.blueOffset) / this._timeLifeData[_loc1_] / 255,(this._segmentPoints[_loc1_].color.alphaOffset - this._segmentPoints[_loc1_ - 1].color.alphaOffset) / this._timeLifeData[_loc1_] / 255);
               }
               _loc1_++;
            }
            if(this._numSegmentPoint == 0)
            {
               this._offsetData.push((this._endColor.redOffset - this._startColor.redOffset) / 255,(this._endColor.greenOffset - this._startColor.greenOffset) / 255,(this._endColor.blueOffset - this._startColor.blueOffset) / 255,(this._endColor.alphaOffset - this._startColor.alphaOffset) / 255);
            }
            else
            {
               this._offsetData.push((this._endColor.redOffset - this._segmentPoints[_loc1_ - 1].color.redOffset) / this._timeLifeData[_loc1_] / 255,(this._endColor.greenOffset - this._segmentPoints[_loc1_ - 1].color.greenOffset) / this._timeLifeData[_loc1_] / 255,(this._endColor.blueOffset - this._segmentPoints[_loc1_ - 1].color.blueOffset) / this._timeLifeData[_loc1_] / 255,(this._endColor.alphaOffset - this._segmentPoints[_loc1_ - 1].color.alphaOffset) / this._timeLifeData[_loc1_] / 255);
            }
         }
         this._timeLifeData.length = 4;
      }
   }
}


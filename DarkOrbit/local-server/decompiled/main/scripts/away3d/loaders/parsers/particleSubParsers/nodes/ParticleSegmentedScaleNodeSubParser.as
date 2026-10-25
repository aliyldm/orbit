package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.nodes.ParticleSegmentedScaleNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.threeD.ThreeDConstValueSubParser;
   import flash.geom.Vector3D;
   
   public class ParticleSegmentedScaleNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _startScaleValue:ThreeDConstValueSubParser;
      
      private var _endScaleValue:ThreeDConstValueSubParser;
      
      private var _segmentPoints:Array;
      
      public function ParticleSegmentedScaleNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleSegmentedScaleNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:ThreeDConstValueSubParser = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.startScale;
            _loc3_ = _loc1_.data;
            this._startScaleValue = new ThreeDConstValueSubParser(null);
            addSubParser(this._startScaleValue);
            this._startScaleValue.parseAsync(_loc3_);
            _loc1_ = _data.endScale;
            _loc3_ = _loc1_.data;
            this._endScaleValue = new ThreeDConstValueSubParser(null);
            addSubParser(this._endScaleValue);
            this._endScaleValue.parseAsync(_loc3_);
            this._segmentPoints = new Array();
            _loc4_ = _data.segmentPoints;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = new ThreeDConstValueSubParser(null);
               addSubParser(_loc6_);
               this._segmentPoints.push({
                  "life":_loc4_[_loc5_].life,
                  "scale":_loc6_
               });
               _loc6_.parseAsync(_loc4_[_loc5_].scale.data);
               _loc5_++;
            }
            this._segmentPoints.sortOn("life",Array.NUMERIC | Array.CASEINSENSITIVE);
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length - 1)
            {
               if(this._segmentPoints[_loc5_].life == this._segmentPoints[_loc5_ + 1].life)
               {
                  this._segmentPoints[_loc5_].life -= 0.00001 * (_loc4_.length - _loc5_);
               }
               _loc5_++;
            }
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.initProps();
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function initProps() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector3D = null;
         var _loc1_:Vector.<Vector3D> = new Vector.<Vector3D>();
         var _loc2_:int = int(this._segmentPoints.length);
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._segmentPoints[_loc3_].scale.setter.generateOneValue();
            _loc4_.w = this._segmentPoints[_loc3_].life;
            _loc1_.push(_loc4_);
            _loc3_++;
         }
         _particleAnimationNode = new ParticleSegmentedScaleNode(_loc2_,this._startScaleValue.setter.generateOneValue(),this._endScaleValue.setter.generateOneValue(),_loc1_);
      }
   }
}


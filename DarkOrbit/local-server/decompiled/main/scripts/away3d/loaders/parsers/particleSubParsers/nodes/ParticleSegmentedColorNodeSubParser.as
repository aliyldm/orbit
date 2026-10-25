package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ColorSegmentPoint;
   import away3d.animators.nodes.ParticleSegmentedColorNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.color.ConstColorValueSubParser;
   
   public class ParticleSegmentedColorNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _startColorValue:ConstColorValueSubParser;
      
      private var _endColorValue:ConstColorValueSubParser;
      
      private var _segmentPoints:Array;
      
      private var _usesMultiplier:Boolean;
      
      private var _usesOffset:Boolean;
      
      public function ParticleSegmentedColorNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleSegmentedColorNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:ConstColorValueSubParser = null;
         if(_isFirstParsing)
         {
            this._usesMultiplier = _data.usesMultiplier;
            this._usesOffset = _data.usesOffset;
            _loc1_ = _data.startColor;
            _loc3_ = _loc1_.data;
            this._startColorValue = new ConstColorValueSubParser(null);
            addSubParser(this._startColorValue);
            this._startColorValue.parseAsync(_loc3_);
            _loc1_ = _data.endColor;
            _loc3_ = _loc1_.data;
            this._endColorValue = new ConstColorValueSubParser(null);
            addSubParser(this._endColorValue);
            this._endColorValue.parseAsync(_loc3_);
            this._segmentPoints = new Array();
            _loc4_ = _data.segmentPoints;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = new ConstColorValueSubParser(null);
               addSubParser(_loc6_);
               this._segmentPoints.push({
                  "life":_loc4_[_loc5_].life,
                  "color":_loc6_
               });
               _loc6_.parseAsync(_loc4_[_loc5_].color.data);
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
         var _loc1_:Vector.<ColorSegmentPoint> = new Vector.<ColorSegmentPoint>();
         var _loc2_:int = int(this._segmentPoints.length);
         while(_loc3_ < _loc2_)
         {
            _loc1_.push(new ColorSegmentPoint(this._segmentPoints[_loc3_].life,this._segmentPoints[_loc3_].color.setter.generateOneValue()));
            _loc3_++;
         }
         _particleAnimationNode = new ParticleSegmentedColorNode(this._usesMultiplier,this._usesOffset,_loc2_,this._startColorValue.setter.generateOneValue(),this._endColorValue.setter.generateOneValue(),_loc1_);
      }
   }
}


package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   
   public class ParticleTimeNodeSubParser extends ParticleNodeSubParserBase
   {
      
      public var usesDuration:Boolean;
      
      public var usesLooping:Boolean;
      
      public var usesDelay:Boolean;
      
      private var _startTimeValue:ValueSubParserBase;
      
      private var _durationValue:ValueSubParserBase;
      
      private var _delayValue:ValueSubParserBase;
      
      public function ParticleTimeNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleTimeNodeSubParser;
      }
      
      private function initSetters() : void
      {
         _setters.push(this._startTimeValue.setter);
         if(this.usesDuration)
         {
            _setters.push(this._durationValue.setter);
         }
         if(this.usesDelay)
         {
            _setters.push(this._delayValue.setter);
         }
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            this.usesLooping = _data.usesLooping;
            this.usesDuration = _data.usesDuration;
            this.usesDelay = _data.usesDelay;
            _loc1_ = _data.startTime;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._startTimeValue = new _loc4_("startTime");
            addSubParser(this._startTimeValue);
            this._startTimeValue.parseAsync(_loc3_);
            if(this.usesDuration)
            {
               _loc1_ = _data.duration;
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc4_)
               {
                  dieWithError("Unknown value");
               }
               this._durationValue = new _loc4_("duration");
               addSubParser(this._durationValue);
               this._durationValue.parseAsync(_loc3_);
            }
            if(this.usesDelay)
            {
               _loc1_ = _data.delay;
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc4_)
               {
                  dieWithError("Unknown value");
               }
               this._delayValue = new _loc4_("delay");
               addSubParser(this._delayValue);
               this._delayValue.parseAsync(_loc3_);
            }
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.initSetters();
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
   }
}


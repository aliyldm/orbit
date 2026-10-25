package away3d.loaders.parsers.particleSubParsers.values.property
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.oneD.OneDConstValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.property.InstancePropertySubSetter;
   import away3d.loaders.parsers.particleSubParsers.values.threeD.ThreeDConstValueSubParser;
   
   public class InstancePropertySubParser extends ValueSubParserBase
   {
      
      private var _positionValue:ThreeDConstValueSubParser;
      
      private var _rotationValue:ThreeDConstValueSubParser;
      
      private var _scaleValue:ThreeDConstValueSubParser;
      
      private var _timeOffsetValue:OneDConstValueSubParser;
      
      private var _playSpeedValue:OneDConstValueSubParser;
      
      public function InstancePropertySubParser(param1:String)
      {
         super(param1,CONST_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.InstancePropertySubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(_isFirstParsing)
         {
            if(_data.position)
            {
               this._positionValue = new ThreeDConstValueSubParser(null);
               addSubParser(this._positionValue);
               this._positionValue.parseAsync(_data.position.data);
            }
            if(_data.rotation)
            {
               this._rotationValue = new ThreeDConstValueSubParser(null);
               addSubParser(this._rotationValue);
               this._rotationValue.parseAsync(_data.rotation.data);
            }
            if(_data.scale)
            {
               this._scaleValue = new ThreeDConstValueSubParser(null);
               addSubParser(this._scaleValue);
               this._scaleValue.parseAsync(_data.scale.data);
            }
            if(_data.timeOffset)
            {
               this._timeOffsetValue = new OneDConstValueSubParser(null);
               addSubParser(this._timeOffsetValue);
               this._timeOffsetValue.parseAsync(_data.timeOffset.data);
            }
            if(_data.playSpeed)
            {
               this._playSpeedValue = new OneDConstValueSubParser(null);
               addSubParser(this._playSpeedValue);
               this._playSpeedValue.parseAsync(_data.playSpeed.data);
            }
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.initSetter();
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function initSetter() : void
      {
         var _loc1_:SetterBase = this._positionValue ? this._positionValue.setter : null;
         var _loc2_:SetterBase = this._rotationValue ? this._rotationValue.setter : null;
         var _loc3_:SetterBase = this._scaleValue ? this._scaleValue.setter : null;
         var _loc4_:SetterBase = this._timeOffsetValue ? this._timeOffsetValue.setter : null;
         var _loc5_:SetterBase = this._playSpeedValue ? this._playSpeedValue.setter : null;
         _setter = new InstancePropertySubSetter(_propName,_loc1_,_loc2_,_loc3_,_loc4_,_loc5_);
      }
   }
}


package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleScaleNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import flash.geom.Vector3D;
   
   public class ParticleScaleNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _scaleValue:ValueSubParserBase;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      public function ParticleScaleNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleScaleNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            this._usesCycle = _data.usesCycle;
            this._usesPhase = _data.usesPhase;
            _loc1_ = _data.scale;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_FOURD_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._scaleValue = new _loc4_(ParticleScaleNode.SCALE_VECTOR3D);
            addSubParser(this._scaleValue);
            this._scaleValue.parseAsync(_loc3_);
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
         var _loc1_:Vector3D = null;
         if(this._scaleValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _loc1_ = this._scaleValue.setter.generateOneValue();
            _particleAnimationNode = new ParticleScaleNode(ParticlePropertiesMode.GLOBAL,this._usesCycle,this._usesPhase,_loc1_.x,_loc1_.y,_loc1_.z,_loc1_.w);
         }
         else
         {
            _particleAnimationNode = new ParticleScaleNode(ParticlePropertiesMode.LOCAL_STATIC,this._usesCycle,this._usesPhase);
            _setters.push(this._scaleValue.setter);
         }
      }
   }
}


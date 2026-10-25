package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleOrbitNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.threeD.ThreeDConstValueSubParser;
   import flash.geom.Vector3D;
   
   public class ParticleOrbitNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _orbitValue:ValueSubParserBase;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      private var _usesEulers:Boolean;
      
      private var _eulersValue:ThreeDConstValueSubParser;
      
      public function ParticleOrbitNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleOrbitNodeSubParser;
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
            _loc1_ = _data.orbit;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_FOURD_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._orbitValue = new _loc4_(ParticleOrbitNode.ORBIT_VECTOR3D);
            addSubParser(this._orbitValue);
            this._orbitValue.parseAsync(_loc3_);
            _loc1_ = _data.eulers;
            if(_loc1_)
            {
               this._usesEulers = true;
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               this._eulersValue = new ThreeDConstValueSubParser(null);
               addSubParser(this._eulersValue);
               this._eulersValue.parseAsync(_loc3_);
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
         var _loc2_:Vector3D = null;
         var _loc1_:Vector3D = this._usesEulers ? this._eulersValue.setter.generateOneValue() : null;
         if(this._orbitValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _loc2_ = this._orbitValue.setter.generateOneValue();
            _particleAnimationNode = new ParticleOrbitNode(ParticlePropertiesMode.GLOBAL,this._usesEulers,this._usesCycle,this._usesPhase,_loc2_.x,_loc2_.y,_loc2_.z,_loc1_);
         }
         else
         {
            _particleAnimationNode = new ParticleOrbitNode(ParticlePropertiesMode.LOCAL_STATIC,this._usesEulers,this._usesCycle,this._usesPhase,100,1,0,_loc1_);
            _setters.push(this._orbitValue.setter);
         }
      }
   }
}


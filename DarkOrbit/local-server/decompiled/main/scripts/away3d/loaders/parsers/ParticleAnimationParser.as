package away3d.loaders.parsers
{
   import away3d.animators.ParticleAnimationSet;
   import away3d.animators.ParticleAnimator;
   import away3d.arcane;
   import away3d.bounds.BoundingSphere;
   import away3d.core.base.ParticleGeometry;
   import away3d.entities.Mesh;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.materials.MaterialSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleNodeSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.nodes.ParticleTimeNodeSubParser;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import flash.geom.Vector3D;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class ParticleAnimationParser extends CompositeParserBase
   {
      
      private var _particleMesh:Mesh;
      
      private var _particleAnimator:ParticleAnimator;
      
      private var _particleAnimationSet:ParticleAnimationSet;
      
      private var _particleGeometry:ParticleGeometry;
      
      private var _bounds:Number;
      
      private var _nodeParsers:Vector.<ParticleNodeSubParserBase>;
      
      private var _particleMaterialParser:MaterialSubParserBase;
      
      private var _particlegeometryParser:ParticleGeometryParser;
      
      private var _globalValues:Vector.<ValueSubParserBase>;
      
      public function ParticleAnimationParser()
      {
         super();
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return param1 == "pam";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         return false;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:ParticleNodeSubParserBase = null;
         var _loc10_:Object = null;
         var _loc11_:ValueSubParserBase = null;
         if(_isFirstParsing)
         {
            this._bounds = _data.bounds;
            _loc1_ = _data.material;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_MATERIALS);
            if(!_loc4_)
            {
               dieWithError("Unknown matierla parser");
            }
            this._particleMaterialParser = new _loc4_();
            addSubParser(this._particleMaterialParser);
            this._particleMaterialParser.parseAsync(_loc3_);
            this._nodeParsers = new Vector.<ParticleNodeSubParserBase>();
            _loc5_ = _data.nodes;
            for each(_loc6_ in _loc5_)
            {
               _loc3_ = _loc6_.data;
               _loc2_ = _loc6_.id;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_PARTICLE_NODES);
               if(!_loc4_)
               {
                  dieWithError("Unknown node parser");
               }
               _loc9_ = new _loc4_();
               addSubParser(_loc9_);
               _loc9_.parseAsync(_loc3_);
               this._nodeParsers.push(_loc9_);
            }
            _loc7_ = _data.globalValues;
            if(_loc7_)
            {
               this._globalValues = new Vector.<ValueSubParserBase>();
               for each(_loc10_ in _loc7_)
               {
                  _loc3_ = _loc10_.data;
                  _loc2_ = _loc10_.id;
                  _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_GLOBAL_VALUES);
                  if(!_loc4_)
                  {
                     dieWithError("Unknown node parser");
                  }
                  _loc11_ = new _loc4_(null);
                  addSubParser(_loc11_);
                  _loc11_.parseAsync(_loc3_);
                  this._globalValues.push(_loc11_);
               }
            }
            _loc8_ = _data.geometry;
            if(_loc8_.embed)
            {
               this._particlegeometryParser = new ParticleGeometryParser();
               addSubParser(this._particlegeometryParser);
               this._particlegeometryParser.parseAsync(_loc8_.data);
            }
            else
            {
               addDependency("geometry",new URLRequest(_loc8_.url),true);
            }
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.generateAnimation();
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         if(param1.id == "geometry")
         {
            this._particlegeometryParser = new ParticleGeometryParser();
            addSubParser(this._particlegeometryParser);
            this._particlegeometryParser.parseAsync(param1.data);
         }
      }
      
      override arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
         dieWithError("resolveDependencyFailure");
      }
      
      private function generateAnimation() : void
      {
         var _loc4_:int = 0;
         var _loc6_:ValueSubParserBase = null;
         var _loc7_:Vector.<SetterBase> = null;
         var _loc8_:SetterBase = null;
         var _loc1_:ParticleTimeNodeSubParser = this._nodeParsers[0] as ParticleTimeNodeSubParser;
         this._particleAnimationSet = new ParticleAnimationSet(_loc1_.usesDuration,_loc1_.usesLooping,_loc1_.usesDelay);
         var _loc2_:int = int(this._nodeParsers.length);
         var _loc3_:Vector.<SetterBase> = new Vector.<SetterBase>();
         if(this._globalValues)
         {
            for each(_loc6_ in this._globalValues)
            {
               _loc3_.push(_loc6_.setter);
            }
         }
         while(_loc4_ < this._nodeParsers.length)
         {
            if(_loc4_ != 0)
            {
               this._particleAnimationSet.addAnimation(this._nodeParsers[_loc4_].particleAnimationNode);
            }
            _loc7_ = this._nodeParsers[_loc4_].setters;
            for each(_loc8_ in _loc7_)
            {
               _loc3_.push(_loc8_);
            }
            _loc4_++;
         }
         var _loc5_:ParticleInitializer = new ParticleInitializer(_loc3_);
         this._particleAnimationSet.initParticleFunc = _loc5_.initHandler;
         finalizeAsset(this._particleAnimationSet);
         this._particleAnimator = new ParticleAnimator(this._particleAnimationSet);
         this._particleMesh = new Mesh(this._particlegeometryParser.particleGeometry,this._particleMaterialParser.material);
         this._particleMesh.bounds = new BoundingSphere();
         this._particleMesh.bounds.fromSphere(new Vector3D(),this._bounds);
         if(_data.hasOwnProperty("shareAnimationGeometry"))
         {
            this._particleMesh.shareAnimationGeometry = _data.shareAnimationGeometry;
         }
         if(_data.hasOwnProperty("name"))
         {
            this._particleMesh.name = _data.name;
         }
         this._particleMesh.animator = this._particleAnimator;
         finalizeAsset(this._particleMesh);
      }
      
      public function get particleMesh() : Mesh
      {
         return this._particleMesh;
      }
   }
}

import away3d.animators.data.ParticleProperties;
import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;

class ParticleInitializer
{
   
   private var _setters:Vector.<SetterBase>;
   
   public function ParticleInitializer(param1:Vector.<SetterBase>)
   {
      super();
      this._setters = param1;
   }
   
   public function initHandler(param1:ParticleProperties) : void
   {
      var _loc2_:SetterBase = null;
      if(param1.index == 0)
      {
         for each(_loc2_ in this._setters)
         {
            _loc2_.startPropsGenerating(param1);
         }
      }
      for each(_loc2_ in this._setters)
      {
         _loc2_.setProps(param1);
      }
      if(param1.index == param1.total - 1)
      {
         for each(_loc2_ in this._setters)
         {
            _loc2_.finishPropsGenerating(param1);
         }
      }
   }
}

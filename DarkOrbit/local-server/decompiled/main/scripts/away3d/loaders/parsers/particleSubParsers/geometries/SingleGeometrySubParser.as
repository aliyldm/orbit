package away3d.loaders.parsers.particleSubParsers.geometries
{
   import away3d.arcane;
   import away3d.core.base.Geometry;
   import away3d.core.base.ParticleGeometry;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.geometries.shapes.ShapeSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.matrix.Matrix2DUVCompositeValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import away3d.tools.helpers.ParticleGeometryHelper;
   import away3d.tools.helpers.data.ParticleGeometryTransform;
   
   use namespace arcane;
   
   public class SingleGeometrySubParser extends GeometrySubParserBase
   {
      
      private var _shape:ShapeSubParserBase;
      
      private var _vertexTransformValue:ValueSubParserBase;
      
      private var _uvTransformValue:ValueSubParserBase;
      
      private var _particleGeometry:ParticleGeometry;
      
      public function SingleGeometrySubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.SingleGeometrySubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         var _loc5_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.vertexTransform;
            if(_loc1_)
            {
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_MATRIX3DS);
               if(!_loc4_)
               {
                  dieWithError("Unknown value");
               }
               this._vertexTransformValue = new _loc4_(null);
               addSubParser(this._vertexTransformValue);
               this._vertexTransformValue.parseAsync(_loc3_);
            }
            _loc1_ = _data.uvTransformValue;
            if(_loc1_)
            {
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               this._uvTransformValue = new Matrix2DUVCompositeValueSubParser(null);
               addSubParser(this._uvTransformValue);
               this._uvTransformValue.parseAsync(_loc3_);
            }
            _loc1_ = _data.shape;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_SHAPES);
            this._shape = new _loc4_();
            addSubParser(this._shape);
            this._shape.parseAsync(_loc3_);
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.generateParticleGeometry();
            finalizeAsset(this._particleGeometry);
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function generateParticleGeometry() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<ParticleGeometryTransform> = null;
         var _loc5_:SetterBase = null;
         var _loc6_:SetterBase = null;
         var _loc7_:ParticleGeometryTransform = null;
         var _loc1_:Geometry = this._shape.getGeometry();
         var _loc2_:Vector.<Geometry> = new Vector.<Geometry>(_numParticles,true);
         while(_loc3_ < _numParticles)
         {
            _loc2_[_loc3_] = _loc1_;
            _loc3_++;
         }
         if(Boolean(this._vertexTransformValue) || Boolean(this._uvTransformValue))
         {
            _loc5_ = this._vertexTransformValue ? this._vertexTransformValue.setter : null;
            _loc6_ = this._uvTransformValue ? this._uvTransformValue.setter : null;
            _loc4_ = new Vector.<ParticleGeometryTransform>(_numParticles,true);
            _loc3_ = 0;
            while(_loc3_ < _numParticles)
            {
               _loc7_ = new ParticleGeometryTransform();
               if(_loc5_)
               {
                  _loc7_.vertexTransform = _loc5_.generateOneValue(_loc3_,_numParticles);
               }
               if(_loc6_)
               {
                  _loc7_.UVTransform = _loc6_.generateOneValue(_loc3_,_numParticles);
               }
               _loc4_[_loc3_] = _loc7_;
               _loc3_++;
            }
         }
         this._particleGeometry = ParticleGeometryHelper.generateGeometry(_loc2_,_loc4_);
      }
      
      override public function get particleGeometry() : ParticleGeometry
      {
         return this._particleGeometry;
      }
   }
}


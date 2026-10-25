package away3d.materials.compilation
{
   import away3d.materials.LightSources;
   import away3d.materials.methods.MethodVO;
   
   public class MethodDependencyCounter
   {
      
      private var _projectionDependencies:uint;
      
      private var _normalDependencies:uint;
      
      private var _viewDirDependencies:uint;
      
      private var _uvDependencies:uint;
      
      private var _secondaryUVDependencies:uint;
      
      private var _globalPosDependencies:uint;
      
      private var _tangentDependencies:uint;
      
      private var _usesGlobalPosFragment:Boolean = false;
      
      private var _numPointLights:uint;
      
      private var _lightSourceMask:uint;
      
      public function MethodDependencyCounter()
      {
         super();
      }
      
      public function reset() : void
      {
         this._projectionDependencies = 0;
         this._normalDependencies = 0;
         this._viewDirDependencies = 0;
         this._uvDependencies = 0;
         this._secondaryUVDependencies = 0;
         this._globalPosDependencies = 0;
         this._tangentDependencies = 0;
         this._usesGlobalPosFragment = false;
      }
      
      public function setPositionedLights(param1:uint, param2:uint) : void
      {
         this._numPointLights = param1;
         this._lightSourceMask = param2;
      }
      
      public function includeMethodVO(param1:MethodVO) : void
      {
         if(param1.needsProjection)
         {
            ++this._projectionDependencies;
         }
         if(param1.needsGlobalVertexPos)
         {
            ++this._globalPosDependencies;
            if(param1.needsGlobalFragmentPos)
            {
               this._usesGlobalPosFragment = true;
            }
         }
         else if(param1.needsGlobalFragmentPos)
         {
            ++this._globalPosDependencies;
            this._usesGlobalPosFragment = true;
         }
         if(param1.needsNormals)
         {
            ++this._normalDependencies;
         }
         if(param1.needsTangents)
         {
            ++this._tangentDependencies;
         }
         if(param1.needsView)
         {
            ++this._viewDirDependencies;
         }
         if(param1.needsUV)
         {
            ++this._uvDependencies;
         }
         if(param1.needsSecondaryUV)
         {
            ++this._secondaryUVDependencies;
         }
      }
      
      public function get tangentDependencies() : uint
      {
         return this._tangentDependencies;
      }
      
      public function get usesGlobalPosFragment() : Boolean
      {
         return this._usesGlobalPosFragment;
      }
      
      public function get projectionDependencies() : uint
      {
         return this._projectionDependencies;
      }
      
      public function get normalDependencies() : uint
      {
         return this._normalDependencies;
      }
      
      public function get viewDirDependencies() : uint
      {
         return this._viewDirDependencies;
      }
      
      public function get uvDependencies() : uint
      {
         return this._uvDependencies;
      }
      
      public function get secondaryUVDependencies() : uint
      {
         return this._secondaryUVDependencies;
      }
      
      public function get globalPosDependencies() : uint
      {
         return this._globalPosDependencies;
      }
      
      public function addWorldSpaceDependencies(param1:Boolean) : void
      {
         if(this._viewDirDependencies > 0)
         {
            ++this._globalPosDependencies;
         }
         if(this._numPointLights > 0 && Boolean(this._lightSourceMask & LightSources.LIGHTS))
         {
            ++this._globalPosDependencies;
            if(param1)
            {
               this._usesGlobalPosFragment = true;
            }
         }
      }
   }
}


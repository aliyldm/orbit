package away3d.tools.helpers.data
{
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   
   public class ParticleGeometryTransform
   {
      
      private var _defaultVertexTransform:Matrix3D;
      
      private var _defaultInvVertexTransform:Matrix3D;
      
      private var _defaultUVTransform:Matrix;
      
      public function ParticleGeometryTransform()
      {
         super();
      }
      
      public function set vertexTransform(param1:Matrix3D) : void
      {
         this._defaultVertexTransform = param1;
         this._defaultInvVertexTransform = param1.clone();
         this._defaultInvVertexTransform.invert();
         this._defaultInvVertexTransform.transpose();
      }
      
      public function set UVTransform(param1:Matrix) : void
      {
         this._defaultUVTransform = param1;
      }
      
      public function get UVTransform() : Matrix
      {
         return this._defaultUVTransform;
      }
      
      public function get vertexTransform() : Matrix3D
      {
         return this._defaultVertexTransform;
      }
      
      public function get invVertexTransform() : Matrix3D
      {
         return this._defaultInvVertexTransform;
      }
   }
}


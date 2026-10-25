package away3d.entities
{
   import away3d.arcane;
   import away3d.cameras.lenses.PerspectiveLens;
   import away3d.containers.ObjectContainer3D;
   import away3d.events.LensEvent;
   import away3d.library.assets.AssetType;
   import away3d.textures.Texture2DBase;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class TextureProjector extends ObjectContainer3D
   {
      
      private var _lens:PerspectiveLens;
      
      private var _viewProjectionInvalid:Boolean = true;
      
      private var _viewProjection:Matrix3D = new Matrix3D();
      
      private var _texture:Texture2DBase;
      
      public function TextureProjector(param1:Texture2DBase)
      {
         super();
         this._lens = new PerspectiveLens();
         this._lens.addEventListener(LensEvent.MATRIX_CHANGED,this.onInvalidateLensMatrix,false,0,true);
         this._texture = param1;
         this._lens.aspectRatio = param1.width / param1.height;
         rotationX = -90;
      }
      
      public function get aspectRatio() : Number
      {
         return this._lens.aspectRatio;
      }
      
      public function set aspectRatio(param1:Number) : void
      {
         this._lens.aspectRatio = param1;
      }
      
      public function get fieldOfView() : Number
      {
         return this._lens.fieldOfView;
      }
      
      public function set fieldOfView(param1:Number) : void
      {
         this._lens.fieldOfView = param1;
      }
      
      override public function get assetType() : String
      {
         return AssetType.TEXTURE_PROJECTOR;
      }
      
      public function get texture() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         if(param1 == this._texture)
         {
            return;
         }
         this._texture = param1;
      }
      
      public function get viewProjection() : Matrix3D
      {
         if(this._viewProjectionInvalid)
         {
            this._viewProjection.copyFrom(inverseSceneTransform);
            this._viewProjection.append(this._lens.matrix);
            this._viewProjectionInvalid = false;
         }
         return this._viewProjection;
      }
      
      override protected function invalidateSceneTransform() : void
      {
         super.invalidateSceneTransform();
         this._viewProjectionInvalid = true;
      }
      
      private function onInvalidateLensMatrix(param1:LensEvent) : void
      {
         this._viewProjectionInvalid = true;
      }
   }
}


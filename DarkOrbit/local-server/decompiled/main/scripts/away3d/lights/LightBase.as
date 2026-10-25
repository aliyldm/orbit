package away3d.lights
{
   import away3d.arcane;
   import away3d.core.base.IRenderable;
   import away3d.core.partition.EntityNode;
   import away3d.core.partition.LightNode;
   import away3d.entities.Entity;
   import away3d.errors.AbstractMethodError;
   import away3d.events.LightEvent;
   import away3d.library.assets.AssetType;
   import away3d.lights.shadowmaps.ShadowMapperBase;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class LightBase extends Entity
   {
      
      private var _color:uint = 16777215;
      
      private var _colorR:Number = 1;
      
      private var _colorG:Number = 1;
      
      private var _colorB:Number = 1;
      
      private var _ambientColor:uint = 16777215;
      
      private var _ambient:Number = 0;
      
      arcane var _ambientR:Number = 0;
      
      arcane var _ambientG:Number = 0;
      
      arcane var _ambientB:Number = 0;
      
      private var _specular:Number = 1;
      
      arcane var _specularR:Number = 1;
      
      arcane var _specularG:Number = 1;
      
      arcane var _specularB:Number = 1;
      
      private var _diffuse:Number = 1;
      
      arcane var _diffuseR:Number = 1;
      
      arcane var _diffuseG:Number = 1;
      
      arcane var _diffuseB:Number = 1;
      
      private var _castsShadows:Boolean;
      
      private var _shadowMapper:ShadowMapperBase;
      
      public function LightBase()
      {
         super();
      }
      
      public function get castsShadows() : Boolean
      {
         return this._castsShadows;
      }
      
      public function set castsShadows(param1:Boolean) : void
      {
         if(this._castsShadows == param1)
         {
            return;
         }
         this._castsShadows = param1;
         if(param1)
         {
            this._shadowMapper = this._shadowMapper || this.createShadowMapper();
            this._shadowMapper.light = this;
         }
         else
         {
            this._shadowMapper.dispose();
            this._shadowMapper = null;
         }
         dispatchEvent(new LightEvent(LightEvent.CASTS_SHADOW_CHANGE));
      }
      
      protected function createShadowMapper() : ShadowMapperBase
      {
         throw new AbstractMethodError();
      }
      
      public function get specular() : Number
      {
         return this._specular;
      }
      
      public function set specular(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         this._specular = param1;
         this.updateSpecular();
      }
      
      public function get diffuse() : Number
      {
         return this._diffuse;
      }
      
      public function set diffuse(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         this._diffuse = param1;
         this.updateDiffuse();
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         this._color = param1;
         this._colorR = (this._color >> 16 & 0xFF) / 255;
         this._colorG = (this._color >> 8 & 0xFF) / 255;
         this._colorB = (this._color & 0xFF) / 255;
         this.updateDiffuse();
         this.updateSpecular();
      }
      
      public function get ambient() : Number
      {
         return this._ambient;
      }
      
      public function set ambient(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         this._ambient = param1;
         this.updateAmbient();
      }
      
      public function get ambientColor() : uint
      {
         return this._ambientColor;
      }
      
      public function set ambientColor(param1:uint) : void
      {
         this._ambientColor = param1;
         this.updateAmbient();
      }
      
      private function updateAmbient() : void
      {
         this._ambientR = (this._ambientColor >> 16 & 0xFF) / 255 * this._ambient;
         this._ambientG = (this._ambientColor >> 8 & 0xFF) / 255 * this._ambient;
         this._ambientB = (this._ambientColor & 0xFF) / 255 * this._ambient;
      }
      
      arcane function getObjectProjectionMatrix(param1:IRenderable, param2:Matrix3D = null) : Matrix3D
      {
         throw new AbstractMethodError();
      }
      
      override protected function createEntityPartitionNode() : EntityNode
      {
         return new LightNode(this);
      }
      
      override public function get assetType() : String
      {
         return AssetType.LIGHT;
      }
      
      private function updateSpecular() : void
      {
         this._specularR = this._colorR * this._specular;
         this._specularG = this._colorG * this._specular;
         this._specularB = this._colorB * this._specular;
      }
      
      private function updateDiffuse() : void
      {
         this._diffuseR = this._colorR * this._diffuse;
         this._diffuseG = this._colorG * this._diffuse;
         this._diffuseB = this._colorB * this._diffuse;
      }
      
      public function get shadowMapper() : ShadowMapperBase
      {
         return this._shadowMapper;
      }
      
      public function set shadowMapper(param1:ShadowMapperBase) : void
      {
         this._shadowMapper = param1;
         this._shadowMapper.light = this;
      }
   }
}


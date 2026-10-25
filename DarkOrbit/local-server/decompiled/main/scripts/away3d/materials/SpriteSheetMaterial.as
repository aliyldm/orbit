package away3d.materials
{
   import away3d.arcane;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class SpriteSheetMaterial extends TextureMaterial
   {
      
      private var _diffuses:Vector.<Texture2DBase>;
      
      private var _normals:Vector.<Texture2DBase>;
      
      private var _speculars:Vector.<Texture2DBase>;
      
      private var _TBDiffuse:Texture2DBase;
      
      private var _TBNormal:Texture2DBase;
      
      private var _TBSpecular:Texture2DBase;
      
      private var _currentMapID:uint;
      
      public function SpriteSheetMaterial(param1:Vector.<Texture2DBase>, param2:Vector.<Texture2DBase> = null, param3:Vector.<Texture2DBase> = null, param4:Boolean = true, param5:Boolean = false, param6:Boolean = true)
      {
         this._diffuses = param1;
         this._normals = param2;
         this._speculars = param3;
         this.initTextures();
         super(this._TBDiffuse,param4,param5,param6);
         if(this._TBNormal)
         {
            this.normalMap = this._TBNormal;
         }
         if(this._TBSpecular)
         {
            this.specularMap = this._TBSpecular;
         }
      }
      
      private function initTextures() : void
      {
         if(!this._diffuses || this._diffuses.length == 0)
         {
            throw new Error("you must pass at least one bitmapdata into diffuses param!");
         }
         this._TBDiffuse = this._diffuses[0];
         if(Boolean(this._normals) && this._normals.length > 0)
         {
            if(this._normals.length != this._diffuses.length)
            {
               throw new Error("The amount of normals bitmapDatas must be same as the amount of diffuses param!");
            }
            this._TBNormal = this._normals[0];
         }
         if(Boolean(this._speculars) && this._speculars.length > 0)
         {
            if(this._speculars.length != this._diffuses.length)
            {
               throw new Error("The amount of normals bitmapDatas must be same as the amount of diffuses param!");
            }
            this._TBSpecular = this._speculars[0];
         }
         this._currentMapID = 0;
      }
      
      arcane function swap(param1:uint = 0) : Boolean
      {
         if(this._currentMapID != param1)
         {
            this._currentMapID = param1;
            this._TBDiffuse = this._diffuses[param1];
            this.texture = this._TBDiffuse;
            if(this._TBNormal)
            {
               this.normalMap = this._TBNormal = this._normals[param1];
            }
            if(this._TBSpecular)
            {
               this.specularMap = this._TBSpecular = this._speculars[param1];
            }
            return true;
         }
         return false;
      }
   }
}


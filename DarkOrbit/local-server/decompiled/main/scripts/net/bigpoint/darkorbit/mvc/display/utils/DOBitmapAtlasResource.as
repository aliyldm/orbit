package net.bigpoint.darkorbit.mvc.display.utils
{
   import flash.display.BitmapData;
   import org.osflash.signals.Promise;
   
   public class DOBitmapAtlasResource
   {
      
      private var _texture:Object;
      
      private var _atlas:DOAtlas;
      
      private var _ready:Promise;
      
      private var _readyWithReferece:Promise;
      
      private var _embeddedTextureClassName:String;
      
      public function DOBitmapAtlasResource(param1:String = "texture")
      {
         super();
         this._embeddedTextureClassName = param1;
         this._ready = new Promise();
         this._readyWithReferece = new Promise(DOBitmapAtlasResource);
      }
      
      public function get texture() : Object
      {
         return this._texture;
      }
      
      public function get atlas() : DOAtlas
      {
         return this._atlas;
      }
      
      public function get ready() : Promise
      {
         return this._ready;
      }
      
      internal function dispose() : void
      {
         if(this._texture is BitmapData)
         {
            (this._texture as BitmapData).dispose();
         }
         this._texture = null;
         this._atlas = null;
      }
      
      internal function setTexture(param1:*) : void
      {
         this._texture = param1;
         this.checkReady();
      }
      
      internal function setAtlas(param1:DOAtlas) : void
      {
         this._atlas = param1;
         this.checkReady();
      }
      
      private function checkReady() : void
      {
         if(Boolean(this._texture) && Boolean(this._atlas))
         {
            this._ready.dispatch();
            this._readyWithReferece.dispatch(this);
         }
      }
      
      public function get embeddedTextureClassName() : String
      {
         return this._embeddedTextureClassName;
      }
      
      public function get readyWithReferece() : Promise
      {
         return this._readyWithReferece;
      }
   }
}


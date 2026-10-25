package net.bigpoint.darkorbit.mvc.display.impl.starling
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.display.IDOBitmap;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import starling.display.DisplayObject;
   import starling.display.Image;
   import starling.display.Sprite;
   import starling.filters.FragmentFilter;
   import starling.textures.Texture;
   
   public class DOStarlingBitmap extends Sprite implements IDOBitmap
   {
      
      private var _content:Image;
      
      private var _texture:Object;
      
      public function DOStarlingBitmap()
      {
         super();
      }
      
      public function get texture() : Object
      {
         return this._texture;
      }
      
      public function set texture(param1:Object) : void
      {
         if(this._content)
         {
            removeChild(this._content);
            this._content.dispose();
            this._content = null;
         }
         this._texture = param1;
         if(param1)
         {
            this._content = new Image(TexturesCache.getTexture(this._texture));
            addChild(this._content);
            flatten();
         }
      }
      
      public function get untypedParent() : Object
      {
         return parent;
      }
      
      public function get untypedRoot() : Object
      {
         return root;
      }
      
      public function get untypedStage() : Object
      {
         return stage;
      }
      
      public function get untypedFilter() : Object
      {
         return this.filter;
      }
      
      public function set untypedFilter(param1:Object) : void
      {
         this.filter = param1 as FragmentFilter;
      }
      
      public function get rotationDeg() : Number
      {
         return rotation * FastMath.RADTODEG;
      }
      
      public function set rotationDeg(param1:Number) : void
      {
         rotation = param1 * FastMath.DEGTORAD;
      }
      
      public function get rotationRad() : Number
      {
         return rotation;
      }
      
      public function set rotationRad(param1:Number) : void
      {
         rotation = param1;
      }
      
      public function setSubtexture(param1:Object, param2:Rectangle) : void
      {
         this.texture = null;
         this._content = new Image(Texture.fromTexture(TexturesCache.getTexture(param1),param2));
         addChild(this._content);
      }
      
      public function untypedLocalToGlobal(param1:Point) : Point
      {
         return localToGlobal(param1);
      }
      
      public function untypedGlobalToLocal(param1:Point) : Point
      {
         return globalToLocal(param1);
      }
      
      public function getUntypedBounds(param1:Object, param2:Rectangle = null) : Rectangle
      {
         return getBounds(param1 as DisplayObject);
      }
   }
}


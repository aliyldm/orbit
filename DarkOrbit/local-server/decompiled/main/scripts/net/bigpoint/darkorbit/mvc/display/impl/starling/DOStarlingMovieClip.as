package net.bigpoint.darkorbit.mvc.display.impl.starling
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.display.IDOMovieClip;
   import net.bigpoint.darkorbit.mvc.display.utils.DOBitmapAtlasResource;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   import starling.core.Starling;
   import starling.display.DisplayObject;
   import starling.display.MovieClip;
   import starling.events.Event;
   import starling.filters.FragmentFilter;
   import starling.textures.TextureAtlas;
   
   public class DOStarlingMovieClip extends MovieClip implements IDOMovieClip
   {
      
      private var _freezed:Boolean = false;
      
      public function DOStarlingMovieClip(param1:DOBitmapAtlasResource, param2:String = null, param3:Number = 30)
      {
         var _loc4_:TextureAtlas = new TextureAtlas(TexturesCache.getTexture(param1.texture),param1.atlas.source);
         super(_loc4_.getTextures(param2),param3);
         addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
      }
      
      public function set freezed(param1:Boolean) : void
      {
         if(this._freezed != param1)
         {
            this._freezed = param1;
            if(this._freezed)
            {
               stop();
            }
            else
            {
               play();
            }
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
         return filter;
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
      
      private function handleAddedToStage(param1:Event) : void
      {
         if(!this._freezed)
         {
            Starling.juggler.add(this);
         }
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         Starling.juggler.remove(this);
      }
   }
}


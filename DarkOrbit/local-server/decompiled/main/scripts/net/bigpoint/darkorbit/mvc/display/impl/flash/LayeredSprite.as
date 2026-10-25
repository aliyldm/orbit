package net.bigpoint.darkorbit.mvc.display.impl.flash
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class LayeredSprite extends Sprite
   {
      
      private var _layers:Vector.<Layer> = new Vector.<Layer>();
      
      private var _layersByIndex:Object = {};
      
      public function LayeredSprite()
      {
         super();
      }
      
      public function addChildOnLayer(param1:DisplayObject, param2:int) : void
      {
         this.getLayer(param2).addChild(param1);
      }
      
      public function removeAll() : void
      {
         while(this._layers.length)
         {
            removeChild(this._layers.pop());
         }
         this._layersByIndex = {};
      }
      
      public function getLayer(param1:int) : DisplayObjectContainer
      {
         var _loc2_:Layer = null;
         if(this._layersByIndex[param1] == null)
         {
            _loc2_ = new Layer(param1);
            this._layersByIndex[param1] = _loc2_;
            this._layers.push(_loc2_);
            this.sortLayers();
         }
         return this._layersByIndex[param1] as Layer;
      }
      
      public function removeChildFromAllLayers(param1:DisplayObject) : void
      {
         if(contains(param1))
         {
            param1.parent.removeChild(param1);
         }
      }
      
      private function sortLayers() : void
      {
         var _loc1_:Layer = null;
         this._layers.sort(Layer.compare);
         for each(_loc1_ in this._layers)
         {
            addChild(_loc1_);
         }
      }
   }
}

import flash.display.Sprite;

class Layer extends Sprite
{
   
   private var _index:int;
   
   public function Layer(param1:int = 0)
   {
      super();
      this._index = param1;
   }
   
   public static function compare(param1:Layer, param2:Layer) : int
   {
      if(param1.index > param2.index)
      {
         return 1;
      }
      if(param1.index < param2.index)
      {
         return -1;
      }
      return 0;
   }
   
   public function get index() : int
   {
      return this._index;
   }
}

package net.bigpoint.darkorbit.fui.components.core.skins.layers
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class MovieClipButtonLayer extends Sprite implements ISkinLayer
   {
      
      private var _mc:MovieClip;
      
      private var _child:String = null;
      
      private var _frame:int = -1;
      
      public function MovieClipButtonLayer(param1:MovieClip)
      {
         super();
         this._mc = param1;
         this._mc.buttonMode = true;
         this.addChild(this._mc);
      }
      
      public function set child(param1:String) : void
      {
         this._child = param1;
      }
      
      public function set frame(param1:Number) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         if(this._child)
         {
            this._mc.buttonMode = true;
            this._mc[this._child].gotoAndStop(param1);
         }
         else
         {
            this._mc.buttonMode = true;
            this._mc.gotoAndStop(param1);
         }
         this._frame = param1;
      }
      
      public function clone() : DisplayObject
      {
         var _loc1_:Class = Class(getDefinitionByName(getQualifiedClassName(this)));
         var _loc2_:MovieClip = MovieClip(new this._mc.constructor());
         if(!_loc2_)
         {
            _loc2_ = this._mc;
         }
         var _loc3_:MovieClipButtonLayer = new _loc1_(_loc2_) as MovieClipButtonLayer;
         _loc3_.child = this._child;
         _loc3_.frame = this._frame;
         return _loc3_;
      }
      
      public function dispose() : void
      {
         if(this._mc)
         {
            if(this.contains(this._mc))
            {
               this.removeChild(this._mc);
            }
            this._mc = null;
         }
      }
   }
}


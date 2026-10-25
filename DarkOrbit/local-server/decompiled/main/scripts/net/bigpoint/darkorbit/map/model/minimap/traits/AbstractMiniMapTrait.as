package net.bigpoint.darkorbit.map.model.minimap.traits
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class AbstractMiniMapTrait extends EntityTraitBase
   {
      
      protected var _icon:DisplayObject;
      
      protected var _scale:Number = 0;
      
      protected var _miniMapWidth:int;
      
      protected var _miniMapHeight:int;
      
      private var _centerIcon:Boolean = false;
      
      private var _useOwnerPosition:Boolean;
      
      private var _layer:int = 0;
      
      public function AbstractMiniMapTrait(param1:DisplayObject, param2:Boolean, param3:Boolean, param4:int = 0)
      {
         super();
         this._icon = param1;
         this._useOwnerPosition = param2;
         this._centerIcon = param3;
         this._layer = param4;
      }
      
      public function getMiniMapIcon(param1:Number, param2:int, param3:int) : DisplayObject
      {
         this._miniMapHeight = param3;
         this._miniMapWidth = param2;
         this._scale = param1;
         this.update();
         return this._icon;
      }
      
      public function toggleIconVisibility(param1:Boolean) : void
      {
         this._icon.visible = param1;
      }
      
      override public function activateTrait() : void
      {
         super.activateTrait();
         owner.position.changed.add(this.update);
         this.update();
      }
      
      override public function deactivateTrait() : void
      {
         owner.position.changed.remove(this.update);
         super.deactivateTrait();
      }
      
      public function get layer() : int
      {
         return this._layer;
      }
      
      protected function update() : void
      {
         if(this._useOwnerPosition)
         {
            this._icon.x = owner.position.x * this._scale;
            this._icon.y = owner.position.y * this._scale;
         }
         if(this._centerIcon)
         {
            this._icon.x -= this._icon.width / 2;
            this._icon.y -= this._icon.height / 2;
         }
      }
   }
}


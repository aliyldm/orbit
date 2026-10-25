package net.bigpoint.darkorbit.fui.components.list.itemlist
{
   import flash.display.DisplayObject;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.list.IItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   
   public class DefaultItemDataAssigner extends Container implements IItemDataAssigner
   {
      
      public static var DEFAULT_ITEMRENDERER_TEMPLATE:XML = <container name="itemRendererContainer" height="20" width="360">
			<textfield name="textfield" x="10" width="200"/>
		</container>;
      
      private static var INVALID_INDEX:int = -1;
      
      private static var INSTANCE_NAME:String = "DefaultItemDataAssigner_";
      
      private static var __ID__:uint = 0;
      
      private var _id:uint = 0;
      
      protected var _selected:Boolean = false;
      
      protected var _index:int;
      
      protected var label:Label;
      
      protected var hitLayer:DisplayObject;
      
      public function DefaultItemDataAssigner()
      {
         super();
         this._id = ++__ID__;
         this.name = this.getInternalIdentifier();
         this.autoSizeWidth = true;
         this._isDraggable = true;
      }
      
      protected function getInternalIdentifier() : String
      {
         return INSTANCE_NAME + this._id.toString();
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function clearIndex() : void
      {
         this._index = INVALID_INDEX;
      }
      
      public function isIndexValid() : Boolean
      {
         return INVALID_INDEX != this._index;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.hitLayer = getChildByName("hitlayer") as DisplayObject;
         this.label = getChildByName("label") as Label;
      }
      
      public function select() : void
      {
         this._selected = true;
         this.drawSelection();
      }
      
      public function unselect() : void
      {
         this._selected = false;
         this.drawSelection();
      }
      
      public function deselect() : void
      {
         this.unselect();
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(param1)
         {
            this.select();
         }
         else
         {
            this.unselect();
         }
      }
      
      public function isSelected() : Boolean
      {
         return this._selected;
      }
      
      protected function drawSelection() : void
      {
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.label = null;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.setItemVisibility(param1);
      }
      
      protected function setItemVisibility(param1:Object) : void
      {
         visible = Boolean(param1);
      }
   }
}


package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners
{
   import flash.display.Bitmap;
   import flash.filters.ColorMatrixFilter;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.model.UpgradeTypeModel;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class UpgradeTargetTypeListAssigner extends DefaultItemDataAssigner
   {
      
      private static const GREY_FILTER:Array = [new ColorMatrixFilter(getColorMatrix())];
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _collectable:Coreponent;
      
      public function UpgradeTargetTypeListAssigner()
      {
         super();
      }
      
      private static function getColorMatrix() : Array
      {
         var _loc1_:uint = 1118481;
         var _loc2_:uint = uint(_loc1_ >> 16 & 0xFF);
         var _loc3_:uint = uint(_loc1_ >> 8 & 0xFF);
         var _loc4_:uint = uint(_loc1_ & 0xFF);
         var _loc5_:Number = 1 / 3;
         var _loc6_:Array = [];
         _loc6_ = _loc6_.concat([_loc5_,_loc5_,_loc5_,0,_loc2_]);
         _loc6_ = _loc6_.concat([_loc5_,_loc5_,_loc5_,0,_loc3_]);
         _loc6_ = _loc6_.concat([_loc5_,_loc5_,_loc5_,0,_loc4_]);
         return _loc6_.concat([0,0,0,1,0]);
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeCallbacks();
            this.removeSignalListeners();
            super.data = param1;
            if(param1)
            {
               this.update(param1 as UpgradeTypeModel);
            }
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._collectable = FuiComponentSelectorUtil.selectComponent("craftableTypeItemContainer",this) as Coreponent;
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         if(this.isSelectable())
         {
            filters = [];
            this._hover.enabled = !_selected;
         }
         else
         {
            filters = GREY_FILTER;
         }
      }
      
      override public function dispose() : void
      {
         this.removeSignalListeners();
         super.dispose();
      }
      
      override public function isIndexValid() : Boolean
      {
         return Boolean(super.isIndexValid()) && this.isSelectable();
      }
      
      private function removeCallbacks() : void
      {
         var _loc1_:UpgradeTypeModel = data as UpgradeTypeModel;
         if(!_loc1_)
         {
            return;
         }
         removeLoadResourceCallback(_loc1_.targetItemType.getLoot30x30(Hero.factionName),this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update(param1:UpgradeTypeModel) : void
      {
         tooltipData = param1.targetItemType.fullname;
         loadResource(param1.targetItemType.getLoot30x30(Hero.factionName),this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this.addSignalListeners();
         this.updateStates();
      }
      
      private function addSignalListeners() : void
      {
         var _loc1_:UpgradeTypeModel = data as UpgradeTypeModel;
         if(_loc1_)
         {
            _loc1_.hasCollectibleRecipe.changed.add(this.updateStates);
         }
      }
      
      private function removeSignalListeners() : void
      {
         var _loc1_:UpgradeTypeModel = data as UpgradeTypeModel;
         if(_loc1_)
         {
            _loc1_.hasCollectibleRecipe.changed.remove(this.updateStates);
         }
      }
      
      private function updateStates() : void
      {
         var _loc1_:UpgradeTypeModel = data as UpgradeTypeModel;
         if(!_loc1_)
         {
            this._collectable.visible = false;
            return;
         }
         this._collectable.visible = _loc1_.hasCollectibleRecipe.value;
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function isSelectable() : Boolean
      {
         var _loc1_:UpgradeTypeModel = data as UpgradeTypeModel;
         return _loc1_ ? _loc1_.targets.length > 0 : false;
      }
   }
}


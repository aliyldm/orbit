package net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.UnstableModuleModule;
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonUnstableModuleModule;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.SelectItemTipAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.StarLevelDisplayHelper;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RerollTargetGridAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _name:Label;
      
      private var _itemUpgradeLevel:Label;
      
      private var _equipped:Coreponent;
      
      private var _starLayer:Sprite;
      
      public function RerollTargetGridAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
            this.renderStarForData(param1 as UnstableModuleModule);
         }
         else
         {
            this.removeCallbacks();
            super.data = param1;
            if(param1)
            {
               this.update(param1 as UnstableModuleModule);
            }
            else
            {
               this.renderStarForData(null);
            }
         }
      }
      
      private function get dataVO() : UnstableModuleModule
      {
         return data as UnstableModuleModule;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("itemName",this) as Label;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._itemUpgradeLevel = FuiComponentSelectorUtil.selectComponent("itemUpgradeLevel",this) as Label;
         this._equipped = FuiComponentSelectorUtil.selectComponent("equipped",this) as Coreponent;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this._img.x;
         this._starLayer.y = this._img.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this._img.width,this._img.height);
         this._starLayer.graphics.endFill();
         addChild(this._starLayer);
         this.tooltipDataAssigner = new SelectItemTipAssigner();
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         this._hover.enabled = !_selected;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         if(!this.dataVO)
         {
            return;
         }
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem(this.dataVO.lootId);
         if(_loc1_)
         {
            removeLoadResourceCallback(_loc1_.getLoot30x30(Hero.factionName),this.handleItemLoaded,AssetsProxy.ITEMS);
         }
      }
      
      private function update(param1:UnstableModuleModule) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:CannonUnstableModuleModule = null;
         this.renderStarForData(this.dataVO);
         if(!this.dataVO)
         {
            return;
         }
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(this.dataVO.lootId);
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.typeClass == ItemFilterTypes.Weapon__CannonType || _loc2_.typeClass == ItemFilterTypes.Weapon__CannonShieldType)
         {
            _loc5_ = WarpControlsProxy.getProxy(GameFacade.getInstance()).getInventoryItemByItemId(param1.itemId);
            if(_loc5_)
            {
               tooltipData = _loc5_;
            }
            else
            {
               tooltipData = _loc2_.fullname;
            }
         }
         else
         {
            tooltipData = _loc2_.fullname;
         }
         var _loc3_:String = _loc2_.getLoot30x30(Hero.factionName);
         loadResource(_loc3_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this._name.text = _loc2_.fullname;
         if(this.dataVO as CannonUnstableModuleModule)
         {
            _loc6_ = this.dataVO as CannonUnstableModuleModule;
            this._itemUpgradeLevel.text = _loc6_.upgradeLevel + "";
         }
         else
         {
            this._itemUpgradeLevel.text = "";
         }
         var _loc4_:ItemVO = this.getInventoryItemForData(this.dataVO);
         if(this._equipped)
         {
            this._equipped.visible = Boolean(_loc4_) && _loc4_.isEquipped;
         }
      }
      
      private function renderStarForData(param1:UnstableModuleModule) : void
      {
         StarLevelDisplayHelper.render(this._starLayer,this.getInventoryItemForData(param1));
      }
      
      private function getInventoryItemForData(param1:UnstableModuleModule) : ItemVO
      {
         if(!param1)
         {
            return null;
         }
         var _loc2_:InventoryProxy = GameFacade.getInstance().retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(!_loc2_ || !_loc2_.inventory)
         {
            return null;
         }
         return _loc2_.inventory.getByItemId(param1.itemId);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this._img.addChild(_loc2_);
      }
   }
}


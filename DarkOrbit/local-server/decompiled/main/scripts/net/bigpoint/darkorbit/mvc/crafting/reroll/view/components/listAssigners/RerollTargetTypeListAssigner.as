package net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.model.RerollTypeModel;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RerollTargetTypeListAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _loadedLootId:String;
      
      private const DMG_KEY:String = "equipment_shipupgrade_dmg";
      
      private const HP_KEY:String = "equipment_shipupgrade_hp";
      
      private const SHD_KEY:String = "equipment_shipupgrade_shd";
      
      private const SPC_KEY:String = "equipment_shipupgrade_spc";
      
      public function RerollTargetTypeListAssigner()
      {
         super();
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
            super.data = param1;
            if(param1)
            {
               this.update(param1 as RerollTypeModel);
            }
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
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
      
      override public function isIndexValid() : Boolean
      {
         return super.isIndexValid();
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback(this._loadedLootId,this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update(param1:RerollTypeModel) : void
      {
         var _loc3_:ItemVO = null;
         if(param1.getRerollList.length <= 0)
         {
            visible = false;
            return;
         }
         var _loc2_:* = param1.getRerollList[0];
         _loc3_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
         tooltipData = this.getModuleTypeLoca(_loc3_.lootID);
         this._loadedLootId = _loc3_.getLoot30x30(Hero.factionName);
         loadResource(this._loadedLootId,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
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
      
      private function getModuleTypeLoca(param1:String) : String
      {
         if(param1.indexOf(this.DMG_KEY) >= 0)
         {
            return BPLocale.getItem("reroll_filter_damage");
         }
         if(param1.indexOf(this.HP_KEY) >= 0)
         {
            return BPLocale.getItem("reroll_filter_hp");
         }
         if(param1.indexOf(this.SHD_KEY) >= 0)
         {
            return BPLocale.getItem("reroll_filter_shield");
         }
         if(param1.indexOf(this.SPC_KEY) >= 0)
         {
            return BPLocale.getItem("reroll_filter_special");
         }
         return "";
      }
   }
}


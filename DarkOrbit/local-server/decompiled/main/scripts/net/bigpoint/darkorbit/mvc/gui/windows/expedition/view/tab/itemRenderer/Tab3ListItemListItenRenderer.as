package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class Tab3ListItemListItenRenderer extends DefaultItemDataAssigner
   {
      
      private var _iconBG:Coreponent;
      
      private var _icon:Coreponent;
      
      private var _item_name:Label;
      
      private var itemVo:ItemVO;
      
      private var _resKey:String = "";
      
      public function Tab3ListItemListItenRenderer()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._iconBG = FuiComponentSelectorUtil.selectComponent("icon_bg",this) as Coreponent;
         this._item_name = FuiComponentSelectorUtil.selectComponent("item_count",this) as Label;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         super.data = param1;
         if(!param1)
         {
            if(this._resKey != "")
            {
               UISystem.getInstance().uiloader.removeCallback(this._resKey,this.handleItemIconLoaded);
            }
            return;
         }
         if(param1.hasOwnProperty("lootId"))
         {
            this.itemVo = ItemDataProviderHelper.getItem(param1.lootId);
            if(this.itemVo)
            {
               this.tooltipData = this.itemVo.fullname;
               _loc2_ = this.itemVo.getLootIcon();
               if(!hasResource(_loc2_,AssetsProxy.ITEMS))
               {
                  _loc2_ = this.itemVo.getLoot100x100();
               }
               if(!hasResource(_loc2_,AssetsProxy.ITEMS))
               {
                  _loc2_ = this.itemVo.getLoot30x30();
               }
               this.loadIcon(_loc2_,AssetsProxy.ITEMS);
               _loc3_ = BPLocale.getItemInCategory("","window_dse_reward").replace("%VALUE%",this.itemVo.codeName).replace("%count%",param1.amount);
               this._item_name.text = _loc3_;
            }
         }
         else if(param1.hasOwnProperty("titleKey"))
         {
            this.tooltipData = BPLocale.getItemInCategory("achievements",param1.titleKey);
            this.loadIcon("event_title_icon_63x63",AssetsProxy.ACHIEVEMENTS);
            this._item_name.text = BPLocale.getItemInCategory("achievements",param1.titleKey);
         }
      }
      
      private function loadIcon(param1:String, param2:String = "ITEMS") : void
      {
         if(this._resKey != "" && this._resKey != param1)
         {
            UISystem.getInstance().uiloader.removeCallback(this._resKey,this.handleItemIconLoaded);
         }
         this._resKey = param1;
         loadResource(param1,this.handleItemIconLoaded,this.handleItemIconLoadError,param2);
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         this._resKey = "";
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._icon.width;
         _loc2_.height = this._icon.height;
         this._icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
      }
   }
}


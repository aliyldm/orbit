package net.bigpoint.darkorbit.mvc.gui.windows.eventRewards.view
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.RewardAchievementModule;
   import net.bigpoint.darkorbit.com.module.RewardContentModule;
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.RewardTitleModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class EventRewardsDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _itemImg:Coreponent;
      
      private var _background:Coreponent;
      
      private var _itemDescription:Label;
      
      public function EventRewardsDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._itemImg = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._background = FuiComponentSelectorUtil.selectComponent("background",this) as Coreponent;
         this._itemDescription = FuiComponentSelectorUtil.selectComponent("item_description",this) as Label;
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
               this.update(param1 as RewardContentModule);
            }
         }
      }
      
      private function removeCallbacks() : void
      {
         var _loc1_:RewardModule = data as RewardModule;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(_loc1_.lootId);
         if(!_loc2_)
         {
            return;
         }
         removeLoadResourceCallback(_loc2_.getLoot100x100(),this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update(param1:RewardContentModule) : void
      {
         var _loc2_:ItemVO = null;
         var _loc3_:String = null;
         var _loc4_:RewardAchievementModule = null;
         if(param1 is RewardModule)
         {
            _loc2_ = ItemDataProviderHelper.getItem((param1 as RewardModule).lootId);
            if(_loc2_)
            {
               _loc2_.amount = (param1 as RewardModule).amount;
               if(_loc2_.amount > 1)
               {
                  this.text = "x" + _loc2_.amount + "\n" + _loc2_.codeName;
               }
               else
               {
                  this.text = _loc2_.fullname;
               }
               _loc3_ = _loc2_.getLootIcon();
               if(!hasResource(_loc3_,AssetsProxy.ITEMS))
               {
                  _loc3_ = _loc2_.getLoot100x100();
               }
               if(!hasResource(_loc3_,AssetsProxy.ITEMS))
               {
                  _loc3_ = _loc2_.getLoot30x30();
               }
               loadResource(_loc3_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
            }
            else
            {
               this.handleItemLoadError(null);
            }
         }
         else if(param1 is RewardAchievementModule)
         {
            this.setImageIcon(ResourceManager.getBitmap("icons","achievementsPlaceholerIcon"));
            _loc4_ = param1 as RewardAchievementModule;
            this.text = BPLocaleUtils.hasTranslation(_loc4_.achievementKey + "_name","achievements") ? BPLocale.getItemInCategory("achievements",_loc4_.achievementKey + "_name") : BPLocale.getItemInCategory("achievements","title_" + _loc4_.achievementKey);
         }
         else if(param1 is RewardTitleModule)
         {
            this.text = BPLocale.getItemInCategory("achievements",InGameCatalog.instance.getTitleKey((param1 as RewardTitleModule).titleKey));
            this.setImageIcon(ResourceManager.getBitmap("icons","achievementsPlaceholerIcon"));
         }
      }
      
      protected function set text(param1:String) : void
      {
         if(param1.length >= 18)
         {
            this._itemDescription.text = param1.substr(0,17) + "...";
         }
         else
         {
            this._itemDescription.text = param1;
         }
         tooltipData = param1;
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._itemImg);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this.setImageIcon(_loc2_);
      }
      
      private function setImageIcon(param1:Bitmap) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._itemImg);
         param1.width = this._itemImg.width;
         param1.height = this._itemImg.height;
         this._itemImg.addChild(param1);
      }
      
      override public function dispose() : void
      {
         this.removeCallbacks();
         super.dispose();
      }
   }
}


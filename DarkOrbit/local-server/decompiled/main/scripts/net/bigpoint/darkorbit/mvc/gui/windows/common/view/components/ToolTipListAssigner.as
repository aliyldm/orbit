package net.bigpoint.darkorbit.mvc.gui.windows.common.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.com.module.RewardAchievementModule;
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.RewardTitleModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.utils.BPLocaleUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ToolTipListAssigner extends DefaultItemDataAssigner
   {
      
      private var _resKey:String;
      
      private var _img:Coreponent;
      
      public function ToolTipListAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc3_:ItemVO = null;
         var _loc4_:RewardTitleModule = null;
         var _loc5_:RewardAchievementModule = null;
         removeLoadResourceCallback(this._resKey,this.handleAssetLoaded);
         var _loc2_:RewardModule = param1 as RewardModule;
         if(_loc2_)
         {
            label.text = TextFormatter.roundInteger(_loc2_.amount) + "x  " + TextUtils.getTranslationByType(_loc2_.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_FULLNAME);
            _loc3_ = ItemDataProviderHelper.getItem(_loc2_.lootId);
            if(_loc3_)
            {
               this._resKey = _loc3_.getLoot30x30();
               if(this._resKey)
               {
                  loadResource(this._resKey,this.handleAssetLoaded,this.handleError,AssetsProxy.ITEMS);
               }
            }
         }
         else if(param1 is RewardTitleModule)
         {
            _loc4_ = param1 as RewardTitleModule;
            if(_loc4_)
            {
               this.loadTitleIcon();
               label.text = BPLocale.getItemInCategory("achievements",InGameCatalog.instance.getTitleKey(_loc4_.titleKey));
            }
         }
         else if(param1 is RewardAchievementModule)
         {
            _loc5_ = param1 as RewardAchievementModule;
            if(_loc5_)
            {
               this._resKey = _loc5_.achievementKey + "_" + _loc5_.level + "_30x30";
               loadResource(this._resKey,this.handleAssetLoaded,this.handleError,AssetsProxy.ACHIEVEMENTS);
               label.text = BPLocaleUtils.hasTranslation(_loc5_.achievementKey + "_name","achievements") ? BPLocale.getItemInCategory("achievements",_loc5_.achievementKey + "_name") : BPLocale.getItemInCategory("achievements","title_" + _loc5_.achievementKey);
            }
         }
         else
         {
            label.text = "wadde hadde dude da";
         }
         super.data = param1;
      }
      
      private function loadTitleIcon() : void
      {
         ResourceManager.loadAndCall("traininggroundsUI",function():void
         {
            setIcon(ResourceManager.getBitmapData("traininggroundsUI","title_icon"));
         },[]);
      }
      
      private function handleAssetLoaded(param1:ImageFinisher) : void
      {
         this.setIcon(param1.getBitmap().bitmapData);
      }
      
      private function setIcon(param1:BitmapData) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1));
      }
      
      private function handleError(param1:*) : void
      {
         this.loadTitleIcon();
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("img",this) as Coreponent;
      }
      
      override public function dispose() : void
      {
         removeLoadResourceCallback(this._resKey,this.handleAssetLoaded);
         super.dispose();
      }
   }
}


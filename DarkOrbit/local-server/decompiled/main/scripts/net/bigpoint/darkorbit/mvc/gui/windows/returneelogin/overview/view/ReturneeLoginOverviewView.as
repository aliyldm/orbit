package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.view
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ReturneeLoginOverviewView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function ReturneeLoginOverviewView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("overview") as Coreponent;
         this.rewardList.itemDataAssigner = ReturneeLoginOverviewListItemAssigner;
      }
      
      public function get title() : String
      {
         return "returnee_login_tab_overview";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      private function get banner() : Coreponent
      {
         return this._cache.selectComponent("overview.banner") as Coreponent;
      }
      
      public function set bannerSkin(param1:String) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.banner);
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("returneelogin"));
         var _loc3_:Bitmap = _loc2_.getEmbeddedBitmap("banner_" + param1);
         _loc3_.width = 570;
         _loc3_.height = 150;
         this.banner.addChild(_loc3_);
      }
      
      public function get welcome() : Label
      {
         return this._cache.selectComponent("overview.welcome") as Label;
      }
      
      private function get rewardList() : ItemList
      {
         return this._cache.selectComponent("overview.rewards.list") as ItemList;
      }
      
      public function set rewardGrid(param1:Vector.<ItemVO>) : void
      {
         this.rewardList.list = new VectorCollection(param1);
      }
      
      public function get claimBtn() : Button
      {
         return this._cache.selectComponent("overview.claim_btn") as Button;
      }
   }
}

